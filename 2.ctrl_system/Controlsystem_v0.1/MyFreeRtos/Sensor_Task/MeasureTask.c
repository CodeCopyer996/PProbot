/**
  ******************************************************************************
  * @file   MeasureTask.c
  * @brief  数据采集任务
  ******************************************************************************
  * @attention
  *			四路超声波传感器采集模块
  *			GPS数据采集模块
  *			红外数据采集模块
  ******************************************************************************
  */

#include <Sensor_Task/MeasureTask.h>

#define EN_MEASURE_TASK			1		//任务功能开启
#define EN_ULTRA_MEASURE		1		//超声波测量功能开启
#define EN_PRESSURE_MEASURE		0		//压力传感器测量功能开启


//打印输出缓存
char Measure_Info_buf[300];

extern UltrasonicDate_t UltraStruData;

extern UART_HandleTypeDef huart7;		//超声波传感器
extern UART_HandleTypeDef huart2;
extern TIM_HandleTypeDef htim14;

/**
  * @func 	测量任务
  * @param	argument：空
  * @note	四路超声波传感器测量
  * 		GPS数据测量
  * 		红外数据测量
  * @retval None
  */
void measureTask(void const * argument)
{
#if EN_MEASURE_TASK
	#if	EN_ULTRA_MEASURE
	vPortEnterCritical();		//进入临界保护
	__HAL_UART_ENABLE_IT(&huart7, UART_IT_RXNE);		//打开串口7接收中断
	vPortExitCritical();		//退出临界保护
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
		ultrasonicMeasure();		//四路超声波数据采集
	#endif

	#if EN_PRESSURE_MEASURE
		pressureData = HX711ReadData();		//获取数据
		printf("pressureData = %ld\n",pressureData);
/*		//定时器测试函数
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
  * @func 	四路超声波传感器测量
  * @param
  * @note	测试使用，使用四路超声波传感器，注意供应电流问题
  * @retval None
  */

void ultrasonicMeasure()
{
	uint16_t testData = 0;
	uint8_t i, ultrStationNum;
	for (i = 1; i < 5; i++){
		vPortEnterCritical();		//进入临界保护
		ultrStationSendDataFun(i);
		vPortExitCritical();		//退出临界保护
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

