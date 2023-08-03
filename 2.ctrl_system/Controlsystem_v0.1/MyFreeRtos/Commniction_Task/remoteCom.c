/**
  ******************************************************************************
  * @file   remoteCom.c
  * @brief  ��Ҫ��������ң�������մ���
  ******************************************************************************
  * @attention
  *			ң�ؽ������ݴ���
  *			DMA��ʼ�������ݴ���
  *			DMA���ݽ��մ���
  *			DMA��ʼ������
  *			DMA�����ж϶���
  ******************************************************************************
  */

#include <Basic_Task/base_task.h>
#include <Commnication_Task/remoteCom.h>

static int UART_Receive_DMA_No_IT(UART_HandleTypeDef* huart, uint8_t* pData, uint32_t Size);
static void usart_receive_buffer( UART_HandleTypeDef *huart );


/**
  * @func 	ң�ؽ������ݴ���
  * @param	������RC_CtrlData����ʾң�����������ݽṹ�����
  * 		������pData����ʾ���ڽ��յ����ݻ���
  * @retval �Խ�������ͨ�����ݽ��з��룬һ����6��ͨ��
  * 		ch0~ch4��ʾҡ���ƶ�
  * 		s1��s2��ʾң�����ϲ��뿪��ѡ��
  */

void RemoteDataProcess (RC_Ctl_t *RC_CtrlData, uint8_t *pData )
{

	//���մ���
	RC_CtrlData->rc.ch0	= (	pData[0] | pData[1] << 8 ) & 0x07FF;
	RC_CtrlData->rc.ch0 -= 1024;
	RC_CtrlData->rc.ch0 = -RC_CtrlData->rc.ch0;		//��������
	RC_CtrlData->rc.ch1	= ( pData[1] >> 3 | pData[2]  << 5 ) & 0x07FF;
	RC_CtrlData->rc.ch1 -= 1024;
	RC_CtrlData->rc.ch2	= ( pData[2] >> 6 | pData[3]  << 2   | pData[4] << 10 ) & 0x07FF;
	RC_CtrlData->rc.ch2 -= 1024;
	RC_CtrlData->rc.ch2 = -RC_CtrlData->rc.ch2;		//��������
	RC_CtrlData->rc.ch3	= ( pData[4] >> 1 | pData[5]  << 7 ) & 0x07FF;
	RC_CtrlData->rc.ch3 -= 1024;
	RC_CtrlData->rc.s1	= (( pData[5] >> 4 ) & 0x0C ) >> 2;
	RC_CtrlData->rc.s2	= (  pData[5] >> 4 ) & 0x03 ;

	//ҡ����������
	if ( RC_CtrlData->rc.ch0 <= RC_DEADLINE && RC_CtrlData->rc.ch0 >= -RC_DEADLINE) {
		RC_CtrlData->rc.ch0 = 0;
	}
	if ( RC_CtrlData->rc.ch1 <= RC_DEADLINE && RC_CtrlData->rc.ch1 >= -RC_DEADLINE) {
	  	RC_CtrlData->rc.ch1 = 0;
	}
	if ( RC_CtrlData->rc.ch2 <= RC_DEADLINE && RC_CtrlData->rc.ch2 >= -RC_DEADLINE) {
	  	RC_CtrlData->rc.ch2 = 0;
	}
	if ( RC_CtrlData->rc.ch3 <= RC_DEADLINE && RC_CtrlData->rc.ch3 >= -RC_DEADLINE) {
	  	RC_CtrlData->rc.ch3 = 0;
	}

	//���մ�����
	if ( RC_CtrlData->rc.ch0 <= -RC_MAX_VALUE && RC_CtrlData->rc.ch0 >= RC_MAX_VALUE) {
		RC_CtrlData->rc.ch0 = 0;
	}
	if ( RC_CtrlData->rc.ch1 <= -RC_MAX_VALUE && RC_CtrlData->rc.ch1 >= RC_MAX_VALUE) {
		RC_CtrlData->rc.ch1 = 0;
	}
	if ( RC_CtrlData->rc.ch2 <= -RC_MAX_VALUE && RC_CtrlData->rc.ch2 >= RC_MAX_VALUE) {
		RC_CtrlData->rc.ch2 = 0;
	}
	if ( RC_CtrlData->rc.ch3 <= -RC_MAX_VALUE && RC_CtrlData->rc.ch3 >= RC_MAX_VALUE) {
		RC_CtrlData->rc.ch3 = 0;
	}

}

/**
  * @func 	DMA��ʼ���մ��������ϵ�����
  * @param	������huart����ʾ���ں�ͷָ��
  * 		��ȡ����״̬������ʱ������DMA�������ݴ���
  * @retval
  */

void Usart1_Recieve_IRQ_Handle( UART_HandleTypeDef *huart )
{
	 if (__HAL_UART_GET_FLAG(huart, UART_FLAG_IDLE) && __HAL_UART_GET_IT_SOURCE(huart, UART_IT_IDLE)) {
		 __HAL_UART_CLEAR_IDLEFLAG(&huart1);
		 usart_receive_buffer(&huart1);
	 }
}

/**
  * @func 	DMA�������ݴ���
  * @param	��������ͷָ��
  * 		�洢���������ݰ���һ֡ң������ʱ���Ϳ�ʼ����DMA���ݴ���
  * @retval
  */

static void usart_receive_buffer( UART_HandleTypeDef *huart )
{
	 __HAL_UART_CLEAR_IDLEFLAG(huart);
	 __HAL_DMA_DISABLE(huart->hdmarx);

	 uint16_t rc_buffer_current_size = 0;
	 rc_buffer_current_size = (uint16_t)huart->hdmarx->Instance->NDTR;

	 if (DR16_RX_BUFFER_SIZE - rc_buffer_current_size == DR16_Rx_DATA_FRAME_LEN) {
		RemoteDataProcess(&RC_CtrlData, rcbuffer);
//		printf("usart3_rx = %d\r\n",rcbuffer);
	}
	 __HAL_DMA_SET_COUNTER(huart->hdmarx, DR16_RX_BUFFER_SIZE);
	 __HAL_DMA_ENABLE(huart->hdmarx);
}


/**
  * @func 	DMA��ʼ������
  * @param	��������ͷָ��
  * 		��Ҫ����DMA�жϴ������ݳ�ʼ��
  * @retval
  */
void dr16_uart_dma_init(UART_HandleTypeDef *huart)
{
	UART_Receive_DMA_No_IT(huart, rcbuffer, DR16_RX_BUFFER_SIZE);
	__HAL_UART_CLEAR_IDLEFLAG(huart);
	__HAL_UART_ENABLE_IT(huart, UART_IT_IDLE);
}


/**
  * @brief   enable global uart it and do not use DMA transfer done it
  * @param   uart IRQHandler id, receive buff, buff size
  * @retval  set success or fail
  * @note	  �˺���ΪHAL���ṩ��������Ҫ���ڴ���DMA���ճ�ʼ��
  */
static int UART_Receive_DMA_No_IT(UART_HandleTypeDef* huart, uint8_t* pData, uint32_t Size)
{
  uint32_t tmp1 = 0;

  tmp1 = huart->RxState;
  if (tmp1 == HAL_UART_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0))
    {
        return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(huart);

    huart->pRxBuffPtr = pData;
    huart->RxXferSize = Size;

    huart->ErrorCode  = HAL_UART_ERROR_NONE;

    /* Enable the DMA Stream */
    HAL_DMA_Start(huart->hdmarx, (uint32_t)&huart->Instance->DR,
                  (uint32_t)pData, Size);

    /* Enable the DMA transfer for the receiver request by setting the DMAR bit
    in the UART CR3 register */
    SET_BIT(huart->Instance->CR3, USART_CR3_DMAR);

    /* Process Unlocked */
    __HAL_UNLOCK(huart);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}


