/**
  ******************************************************************************
  * @file   pid_task.c
  * @brief  主要用于PID计算
  ******************************************************************************
  * @attention
  *			PID初始化
  *			PID计算
  *			PID清零
  ******************************************************************************
  */

#include <Basic_Task/pid_task.h>

/**
  * @func 	PID限幅函数
  * @param	input:输入参数
  * 		max:  输入最大值限制
  * @retval None
  */

#define limt_max(input, max) {			\
			if (input > max) {			\
				input = max;			\
			}							\
			else if (input < -max) {	\
				input = -max;			\
			}							\
		}

/**
  * @func 	PID初始化
  * @param	pid_init：	PID结构体数据指针
  * 		mode：		普通PID
  * 		PID[3]:		KP、KI、KD参数
  * 		max_out:	PID最大输出限制
  * 		max_inte_out:PID积分最大输出
  * @note
  * @retval None
  */
void pid_init(pid_param_t *pid_init, uint8_t mode, const fp32 PID[3], fp32 max_out, fp32 max_inte_out)
{
	if (pid_init == NULL){
		return;
	}
	pid_init->mode = mode;
	pid_init->Kp = PID[0];
	pid_init->Ki = PID[1];
	pid_init->Kd = PID[2];
	pid_init->max_out = max_out;
	pid_init->max_inte_out = max_inte_out;
	pid_init->Debuff[0] = pid_init->Debuff[1] = pid_init->Debuff[2] = 0.0f;
	pid_init->Error[0] = pid_init->Error[1] = pid_init->Error[2] = 0.0f;
	pid_init->PID_out = 0.0f;
	pid_init->Pout = pid_init->Dout = pid_init->Iout = 0.0f;
}

/**
  * @func 	PID计算
  * @param	pid_calc：PID参数结构体
  * 		set_data：PID设定参数
  * 		feedback_data：PID反馈参数
  * @note
  * @retval None
  */

fp32 pid_calculation(pid_param_t *pid_calc, fp32 set_data, fp32 feedback_data)
{
	if (pid_calc == NULL){
		return 0.0f;
	}
	pid_calc->Error[2] = pid_calc->Error[1];					//更换前两次误差为前一次误差
	pid_calc->Error[1] = pid_calc->Error[0];					//更换前一次误差为当前误差
	pid_calc->set_data = set_data;
	pid_calc->feedback_data = feedback_data;
	pid_calc->Error[0] = set_data - feedback_data;				//获取当前误差
	if (pid_calc->mode == PID_POSITION_MODE){	 //位置式PID
		pid_calc->Pout = pid_calc->Kp * pid_calc->Error[0];		//离散比例项
		pid_calc->Iout += pid_calc->Ki * pid_calc->Error[0];	//离散积分项
		pid_calc->Debuff[2] = pid_calc->Debuff[1];				//更换前两次误差差值
		pid_calc->Debuff[1] = pid_calc->Debuff[0];				//更换前一次误差差值
		pid_calc->Debuff[0] = pid_calc->Error[0] - pid_calc->Error[1];			//获取误差差值
		pid_calc->Dout = pid_calc->Kd * pid_calc->Debuff[0];
		pid_calc->PID_out = pid_calc->Pout + pid_calc->Iout + pid_calc->Dout;	//计算PID输出值大小
		limt_max(pid_calc->Pout, pid_calc->max_out);							//限制PID输出大小
	}
	else if (pid_calc->mode == PID_INCER_MODE){		//增量式PID
		pid_calc->Pout = pid_calc->Kp * (pid_calc->Error[0] - pid_calc->Error[1]);
		pid_calc->Iout = pid_calc->Ki * pid_calc->Error[0];
		pid_calc->Debuff[2] = pid_calc->Debuff[1];
		pid_calc->Debuff[1] = pid_calc->Debuff[0];
		pid_calc->Debuff[0] = pid_calc->Error[0] - 2.0 * pid_calc->Error[1] + pid_calc->Error[2];
		pid_calc->Dout = pid_calc->Kd * pid_calc->Debuff[0];
		limt_max(pid_calc->Pout, pid_calc->max_out);
	}
	return pid_calc->PID_out;
}

/**
  * @func 	PID清除
  * @param	pid_clear参数结构体
  * @note	PID设定参数全部清零处理
  * @retval None
  */

void pid_clear(pid_param_t *pid_clear)
{
	if (pid_clear == NULL){
		return;
	}
	pid_clear->Error[0] = pid_clear->Error[1] = pid_clear->Error[2] = 0.0f;
	pid_clear->Debuff[0] = pid_clear->Debuff[1] = pid_clear->Debuff[2] = 0.0f;
	pid_clear->PID_out = pid_clear->Pout = pid_clear->Iout = pid_clear->Dout = 0.0f;
	pid_clear->set_data = pid_clear->feedback_data = 0.0f;
}





