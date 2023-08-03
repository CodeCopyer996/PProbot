#ifndef __CHASSIS_TASK_H__
#define __CHASSIS_TASK_H__

#include <math.h>

#include "Basic_Task/base_calculation.h"
#include "Basic_Task/pid_task.h"
#include <Commnication_Task/CANCom.h>
#include <Commnication_Task/remoteCom.h>
#include <Commnication_Task/Uart8_DMA_RT.h>

#define MOTORDRIVE_TASK_INIT_TIME	500		//���ʱ�����ڳ�ʼ����������

//PID��������
//���̵���ٶ�PID����
//��ʼֵKP=10000.0f��KI=2500.0f��KD = 55.0f��MaxOut=200.0f
#define M3508_SPEED_PID_KP				1.8f
#define M3508_SPEED_PID_KI				0.1f
#define M3508_SPEED_PID_KD				0.0f
#define M3508_SPEED_PID_MAX_OUT			M3508_MAX_CURR
#define M3508_SPEED_PID_MAX_INTE_OUT	2000.0f

#define M3508_POSITION_PID_KP				150.0f
#define M3508_POSITION_PID_KI				0.0001f
#define M3508_POSITION_PID_KD				0.0f
#define M3508_POSITION_PID_MAX_OUT			4000.0f
#define M3508_POSITION_PID_MAX_INTE_OUT	    2000.0f
//M3508���������ֵ,��ʼֵ1000
#define M3508_MAX_CURR	4000.0f
//����ٶ����ֵ����
#define Motor_MAX_SPEED		1.0f	//�����������ٶ�����
#define Motor_RCtoM_LEN     0.006f          //ң����ң��ת��Ϊ���ת�ٵı�������

//���ת��ת��Ϊ�ƶ��ٶȱ�������
#define M3508_MOTOR_RPM_TO_VECTOR_SEN		0.00042f		//���̵���ٶ�ת��Ϊ�ƶ��ٶ�
//#define M3508_MOTOR_RPM_TO_VECTOR_SEN		1.0f		//���̵���ٶ�ת��Ϊ�ƶ��ٶ�


//һ�׵�ͨ�˲�����
#define MOTOR_FILTER_FRAME_PERIOD			0.002f			//һ���˲������ʱ��
#define MOTOR_FILTER_TIME_CONST_SET	        0.3333f			//���ʱ�䳣��

//���������Ϊģʽ
typedef enum {
	//������Ϊģʽ
	ROBOT_STOP_MODE,				//�����ƶ�ģʽ
	ROBOT_MOTOR_SPEED_PID_MODE,	    //����ٶȻ�ģʽ
    ROBOT_UART_POSITION_PID_MODE,   //���λ�û�ģʽ
}chassis_behaviour_mode_e;

#define ROBOT_STOP_MODE 1
#define ROBOT_MOTOR_SPEED_PID_MODE  2
#define ROBOT_UART_POSITION_PID_MODE  3
//���̵�����Ʋ���
typedef struct {
	const 	 moto_measure_t	*chassis_motor_measure; 	//��ȡ�����������
	fp32 	 accel;										//��ȡ���̵�����ٶ�ֵ
	fp32 	 speed_set;									//����ٶ�ң�����趨ֵ
	fp32 	 speed_feedback;							//����ٶȷ���ֵ
	int16_t  give_current;								//������ת���֣�������int����

    int16_t   offset_angle;                            //�ϵ����ת�ӳ�ʼƫ��ֵ = angle(��ʼֵ��
	int16_t   cyclinder_angle;                         //���ת��ת��λ��(����ֵ ����ʽ) = angle - offset_angle
	int16_t   cyclinder_lastangle;
    int16_t   cyc_angle_err;                            //���ת�����μ��ֵ
    int32_t   cyc_numberCNT;                            //���ת��ת��
    int16_t   llast_angle;                              //ǰ�ڶ���ת��λ��

    int16_t   mot_angle;                                //��������ĽǶȣ��㣩
    int32_t   mot_angleCNT;                             //���������ܵ�ת�ӿ̶���
    int16_t   mot_cycleNUM;                             //����������תȦ��

}chassis_motor_t;

//��������˶�����,�������������
typedef struct {
	const RC_Ctl_t 				*chassis_RC;					//ң��������
	pid_param_t 				moto_pid_speed[4];				//���PID����ṹ��
	pid_param_t                 moto_pid_position[4];           //���λ��PID�ṹ��
	first_order_filter_t 		chassis_Fir_ord_filt_set_vx;	//����һ���˲�������x����
	first_order_filter_t 		chassis_Fir_ord_filt_set_vy;	//����һ���˲�������y����
   	first_order_filter_t        motor_Fir_ord_filt_set[6];      //�ؽڵ��һ���˲����ýṹ������
	chassis_behaviour_mode_e	chassis_move_mode;				//��������ƶ���Ϊģʽ
	chassis_behaviour_mode_e	last_chassis_mode;				//�����ϴο���״̬�������ڵ��̹�������
	chassis_motor_t				motor_chassis[4];				//�����ĸ������������


	fp32 Motor_speed_set[4];
    int16_t Motor_position_set[4];

    const my_Uart8_RX_Data_t    *Motor_PCctrl;                            //���ڿ��Ʒ���ָ��
    fp32 Motor_speed_max;
    fp32 Motor_speed_min;


}chassis_move_t;




#endif

