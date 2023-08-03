#ifndef _BASE_CALCULATION_H_
#define _BASE_CALCULATION_H_

#include <Commnication_Task/CANCom.h>

#define PI	3.1415f

//�Ƕȸ�ʽ��Ϊ������
#define rad_format(ang)		loop_fp32_constrain(ang, -PI, PI)

//�˲��������ṹ��
typedef struct{
	fp32 inout;				//��������
	fp32 out;				//�˲��������
	fp32 time_constant;		//�˲�ʱ�䳣������
	fp32 frame_period;		//�˲����ʱ��
}__packed first_order_filter_t;


fp32 Fast_inv_square(fp32 num);
void first_order_filter_init(first_order_filter_t *filter_t_init, fp32 frame_period, const fp32 time_const);

void first_order_filter_calculation(first_order_filter_t *filter_t_cali, fp32 input);

fp32 fp32_constrain(fp32 value, fp32 min_value, fp32 max_value);	//�޷�����


#endif



