/**
  ******************************************************************************
  * @file   chassis_behaviour.c
  * @brief  底盘运动控制模式，控制底盘运动行为
  ******************************************************************************
  * @attention
  *			底盘行为模式设置
  *			底盘控制模式设置
  *			底盘不同控制模式变量设置
  *			底盘无力状态设置
  *			底盘不移动行为状态设置
  *			底盘不跟随云台角度状态设置
  *			底盘直接由遥控器进行控制设置
  *
  ******************************************************************************
  */

#include "../Include/Motordrive_Task/Motor_behaviour.h"

#define CHASSIS_VX_RC_SEN  11.905f
#define L1  0.02
#define L2  0.220
#define L3  0.240
#define L4  0.045
#define C   2.3873
static void motor_brake_move_control(chassis_move_t *chassis_move_rc_to_vector);
static void motor_speed_pid_ctrl_vector(chassis_move_t *motor_speed_pid_vec);
static void motor_position_pid_ctrl_vector(chassis_move_t *motor_position_pid_vec);

chassis_behaviour_mode_e chassis_behaviour_mode = ROBOT_UART_POSITION_PID_MODE;	//默认底盘制动模式

/**
  * @func 	遥控器对底盘行为模式设置
  * @author	ym【简化控制模式，去除无关控制模式】
  * @param	chassis_move_t,属性结构体
  * @note	拨码开关S1，可以选择三种模式，外加一种默认设置模式
  * 		switch_is_down：	ROBOT_UART_POSITION_PID_MODE：	速度环控制模式
  * 		switch_is_mid：	ROBOT_MOTOR_SPEED_PID_MODE：	速度环+角度环模式
  * 		switch_is_up：	ROBOT_STOP_MODE：	遥控器直接控制模式
  * 		拨码开关S2，未设置底盘运动模式
  * @retval null
  */

void chassis_behaviour_mode_set(chassis_move_t *chassis_move_mode)
{
	if (chassis_move_mode == NULL){
		return;
	}

	if (switch_s1_is_up(chassis_move_mode->chassis_RC->rc.s1)){	//拨码开关S1向上
		if (switch_s2_is_up(chassis_move_mode->chassis_RC->rc.s2)) {		//S2向上
			chassis_behaviour_mode = ROBOT_STOP_MODE;					//设置制动模式
			chassis_move_mode->chassis_move_mode = ROBOT_STOP_MODE;
		}
		else if (switch_s2_is_mid(chassis_move_mode->chassis_RC->rc.s2)){	//S2中间
			chassis_behaviour_mode = ROBOT_MOTOR_SPEED_PID_MODE;			//电机速度环模式
			chassis_move_mode->chassis_move_mode = ROBOT_MOTOR_SPEED_PID_MODE;
		}
		else if (switch_s2_is_down(chassis_move_mode->chassis_RC->rc.s2)){	//S2向下
					chassis_behaviour_mode = ROBOT_UART_POSITION_PID_MODE;			//串口电机位置环模式
					chassis_move_mode->chassis_move_mode = ROBOT_UART_POSITION_PID_MODE;
				}
	}
}

/**
  * @func 	底盘不同控制模式对变量进行设置
  * @param	vx_set:	x方向变量设置；	vy_set: Y方向变量设置
  * 		angle_set:	wz_set，旋转角度值设置
  * 		chassis_move_rc_to_vec:	底盘移动属性结构体设置
  * @note	对应四种底盘设置模式

  * 		CHASSIS_BRAKE_MODE:			      底盘需要停止设置，具有速度环
  *         CHASSIS_MOTOR_SPEED_PID_MODE,	  电机速度环模式
  *	        //云台行为模式
  *
  * @retval null
  */

void chassis_behaviour_ctrl_var_set(chassis_move_t *chassis_move_rc_to_vec)
{
//	if (chassis_move_rc_to_vec->Motor_speed_set[0] == 0 || chassis_move_rc_to_vec->Motor_speed_set[1] == 0 || chassis_move_rc_to_vec->Motor_speed_set[2] == 0 || chassis_move_rc_to_vec->Motor_speed_set[3] == 0|| chassis_move_rc_to_vec ==NULL){
//		return;
//	}
    if (chassis_move_rc_to_vec->chassis_move_mode == ROBOT_STOP_MODE){
//		motor_brake_move_control(chassis_move_rc_to_vec);
		motor_position_pid_ctrl_vector(chassis_move_rc_to_vec);
	}

	else if (chassis_move_rc_to_vec->chassis_move_mode == ROBOT_MOTOR_SPEED_PID_MODE){	//电机速度环模式
//		motor_speed_pid_ctrl_vector(chassis_move_rc_to_vec);
		motor_position_pid_ctrl_vector(chassis_move_rc_to_vec);
	}
	else if (chassis_move_rc_to_vec->chassis_move_mode == ROBOT_UART_POSITION_PID_MODE){	//电机位置环模式
			motor_position_pid_ctrl_vector(chassis_move_rc_to_vec);
		}

}



/**
  * @func 	不移动模式
  * @param	vx_set：vy_set：vw_set：通过速度环，设置旋转x、y、w值
  * 		chassis_move_rc_to_vector:检查参数完整性
  * @note	设置值为0，由速度环对底盘进行制动,不通过CAN直接发送数据
  * @retval null
  */

static void motor_brake_move_control(chassis_move_t *chassis_move_rc_to_vector)
{
//	if (chassis_move_rc_to_vector->Motor_speed_set[0] == NULL || chassis_move_rc_to_vector->Motor_set[1] == NULL || chassis_move_rc_to_vector->Motor_set[2] == NULL || chassis_move_rc_to_vector->Motor_set[3] == NULL|| chassis_move_rc_to_vector ==NULL)
//	    {
//			return;
//		}
	chassis_move_rc_to_vector->Motor_speed_set[0] = 0.0f;
	chassis_move_rc_to_vector->Motor_speed_set[1] = 0.0f;
	chassis_move_rc_to_vector->Motor_speed_set[2] = 0.0f;
	chassis_move_rc_to_vector->Motor_speed_set[3] = 0.0f;
}

/**
  * @func 	电机速度环模式
  * @param	vx_set: x方向指针；	vy_set:y方向指针
  * 		vw_set：旋转方向指针
  * 		chassis_move_rc_to_vector：底盘移动变量属性结构体
  * @note
  * @retval null
  */
static void motor_speed_pid_ctrl_vector(chassis_move_t *motor_speed_pid_vec)
{
//	if (motor_speed_pid_vec->Motor_speed_set[0] == NULL || motor_speed_pid_vec->Motor_speed_set[1] == NULL || motor_speed_pid_vec->Motor_speed_set[2] == NULL ||motor_speed_pid_vec->Motor_speed_set[3] == NULL || motor_speed_pid_vec == NULL){
//			return;
//	}
	motor_speed_pid_vec->Motor_speed_set[0] = CHASSIS_VX_RC_SEN * motor_speed_pid_vec->chassis_RC->rc.ch0;
	motor_speed_pid_vec->Motor_speed_set[1] = CHASSIS_VX_RC_SEN * motor_speed_pid_vec->chassis_RC->rc.ch1;
	motor_speed_pid_vec->Motor_speed_set[2] = CHASSIS_VX_RC_SEN * motor_speed_pid_vec->chassis_RC->rc.ch2;
	motor_speed_pid_vec->Motor_speed_set[3] = CHASSIS_VX_RC_SEN * motor_speed_pid_vec->chassis_RC->rc.ch3;

}
/**
  * @func 	电机位置环模式
  * @param	上位机串口发送的数据
  * 		motor_position_pid_vec：电机变量属性结构体
  * @note
  * @retval null
  */

static void motor_position_pid_ctrl_vector(chassis_move_t *motor_position_pid_vec)
{
	uint8_t i;
	fp32 pos[3];
	uint8_t K;
	for( i = 0 ; i < 3 ; i++){
		pos[i] = motor_position_pid_vec->Motor_PCctrl->pos[i];
	}
	motor_position_pid_vec->Motor_position_set[0] =  (atan2(pos[1],pos[0]) - atan2(L1,sqrt(pos[0]*pos[0]+pos[1]*pos[1]-L1*L1)))*C;
	K = (pow(pos[0],2)+pow(pos[1],2)+pow(pos[2],2)-pow(L1,2)-pow(L2,2)-pow(L3,2)-pow(L4,2))/(2*L2);
	motor_position_pid_vec->Motor_position_set[2] = (int16_t) ((atan2(L4,L3)-atan2(K,sqrt(L4*L4+L3*L3-K*K)))-3.1416/2)*C;
	motor_position_pid_vec->Motor_position_set[1] = (int16_t) (atan2(-(L4+L4*cos(motor_position_pid_vec->Motor_position_set[2]))*pos[2] +
			(cos(motor_position_pid_vec->Motor_position_set[0])*pos[0]+sin(motor_position_pid_vec->Motor_position_set[0])*pos[1])*(L2*sin(motor_position_pid_vec->Motor_position_set[2])-L3),(-L3+L2*sin(motor_position_pid_vec->Motor_position_set[2]))*pos[2] +
			(cos(motor_position_pid_vec->Motor_position_set[0])*pos[0]+sin(motor_position_pid_vec->Motor_position_set[0])*pos[2])*(L2*cos(motor_position_pid_vec->Motor_position_set[2])+L4)) - motor_position_pid_vec->Motor_position_set[2])*C;

// for( i = 0 ; i < 4 ; i++){
//
//	motor_position_pid_vec->Motor_position_set[i] = motor_position_pid_vec->Motor_PCctrl->angle[i];

}
