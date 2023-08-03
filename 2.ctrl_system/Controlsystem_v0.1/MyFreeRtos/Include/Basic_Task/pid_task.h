#ifndef __PID_TASK_H_
#define __PID_TASK_H_

#include <Basic_Task/base_task.h>

#define PID_POSITION_MODE	1
#define PID_INCER_MODE		2

typedef struct {
	uint8_t	mode;	//PID模式
	//PID三个参数确定
	fp32	Kp;
	fp32	Ki;
	fp32	Kd;
	//PID输出限制
	fp32	max_out;		//最大输出
	fp32	max_inte_out;	//积分项最大输出

	fp32	set_data;			//设定值
	fp32	feedback_data;		//反馈值
	//PID输出结果
	fp32	PID_out;
	fp32	Pout;
	fp32	Iout;
	fp32	Dout;
	//PID输出误差项
	fp32	Debuff[3];	//微分项：0：最新；1：上一次；2：上两次
	fp32	Error[3];	//误差项：0：最新；1：上一次；2：上两次
}pid_param_t;



/*			函数声明部分				*/
//PID 初始化
void pid_init(pid_param_t *pid_init, uint8_t mode, const fp32 PID[3], fp32 max_out, fp32 max_inte_out);
//PID计算
fp32 pid_calculation(pid_param_t *pid_calc, fp32 set_data, fp32 feedback_data);
//PID清零
void pid_clear(pid_param_t *pid_clear);

#endif
