/**
  ******************************************************************************
  * @file   Uart8_DMA_RT.c
  * @brief  主要用于PC电脑控制模式接收指令
  ******************************************************************************
  * @attention
  *			DMA开始进行数据传输
  *			DMA数据接收处理
  *			DMA初始化函数
  *			DMA接收中断定义
  ******************************************************************************
  */
#include <Basic_Task/base_task.h>
#include <Commnication_Task/Uart8_DMA_RT.h>

//extern volatile uint8_t  rx_len;
//extern volatile uint32_t  recv_end_flag;
//extern uint8_t rx_Buff[200];
//extern my_Uart8_RX_Data_t	myuart8ctrldata_t;

void  MyUart8_DMArecieve_IRQHandle(UART_HandleTypeDef *huart)
 {
	uint32_t tmp_flag = 0;
	uint32_t temp;
	tmp_flag =__HAL_UART_GET_FLAG(huart,UART_FLAG_IDLE); //获取IDLE标志位
	if((tmp_flag != RESET))//idle标志被置位
	{
		__HAL_UART_CLEAR_IDLEFLAG(huart);//清除标志位
		//temp = huart1.Instance->SR;  //清除状态寄存器SR,读取SR寄存器可以实现清除SR寄存器的功能
		//temp = huart1.Instance->DR; //读取数据寄存器中的数据
		//这两句和上面那句等效
		HAL_UART_DMAStop(huart); //
		temp  = (uint32_t)huart->hdmarx->Instance->NDTR;// 获取DMA中未传输的数据个数
		//temp  = hdma_usart1_rx.Instance->NDTR;//读取NDTR寄存器 获取DMA中未传输的数据个数，
		//这句和上面那句等效
		rx_len =  UART8_DMA_RX_BUFFER_SIZE - temp; //总计数减去未传输的数据个数，得到已经接收的数据个数
		recv_end_flag = 1;	// 接受完成标志位置1
	}
 }

void PC_data_process(my_Uart8_RX_Data_t *ctrldata_t, uint8_t* rxBuff)
{

	ctrldata_t->angle[0] = rxBuff[0] <<8 | rxBuff[1] ;
	ctrldata_t->angle[1] = rxBuff[2] <<8 | rxBuff[3] ;
	ctrldata_t->angle[2] = rxBuff[4] <<8 | rxBuff[5] ;
	ctrldata_t->angle[3] = rxBuff[6] <<8 | rxBuff[7] ;
	ctrldata_t->pos[0]   = rxBuff[8] <<8 | rxBuff[9] ;
	ctrldata_t->pos[1] = rxBuff[10] <<8 | rxBuff[11] ;
	ctrldata_t->pos[2] = rxBuff[12] <<8 | rxBuff[13] ;

}

void MyUart8_DMArx_Init(UART_HandleTypeDef *huart)
 {

	__HAL_UART_ENABLE_IT(huart, UART_IT_IDLE);
	HAL_UART_Receive_DMA(huart, (uint8_t*)rx_Buff, UART8_DMA_RX_DATA_LEN);


 }


void MyUart8_DMArx_Process(UART_HandleTypeDef *huart)
{
	if(recv_end_flag == 1){
		PC_data_process(&myuart8ctrldata_t, rx_Buff);
		HAL_UART_Transmit_DMA(huart, rx_Buff,rx_len);
		rx_len = 0;//清除计数
		recv_end_flag = 0;//清除接收结束标志位
		memset(rx_Buff,0,rx_len);
	}
	HAL_UART_Receive_DMA(huart,(uint8_t*)rx_Buff,UART8_DMA_RX_DATA_LEN);

}






