/**
  ******************************************************************************
  * @file   PressureMeasurt.c
  * @brief  ѹ�����ݲɼ�
  ******************************************************************************
  * @attention	�ɼ�ѹ������
  * @Date		2021/6/17
  * @author		YM
  ******************************************************************************
  */
#include <Sensor_Task/PressureMeasure.h>

/**
  * @func 	ѹ��������ģ�����ݻ�ȡ
  * @param
  * @note	��ʹ��ѹ��������ģ���ʱ����Ҫע����Ƕ��ڸߵ�ƽ������ʱ����Ҫ��ʹ��ʱ��Ҫע��
  * @retval None
  */

uint32_t HX711ReadData(void)
{
	uint32_t	count;
	HX711_CLK1_LOW;				//CLK���ͣ�ʹ��ģ��AD
	count = 0;
	while (HX711_DAT1_STATUS);	//�ȴ�ADת������
	for (uint8_t i = 0; i < 24; i ++) {
		HX711_CLK1_HIGH;		//CLK�øߣ���������
		myDelay_us(10);
		count = count << 1;		//�½�����ʱ����Count����һλ���Ҳಹ��
		HX711_CLK1_LOW;			//CLK�õ�
		if (HX711_DAT1_STATUS) {
			count++;
		}
	}
	HX711_CLK1_HIGH;
	myDelay_us(10);
	count = count ^ 0x800000;	//��25�������½�����ʱ��ת������
	HX711_CLK1_LOW;
	myDelay_us(5);
	return(count);
}
