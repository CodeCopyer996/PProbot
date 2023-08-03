/**
  ******************************************************************************
  * @file   pid_task.c
  * @brief  ��Ҫ����PID����
  ******************************************************************************
  * @attention
  *			PID��ʼ��
  *			PID����
  *			PID����
  ******************************************************************************
  */

#include <Basic_Task/pid_task.h>

/**
  * @func 	PID�޷�����
  * @param	input:�������
  * 		max:  �������ֵ����
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
  * @func 	PID��ʼ��
  * @param	pid_init��	PID�ṹ������ָ��
  * 		mode��		��ͨPID
  * 		PID[3]:		KP��KI��KD����
  * 		max_out:	PID����������
  * 		max_inte_out:PID����������
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
  * @func 	PID����
  * @param	pid_calc��PID�����ṹ��
  * 		set_data��PID�趨����
  * 		feedback_data��PID��������
  * @note
  * @retval None
  */

fp32 pid_calculation(pid_param_t *pid_calc, fp32 set_data, fp32 feedback_data)
{
	if (pid_calc == NULL){
		return 0.0f;
	}
	pid_calc->Error[2] = pid_calc->Error[1];					//����ǰ�������Ϊǰһ�����
	pid_calc->Error[1] = pid_calc->Error[0];					//����ǰһ�����Ϊ��ǰ���
	pid_calc->set_data = set_data;
	pid_calc->feedback_data = feedback_data;
	pid_calc->Error[0] = set_data - feedback_data;				//��ȡ��ǰ���
	if (pid_calc->mode == PID_POSITION_MODE){	 //λ��ʽPID
		pid_calc->Pout = pid_calc->Kp * pid_calc->Error[0];		//��ɢ������
		pid_calc->Iout += pid_calc->Ki * pid_calc->Error[0];	//��ɢ������
		pid_calc->Debuff[2] = pid_calc->Debuff[1];				//����ǰ��������ֵ
		pid_calc->Debuff[1] = pid_calc->Debuff[0];				//����ǰһ������ֵ
		pid_calc->Debuff[0] = pid_calc->Error[0] - pid_calc->Error[1];			//��ȡ����ֵ
		pid_calc->Dout = pid_calc->Kd * pid_calc->Debuff[0];
		pid_calc->PID_out = pid_calc->Pout + pid_calc->Iout + pid_calc->Dout;	//����PID���ֵ��С
		limt_max(pid_calc->Pout, pid_calc->max_out);							//����PID�����С
	}
	else if (pid_calc->mode == PID_INCER_MODE){		//����ʽPID
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
  * @func 	PID���
  * @param	pid_clear�����ṹ��
  * @note	PID�趨����ȫ�����㴦��
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





