/**
  ******************************************************************************
  * @file   remoteCom.c
  * @brief  主要用于无线遥控器接收处理
  ******************************************************************************
  * @attention
  *			遥控接收数据处理
  *			DMA开始进行数据传输
  *			DMA数据接收处理
  *			DMA初始化函数
  *			DMA接收中断定义
  ******************************************************************************
  */

#include <Basic_Task/base_task.h>
#include <Commnication_Task/remoteCom.h>

static int UART_Receive_DMA_No_IT(UART_HandleTypeDef* huart, uint8_t* pData, uint32_t Size);
static void usart_receive_buffer( UART_HandleTypeDef *huart );


/**
  * @func 	遥控接收数据处理
  * @param	参数：RC_CtrlData，表示遥控器接收数据结构体参数
  * 		参数：pData，表示串口接收到数据缓存
  * @retval 对接收数据通道数据进行分离，一共有6个通道
  * 		ch0~ch4表示摇杆移动
  * 		s1、s2表示遥控器上拨码开关选择
  */

void RemoteDataProcess (RC_Ctl_t *RC_CtrlData, uint8_t *pData )
{

	//接收处理
	RC_CtrlData->rc.ch0	= (	pData[0] | pData[1] << 8 ) & 0x07FF;
	RC_CtrlData->rc.ch0 -= 1024;
	RC_CtrlData->rc.ch0 = -RC_CtrlData->rc.ch0;		//修正方向
	RC_CtrlData->rc.ch1	= ( pData[1] >> 3 | pData[2]  << 5 ) & 0x07FF;
	RC_CtrlData->rc.ch1 -= 1024;
	RC_CtrlData->rc.ch2	= ( pData[2] >> 6 | pData[3]  << 2   | pData[4] << 10 ) & 0x07FF;
	RC_CtrlData->rc.ch2 -= 1024;
	RC_CtrlData->rc.ch2 = -RC_CtrlData->rc.ch2;		//修正方向
	RC_CtrlData->rc.ch3	= ( pData[4] >> 1 | pData[5]  << 7 ) & 0x07FF;
	RC_CtrlData->rc.ch3 -= 1024;
	RC_CtrlData->rc.s1	= (( pData[5] >> 4 ) & 0x0C ) >> 2;
	RC_CtrlData->rc.s2	= (  pData[5] >> 4 ) & 0x03 ;

	//摇杆死区处理
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

	//接收错误处理
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
  * @func 	DMA开始接收串口总线上的数据
  * @param	参数：huart，表示串口号头指针
  * 		获取总线状态，空闲时，启用DMA进行数据传输
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
  * @func 	DMA接收数据处理
  * @param	参数串口头指针
  * 		存储器接收数据包含一帧遥控数据时，就开始进行DMA数据传输
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
  * @func 	DMA初始化函数
  * @param	参数串口头指针
  * 		主要用于DMA中断传输数据初始化
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
  * @note	  此函数为HAL库提供函数，主要用于串口DMA接收初始化
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


