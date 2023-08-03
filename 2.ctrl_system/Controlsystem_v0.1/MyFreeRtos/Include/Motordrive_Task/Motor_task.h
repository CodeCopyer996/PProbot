#ifndef __CHASSIS_TASK_H__
#define __CHASSIS_TASK_H__

#include <math.h>

#include "Basic_Task/base_calculation.h"
#include "Basic_Task/pid_task.h"
#include <Commnication_Task/CANCom.h>
#include <Commnication_Task/remoteCom.h>
#include <Commnication_Task/Uart8_DMA_RT.h>

#define MOTORDRIVE_TASK_INIT_TIME	500		//这段时间用于初始化底盘任务

//PID参数设置
//底盘电机速度PID参数
//初始值KP=10000.0f、KI=2500.0f、KD = 55.0f、MaxOut=200.0f
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
//M3508电机最大电流值,初始值1000
#define M3508_MAX_CURR	4000.0f
//电机速度最大值限制
#define Motor_MAX_SPEED		1.0f	//单个电机最大速度限制
#define Motor_RCtoM_LEN     0.006f          //遥控器遥感转换为电机转速的比例因子

//电机转速转换为移动速度比例因子
#define M3508_MOTOR_RPM_TO_VECTOR_SEN		0.00042f		//底盘电机速度转换为移动速度
//#define M3508_MOTOR_RPM_TO_VECTOR_SEN		1.0f		//底盘电机速度转换为移动速度


//一阶低通滤波参数
#define MOTOR_FILTER_FRAME_PERIOD			0.002f			//一阶滤波器间隔时间
#define MOTOR_FILTER_TIME_CONST_SET	        0.3333f			//电机时间常数

//定义底盘行为模式
typedef enum {
	//底盘行为模式
	ROBOT_STOP_MODE,				//底盘制动模式
	ROBOT_MOTOR_SPEED_PID_MODE,	    //电机速度环模式
    ROBOT_UART_POSITION_PID_MODE,   //电机位置环模式
}chassis_behaviour_mode_e;

#define ROBOT_STOP_MODE 1
#define ROBOT_MOTOR_SPEED_PID_MODE  2
#define ROBOT_UART_POSITION_PID_MODE  3
//底盘电机控制参数
typedef struct {
	const 	 moto_measure_t	*chassis_motor_measure; 	//获取电机测量参数
	fp32 	 accel;										//获取底盘电机加速度值
	fp32 	 speed_set;									//电机速度遥控器设定值
	fp32 	 speed_feedback;							//电机速度反馈值
	int16_t  give_current;								//有正反转区分，所以是int类型

    int16_t   offset_angle;                            //上电后电机转子初始偏差值 = angle(初始值）
	int16_t   cyclinder_angle;                         //电机转子转角位置(绝对值 增量式) = angle - offset_angle
	int16_t   cyclinder_lastangle;
    int16_t   cyc_angle_err;                            //电机转子两次间差值
    int32_t   cyc_numberCNT;                            //电机转子转数
    int16_t   llast_angle;                              //前第二次转子位置

    int16_t   mot_angle;                                //电机输出轴的角度（°）
    int32_t   mot_angleCNT;                             //电机输出轴总的转子刻度数
    int16_t   mot_cycleNUM;                             //电机输出轴旋转圈数

}chassis_motor_t;

//定义底盘运动参数,多个电机共享参数
typedef struct {
	const RC_Ctl_t 				*chassis_RC;					//遥控器属性
	pid_param_t 				moto_pid_speed[4];				//电机PID计算结构体
	pid_param_t                 moto_pid_position[4];           //电机位置PID结构体
	first_order_filter_t 		chassis_Fir_ord_filt_set_vx;	//底盘一阶滤波器设置x方向
	first_order_filter_t 		chassis_Fir_ord_filt_set_vy;	//底盘一阶滤波器设置y方向
   	first_order_filter_t        motor_Fir_ord_filt_set[6];      //关节电机一阶滤波设置结构体数组
	chassis_behaviour_mode_e	chassis_move_mode;				//定义底盘移动行为模式
	chassis_behaviour_mode_e	last_chassis_mode;				//底盘上次控制状态机，用于底盘过渡作用
	chassis_motor_t				motor_chassis[4];				//底盘四个电机控制属性


	fp32 Motor_speed_set[4];
    int16_t Motor_position_set[4];

    const my_Uart8_RX_Data_t    *Motor_PCctrl;                            //串口控制发送指令
    fp32 Motor_speed_max;
    fp32 Motor_speed_min;


}chassis_move_t;




#endif

