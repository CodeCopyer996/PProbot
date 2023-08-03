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
//����ͨѶģʽѡ��
#define USART3_TX_MODE 	0
#define USART3_RX_MODE 	1

//NRFͨѶģʽѡ��
#define NRF_TX_MODE		2
#define NRF_RX_MODE		3


//����ͨѶ���ݴ��ģʽ
#define PID_TXDATAFRAME			1		//PID��ʾ����֡
#define RUN_TXDATAFRAME_1		2		//������ʾ����֡1



void USART3ComModeChoose(uint8_t ComFlag, uint8_t *ComData, uint16_t Len);

void NRFComModeChoose(uint8_t NRFComFlag, uint8_t *NRFComData, uint16_t NRFLen);

//������ݴ��
void Motor_data_packHandle(uint8_t *dataFrame, chassis_move_t *motorData);

//�������ݴ��
void Run_DataSend_Handle(uint8_t TxModeChoose, uint8_t frameMode, uint8_t *dataFrame, chassis_move_t *motorData,
		 UltrasonicDate_t *ultrFeedback);

#endif
