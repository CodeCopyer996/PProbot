/*
 * PC_CtrlPoss.h
 *
 *  Created on: 2023年5月11日
 *      Author: shipe
 */

#ifndef _PC_CTRLPOS_H_
#define _PC_CTRLPOS_H_
#include <Basic_Task/base_task.h>
#include "usart.h"


#define USART3_DMA_RX_BUFFER_SIZE	50
#define USART3_DMA_RX_DATA_FRAME_LEN	16

uint8_t usart3_rx_buffer[16];  //定义接收缓冲数组

typedef  struct {
	struct {
		int8_t angle1;
		int8_t angle2;
		int8_t angle3;
		int8_t angle4;
		int8_t px;
		int8_t py;
		int8_t pz;
	} PC_rx;
}my_Ctrl_RX_Data_t;

my_Ctrl_RX_Data_t	myrxctrldata_t;


//串口DMA接收数据
void Usart3_Recieve_IRQ_Handle( UART_HandleTypeDef *huart );
void myUsart3RXDataProcess( uint8_t *usart3_rx_buffer, my_Ctrl_RX_Data_t *myRXCtrlData);
void PC_usart3_dma_init(UART_HandleTypeDef *huart);

//串口DMA发送数据
void Usart3Tx_DmaInit();
void MCU_To_PC_SendData(uint8_t *data, uint16_t Len);


#endif /* INCLUDE_COMMNICATION_TASK_PC_CTRLPOSS_H_ */
