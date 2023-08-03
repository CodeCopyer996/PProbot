#ifndef __PID_TASK_H_
#define __PID_TASK_H_

#include <Basic_Task/base_task.h>

#define PID_POSITION_MODE	1
#define PID_INCER_MODE		2

typedef struct {
	uint8_t	mode;	//PIDģʽ
	//PID��������ȷ��
	fp32	Kp;
	fp32	Ki;
	fp32	Kd;
	//PID�������
	fp32	max_out;		//������
	fp32	max_inte_out;	//������������

	fp32	set_data;			//�趨ֵ
	fp32	feedback_data;		//����ֵ
	//PID������
	fp32	PID_out;
	fp32	Pout;
	fp32	Iout;
	fp32	Dout;
	//PID��������
	fp32	Debuff[3];	//΢���0�����£�1����һ�Σ�2��������
	fp32	Error[3];	//����0�����£�1����һ�Σ�2��������
}pid_param_t;



/*			������������				*/
//PID ��ʼ��
void pid_init(pid_param_t *pid_init, uint8_t mode, const fp32 PID[3], fp32 max_out, fp32 max_inte_out);
//PID����
fp32 pid_calculation(pid_param_t *pid_calc, fp32 set_data, fp32 feedback_data);
//PID����
void pid_clear(pid_param_t *pid_clear);

#endif
