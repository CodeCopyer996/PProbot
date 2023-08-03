/**
  ******************************************************************************
  * @file   PC_CTRLPOS.c
  * @brief  主要用于MCU与PC的短距离通讯任务,实现机械臂的角度控制
  ******************************************************************************
  * @attention
  *			串口3的DMA对数据帧进行收、发处理
  *			DMA初始化函数
  *			DMA接收中断定义
  ******************************************************************************
  */
#include <Basic_Task/base_task.h>
#include <Commnication_Task/PC_CtrlPos.h>


extern DMA_HandleTypeDef hdma_usart3_tx;


static int USART_Receive_DMA_No_IT(UART_HandleTypeDef* huart, uint8_t* rx_buffer, uint32_t Size);
static void usart3_receive_buffer( UART_HandleTypeDef *huart );


/**
  * @func 	遥控接收数据处理
  * @param	参数：RC_CtrlData，表示遥控器接收数据结构体参数
  * 		参数：pData，表示串口接收到数据缓存
  * @retval 对接收数据通道数据进行分离，一共有6个通道
  * 		ch0~ch4表示摇杆移动
  * 		s1、s2表示遥控器上拨码开关选择
  */

/**
  * @func 	串口8【接收】数据解析处理
  * @param	usart3_rx_buffer:	接收数据缓存
  * 		myRXCtrlData:				处理保存指针
  * @retval
  * @note	对来自PU串口的数据进行解析
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
  * @func 	DMA开始接收串口总线上的数据
  * @param	参数：huart，表示串口号头指针
  * 		获取总线状态，空闲时，启用DMA进行数据传输
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
  * @func 	DMA接收数据
  * @param	参数串口头指针
  * 		存储器接收数据包含一帧遥控数据时，就开始进行DMA数据传输
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
  * @func 	DMA初始化函数
  * @param	参数串口头指针
  * 		主要用于DMA中断传输数据初始化
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
  * @note	  此函数为HAL库提供函数，主要用于串口DMA接收初始化
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
  * @brief	DMA传输【发送】初始化
  * @param
  * @retval None
  */
void Usart3Tx_DmaInit()
{
	//使能串口DMA发送
	SET_BIT(huart3.Instance->CR3, USART_CR3_DMAT);		//使能串口DMA的发送
	//SET_BIT(huart3.Instance->CR3, USART_CR3_DMAT);
	//失能DMA，对寄存器进行配置
	__HAL_DMA_DISABLE(&hdma_usart3_tx);
	while (hdma_usart3_tx.Instance->CR & DMA_SxCR_EN) {		//EN位写0需要时间
		__HAL_DMA_DISABLE(&hdma_usart3_tx);
	}
	hdma_usart3_tx.Instance->PAR = (uint32_t) & (USART3->DR);
	hdma_usart3_tx.Instance->M0AR = (uint32_t)(NULL);
	hdma_usart3_tx.Instance->NDTR = 0;
}

/**
  * @brief	使用DMA串口【发送】数据
  * @param	data:传输数据地址
  * 		Len：传输数据长度
  * @retval None
  */

void MCU_To_PC_SendData(uint8_t *data, uint16_t Len)
{
	//失能DMA，对寄存器进行配置
	__HAL_DMA_DISABLE(&hdma_usart3_tx);
	while (hdma_usart3_tx.Instance->CR & DMA_SxCR_EN) {		//EN位写0需要时间
		__HAL_DMA_DISABLE(&hdma_usart3_tx);
	}
	//清除传输的状态中断标志位
	__HAL_DMA_CLEAR_FLAG(&hdma_usart3_tx, DMA_LISR_TCIF3);
	//设置数据地址
	hdma_usart3_tx.Instance->M0AR = (uint32_t)(data);		//将地址转换为32位地址
	//设置数据长度
	hdma_usart3_tx.Instance->NDTR = Len;					//设置数据长度
	//使能DMA
	__HAL_DMA_ENABLE(&hdma_usart3_tx);
}

