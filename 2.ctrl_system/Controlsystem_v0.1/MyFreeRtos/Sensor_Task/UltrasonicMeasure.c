/**
  ******************************************************************************
  * @file   UltrasonicMeasure.c
  * @brief  超声波数据采集
  ******************************************************************************
  * @attention
  *			使用串口7对四个超声波传感器数据进行采集
  ******************************************************************************
  */

#include <Sensor_Task/UltrasonicMeasure.h>

#define ULTRBUFFERNUM 10

extern UART_HandleTypeDef huart7;

static uint8_t ultraSendDataStation1[10] = {0x7f,0x01,0x12,0x00,0x00,0x00,0x00,0x00,0x03,0x16};
static uint8_t ultraSendDataStation2[10] = {0x7f,0x02,0x12,0x00,0x00,0x00,0x00,0x00,0x03,0x17};
static uint8_t ultraSendDataStation3[10] = {0x7f,0x03,0x12,0x00,0x00,0x00,0x00,0x00,0x03,0x18};
static uint8_t ultraSendDataStation4[10] = {0x7f,0x04,0x12,0x00,0x00,0x00,0x00,0x00,0x03,0x19};

uint8_t ultraReceiveDataBuffer[ULTRBUFFERNUM];

UltrasonicDate_t UltraStruData;

static uint16_t ReceiveTemp;
static uint8_t TempCounter = 0;

/**
  * @func 	发送数据到超声波传感器
  * @param	ultraStationNum:选中超声波站号
  * @note
  * @retval None
  */
void ultrStationSendDataFun(uint8_t ultraStationNum)
{
	switch(ultraStationNum){
		case 1:		HAL_UART_Transmit(&huart7, ultraSendDataStation1, 10, 100);		break;
		case 2:		HAL_UART_Transmit(&huart7, ultraSendDataStation2, 10, 100);		break;
		case 3:		HAL_UART_Transmit(&huart7, ultraSendDataStation3, 10, 100);		break;
		case 4:		HAL_UART_Transmit(&huart7, ultraSendDataStation4, 10, 100);		break;

		default:	break;
	}
}

/**
  * @func 	串口7接收中断处理
  * @param
  * @note
  * @retval None
  */
void myUsart7RecieveIRQHandle( UART_HandleTypeDef *huart )
{
    if (huart->Instance->SR & UART_FLAG_RXNE) {
    	ReceiveTemp = huart->Instance->DR;
    	ultraReceiveDataBuffer[TempCounter++] = ReceiveTemp;
    	if (TempCounter == 10) {
    		ultrSationDaraReceiveHandle();
    		UltraStruData.RecriveFrameDataFalg = 1;
    		TempCounter = 0;
    	}
    }
}

/**
  * @func 	串口7数据解析处理
  * @param
  * @note
  * @retval None
  */
void ultrSationDaraReceiveHandle()
{
	uint8_t i, TempStation;
	uint16_t CheckBit = 0, TempMeasureData = 0;
	//检查开始位
	if (ultraReceiveDataBuffer[0] != STARTBIT) {
		return;
	}
	//计算校验码
	for (i = 1; i < 9; i++) {
		CheckBit += ultraReceiveDataBuffer[i];
	}
	//检查校验码
	if (ultraReceiveDataBuffer[9] != CheckBit) {
		return;
	}
	else {
		TempStation = ultraReceiveDataBuffer[1];
		TempMeasureData = 256 * ultraReceiveDataBuffer[4] + ultraReceiveDataBuffer[5];
		UltraStruData.StationNum = TempStation;

		UltraStruData.StationNumCurrent = TempStation;
		UltraStruData.DataUltrCurrent = TempMeasureData;
		if (TempStation == STATION1) {
			UltraStruData.DataUltrStation1 = TempMeasureData;
		}
		else if (TempStation == STATION2) {
			UltraStruData.DataUltrStation2 = TempMeasureData;
		}
		else if (TempStation == STATION3) {
			UltraStruData.DataUltrStation3 = TempMeasureData;
		}
		else{
			UltraStruData.DataUltrStation4 = TempMeasureData;
		}
	}
}
