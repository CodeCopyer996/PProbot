/**
  ******************************************************************************
  * @file   base_calculation.c
  * @brief  基础计算
  ******************************************************************************
  * @attention
  *			快速开方函数
  *			一阶低通滤波函数
  *			循环限幅函数
  ******************************************************************************
  */


#include <Basic_Task/base_calculation.h>


/**
  * @func 	C语言快速开方算法，使用的是卡马克的Fast inverse square root方法
  * @author	RM
  * @param	参数：0x5f3759df，是卡马克给出的一个值
  * @retval None
  */
fp32 Fast_inv_square(fp32 num)
{
	fp32 half_num = 0.5f * num;
	fp32 y = num;
	long i = *(long *)&y;
	i = 0x5f3759df - (i>>1);
	y = *(fp32 *)&i;
	y = y * (1.5f - (half_num * y *y));
	return y;
}

/**
  * @func 	一阶低通滤波初始化
  * @author	RM
  * @param	参数：filter_t_cali，一阶低通滤波结构体
  * 		参数：frame_period， 滤波时间间隔
  * 		参数：time_const， 模型时间常数
  * @retval None
  */
void first_order_filter_init(first_order_filter_t *filter_t_init, fp32 frame_period, const fp32 time_const)
{
	filter_t_init->frame_period  = frame_period;
	filter_t_init->time_constant = time_const;
	filter_t_init->inout		 = 0.0f;
	filter_t_init->out 			 = 0.0f;
}

/**
  * @func 	一阶低通滤波计算
  * @author	RM（已修改）
  * @param	参数：filter_t_cali，一阶低通滤波结构体
  * 		参数：input， 输入信号
  * @note	采用的是一阶RC电路等效滤波模型分析，滤波公式采用改模型推导的结果分析
  * @retval None
  */
void first_order_filter_calculation(first_order_filter_t *filter_t_cali, fp32 input)
{
	filter_t_cali->inout	= input;
		filter_t_cali->out	=
					filter_t_cali->time_constant / (filter_t_cali->time_constant + filter_t_cali->frame_period)*filter_t_cali->out +
					filter_t_cali->frame_period / (filter_t_cali->time_constant + filter_t_cali->frame_period)*filter_t_cali->inout;
}

/**
  * @func 	循环限幅函数,主要用于修正输入值的范围
  * @author	RM
  * @param	input:输入参数
  * 		min_value:输入限幅最小值
  * 		max_value:输入限幅最大值
  * @note
  * @retval None
  */

float loop_fp32_constrain(float input, float min_value, float max_value)
{
	float len = 0;
	if (max_value < min_value){		//输入不合理，直接返回原值
		return input;
	}
	if (input >max_value){
		len =  max_value - min_value;
		while (input > max_value){
			input -= len;
		}
	}
	else if (input < min_value){
		len =  max_value - min_value;
		while (input < len){
			input += len;
		}
	}
	return input;
}

/**
  * @func 	限幅函数,主要用于修正输入值的范围
  * @author	RM
  * @param	value:输入参数
  * 		min_value:输入限幅最小值
  * 		max_value:输入限幅最大值
  * @note
  * @retval None
  */

fp32 fp32_constrain(fp32 value, fp32 min_value, fp32 max_value)
{
	if (value < min_value){
		return min_value;
	}
	else if (value > max_value){
		return max_value;
	}
	else
		return value;
}




