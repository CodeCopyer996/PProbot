/**
  ******************************************************************************
  * @file   MeasureTask.c
  * @brief  ���ݲɼ�����
  ******************************************************************************
  * @attention
  *			��·�������������ɼ�ģ��
  *			GPS���ݲɼ�ģ��
  *			�������ݲɼ�ģ��
  ******************************************************************************
  */

#include <Sensor_Task/MeasureTask.h>

#define EN_MEASURE_TASK			1		//�����ܿ���
#define EN_ULTRA_MEASURE		1		//�������������ܿ���
#define EN_PRESSURE_MEASURE		0		//ѹ���������������ܿ���


//��ӡ�������
char Measure_Info_buf[300];

extern UltrasonicDate_t UltraStruData;

extern UART_HandleTypeDef huart7;		//������������
extern UART_HandleTypeDef huart2;
extern TIM_HandleTypeDef htim14;

/**
  * @func 	��������
  * @param	argument����
  * @note	��·����������������
  * 		GPS���ݲ���
  * 		�������ݲ���
  * @retval None
  */
void measureTask(void const * argument)
{
#if EN_MEASURE_TASK
	#if	EN_ULTRA_MEASURE
	vPortEnterCritical();		//�����ٽ籣��
	__HAL_UART_ENABLE_IT(&huart7, UART_IT_RXNE);		//�򿪴���7�����ж�
	vPortExitCritical();		//�˳��ٽ籣��
	#endif
	#if EN_PRESSURE_MEASURE
		uint32_t pressureData;
		uint16_t i;
		HAL_TIM_Base_Start_IT(&htim14);
	#endif

#endif
	for(;;)
	{
#if	EN_MEASURE_TASK

	#if	EN_ULTRA_MEASURE
		ultrasonicMeasure();		//��·���������ݲɼ�
	#endif

	#if EN_PRESSURE_MEASURE
		pressureData = HX711ReadData();		//��ȡ����
		printf("pressureData = %ld\n",pressureData);
/*		//��ʱ�����Ժ���
		for(i = 0; i < 100; i++){
			myDelay_us(1000);
		}
		printf("us is ok \n");*/
	#endif

#endif
		osDelay(10);
	}

}

/**
  * @func 	��·����������������
  * @param
  * @note	����ʹ�ã�ʹ����·��������������ע�⹩Ӧ��������
  * @retval None
  */

void ultrasonicMeasure()
{
	uint16_t testData = 0;
	uint8_t i, ultrStationNum;
	for (i = 1; i < 5; i++){
		vPortEnterCritical();		//�����ٽ籣��
		ultrStationSendDataFun(i);
		vPortExitCritical();		//�˳��ٽ籣��
		if (UltraStruData.RecriveFrameDataFalg == 1) {
			testData = UltraStruData.DataUltrCurrent;
			ultrStationNum = UltraStruData.StationNumCurrent;
			UltraStruData.RecriveFrameDataFalg = 0;
/*			sprintf(Measure_Info_buf, "**** ultrStationNum: %d    MeasureData: %d  \r\n", ultrStationNum,testData);
			HAL_UART_Transmit(&huart2, (uint8_t *)Measure_Info_buf, (COUNTOF(Measure_Info_buf)-1), 55);*/
		}
		osDelay(17);
	}
}

