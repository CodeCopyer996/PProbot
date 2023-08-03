#ifndef _COM_TASK_H__
#define _COM_TASK_H__

#include <Basic_Task/base_task.h>
#include <Commnication_Task/CANCom.h>
//#include <Commnication_Task/MCUAndPCCom.h>
#include <Commnication_Task/NRF24L01.h>
#include <Commnication_Task/remoteCom.h>
#include <Motordrive_Task/Motor_task.h>
#include <Sensor_Task/UltrasonicMeasure.h>
#include <Commnication_Task/PC_CtrlPos.h>
//串口通讯模式选择
#define USART3_TX_MODE 	0
#define USART3_RX_MODE 	1

//NRF通讯模式选择
#define NRF_TX_MODE		2
#define NRF_RX_MODE		3


//无线通讯数据打包模式
#define PID_TXDATAFRAME			1		//PID显示数据帧
#define RUN_TXDATAFRAME_1		2		//运行显示数据帧1



void USART3ComModeChoose(uint8_t ComFlag, uint8_t *ComData, uint16_t Len);

void NRFComModeChoose(uint8_t NRFComFlag, uint8_t *NRFComData, uint16_t NRFLen);

//电机数据打包
void Motor_data_packHandle(uint8_t *dataFrame, chassis_move_t *motorData);

//发送数据打包
void Run_DataSend_Handle(uint8_t TxModeChoose, uint8_t frameMode, uint8_t *dataFrame, chassis_move_t *motorData,
		 UltrasonicDate_t *ultrFeedback);

#endif
