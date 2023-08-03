#ifndef _MCU_AND_PC_COM_H__
#define _MCU_AND_PC_COM_H__

#include <Commnication_Task/remoteCom.h>
#include "usart.h"
#include "stm32f427xx.h"

#define USART3_DMA_RX_BUFFER_SIZE	50
#define USART3_DMA_RX_DATA_FRAME	16



//����ģʽ����
#define		MYPIDSETMODE		0x01			//PID����ģʽ
#define		POSCTRL_MODE	0x10			//PCֱ�ӿ���ģʽ


//Э��֡����



//PID���ƽṹ�����
typedef struct {

	uint16_t		myKP;
	uint16_t		myKI;
	uint16_t		myKD;
	uint16_t		myPIDSpeedSet;		//����4�������ͬ�ٶ�



} myPIDCtrlRXData_t;


//�Զ������Э����ս�������
//typedef  struct {
//
//	//��ʱ�趨�⼸������
//	uint8_t				myMode;
//	uint8_t              uart_position_set[4];    //�趨λ��ֵ
//	myPIDCtrlRXData_t	myPID_t;			//PID�����ṹ��
//
//}my_Ctrl_RX_Data_t;

typedef  struct {

	//��ʱ�趨�⼸������
	uint8_t              uart_position_set[4];    //�趨λ��ֵ

}my_Ctrl_RX_Data_t;

//��������֡����
typedef struct {
	uint16_t		Motor1Speed;	//�����ĸ��������
	uint16_t		Motor2Speed;
	uint16_t		Motor3Speed;
	uint16_t		Motor4Speed;

	uint8_t			Motor1Temp;		//�����ĸ�����¶�
	uint8_t			Motor2Temp;
	uint8_t			Motor3Temp;
	uint8_t			Motor4Temp;

	uint8_t			PowerInfo;		//�������̵�����Ϣ

}my_Run_TX_Data_t;



//����DMA��������
void Usart3Tx_DmaInit();
void MCU_To_PC_SendData(uint8_t *data, uint16_t Len);

//����DMA��������
void Usart3Rx_Init();
void Usart3Rx_DMAInit(uint8_t *Usart3_DMA_RxBuffer1, uint8_t *Usart3_DMA_RxBuffer2, uint16_t FreamLen);
void Usart3Rx_DMA_IRQHandle(UART_HandleTypeDef *huart);

//�������ݽ���
void myUsart3RXDataHandle(volatile const uint8_t *usart3_rx_buffer, my_Ctrl_RX_Data_t *myRXCtrlData);

//��ȡ����������ݽṹ��ָ��
const my_Ctrl_RX_Data_t *Get_MyRXCtrlDataPoint();


#endif
