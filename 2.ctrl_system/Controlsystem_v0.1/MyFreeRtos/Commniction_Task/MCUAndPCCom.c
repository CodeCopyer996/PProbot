/**
  ******************************************************************************
  * @file   PCComTask.c
  * @brief  主要用于MCU与PC的短距离通讯任务
  ******************************************************************************
  * @attention
  *			串口3的DMA对数据帧进行收、发处理
  *			DMA初始化函数
  *			DMA接收中断定义
  ******************************************************************************
  */

#include <Commnication_Task/MCUAndPCCom.h>


extern DMA_HandleTypeDef hdma_usart3_rx;
extern DMA_HandleTypeDef hdma_usart3_tx;
extern UART_HandleTypeDef huart3;
extern UART_HandleTypeDef huart2;

static uint8_t Usart3_DMA_RxBuffer[2][USART3_DMA_RX_BUFFER_SIZE];		//串口3接收DMA定义接收大小，使用的是双缓冲区模式
uint8_t temppcComSendDataTest[16]={0x7f,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0xaa,0xaa,0xaa,0x00,0x00,0x03,0x0f,0x0f};


//声明接收结构体变量
my_Ctrl_RX_Data_t	myrxctrldata_t;





/**
  * @func 	获取自定义协议帧参数结构体【指针】
  * @param
  * @retval	myrxctrldata_t
  * @note	这样做的目的是起到隔离作用，通过调用函数指针的方式，起到对结构体变量的访问，
  * 		避免访问地方太多，引起更多的冲突。
  * 		访问这个函数的时候，需要先定义my_Ctrl_RX_Data_t这样的一个结构体变量，用于保存返回值
  */
const my_Ctrl_RX_Data_t *Get_MyRXCtrlDataPoint()
{
	return &myrxctrldata_t;		//返回定义的结构体变量地址，所有文件均通过这个函数获取解析数据结果
}




//static void Usart3_Rx_DMA_BufferData(UART_HandleTypeDef *huart , uint8_t BufferFlag);

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

/**
  * @func 	串口3【接收】DMA初始化封装
  * @param
  * @retval
  * @note
  */
void Usart3Rx_Init()
{
	Usart3Rx_DMAInit(Usart3_DMA_RxBuffer[0],Usart3_DMA_RxBuffer[1],USART3_DMA_RX_BUFFER_SIZE);
}


/**
  * @func 	串口3【接收】DMA初始化
  * @param	Usart3_DMA_RxBuffer1:	DMA接收缓存区1
  * 		Usart3_DMA_RxBuffer2: 	DMA接收缓存区2
  * 		FreamLen:				DMA接收帧长度
  * @retval
  * @note	使用空闲中断开启DMA传输
  */
void Usart3Rx_DMAInit(uint8_t *Usart3_DMA_RxBuffer1, uint8_t *Usart3_DMA_RxBuffer2, uint16_t FreamLen)
{
	SET_BIT(huart3.Instance->CR3, USART_CR3_DMAR);	//使能串口DMA的接收
	__HAL_UART_ENABLE_IT(&huart3, UART_IT_IDLE);	//使能串口空闲中断

	//失能DMA，对寄存器进行配置
	__HAL_DMA_DISABLE(&hdma_usart3_rx);
	while (hdma_usart3_rx.Instance->CR & DMA_SxCR_EN) {		//EN位写0需要时间
		__HAL_DMA_DISABLE(&hdma_usart3_rx);
	}
	hdma_usart3_rx.Instance->PAR  = (uint32_t) & (USART3->DR);			//设置外设寄存器地址位DR寄存器
	hdma_usart3_rx.Instance->M0AR = (uint32_t)(Usart3_DMA_RxBuffer1);	//设置内存缓冲区1

	hdma_usart3_rx.Instance->M1AR = (uint32_t)(Usart3_DMA_RxBuffer2);	//设置内存缓冲区2

	hdma_usart3_rx.Instance->NDTR = FreamLen;				//设置数据长度

	SET_BIT(hdma_usart3_rx.Instance->CR, DMA_SxCR_DBM);		//使能双缓冲区

	//使能DMA
	__HAL_DMA_ENABLE(&hdma_usart3_rx);
}

/**
  * @func 	串口3【接收】中断
  * @param
  * @retval
  * @note	使用双缓冲区进行数据接收处理
  * 		【注意】采用的是定字长传输，即传输字长为USART3_DMA_RX_DATA_FRAME大小
  */

void Usart3Rx_DMA_IRQHandle(UART_HandleTypeDef *huart)
{
	if (huart->Instance->SR & UART_FLAG_RXNE) {		//接收到数据非空
		__HAL_UART_CLEAR_PEFLAG(huart);
	}
	else if (huart->Instance->SR & UART_FLAG_IDLE) {	//检测到空闲帧
		__HAL_UART_CLEAR_PEFLAG(huart);				//清除串口传输错误标记位
		static uint16_t mcu_current_buffer_size = 0;

		if ( (hdma_usart3_rx.Instance->CR & DMA_SxCR_CT) == RESET) {			//双缓冲区
			__HAL_DMA_DISABLE(huart->hdmarx);		//失能DMA,EN位为0
			while (hdma_usart3_rx.Instance->CR & DMA_SxCR_EN) {		//EN位写0需要时间
				__HAL_DMA_DISABLE(&hdma_usart3_rx);
			}
			mcu_current_buffer_size = USART3_DMA_RX_BUFFER_SIZE - __HAL_DMA_GET_COUNTER(huart->hdmarx);

			__HAL_DMA_SET_COUNTER(huart->hdmarx, USART3_DMA_RX_BUFFER_SIZE);						//重新设定数据长度
			hdma_usart3_rx.Instance->CR |= DMA_SxCR_CT;												//重新设定缓冲区1地址,交换存储区

			__HAL_DMA_ENABLE(huart->hdmarx);	//使能DMA

			if ( mcu_current_buffer_size == USART3_DMA_RX_DATA_FRAME) {		//表示获取到一帧数据
				/*******接收到数据处理*******/
				//测试代码
//                sprintf(Usart3_DMA_RxBuffer, "54653345\r\n ");
//
//				HAL_UART_Transmit(&huart2, Usart3_DMA_RxBuffer[0], 20, 100);
//
				//数据解析
				myUsart3RXDataHandle(Usart3_DMA_RxBuffer[0], &myrxctrldata_t);

			}
		}
		else {	//双缓冲区
			__HAL_DMA_DISABLE(huart->hdmarx);		//使能DMA,EN位为0
			while (hdma_usart3_rx.Instance->CR & DMA_SxCR_EN) {		//EN位写0需要时间
				__HAL_DMA_DISABLE(&hdma_usart3_rx);
			}
			mcu_current_buffer_size = USART3_DMA_RX_BUFFER_SIZE - __HAL_DMA_GET_COUNTER(huart->hdmarx);		//获取剩余长度
			hdma_usart3_rx.Instance->CR &= ~(DMA_SxCR_CT);						//重新设定缓冲区0地址，交换存储区
			__HAL_DMA_SET_COUNTER(huart->hdmarx, USART3_DMA_RX_BUFFER_SIZE);			//重新设定数据长度
			__HAL_DMA_ENABLE(&hdma_usart3_rx);									//使能DMA

			if (mcu_current_buffer_size == USART3_DMA_RX_DATA_FRAME) {	//表示获取到一帧数据
				/*******接收到数据处理*******/
/*				//测试代码
				HAL_UART_Transmit(&huart2, Usart3_DMA_RxBuffer[1], 20, 100);*/

				//数据解析函数
				myUsart3RXDataHandle(Usart3_DMA_RxBuffer[1], &myrxctrldata_t);

			}
		}
	}
}



/**
  * @func 	串口3【接收】数据解析处理
  * @param	usart3_rx_buffer:	接收数据
  * 		xxxxx:				处理保存指针
  * @retval
  * @note	对来自PU串口的数据进行解析
  *
  */
void myUsart3RXDataHandle(volatile const uint8_t *usart3_rx_buffer, my_Ctrl_RX_Data_t *myRXCtrlData)
{


			myRXCtrlData->uart_position_set[0] = usart3_rx_buffer[2];
			myRXCtrlData->uart_position_set[1] = usart3_rx_buffer[3];
			myRXCtrlData->uart_position_set[2] = usart3_rx_buffer[4];
//			myRXCtrlData->uart_position_set[3] = usart3_rx_buffer[5];
			myRXCtrlData->uart_position_set[3] = 36;

}

//void myUsart3RXDataHandle(volatile const uint8_t *usart3_rx_buffer, my_Ctrl_RX_Data_t *myRXCtrlData)
//{
//	if (usart3_rx_buffer[0] == 0x01) {	//成功接收到来自PC的数据
//		myRXCtrlData->myMode = usart3_rx_buffer[1];		//获取控制模式
//		if (usart3_rx_buffer[1] == MYPIDSETMODE) {		//PID设置模式
//			myRXCtrlData->myPID_t.myKP = usart3_rx_buffer[2] | usart3_rx_buffer[3];					//获取KP参数
//			myRXCtrlData->myPID_t.myKI = usart3_rx_buffer[4] | usart3_rx_buffer[5];					//获取KI参数
//			myRXCtrlData->myPID_t.myKD = usart3_rx_buffer[6] | usart3_rx_buffer[7];					//获取KD参数
//			myRXCtrlData->myPID_t.myPIDSpeedSet = usart3_rx_buffer[8] | usart3_rx_buffer[9];		//获取电机速度设置参数
//		}
//		else if (usart3_rx_buffer[1] == POSCTRL_MODE){	//PC控制角度模式
//			myRXCtrlData->uart_position_set[0] = usart3_rx_buffer[2];
//			myRXCtrlData->uart_position_set[1] = usart3_rx_buffer[3];
//			myRXCtrlData->uart_position_set[2] = usart3_rx_buffer[4];
////			myRXCtrlData->uart_position_set[3] = usart3_rx_buffer[5];
//			myRXCtrlData->uart_position_set[3] = 36;
//
//			//添加PC控制解析代码
//		}
//	}
//	else {	//数据接收错误
//		printf("myUsart3 RX data error\n");
//	}
//
//}









