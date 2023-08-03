/*
 * Uart8_DMA_RT.h
 *
 *  Created on: 2023Äê5ÔÂ17ÈÕ
 *      Author: shipe
 */

#ifndef INCLUDE_COMMNICATION_TASK_UART8_DMA_RT_H_
#define INCLUDE_COMMNICATION_TASK_UART8_DMA_RT_H_
#include "usart.h"
#include <Basic_Task/base_task.h>
#include <string.h>

volatile uint16_t  rx_len;
volatile uint32_t  recv_end_flag;
 uint8_t rx_Buff[200];

typedef  struct{

 uint16_t angle[4];
 int16_t  pos[3];

}my_Uart8_RX_Data_t;

my_Uart8_RX_Data_t	myuart8ctrldata_t;


#define UART8_DMA_RX_BUFFER_SIZE	50
#define UART8_DMA_RX_DATA_LEN	    16

extern UART_HandleTypeDef huart8;
extern DMA_HandleTypeDef hdma_uart8_rx;
extern DMA_HandleTypeDef hdma_uart8_tx;


void  MyUart8_DMArecieve_IRQHandle(UART_HandleTypeDef *huart);
void MyUart8_DMArx_Init(UART_HandleTypeDef *huart);
void MyUart8_DMArx_Process(UART_HandleTypeDef *huart);
void PC_data_process(my_Uart8_RX_Data_t *ctrldata_t, uint8_t* rxBuff);


#endif /* INCLUDE_COMMNICATION_TASK_UART8_DMA_RT_H_ */
