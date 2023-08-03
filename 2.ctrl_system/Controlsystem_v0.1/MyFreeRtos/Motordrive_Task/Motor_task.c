/**
  ******************************************************************************
  * @file   chassis_task.c
  * @brief  底盘运动控制相关函数
  ******************************************************************************
  * @attention
  *			底盘初始化
  *			判断底盘电机是否正常工作
  *			设置底盘运动模式
  *			底盘模式改变过渡
  *			底盘数据更新，设置底盘控制变量
  *			发送电机控制电流
  ******************************************************************************
  */

#include "Motordrive_Task/Motor_task.h"
#include "Motordrive_Task/Motor_behaviour.h"



#define 	En_MotorTaskRunTime		0	//任务时间统计,用于测试任务情况
#define 	EN_Motor_Info_Print			1	//打印信息控制

//任务时间统计ms
uint32_t	Chassis_StartTime, Chassis_EndTime, Chassis_RunTime;

static void chassis_init(chassis_move_t *chassis_move_init);
static void chassis_feedback_updata(chassis_move_t *chassis_move_updata,uint8_t msg_cnt);
static void chassis_set_mode(chassis_move_t *chassis_move_mode);
static void chassis_loop_ctrl(chassis_move_t *chassis_loop_ctrl);
static void chassis_set_ctrl(chassis_move_t *chassis_set_ctrl);
static void chassisComFeedbackUpdata(chassis_move_t *chassisComFeedbackUpdata);
static void chassisFeedbackDatainit(chassis_move_t *chassisFeedbackInit);
//static void motor_offsetangle_init(chassis_move_t *motor_offsetangle_init);

extern UART_HandleTypeDef huart2;
extern uint8_t rcbuffer[18];

char Chassis_Info_buf[400];			//打印输出信息
char Chassis_Info_buf2[200];

chassis_move_t motor_move;		//定义底盘运动数据
chassis_move_t Com_move;			//定义底盘运动反馈数据

//uint8_t		Remode_Ctrl_Status[3] = {0};	//转向状态控制

uint8_t		START_FLAG = 1;		//默认只获取一次初始值，获取后不再获取
//遥控器操作值获取，用于判断遥控器指令类型
//前后直线控制，Ch1有数据，其余通道为0
//uint16_t	chassis_Ch0;		//Ch0通道	Motor1
//uint16_t	chassis_Ch1;		//Ch1通道	Motor2
//uint16_t	chassis_Ch2;		//Ch2通道	Motor3
//uint16_t	chassis_Ch3;        //Ch2通道	Motor3
//static uint8_t     msg_CNT = 0;            //offset_angle初始化用到

//变量值初始化
//底盘速度环PID值初始化
const static fp32 motor_speed_pid[4] = {M3508_SPEED_PID_KP, M3508_SPEED_PID_KI, M3508_SPEED_PID_KD};
const static fp32 motor_position_pid[4] = {M3508_POSITION_PID_KP, M3508_POSITION_PID_KI, M3508_POSITION_PID_KD};
/**
  * @func 	底盘控制任务
  * @param	argument：空
  * @note	底盘初始化、设置底盘控制模式、底盘数据更新、底盘控制变量设置、底盘控制PID计算、发送电机控制电流
  * @retval None
  */

void Motordrive_task(void *argument)
{
	uint8_t msg_cnt = 0;
	//空闲一段时间，等待其他设备加载成功
	osDelay(MOTORDRIVE_TASK_INIT_TIME);
	vPortEnterCritical();		//进入临界保护
	//底盘初始化
	chassis_init(&motor_move);
	//底盘反馈数据初始化，主要用于反馈底盘运动情况显示

	chassisFeedbackDatainit(&Com_move);

	vPortExitCritical();		//退出临界保护
	//打开电源
	ctrl_power_enable(1);	//直接默认打开

	//主要控制程序
	for(;;)
	{
		if(START_FLAG == 1){
			START_FLAG=0;
			Buzzer_Control(500);		//蜂鸣器提示成功，可以操作遥控器
			osDelay(1000);
		}
#if En_MotorTaskRunTime
		Chassis_StartTime = HAL_GetTick();
#endif
		//设置控制模式
		else {

		chassis_set_mode(&motor_move);
		//测量数据更新
		chassis_feedback_updata(&motor_move, msg_cnt);
        if(msg_cnt < 2)
        	{msg_cnt++;}
        else
        	{msg_cnt = 15;}
		//反馈速度更新
		chassisComFeedbackUpdata(&Com_move);              //反馈数据Cam_move

		//控制变量设置
		chassis_set_ctrl(&motor_move);

		//PID计算
		chassis_loop_ctrl(&motor_move);
		//电机错误处理（未添加）

		//电机发送控制电流
		can1_send_set_moto_current(motor_move.motor_chassis[0].give_current, motor_move.motor_chassis[1].give_current,
				motor_move.motor_chassis[2].give_current, motor_move.motor_chassis[3].give_current);
		//vPortExitCritical();		//退出临界保护

		//电机输出测试
#if EN_Motor_Info_Print
		//遥控器输出测试
//		sprintf(Chassis_Info_buf, " CH0: %d    CH1: %d    CH2: %d	CH3:%d\r\n ",
//				motor_move.chassis_RC->rc.ch0,motor_move.chassis_RC->rc.ch1,motor_move.chassis_RC->rc.ch2,motor_move.chassis_RC->rc.ch3);
//		HAL_UART_Transmit(&huart2, (uint8_t *)Chassis_Info_buf, (COUNTOF(Chassis_Info_buf)-1), 55);
		//电机电流输出测试
//		sprintf(Chassis_Info_buf, " Motor_speed_set[3]:%.f    speed_set[3]: %.f	 speed_feedback[3]:%.2f  give_cur:%d speed_rpm[0]:%d given_cur:%d\r\n ",
//						motor_move.Motor_speed_set[3],
//						motor_move.motor_chassis[3].speed_set,
//						motor_move.motor_chassis[3].speed_feedback,
//						motor_move.motor_chassis[0].give_current,
//						motor_move.motor_chassis[3].chassis_motor_measure->speed_rpm,
//						motor_move.motor_chassis[3].chassis_motor_measure->given_current);

//		sprintf(Chassis_Info_buf, "Motor_set[3]:%d\r\n ",
//				motor_move.Motor_PCctrl->angle[3]);
//		HAL_UART_Transmit(&huart2, (uint8_t *)Chassis_Info_buf, (COUNTOF(Chassis_Info_buf)-1), 55);

//		 printf("M_set[3]:%d cyc_angle[3]=%d  l_angle=%d cyc_llang=%d cyc_cnt=%d sped=%d  cur=%d mot_num=%d\r\n",
//		        		motor_move.Motor_position_set[3],
//						motor_move.motor_chassis[3].chassis_motor_measure->angle,
//						motor_move.motor_chassis[3].chassis_motor_measure->last_angle,
//						motor_move.motor_chassis[3].llast_angle,
//						motor_move.motor_chassis[3].cyc_numberCNT,
//						motor_move.motor_chassis[3].chassis_motor_measure->speed_rpm,
//		                motor_move.motor_chassis[3].give_current,
//						motor_move.motor_chassis[3].mot_cycleNUM);
		 printf("M_set[1]:%d M_set[2]:%d M_set[3]:%d  mot_pos[1]=%d mot_pos[2]=%d mot_pos[3]=%d\r\n",
				        myuart8ctrldata_t.pos[0],
						myuart8ctrldata_t.pos[1],
						myuart8ctrldata_t.pos[2],
						motor_move.Motor_position_set[0],
						motor_move.Motor_position_set[1],
						motor_move.Motor_position_set[2]);
//						motor_move.Motor_position_set[1],
//						motor_move.Motor_position_set[2],
//						motor_move.Motor_position_set[3],
//						motor_move.motor_chassis[0].mot_cycleNUM,
//						motor_move.motor_chassis[1].mot_cycleNUM,
//						motor_move.motor_chassis[2].mot_cycleNUM,
//						motor_move.motor_chassis[3].mot_cycleNUM);

		//遥控器输出测试
#endif

#if En_MotorTaskRunTime
		Chassis_EndTime = HAL_GetTick();
		Chassis_RunTime = Chassis_EndTime - Chassis_StartTime;
		printf("#### Chassis task RunTime = %ld \r\n", Chassis_RunTime);
#endif
		}
		osDelay(5);
	}
}

/*******************************分割线************************************************************/
/**
  * @func 	底盘反馈数据
  * @param
  * @note
  * @retval None
  */
static void chassisFeedbackDatainit(chassis_move_t *chassisFeedbackInit)
{
	//获取底盘电机数据指针，初始化速度PID
	for (uint8_t i = 0; i < 4; i++){
		chassisFeedbackInit->motor_chassis[i].chassis_motor_measure = get_chassis_motor_measure_point(i);
	}
}


/**
  * @func 	底盘数据测量发送反馈更新
  * @param
  * @note	包括测量数据、电机速度、欧拉角度、机器人速度更新
  * @retval None
  */
static void chassisComFeedbackUpdata(chassis_move_t *chassisComFeedbackUpdata)
{
	//底盘电机速度测量值更新
	for (uint8_t i = 0;i < 4; i++){		//更新电机速度
		chassisComFeedbackUpdata->motor_chassis[i].speed_feedback =
				chassisComFeedbackUpdata->motor_chassis[i].chassis_motor_measure->speed_rpm;
        //更新角度值cyclinder_angle
		chassisComFeedbackUpdata->motor_chassis[i].cyclinder_angle = chassisComFeedbackUpdata->motor_chassis[i].chassis_motor_measure->angle
				- chassisComFeedbackUpdata->motor_chassis[i].offset_angle;
	}
}


/****************************************************分割线************************************************************/


/**
  * @func 	底盘初始化
  * @param	初始化“chassis_move”变量，
  * @note	包括pid初始化，遥控器指针初始化，底盘电机初始化
  * 		云台电机初始化，陀螺仪角度指针初始化
  * @retval None
  */
static void chassis_init(chassis_move_t *chassis_move_init)
{
	uint8_t i = 0;
	//初始化参数检查
	if(chassis_move_init == NULL) {
		return;
	}
	//底盘开机状态初始化
	chassis_move_init->chassis_move_mode = ROBOT_UART_POSITION_PID_MODE;	//底盘开机状态为底盘制动模式
	//获取遥控器指针
	chassis_move_init->chassis_RC = &RC_CtrlData;			//将遥控器参数结构体指针的地址进行传递
	chassis_move_init->Motor_PCctrl = &myuart8ctrldata_t;      //将PC串口发送的数据进行传递



	//获取底盘电机数据指针，初始化速度PID
	for (i = 0; i < 4; i++){
		chassis_move_init->motor_chassis[i].chassis_motor_measure = get_chassis_motor_measure_point(i);	//【关键】
		pid_init(&chassis_move_init->moto_pid_speed[i], PID_POSITION_MODE, motor_speed_pid,
				M3508_SPEED_PID_MAX_OUT, M3508_SPEED_PID_MAX_INTE_OUT);
		pid_init(&chassis_move_init->moto_pid_position[i], PID_POSITION_MODE, motor_position_pid,
				M3508_POSITION_PID_MAX_OUT, M3508_POSITION_PID_MAX_INTE_OUT);
	}

	//一阶低通滤波初始化
	for (i=0;i<4;i++){
		first_order_filter_init(&chassis_move_init->motor_Fir_ord_filt_set[i], MOTOR_FILTER_FRAME_PERIOD,
				MOTOR_FILTER_TIME_CONST_SET);
	}



    //最大速度限制
	chassis_move_init->Motor_speed_max= Motor_MAX_SPEED;
	chassis_move_init->Motor_speed_min= -Motor_MAX_SPEED;
	//初始化完成后更新测量数据
//	chassis_feedback_updata(chassis_move_init);


}

/**
  * @func 	底盘运动模式设置
  * @param
  * @note	通过拨码开关进行模式切换
  * 		通过逻辑判断，赋值“chassis_behaviour_mode”进行模式切换
  * @retval None
  */

static void chassis_set_mode(chassis_move_t *chassis_move_mode)
{
	if (chassis_move_mode == NULL){
		return;
	}
	chassis_move_mode->chassis_RC = &RC_CtrlData;			//将遥控器参数结构体指针的地址进行传递
	chassis_move_mode->Motor_PCctrl = &myuart8ctrldata_t;      //将PC串口发送的数据进行传递
	chassis_behaviour_mode_set(chassis_move_mode);

}

/**
  * @func 	底盘数据测量值更新
  * @param	chassis_move_updata:参数结构体
  * @note	包括测量数据、电机速度、欧拉角度、机器人速度更新
  * @retval None
  */
static void chassis_feedback_updata(chassis_move_t *chassis_move_updata,uint8_t  msg_cnt)
{
	if (chassis_move_updata == NULL){
		return;
	}
    if(msg_cnt < 2){
        uint8_t	i;
	   	for (i = 0;i < 4; i++){		//更新电机速度、加速度；【加速度暂时没有更新，调试PID的时候再更新】
	   		chassis_move_updata->motor_chassis[i].speed_feedback =
	   		   					chassis_move_updata->motor_chassis[i].chassis_motor_measure->speed_rpm;
	   		chassis_move_updata->motor_chassis[i].offset_angle = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle;
	   		chassis_move_updata->motor_chassis[i].cyc_numberCNT = 0;
	   		chassis_move_updata->motor_chassis[i].mot_angle = 0;
	   		chassis_move_updata->motor_chassis[i].mot_angleCNT = 0;
   	    chassis_move_updata->motor_chassis[i].mot_cycleNUM = 0;


	   	}
    }
    else{
        uint8_t	i;
	   	for (i = 0;i < 4; i++){		//更新电机速度、加速度；【加速度暂时没有更新，调试PID的时候再更新】
	   		chassis_move_updata->motor_chassis[i].speed_feedback =
	   		   					chassis_move_updata->motor_chassis[i].chassis_motor_measure->speed_rpm;

	   		//更新角度值cyclinder_angle，转子角度差
	   		chassis_move_updata->motor_chassis[i].cyclinder_angle = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle
	   					- chassis_move_updata->motor_chassis[i].offset_angle;
	   		chassis_move_updata->motor_chassis[i].cyc_angle_err = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle - chassis_move_updata->motor_chassis[i].llast_angle;

	   		//更新电机转子转数刻度值
	   		if(chassis_move_updata->motor_chassis[i].chassis_motor_measure->speed_rpm >= 20)
	   		{
	   			if(-18 < chassis_move_updata->motor_chassis[i].cyc_numberCNT && chassis_move_updata->motor_chassis[i].cyc_numberCNT < 18)
	   			{
	   				if(chassis_move_updata->motor_chassis[i].cyc_angle_err < -10){
	   					chassis_move_updata->motor_chassis[i].cyc_numberCNT++;
	   				}
	   			}
	   		   else{
	   			chassis_move_updata->motor_chassis[i].cyc_numberCNT = 0;
	   	        chassis_move_updata->motor_chassis[i].mot_cycleNUM++;

	   		   }
		   		chassis_move_updata->motor_chassis[i].mot_angleCNT = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle + chassis_move_updata->motor_chassis[i].cyc_numberCNT * 8191;
		   		chassis_move_updata->motor_chassis[i].mot_angle = chassis_move_updata->motor_chassis[i].mot_angleCNT/(8191*18.00f)*360;
	   		}
	   	    else if(chassis_move_updata->motor_chassis[i].chassis_motor_measure->speed_rpm < -20)
	   	    {
	   	    	if(-18 < chassis_move_updata->motor_chassis[i].cyc_numberCNT && chassis_move_updata->motor_chassis[i].cyc_numberCNT < 18)
	   	    	{
	   	    		if(chassis_move_updata->motor_chassis[i].cyc_angle_err > 10){
	   	    		   	chassis_move_updata->motor_chassis[i].cyc_numberCNT--;
	   	    		}
	   	        }
	   	       else{
	   	        chassis_move_updata->motor_chassis[i].cyc_numberCNT = 0;
	   	        chassis_move_updata->motor_chassis[i].mot_cycleNUM--;
	   	       }
		   		chassis_move_updata->motor_chassis[i].mot_angleCNT = -8191+chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle + chassis_move_updata->motor_chassis[i].cyc_numberCNT * 8191;
		   		chassis_move_updata->motor_chassis[i].mot_angle = chassis_move_updata->motor_chassis[i].mot_angleCNT/(8191*18.00f)*360;
	   	    }

//	   	    else if(chassis_move_updata->motor_chassis[i].chassis_motor_measure->speed_rpm == 0)
//	   	    {
//	   	    	if(chassis_move_updata->motor_chassis[i].give_current>=0)
//	   	    	{
//
//	   	    		chassis_move_updata->motor_chassis[i].mot_angleCNT = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle + chassis_move_updata->motor_chassis[i].cyc_numberCNT * 8191;
//	   	    		chassis_move_updata->motor_chassis[i].mot_angle = chassis_move_updata->motor_chassis[i].mot_angleCNT/(8191*18.00f)*360;
//	   	    	}
//	   	    	else
//	   	    	{
//
//			   		chassis_move_updata->motor_chassis[i].mot_angleCNT = -8191+chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle + chassis_move_updata->motor_chassis[i].cyc_numberCNT * 8191;
//			   		chassis_move_updata->motor_chassis[i].mot_angle = chassis_move_updata->motor_chassis[i].mot_angleCNT/(8191*18.00f)*360;
//	   	    	}
//
//	   	    }

	   		//电机轴的输出刻度值及角度值
//	   		chassis_move_updata->motor_chassis[i].mot_angleCNT = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle + chassis_move_updata->motor_chassis[i].cyc_numberCNT * 8191;
//	   		chassis_move_updata->motor_chassis[i].mot_angle = chassis_move_updata->motor_chassis[i].mot_angleCNT/(8191*18.00f)*360;
	   		//更新转子last角度值
	   		chassis_move_updata->motor_chassis[i].llast_angle = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle;
	   	  }
    }
 }

/**
  * @func 	根据底盘控制模式，设置底盘控制值
  * @param
  * @note	运动控制值vx_set等通过chassis_behaviour_mode_set设置
  * @retval None
  */

static void chassis_set_ctrl(chassis_move_t *chassis_set_ctrl)
{
	if (chassis_set_ctrl == NULL){
		return;
	}
	uint8_t i;
//	for(i=0;i<4;i++){
//		chassis_set_ctrl->Motor_speed_set[i]=0.0f;
//	}
	chassis_behaviour_ctrl_var_set(chassis_set_ctrl);	//将三个值带回来

	 if (chassis_set_ctrl->chassis_move_mode == ROBOT_STOP_MODE){			//速度由遥控器控制，具有角度环，无速度环
		//底盘角度环控制
	}
	else{	//速度环模式
		for(i=0;i<4;i++){
			chassis_set_ctrl->Motor_speed_set[i] = fp32_constrain(chassis_set_ctrl->Motor_speed_set[i], chassis_set_ctrl->Motor_speed_min, chassis_set_ctrl->Motor_speed_max);
		}
	}
}

/**
  * @func 	循环控制，根据控制设定值，计算电机电流值，进行控制
  * @param
  * @note
  * @retval None
  */
static void chassis_loop_ctrl(chassis_move_t *chassis_loop_ctrl)
{

//	fp32 wheel_speed[4] = {0.0f, 0.0f, 0.0f, 0.0f};
//	fp32 max_vector = 0.0f;
//	fp32 rate_vector = 0.0f;
//	fp32 temp_vertor = 0.0f;
	uint8_t i;
//
//	//计算轮子控制最大速度，并限制其最大速度
//	for (i = 0; i <4; i++){
//		chassis_loop_ctrl->motor_chassis[i].speed_set = chassis_loop_ctrl->Motor_speed_set[i];
//		temp_vertor = fabs(chassis_loop_ctrl->motor_chassis[i].speed_feedback);
//		if (max_vector < temp_vertor){
//			max_vector = temp_vertor;
//		}
//	}
//	if (max_vector > Motor_MAX_SPEED){
//		rate_vector = Motor_MAX_SPEED / max_vector;
//		for (i = 0; i <4; i++){
//			chassis_loop_ctrl->motor_chassis[i].speed_feedback *= rate_vector;
//		}
//	}

	//计算各关节电机的位置和速度PID
	if (chassis_loop_ctrl->chassis_move_mode == ROBOT_UART_POSITION_PID_MODE){                  //something wrong
	  for (i = 0; i <4; i++){
		  pid_calculation(&chassis_loop_ctrl->moto_pid_position[i], chassis_loop_ctrl->Motor_position_set[i],
		  				chassis_loop_ctrl->motor_chassis[i].mot_cycleNUM);

		  chassis_loop_ctrl->moto_pid_position[i].PID_out = fp32_constrain(chassis_loop_ctrl->moto_pid_position[i].PID_out, -3500, 3500);    //位置PID限幅

		  pid_calculation(&chassis_loop_ctrl->moto_pid_speed[i], chassis_loop_ctrl->moto_pid_position[i].PID_out,
				chassis_loop_ctrl->motor_chassis[i].speed_feedback);

		  chassis_loop_ctrl->moto_pid_speed[i].PID_out = fp32_constrain(chassis_loop_ctrl->moto_pid_speed[i].PID_out, -12000, 12000);         //速度PID限幅
	      }
	}
	else
	{
		 for (i = 0; i <4; i++){
			 pid_calculation(&chassis_loop_ctrl->moto_pid_speed[i], chassis_loop_ctrl->motor_chassis[i].speed_set,
							chassis_loop_ctrl->motor_chassis[i].speed_feedback);
		 }
	}

	//赋予电流值
	for (i = 0; i <4; i++){
		chassis_loop_ctrl->motor_chassis[i].give_current = (int16_t)(chassis_loop_ctrl->moto_pid_speed[i].PID_out);
	}

}

/************************************************************************************************
 * 									以下部分为直线行驶修正部分
 * **********************************************************************************************/

/**
  * @func 	判断是否直线行驶操作
  * @param	ch0->左右平移、ch1->前后、ch2->左右自旋
  * @note
  * @retval 0->左右平移动作;1->前后动作;2->自旋动作;4->手动补偿，不进行自动补偿操作
  */
//static uint8_t Remote_Ctrl_Mode (uint16_t ch0, uint16_t ch1, uint16_t ch2)
//{
//	if ((ch0 != 0) && (ch1 == 0) && (ch2 == 0)) {		//左右平移动作
//		return 0;
//	}
//	else if ((ch1 != 0) && (ch0 == 0) && (ch2 == 0)) {	//前后动作
//		return 1;
//	}
//	else if ((ch2 != 0) && (ch1 == 0) && (ch2 == 0)) {	//自旋动作
//		return 2;
//	}
//	else
//		return 4;		//手动补偿，不进行自动补偿操作
//}

/**
  * @func	获取Yaw初始值
  * @param
  * @note	1s时间获取一个数据，和上个数据进行比较
  * 		IMUInitData[0]->上一个数据
  * 		IMUInitData[1]->最新数据
  * 		IMUInitData[2]->用于连续误差值小于1计数
  * 		IMUInitData[3]->有效数据记录
  * @retval
  */
//static uint8_t Get_Chassis_Yaw_Init_Data(float yaw)
//{
//	//浮点型数据放大100倍，截取转换为绝对值数据进行处理
//	IMUInitData[1] = abs((int16_t)(yaw * 100));
//	//printf("IMUInitData[1] = %d, IMUInitData[2] = %d\r\n",IMUInitData[1],IMUInitData[2]);
//	if (abs( IMUInitData[1] - IMUInitData[0] ) > 80 ) {		//误差值大于1，认为误差过大
//		IMUInitData[0] = IMUInitData[1];	//保存上一个数据
//		IMUInitData[2] = 0;		//有效数据个数清零
//		return 1;
//	}
//	else if (abs( IMUInitData[1] - IMUInitData[0] ) <= 80) {	//误差值小于1，认为有效数据
//		if (IMUInitData[2] != 0) {		//如果已经检测到一个有效数据
//			if (abs( IMUInitData[1] - IMUInitData[3]) <= 80 ) {	//检测到有效数据下，且当前数据为有效数据
//				IMUInitData[2] += 1;		//有效数据加1
//				if (IMUInitData[2] >= 3) {	//连续3次获取到有效数据，认为有效数据
//					return 0;
//				}
//			}
//			else {		//当前数据和有效数据有较大变化，认为数据未稳定
//				IMUInitData[2] = 0;			//有效数据清零
//			}
//		}
//		IMUInitData[0] = IMUInitData[1];	//保存上一个数据
//		IMUInitData[3] = IMUInitData[1];	//记录有效数据
//		if (IMUInitData[2] < 1) {
//			IMUInitData[2] = 1;		//有效数据加1
//		}
//			return 2;
//	}
//}
//
/**
  * @func	偏移量检测
  * @param
  * @note	偏移量检测大于5度，进行补偿
  * 		【注意！！！！！！！！！】还需要添加时间验证机智，防止个别错误数据进行错误补偿
  * @retval	0->不补偿；1->直线右偏补偿；2->直线左偏补偿
  */

//static uint8_t Chassis_Offset_Detection(float initYaw, float currYaw)
//{
//	//将浮点数放大100倍，进行处理
//	int16_t initYaw_INT = (int16_t)(initYaw * 100);
//	int16_t currYaw_INT = (int16_t)(currYaw * 100);
//	int16_t offsetVal	= initYaw_INT - currYaw_INT;
//	//printf("initYaw_INT = %d	currYaw_INT = %d offsetVal = %d\r\n",initYaw_INT, currYaw_INT, offsetVal);
//	if (offsetVal <= -500) {		//右偏
//		//printf("Right\n");
//		return 1;
//	}
//	else if (offsetVal >= 500) {	//左偏
//		//printf("Left\r\n");
//		return 2;
//	}
//	else{	//小于5°，认为不偏
//		//printf("NO Offset\r\n");
//		return 0;
//	}
//}

/**
  * @func 	遥控器转向动作完成判断
  * @param
  * @note	转向完成后，修正当前初始值
  * @retval 0->正常动作；其他: 转向完成
  */
//static uint8_t Remote_Ctrl_Change_Direction_Judge(int8_t RemoteStatus[3], int16_t Ch0, int16_t Ch1, int16_t Ch2,int16_t Ch3)
//{
//	if ((Ch2 != 0) && Ch1 == 0) {		//正在进行转向操作标记
//		RemoteStatus[0] = 1;
//	}
//	if ((RemoteStatus[0] != 0 ) && (Ch2 == 0)) {
//		RemoteStatus[0] = 0;	//清除转向标记
//		return 1;		//转向动作完成标志
//	}
//	if ((Ch0 != 0) && Ch1 == 0) {		//正在进行平移操作
//		RemoteStatus[1] = 1;
//	}
//	if ((RemoteStatus[1] != 0 ) && (Ch0 == 0)) {
//		RemoteStatus[1] = 0;	//清除平移标记
//		return 2;		//平移动作完成标志
//	}
//	if ((Ch1 != 0) && (Ch2 != 0)) {		//手动调节转向操作
//		RemoteStatus[2] = 1;
//	}
//	if ((RemoteStatus[2] != 0 ) && (Ch2 == 0)) {
//		RemoteStatus[3] = 0;	//清除手动调节标记
//		return 2;		//手动调节动作完成标志
//	}
//	else
//		return 0;		//正常动作标志
//}

/**
  * @func 	偏移补偿动作
  * @param
  * @note	根据偏移状态，对各个轮转速电流值进行补偿
  * @retval 0->不转向；1->右转向；2->左转向
  */

//static void Chassis_Wheel_Compensation()
//{
//
//
//}

