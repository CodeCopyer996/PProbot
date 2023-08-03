/**
  ******************************************************************************
  * @file   UltrasonicMeasure.c
  * @brief  ���������ݲɼ�
  ******************************************************************************
  * @attention
  *			ʹ�ô���7���ĸ����������������ݽ��вɼ�
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
  * @func 	�������ݵ�������������
  * @param	ultraStationNum:ѡ�г�����վ��
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
  * @func 	����7�����жϴ���
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
  * @func 	����7���ݽ�������
  * @param
  * @note
  * @retval None
  */
void ultrSationDaraReceiveHandle()
{
	uint8_t i, TempStation;
	uint16_t CheckBit = 0, TempMeasureData = 0;
	//��鿪ʼλ
	if (ultraReceiveDataBuffer[0] != STARTBIT) {
		return;
	}
	//����У����
	for (i = 1; i < 9; i++) {
		CheckBit += ultraReceiveDataBuffer[i];
	}
	//���У����
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
