/**
  ******************************************************************************
  * @file   PC_CTRLPOS.c
  * @brief  ��Ҫ����MCU��PC�Ķ̾���ͨѶ����,ʵ�ֻ�е�۵ĽǶȿ���
  ******************************************************************************
  * @attention
  *			����3��DMA������֡�����ա�������
  *			DMA��ʼ������
  *			DMA�����ж϶���
  ******************************************************************************
  */
#include <Basic_Task/base_task.h>
#include <Commnication_Task/PC_CtrlPos.h>


extern DMA_HandleTypeDef hdma_usart3_tx;


static int USART_Receive_DMA_No_IT(UART_HandleTypeDef* huart, uint8_t* rx_buffer, uint32_t Size);
static void usart3_receive_buffer( UART_HandleTypeDef *huart );


/**
  * @func 	ң�ؽ������ݴ���
  * @param	������RC_CtrlData����ʾң�����������ݽṹ�����
  * 		������pData����ʾ���ڽ��յ����ݻ���
  * @retval �Խ�������ͨ�����ݽ��з��룬һ����6��ͨ��
  * 		ch0~ch4��ʾҡ���ƶ�
  * 		s1��s2��ʾң�����ϲ��뿪��ѡ��
  */

/**
  * @func 	����8�����ա����ݽ�������
  * @param	usart3_rx_buffer:	�������ݻ���
  * 		myRXCtrlData:				������ָ��
  * @retval
  * @note	������PU���ڵ����ݽ��н���
  *
  */
void myUsart3RXDataProcess( uint8_t *usart3_rx_buffer, my_Ctrl_RX_Data_t* myRXCtrlData)
{

			myRXCtrlData->PC_rx.angle1 = usart3_rx_buffer[0];
			myRXCtrlData->PC_rx.angle2 = usart3_rx_buffer[1];
			myRXCtrlData->PC_rx.angle3 = usart3_rx_buffer[2];
			myRXCtrlData->PC_rx.angle4 = usart3_rx_buffer[3];

}

/**
  * @func 	DMA��ʼ���մ��������ϵ�����
  * @param	������huart����ʾ���ں�ͷָ��
  * 		��ȡ����״̬������ʱ������DMA�������ݴ���
  * @retval
  */

void Usart3_Recieve_IRQ_Handle( UART_HandleTypeDef *huart )
{
	 if (__HAL_UART_GET_FLAG(huart, UART_FLAG_IDLE) && __HAL_UART_GET_IT_SOURCE(huart, UART_IT_IDLE)) {
		 __HAL_UART_CLEAR_IDLEFLAG(&huart3);
		 usart3_receive_buffer(&huart3);
	 }
}

/**
  * @func 	DMA��������
  * @param	��������ͷָ��
  * 		�洢���������ݰ���һ֡ң������ʱ���Ϳ�ʼ����DMA���ݴ���
  * @retval
  */

static void usart3_receive_buffer( UART_HandleTypeDef *huart )
{
	 __HAL_UART_CLEAR_IDLEFLAG(huart);
	 __HAL_DMA_DISABLE(huart->hdmarx);

	 uint16_t rc_buffer_current_size = 0;
	 rc_buffer_current_size = (uint16_t)huart->hdmarx->Instance->NDTR;

	 if (USART3_DMA_RX_BUFFER_SIZE - rc_buffer_current_size == USART3_DMA_RX_DATA_FRAME_LEN) {
		 myUsart3RXDataProcess(usart3_rx_buffer,&myrxctrldata_t);
	}
	 __HAL_DMA_SET_COUNTER(huart->hdmarx, USART3_DMA_RX_BUFFER_SIZE);
	 __HAL_DMA_ENABLE(huart->hdmarx);
}

/**
  * @func 	DMA��ʼ������
  * @param	��������ͷָ��
  * 		��Ҫ����DMA�жϴ������ݳ�ʼ��
  * @retval
  */

void PC_usart3_dma_init(UART_HandleTypeDef *huart)
{

	USART_Receive_DMA_No_IT(huart, usart3_rx_buffer, USART3_DMA_RX_BUFFER_SIZE);
//    printf("usart3_rx_buffer = %d\r\n", usart3_rx_buffer[0]);
	__HAL_UART_CLEAR_IDLEFLAG(huart);
	__HAL_UART_ENABLE_IT(huart, UART_IT_IDLE);
}


/**
  * @brief   enable global uart it and do not use DMA transfer done it
  * @param   uart IRQHandler id, receive buff, buff size
  * @retval  set success or fail
  * @note	  �˺���ΪHAL���ṩ��������Ҫ���ڴ���DMA���ճ�ʼ��
  */
static int USART_Receive_DMA_No_IT(UART_HandleTypeDef* huart, uint8_t* rx_buffer, uint32_t Size)
{
  uint32_t tmp1 = 0;
  tmp1 = huart->RxState;
  if (tmp1 == HAL_UART_STATE_READY)
  {
    if ((rx_buffer == NULL) || (Size == 0))
    {
        return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(huart);

    huart->pRxBuffPtr = rx_buffer;
    huart->RxXferSize = Size;

    huart->ErrorCode  = HAL_UART_ERROR_NONE;

    /* Enable the DMA Stream */
    HAL_DMA_Start(huart->hdmarx, (uint32_t)&huart->Instance->DR,
                  (uint32_t)rx_buffer, Size);

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

/**
  * @brief	DMA���䡾���͡���ʼ��
  * @param
  * @retval None
  */
void Usart3Tx_DmaInit()
{
	//ʹ�ܴ���DMA����
	SET_BIT(huart3.Instance->CR3, USART_CR3_DMAT);		//ʹ�ܴ���DMA�ķ���
	//SET_BIT(huart3.Instance->CR3, USART_CR3_DMAT);
	//ʧ��DMA���ԼĴ�����������
	__HAL_DMA_DISABLE(&hdma_usart3_tx);
	while (hdma_usart3_tx.Instance->CR & DMA_SxCR_EN) {		//ENλд0��Ҫʱ��
		__HAL_DMA_DISABLE(&hdma_usart3_tx);
	}
	hdma_usart3_tx.Instance->PAR = (uint32_t) & (USART3->DR);
	hdma_usart3_tx.Instance->M0AR = (uint32_t)(NULL);
	hdma_usart3_tx.Instance->NDTR = 0;
}

/**
  * @brief	ʹ��DMA���ڡ����͡�����
  * @param	data:�������ݵ�ַ
  * 		Len���������ݳ���
  * @retval None
  */

void MCU_To_PC_SendData(uint8_t *data, uint16_t Len)
{
	//ʧ��DMA���ԼĴ�����������
	__HAL_DMA_DISABLE(&hdma_usart3_tx);
	while (hdma_usart3_tx.Instance->CR & DMA_SxCR_EN) {		//ENλд0��Ҫʱ��
		__HAL_DMA_DISABLE(&hdma_usart3_tx);
	}
	//��������״̬�жϱ�־λ
	__HAL_DMA_CLEAR_FLAG(&hdma_usart3_tx, DMA_LISR_TCIF3);
	//�������ݵ�ַ
	hdma_usart3_tx.Instance->M0AR = (uint32_t)(data);		//����ַת��Ϊ32λ��ַ
	//�������ݳ���
	hdma_usart3_tx.Instance->NDTR = Len;					//�������ݳ���
	//ʹ��DMA
	__HAL_DMA_ENABLE(&hdma_usart3_tx);
}

