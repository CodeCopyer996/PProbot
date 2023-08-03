#ifndef _MCU_AND_PC_COM_H__
#define _MCU_AND_PC_COM_H__

#include <Commnication_Task/remoteCom.h>
#include "usart.h"
#include "stm32f427xx.h"

#define USART3_DMA_RX_BUFFER_SIZE	50
#define USART3_DMA_RX_DATA_FRAME	16



//控制模式定义
#define		MYPIDSETMODE		0x01			//PID设置模式
#define		POSCTRL_MODE	0x10			//PC直接控制模式


//协议帧定义



//PID控制结构体参数
typedef struct {

	uint16_t		myKP;
	uint16_t		myKI;
	uint16_t		myKD;
	uint16_t		myPIDSpeedSet;		//设置4个电机相同速度



} myPIDCtrlRXData_t;


//自定义控制协议接收解析数据
//typedef  struct {
//
//	//暂时设定这几个数据
//	uint8_t				myMode;
//	uint8_t              uart_position_set[4];    //设定位置值
//	myPIDCtrlRXData_t	myPID_t;			//PID参数结构体
//
//}my_Ctrl_RX_Data_t;

typedef  struct {

	//暂时设定这几个数据
	uint8_t              uart_position_set[4];    //设定位置值

}my_Ctrl_RX_Data_t;

//发送数据帧定义
typedef struct {
	uint16_t		Motor1Speed;	//反馈四个电机速速
	uint16_t		Motor2Speed;
	uint16_t		Motor3Speed;
	uint16_t		Motor4Speed;

	uint8_t			Motor1Temp;		//反馈四个电机温度
	uint8_t			Motor2Temp;
	uint8_t			Motor3Temp;
	uint8_t			Motor4Temp;

	uint8_t			PowerInfo;		//反馈底盘电量信息

}my_Run_TX_Data_t;



//串口DMA发送数据
void Usart3Tx_DmaInit();
void MCU_To_PC_SendData(uint8_t *data, uint16_t Len);

//串口DMA接收数据
void Usart3Rx_Init();
void Usart3Rx_DMAInit(uint8_t *Usart3_DMA_RxBuffer1, uint8_t *Usart3_DMA_RxBuffer2, uint16_t FreamLen);
void Usart3Rx_DMA_IRQHandle(UART_HandleTypeDef *huart);

//接收数据解析
void myUsart3RXDataHandle(volatile const uint8_t *usart3_rx_buffer, my_Ctrl_RX_Data_t *myRXCtrlData);

//获取定义控制数据结构体指针
const my_Ctrl_RX_Data_t *Get_MyRXCtrlDataPoint();


#endif
