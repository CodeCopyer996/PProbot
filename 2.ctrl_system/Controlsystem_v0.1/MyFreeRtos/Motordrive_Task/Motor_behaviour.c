/**
  ******************************************************************************
  * @file   chassis_behaviour.c
  * @brief  �����˶�����ģʽ�����Ƶ����˶���Ϊ
  ******************************************************************************
  * @attention
  *			������Ϊģʽ����
  *			���̿���ģʽ����
  *			���̲�ͬ����ģʽ��������
  *			��������״̬����
  *			���̲��ƶ���Ϊ״̬����
  *			���̲�������̨�Ƕ�״̬����
  *			����ֱ����ң�������п�������
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

chassis_behaviour_mode_e chassis_behaviour_mode = ROBOT_UART_POSITION_PID_MODE;	//Ĭ�ϵ����ƶ�ģʽ

/**
  * @func 	ң�����Ե�����Ϊģʽ����
  * @author	ym���򻯿���ģʽ��ȥ���޹ؿ���ģʽ��
  * @param	chassis_move_t,���Խṹ��
  * @note	���뿪��S1������ѡ������ģʽ�����һ��Ĭ������ģʽ
  * 		switch_is_down��	ROBOT_UART_POSITION_PID_MODE��	�ٶȻ�����ģʽ
  * 		switch_is_mid��	ROBOT_MOTOR_SPEED_PID_MODE��	�ٶȻ�+�ǶȻ�ģʽ
  * 		switch_is_up��	ROBOT_STOP_MODE��	ң����ֱ�ӿ���ģʽ
  * 		���뿪��S2��δ���õ����˶�ģʽ
  * @retval null
  */

void chassis_behaviour_mode_set(chassis_move_t *chassis_move_mode)
{
	if (chassis_move_mode == NULL){
		return;
	}

	if (switch_s1_is_up(chassis_move_mode->chassis_RC->rc.s1)){	//���뿪��S1����
		if (switch_s2_is_up(chassis_move_mode->chassis_RC->rc.s2)) {		//S2����
			chassis_behaviour_mode = ROBOT_STOP_MODE;					//�����ƶ�ģʽ
			chassis_move_mode->chassis_move_mode = ROBOT_STOP_MODE;
		}
		else if (switch_s2_is_mid(chassis_move_mode->chassis_RC->rc.s2)){	//S2�м�
			chassis_behaviour_mode = ROBOT_MOTOR_SPEED_PID_MODE;			//����ٶȻ�ģʽ
			chassis_move_mode->chassis_move_mode = ROBOT_MOTOR_SPEED_PID_MODE;
		}
		else if (switch_s2_is_down(chassis_move_mode->chassis_RC->rc.s2)){	//S2����
					chassis_behaviour_mode = ROBOT_UART_POSITION_PID_MODE;			//���ڵ��λ�û�ģʽ
					chassis_move_mode->chassis_move_mode = ROBOT_UART_POSITION_PID_MODE;
				}
	}
}

/**
  * @func 	���̲�ͬ����ģʽ�Ա�����������
  * @param	vx_set:	x����������ã�	vy_set: Y�����������
  * 		angle_set:	wz_set����ת�Ƕ�ֵ����
  * 		chassis_move_rc_to_vec:	�����ƶ����Խṹ������
  * @note	��Ӧ���ֵ�������ģʽ

  * 		CHASSIS_BRAKE_MODE:			      ������Ҫֹͣ���ã������ٶȻ�
  *         CHASSIS_MOTOR_SPEED_PID_MODE,	  ����ٶȻ�ģʽ
  *	        //��̨��Ϊģʽ
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

	else if (chassis_move_rc_to_vec->chassis_move_mode == ROBOT_MOTOR_SPEED_PID_MODE){	//����ٶȻ�ģʽ
//		motor_speed_pid_ctrl_vector(chassis_move_rc_to_vec);
		motor_position_pid_ctrl_vector(chassis_move_rc_to_vec);
	}
	else if (chassis_move_rc_to_vec->chassis_move_mode == ROBOT_UART_POSITION_PID_MODE){	//���λ�û�ģʽ
			motor_position_pid_ctrl_vector(chassis_move_rc_to_vec);
		}

}



/**
  * @func 	���ƶ�ģʽ
  * @param	vx_set��vy_set��vw_set��ͨ���ٶȻ���������תx��y��wֵ
  * 		chassis_move_rc_to_vector:������������
  * @note	����ֵΪ0�����ٶȻ��Ե��̽����ƶ�,��ͨ��CANֱ�ӷ�������
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
  * @func 	����ٶȻ�ģʽ
  * @param	vx_set: x����ָ�룻	vy_set:y����ָ��
  * 		vw_set����ת����ָ��
  * 		chassis_move_rc_to_vector�������ƶ��������Խṹ��
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
  * @func 	���λ�û�ģʽ
  * @param	��λ�����ڷ��͵�����
  * 		motor_position_pid_vec������������Խṹ��
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
