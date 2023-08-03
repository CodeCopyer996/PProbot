/**
  ******************************************************************************
  * @file   base_calculation.c
  * @brief  ��������
  ******************************************************************************
  * @attention
  *			���ٿ�������
  *			һ�׵�ͨ�˲�����
  *			ѭ���޷�����
  ******************************************************************************
  */


#include <Basic_Task/base_calculation.h>


/**
  * @func 	C���Կ��ٿ����㷨��ʹ�õ��ǿ���˵�Fast inverse square root����
  * @author	RM
  * @param	������0x5f3759df���ǿ���˸�����һ��ֵ
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
  * @func 	һ�׵�ͨ�˲���ʼ��
  * @author	RM
  * @param	������filter_t_cali��һ�׵�ͨ�˲��ṹ��
  * 		������frame_period�� �˲�ʱ����
  * 		������time_const�� ģ��ʱ�䳣��
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
  * @func 	һ�׵�ͨ�˲�����
  * @author	RM�����޸ģ�
  * @param	������filter_t_cali��һ�׵�ͨ�˲��ṹ��
  * 		������input�� �����ź�
  * @note	���õ���һ��RC��·��Ч�˲�ģ�ͷ������˲���ʽ���ø�ģ���Ƶ��Ľ������
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
  * @func 	ѭ���޷�����,��Ҫ������������ֵ�ķ�Χ
  * @author	RM
  * @param	input:�������
  * 		min_value:�����޷���Сֵ
  * 		max_value:�����޷����ֵ
  * @note
  * @retval None
  */

float loop_fp32_constrain(float input, float min_value, float max_value)
{
	float len = 0;
	if (max_value < min_value){		//���벻����ֱ�ӷ���ԭֵ
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
  * @func 	�޷�����,��Ҫ������������ֵ�ķ�Χ
  * @author	RM
  * @param	value:�������
  * 		min_value:�����޷���Сֵ
  * 		max_value:�����޷����ֵ
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




