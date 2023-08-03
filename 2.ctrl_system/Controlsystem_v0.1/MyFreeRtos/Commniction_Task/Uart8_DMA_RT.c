/**
  ******************************************************************************
  * @file   Uart8_DMA_RT.c
  * @brief  ��Ҫ����PC���Կ���ģʽ����ָ��
  ******************************************************************************
  * @attention
  *			DMA��ʼ�������ݴ���
  *			DMA���ݽ��մ���
  *			DMA��ʼ������
  *			DMA�����ж϶���
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
	tmp_flag =__HAL_UART_GET_FLAG(huart,UART_FLAG_IDLE); //��ȡIDLE��־λ
	if((tmp_flag != RESET))//idle��־����λ
	{
		__HAL_UART_CLEAR_IDLEFLAG(huart);//�����־λ
		//temp = huart1.Instance->SR;  //���״̬�Ĵ���SR,��ȡSR�Ĵ�������ʵ�����SR�Ĵ����Ĺ���
		//temp = huart1.Instance->DR; //��ȡ���ݼĴ����е�����
		//������������Ǿ��Ч
		HAL_UART_DMAStop(huart); //
		temp  = (uint32_t)huart->hdmarx->Instance->NDTR;// ��ȡDMA��δ��������ݸ���
		//temp  = hdma_usart1_rx.Instance->NDTR;//��ȡNDTR�Ĵ��� ��ȡDMA��δ��������ݸ�����
		//���������Ǿ��Ч
		rx_len =  UART8_DMA_RX_BUFFER_SIZE - temp; //�ܼ�����ȥδ��������ݸ������õ��Ѿ����յ����ݸ���
		recv_end_flag = 1;	// ������ɱ�־λ��1
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
		rx_len = 0;//�������
		recv_end_flag = 0;//������ս�����־λ
		memset(rx_Buff,0,rx_len);
	}
	HAL_UART_Receive_DMA(huart,(uint8_t*)rx_Buff,UART8_DMA_RX_DATA_LEN);

}






