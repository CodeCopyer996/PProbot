/**
  ******************************************************************************
  * @file   chassis_task.c
  * @brief  �����˶�������غ���
  ******************************************************************************
  * @attention
  *			���̳�ʼ��
  *			�жϵ��̵���Ƿ���������
  *			���õ����˶�ģʽ
  *			����ģʽ�ı����
  *			�������ݸ��£����õ��̿��Ʊ���
  *			���͵�����Ƶ���
  ******************************************************************************
  */

#include "Motordrive_Task/Motor_task.h"
#include "Motordrive_Task/Motor_behaviour.h"



#define 	En_MotorTaskRunTime		0	//����ʱ��ͳ��,���ڲ����������
#define 	EN_Motor_Info_Print			1	//��ӡ��Ϣ����

//����ʱ��ͳ��ms
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

char Chassis_Info_buf[400];			//��ӡ�����Ϣ
char Chassis_Info_buf2[200];

chassis_move_t motor_move;		//��������˶�����
chassis_move_t Com_move;			//��������˶���������

//uint8_t		Remode_Ctrl_Status[3] = {0};	//ת��״̬����

uint8_t		START_FLAG = 1;		//Ĭ��ֻ��ȡһ�γ�ʼֵ����ȡ���ٻ�ȡ
//ң��������ֵ��ȡ�������ж�ң����ָ������
//ǰ��ֱ�߿��ƣ�Ch1�����ݣ�����ͨ��Ϊ0
//uint16_t	chassis_Ch0;		//Ch0ͨ��	Motor1
//uint16_t	chassis_Ch1;		//Ch1ͨ��	Motor2
//uint16_t	chassis_Ch2;		//Ch2ͨ��	Motor3
//uint16_t	chassis_Ch3;        //Ch2ͨ��	Motor3
//static uint8_t     msg_CNT = 0;            //offset_angle��ʼ���õ�

//����ֵ��ʼ��
//�����ٶȻ�PIDֵ��ʼ��
const static fp32 motor_speed_pid[4] = {M3508_SPEED_PID_KP, M3508_SPEED_PID_KI, M3508_SPEED_PID_KD};
const static fp32 motor_position_pid[4] = {M3508_POSITION_PID_KP, M3508_POSITION_PID_KI, M3508_POSITION_PID_KD};
/**
  * @func 	���̿�������
  * @param	argument����
  * @note	���̳�ʼ�������õ��̿���ģʽ���������ݸ��¡����̿��Ʊ������á����̿���PID���㡢���͵�����Ƶ���
  * @retval None
  */

void Motordrive_task(void *argument)
{
	uint8_t msg_cnt = 0;
	//����һ��ʱ�䣬�ȴ������豸���سɹ�
	osDelay(MOTORDRIVE_TASK_INIT_TIME);
	vPortEnterCritical();		//�����ٽ籣��
	//���̳�ʼ��
	chassis_init(&motor_move);
	//���̷������ݳ�ʼ������Ҫ���ڷ��������˶������ʾ

	chassisFeedbackDatainit(&Com_move);

	vPortExitCritical();		//�˳��ٽ籣��
	//�򿪵�Դ
	ctrl_power_enable(1);	//ֱ��Ĭ�ϴ�

	//��Ҫ���Ƴ���
	for(;;)
	{
		if(START_FLAG == 1){
			START_FLAG=0;
			Buzzer_Control(500);		//��������ʾ�ɹ������Բ���ң����
			osDelay(1000);
		}
#if En_MotorTaskRunTime
		Chassis_StartTime = HAL_GetTick();
#endif
		//���ÿ���ģʽ
		else {

		chassis_set_mode(&motor_move);
		//�������ݸ���
		chassis_feedback_updata(&motor_move, msg_cnt);
        if(msg_cnt < 2)
        	{msg_cnt++;}
        else
        	{msg_cnt = 15;}
		//�����ٶȸ���
		chassisComFeedbackUpdata(&Com_move);              //��������Cam_move

		//���Ʊ�������
		chassis_set_ctrl(&motor_move);

		//PID����
		chassis_loop_ctrl(&motor_move);
		//���������δ��ӣ�

		//������Ϳ��Ƶ���
		can1_send_set_moto_current(motor_move.motor_chassis[0].give_current, motor_move.motor_chassis[1].give_current,
				motor_move.motor_chassis[2].give_current, motor_move.motor_chassis[3].give_current);
		//vPortExitCritical();		//�˳��ٽ籣��

		//����������
#if EN_Motor_Info_Print
		//ң�����������
//		sprintf(Chassis_Info_buf, " CH0: %d    CH1: %d    CH2: %d	CH3:%d\r\n ",
//				motor_move.chassis_RC->rc.ch0,motor_move.chassis_RC->rc.ch1,motor_move.chassis_RC->rc.ch2,motor_move.chassis_RC->rc.ch3);
//		HAL_UART_Transmit(&huart2, (uint8_t *)Chassis_Info_buf, (COUNTOF(Chassis_Info_buf)-1), 55);
		//��������������
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

		//ң�����������
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

/*******************************�ָ���************************************************************/
/**
  * @func 	���̷�������
  * @param
  * @note
  * @retval None
  */
static void chassisFeedbackDatainit(chassis_move_t *chassisFeedbackInit)
{
	//��ȡ���̵������ָ�룬��ʼ���ٶ�PID
	for (uint8_t i = 0; i < 4; i++){
		chassisFeedbackInit->motor_chassis[i].chassis_motor_measure = get_chassis_motor_measure_point(i);
	}
}


/**
  * @func 	�������ݲ������ͷ�������
  * @param
  * @note	�����������ݡ�����ٶȡ�ŷ���Ƕȡ��������ٶȸ���
  * @retval None
  */
static void chassisComFeedbackUpdata(chassis_move_t *chassisComFeedbackUpdata)
{
	//���̵���ٶȲ���ֵ����
	for (uint8_t i = 0;i < 4; i++){		//���µ���ٶ�
		chassisComFeedbackUpdata->motor_chassis[i].speed_feedback =
				chassisComFeedbackUpdata->motor_chassis[i].chassis_motor_measure->speed_rpm;
        //���½Ƕ�ֵcyclinder_angle
		chassisComFeedbackUpdata->motor_chassis[i].cyclinder_angle = chassisComFeedbackUpdata->motor_chassis[i].chassis_motor_measure->angle
				- chassisComFeedbackUpdata->motor_chassis[i].offset_angle;
	}
}


/****************************************************�ָ���************************************************************/


/**
  * @func 	���̳�ʼ��
  * @param	��ʼ����chassis_move��������
  * @note	����pid��ʼ����ң����ָ���ʼ�������̵����ʼ��
  * 		��̨�����ʼ���������ǽǶ�ָ���ʼ��
  * @retval None
  */
static void chassis_init(chassis_move_t *chassis_move_init)
{
	uint8_t i = 0;
	//��ʼ���������
	if(chassis_move_init == NULL) {
		return;
	}
	//���̿���״̬��ʼ��
	chassis_move_init->chassis_move_mode = ROBOT_UART_POSITION_PID_MODE;	//���̿���״̬Ϊ�����ƶ�ģʽ
	//��ȡң����ָ��
	chassis_move_init->chassis_RC = &RC_CtrlData;			//��ң���������ṹ��ָ��ĵ�ַ���д���
	chassis_move_init->Motor_PCctrl = &myuart8ctrldata_t;      //��PC���ڷ��͵����ݽ��д���



	//��ȡ���̵������ָ�룬��ʼ���ٶ�PID
	for (i = 0; i < 4; i++){
		chassis_move_init->motor_chassis[i].chassis_motor_measure = get_chassis_motor_measure_point(i);	//���ؼ���
		pid_init(&chassis_move_init->moto_pid_speed[i], PID_POSITION_MODE, motor_speed_pid,
				M3508_SPEED_PID_MAX_OUT, M3508_SPEED_PID_MAX_INTE_OUT);
		pid_init(&chassis_move_init->moto_pid_position[i], PID_POSITION_MODE, motor_position_pid,
				M3508_POSITION_PID_MAX_OUT, M3508_POSITION_PID_MAX_INTE_OUT);
	}

	//һ�׵�ͨ�˲���ʼ��
	for (i=0;i<4;i++){
		first_order_filter_init(&chassis_move_init->motor_Fir_ord_filt_set[i], MOTOR_FILTER_FRAME_PERIOD,
				MOTOR_FILTER_TIME_CONST_SET);
	}



    //����ٶ�����
	chassis_move_init->Motor_speed_max= Motor_MAX_SPEED;
	chassis_move_init->Motor_speed_min= -Motor_MAX_SPEED;
	//��ʼ����ɺ���²�������
//	chassis_feedback_updata(chassis_move_init);


}

/**
  * @func 	�����˶�ģʽ����
  * @param
  * @note	ͨ�����뿪�ؽ���ģʽ�л�
  * 		ͨ���߼��жϣ���ֵ��chassis_behaviour_mode������ģʽ�л�
  * @retval None
  */

static void chassis_set_mode(chassis_move_t *chassis_move_mode)
{
	if (chassis_move_mode == NULL){
		return;
	}
	chassis_move_mode->chassis_RC = &RC_CtrlData;			//��ң���������ṹ��ָ��ĵ�ַ���д���
	chassis_move_mode->Motor_PCctrl = &myuart8ctrldata_t;      //��PC���ڷ��͵����ݽ��д���
	chassis_behaviour_mode_set(chassis_move_mode);

}

/**
  * @func 	�������ݲ���ֵ����
  * @param	chassis_move_updata:�����ṹ��
  * @note	�����������ݡ�����ٶȡ�ŷ���Ƕȡ��������ٶȸ���
  * @retval None
  */
static void chassis_feedback_updata(chassis_move_t *chassis_move_updata,uint8_t  msg_cnt)
{
	if (chassis_move_updata == NULL){
		return;
	}
    if(msg_cnt < 2){
        uint8_t	i;
	   	for (i = 0;i < 4; i++){		//���µ���ٶȡ����ٶȣ������ٶ���ʱû�и��£�����PID��ʱ���ٸ��¡�
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
	   	for (i = 0;i < 4; i++){		//���µ���ٶȡ����ٶȣ������ٶ���ʱû�и��£�����PID��ʱ���ٸ��¡�
	   		chassis_move_updata->motor_chassis[i].speed_feedback =
	   		   					chassis_move_updata->motor_chassis[i].chassis_motor_measure->speed_rpm;

	   		//���½Ƕ�ֵcyclinder_angle��ת�ӽǶȲ�
	   		chassis_move_updata->motor_chassis[i].cyclinder_angle = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle
	   					- chassis_move_updata->motor_chassis[i].offset_angle;
	   		chassis_move_updata->motor_chassis[i].cyc_angle_err = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle - chassis_move_updata->motor_chassis[i].llast_angle;

	   		//���µ��ת��ת���̶�ֵ
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

	   		//����������̶�ֵ���Ƕ�ֵ
//	   		chassis_move_updata->motor_chassis[i].mot_angleCNT = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle + chassis_move_updata->motor_chassis[i].cyc_numberCNT * 8191;
//	   		chassis_move_updata->motor_chassis[i].mot_angle = chassis_move_updata->motor_chassis[i].mot_angleCNT/(8191*18.00f)*360;
	   		//����ת��last�Ƕ�ֵ
	   		chassis_move_updata->motor_chassis[i].llast_angle = chassis_move_updata->motor_chassis[i].chassis_motor_measure->angle;
	   	  }
    }
 }

/**
  * @func 	���ݵ��̿���ģʽ�����õ��̿���ֵ
  * @param
  * @note	�˶�����ֵvx_set��ͨ��chassis_behaviour_mode_set����
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
	chassis_behaviour_ctrl_var_set(chassis_set_ctrl);	//������ֵ������

	 if (chassis_set_ctrl->chassis_move_mode == ROBOT_STOP_MODE){			//�ٶ���ң�������ƣ����нǶȻ������ٶȻ�
		//���̽ǶȻ�����
	}
	else{	//�ٶȻ�ģʽ
		for(i=0;i<4;i++){
			chassis_set_ctrl->Motor_speed_set[i] = fp32_constrain(chassis_set_ctrl->Motor_speed_set[i], chassis_set_ctrl->Motor_speed_min, chassis_set_ctrl->Motor_speed_max);
		}
	}
}

/**
  * @func 	ѭ�����ƣ����ݿ����趨ֵ������������ֵ�����п���
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
//	//�������ӿ�������ٶȣ�������������ٶ�
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

	//������ؽڵ����λ�ú��ٶ�PID
	if (chassis_loop_ctrl->chassis_move_mode == ROBOT_UART_POSITION_PID_MODE){                  //something wrong
	  for (i = 0; i <4; i++){
		  pid_calculation(&chassis_loop_ctrl->moto_pid_position[i], chassis_loop_ctrl->Motor_position_set[i],
		  				chassis_loop_ctrl->motor_chassis[i].mot_cycleNUM);

		  chassis_loop_ctrl->moto_pid_position[i].PID_out = fp32_constrain(chassis_loop_ctrl->moto_pid_position[i].PID_out, -3500, 3500);    //λ��PID�޷�

		  pid_calculation(&chassis_loop_ctrl->moto_pid_speed[i], chassis_loop_ctrl->moto_pid_position[i].PID_out,
				chassis_loop_ctrl->motor_chassis[i].speed_feedback);

		  chassis_loop_ctrl->moto_pid_speed[i].PID_out = fp32_constrain(chassis_loop_ctrl->moto_pid_speed[i].PID_out, -12000, 12000);         //�ٶ�PID�޷�
	      }
	}
	else
	{
		 for (i = 0; i <4; i++){
			 pid_calculation(&chassis_loop_ctrl->moto_pid_speed[i], chassis_loop_ctrl->motor_chassis[i].speed_set,
							chassis_loop_ctrl->motor_chassis[i].speed_feedback);
		 }
	}

	//�������ֵ
	for (i = 0; i <4; i++){
		chassis_loop_ctrl->motor_chassis[i].give_current = (int16_t)(chassis_loop_ctrl->moto_pid_speed[i].PID_out);
	}

}

/************************************************************************************************
 * 									���²���Ϊֱ����ʻ��������
 * **********************************************************************************************/

/**
  * @func 	�ж��Ƿ�ֱ����ʻ����
  * @param	ch0->����ƽ�ơ�ch1->ǰ��ch2->��������
  * @note
  * @retval 0->����ƽ�ƶ���;1->ǰ����;2->��������;4->�ֶ��������������Զ���������
  */
//static uint8_t Remote_Ctrl_Mode (uint16_t ch0, uint16_t ch1, uint16_t ch2)
//{
//	if ((ch0 != 0) && (ch1 == 0) && (ch2 == 0)) {		//����ƽ�ƶ���
//		return 0;
//	}
//	else if ((ch1 != 0) && (ch0 == 0) && (ch2 == 0)) {	//ǰ����
//		return 1;
//	}
//	else if ((ch2 != 0) && (ch1 == 0) && (ch2 == 0)) {	//��������
//		return 2;
//	}
//	else
//		return 4;		//�ֶ��������������Զ���������
//}

/**
  * @func	��ȡYaw��ʼֵ
  * @param
  * @note	1sʱ���ȡһ�����ݣ����ϸ����ݽ��бȽ�
  * 		IMUInitData[0]->��һ������
  * 		IMUInitData[1]->��������
  * 		IMUInitData[2]->�����������ֵС��1����
  * 		IMUInitData[3]->��Ч���ݼ�¼
  * @retval
  */
//static uint8_t Get_Chassis_Yaw_Init_Data(float yaw)
//{
//	//���������ݷŴ�100������ȡת��Ϊ����ֵ���ݽ��д���
//	IMUInitData[1] = abs((int16_t)(yaw * 100));
//	//printf("IMUInitData[1] = %d, IMUInitData[2] = %d\r\n",IMUInitData[1],IMUInitData[2]);
//	if (abs( IMUInitData[1] - IMUInitData[0] ) > 80 ) {		//���ֵ����1����Ϊ������
//		IMUInitData[0] = IMUInitData[1];	//������һ������
//		IMUInitData[2] = 0;		//��Ч���ݸ�������
//		return 1;
//	}
//	else if (abs( IMUInitData[1] - IMUInitData[0] ) <= 80) {	//���ֵС��1����Ϊ��Ч����
//		if (IMUInitData[2] != 0) {		//����Ѿ���⵽һ����Ч����
//			if (abs( IMUInitData[1] - IMUInitData[3]) <= 80 ) {	//��⵽��Ч�����£��ҵ�ǰ����Ϊ��Ч����
//				IMUInitData[2] += 1;		//��Ч���ݼ�1
//				if (IMUInitData[2] >= 3) {	//����3�λ�ȡ����Ч���ݣ���Ϊ��Ч����
//					return 0;
//				}
//			}
//			else {		//��ǰ���ݺ���Ч�����нϴ�仯����Ϊ����δ�ȶ�
//				IMUInitData[2] = 0;			//��Ч��������
//			}
//		}
//		IMUInitData[0] = IMUInitData[1];	//������һ������
//		IMUInitData[3] = IMUInitData[1];	//��¼��Ч����
//		if (IMUInitData[2] < 1) {
//			IMUInitData[2] = 1;		//��Ч���ݼ�1
//		}
//			return 2;
//	}
//}
//
/**
  * @func	ƫ�������
  * @param
  * @note	ƫ����������5�ȣ����в���
  * 		��ע�⣡����������������������Ҫ���ʱ����֤���ǣ���ֹ����������ݽ��д��󲹳�
  * @retval	0->��������1->ֱ����ƫ������2->ֱ����ƫ����
  */

//static uint8_t Chassis_Offset_Detection(float initYaw, float currYaw)
//{
//	//���������Ŵ�100�������д���
//	int16_t initYaw_INT = (int16_t)(initYaw * 100);
//	int16_t currYaw_INT = (int16_t)(currYaw * 100);
//	int16_t offsetVal	= initYaw_INT - currYaw_INT;
//	//printf("initYaw_INT = %d	currYaw_INT = %d offsetVal = %d\r\n",initYaw_INT, currYaw_INT, offsetVal);
//	if (offsetVal <= -500) {		//��ƫ
//		//printf("Right\n");
//		return 1;
//	}
//	else if (offsetVal >= 500) {	//��ƫ
//		//printf("Left\r\n");
//		return 2;
//	}
//	else{	//С��5�㣬��Ϊ��ƫ
//		//printf("NO Offset\r\n");
//		return 0;
//	}
//}

/**
  * @func 	ң����ת��������ж�
  * @param
  * @note	ת����ɺ�������ǰ��ʼֵ
  * @retval 0->��������������: ת�����
  */
//static uint8_t Remote_Ctrl_Change_Direction_Judge(int8_t RemoteStatus[3], int16_t Ch0, int16_t Ch1, int16_t Ch2,int16_t Ch3)
//{
//	if ((Ch2 != 0) && Ch1 == 0) {		//���ڽ���ת��������
//		RemoteStatus[0] = 1;
//	}
//	if ((RemoteStatus[0] != 0 ) && (Ch2 == 0)) {
//		RemoteStatus[0] = 0;	//���ת����
//		return 1;		//ת������ɱ�־
//	}
//	if ((Ch0 != 0) && Ch1 == 0) {		//���ڽ���ƽ�Ʋ���
//		RemoteStatus[1] = 1;
//	}
//	if ((RemoteStatus[1] != 0 ) && (Ch0 == 0)) {
//		RemoteStatus[1] = 0;	//���ƽ�Ʊ��
//		return 2;		//ƽ�ƶ�����ɱ�־
//	}
//	if ((Ch1 != 0) && (Ch2 != 0)) {		//�ֶ�����ת�����
//		RemoteStatus[2] = 1;
//	}
//	if ((RemoteStatus[2] != 0 ) && (Ch2 == 0)) {
//		RemoteStatus[3] = 0;	//����ֶ����ڱ��
//		return 2;		//�ֶ����ڶ�����ɱ�־
//	}
//	else
//		return 0;		//����������־
//}

/**
  * @func 	ƫ�Ʋ�������
  * @param
  * @note	����ƫ��״̬���Ը�����ת�ٵ���ֵ���в���
  * @retval 0->��ת��1->��ת��2->��ת��
  */

//static void Chassis_Wheel_Compensation()
//{
//
//
//}

