/**
  ******************************************************************************
  * @file   PCComTask.c
  * @brief  ��Ҫ����MCU��PC�Ķ̾���ͨѶ����
  ******************************************************************************
  * @attention
  *			����3��DMA������֡�����ա�������
  *			DMA��ʼ������
  *			DMA�����ж϶���
  ******************************************************************************
  */

#include <Commnication_Task/MCUAndPCCom.h>


extern DMA_HandleTypeDef hdma_usart3_rx;
extern DMA_HandleTypeDef hdma_usart3_tx;
extern UART_HandleTypeDef huart3;
extern UART_HandleTypeDef huart2;

static uint8_t Usart3_DMA_RxBuffer[2][USART3_DMA_RX_BUFFER_SIZE];		//����3����DMA������մ�С��ʹ�õ���˫������ģʽ
uint8_t temppcComSendDataTest[16]={0x7f,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0xaa,0xaa,0xaa,0x00,0x00,0x03,0x0f,0x0f};


//�������սṹ�����
my_Ctrl_RX_Data_t	myrxctrldata_t;





/**
  * @func 	��ȡ�Զ���Э��֡�����ṹ�塾ָ�롿
  * @param
  * @retval	myrxctrldata_t
  * @note	��������Ŀ�����𵽸������ã�ͨ�����ú���ָ��ķ�ʽ���𵽶Խṹ������ķ��ʣ�
  * 		������ʵط�̫�࣬�������ĳ�ͻ��
  * 		�������������ʱ����Ҫ�ȶ���my_Ctrl_RX_Data_t������һ���ṹ����������ڱ��淵��ֵ
  */
const my_Ctrl_RX_Data_t *Get_MyRXCtrlDataPoint()
{
	return &myrxctrldata_t;		//���ض���Ľṹ�������ַ�������ļ���ͨ�����������ȡ�������ݽ��
}




//static void Usart3_Rx_DMA_BufferData(UART_HandleTypeDef *huart , uint8_t BufferFlag);

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

/**
  * @func 	����3�����ա�DMA��ʼ����װ
  * @param
  * @retval
  * @note
  */
void Usart3Rx_Init()
{
	Usart3Rx_DMAInit(Usart3_DMA_RxBuffer[0],Usart3_DMA_RxBuffer[1],USART3_DMA_RX_BUFFER_SIZE);
}


/**
  * @func 	����3�����ա�DMA��ʼ��
  * @param	Usart3_DMA_RxBuffer1:	DMA���ջ�����1
  * 		Usart3_DMA_RxBuffer2: 	DMA���ջ�����2
  * 		FreamLen:				DMA����֡����
  * @retval
  * @note	ʹ�ÿ����жϿ���DMA����
  */
void Usart3Rx_DMAInit(uint8_t *Usart3_DMA_RxBuffer1, uint8_t *Usart3_DMA_RxBuffer2, uint16_t FreamLen)
{
	SET_BIT(huart3.Instance->CR3, USART_CR3_DMAR);	//ʹ�ܴ���DMA�Ľ���
	__HAL_UART_ENABLE_IT(&huart3, UART_IT_IDLE);	//ʹ�ܴ��ڿ����ж�

	//ʧ��DMA���ԼĴ�����������
	__HAL_DMA_DISABLE(&hdma_usart3_rx);
	while (hdma_usart3_rx.Instance->CR & DMA_SxCR_EN) {		//ENλд0��Ҫʱ��
		__HAL_DMA_DISABLE(&hdma_usart3_rx);
	}
	hdma_usart3_rx.Instance->PAR  = (uint32_t) & (USART3->DR);			//��������Ĵ�����ַλDR�Ĵ���
	hdma_usart3_rx.Instance->M0AR = (uint32_t)(Usart3_DMA_RxBuffer1);	//�����ڴ滺����1

	hdma_usart3_rx.Instance->M1AR = (uint32_t)(Usart3_DMA_RxBuffer2);	//�����ڴ滺����2

	hdma_usart3_rx.Instance->NDTR = FreamLen;				//�������ݳ���

	SET_BIT(hdma_usart3_rx.Instance->CR, DMA_SxCR_DBM);		//ʹ��˫������

	//ʹ��DMA
	__HAL_DMA_ENABLE(&hdma_usart3_rx);
}

/**
  * @func 	����3�����ա��ж�
  * @param
  * @retval
  * @note	ʹ��˫�������������ݽ��մ���
  * 		��ע�⡿���õ��Ƕ��ֳ����䣬�������ֳ�ΪUSART3_DMA_RX_DATA_FRAME��С
  */

void Usart3Rx_DMA_IRQHandle(UART_HandleTypeDef *huart)
{
	if (huart->Instance->SR & UART_FLAG_RXNE) {		//���յ����ݷǿ�
		__HAL_UART_CLEAR_PEFLAG(huart);
	}
	else if (huart->Instance->SR & UART_FLAG_IDLE) {	//��⵽����֡
		__HAL_UART_CLEAR_PEFLAG(huart);				//������ڴ��������λ
		static uint16_t mcu_current_buffer_size = 0;

		if ( (hdma_usart3_rx.Instance->CR & DMA_SxCR_CT) == RESET) {			//˫������
			__HAL_DMA_DISABLE(huart->hdmarx);		//ʧ��DMA,ENλΪ0
			while (hdma_usart3_rx.Instance->CR & DMA_SxCR_EN) {		//ENλд0��Ҫʱ��
				__HAL_DMA_DISABLE(&hdma_usart3_rx);
			}
			mcu_current_buffer_size = USART3_DMA_RX_BUFFER_SIZE - __HAL_DMA_GET_COUNTER(huart->hdmarx);

			__HAL_DMA_SET_COUNTER(huart->hdmarx, USART3_DMA_RX_BUFFER_SIZE);						//�����趨���ݳ���
			hdma_usart3_rx.Instance->CR |= DMA_SxCR_CT;												//�����趨������1��ַ,�����洢��

			__HAL_DMA_ENABLE(huart->hdmarx);	//ʹ��DMA

			if ( mcu_current_buffer_size == USART3_DMA_RX_DATA_FRAME) {		//��ʾ��ȡ��һ֡����
				/*******���յ����ݴ���*******/
				//���Դ���
//                sprintf(Usart3_DMA_RxBuffer, "54653345\r\n ");
//
//				HAL_UART_Transmit(&huart2, Usart3_DMA_RxBuffer[0], 20, 100);
//
				//���ݽ���
				myUsart3RXDataHandle(Usart3_DMA_RxBuffer[0], &myrxctrldata_t);

			}
		}
		else {	//˫������
			__HAL_DMA_DISABLE(huart->hdmarx);		//ʹ��DMA,ENλΪ0
			while (hdma_usart3_rx.Instance->CR & DMA_SxCR_EN) {		//ENλд0��Ҫʱ��
				__HAL_DMA_DISABLE(&hdma_usart3_rx);
			}
			mcu_current_buffer_size = USART3_DMA_RX_BUFFER_SIZE - __HAL_DMA_GET_COUNTER(huart->hdmarx);		//��ȡʣ�೤��
			hdma_usart3_rx.Instance->CR &= ~(DMA_SxCR_CT);						//�����趨������0��ַ�������洢��
			__HAL_DMA_SET_COUNTER(huart->hdmarx, USART3_DMA_RX_BUFFER_SIZE);			//�����趨���ݳ���
			__HAL_DMA_ENABLE(&hdma_usart3_rx);									//ʹ��DMA

			if (mcu_current_buffer_size == USART3_DMA_RX_DATA_FRAME) {	//��ʾ��ȡ��һ֡����
				/*******���յ����ݴ���*******/
/*				//���Դ���
				HAL_UART_Transmit(&huart2, Usart3_DMA_RxBuffer[1], 20, 100);*/

				//���ݽ�������
				myUsart3RXDataHandle(Usart3_DMA_RxBuffer[1], &myrxctrldata_t);

			}
		}
	}
}



/**
  * @func 	����3�����ա����ݽ�������
  * @param	usart3_rx_buffer:	��������
  * 		xxxxx:				������ָ��
  * @retval
  * @note	������PU���ڵ����ݽ��н���
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
//	if (usart3_rx_buffer[0] == 0x01) {	//�ɹ����յ�����PC������
//		myRXCtrlData->myMode = usart3_rx_buffer[1];		//��ȡ����ģʽ
//		if (usart3_rx_buffer[1] == MYPIDSETMODE) {		//PID����ģʽ
//			myRXCtrlData->myPID_t.myKP = usart3_rx_buffer[2] | usart3_rx_buffer[3];					//��ȡKP����
//			myRXCtrlData->myPID_t.myKI = usart3_rx_buffer[4] | usart3_rx_buffer[5];					//��ȡKI����
//			myRXCtrlData->myPID_t.myKD = usart3_rx_buffer[6] | usart3_rx_buffer[7];					//��ȡKD����
//			myRXCtrlData->myPID_t.myPIDSpeedSet = usart3_rx_buffer[8] | usart3_rx_buffer[9];		//��ȡ����ٶ����ò���
//		}
//		else if (usart3_rx_buffer[1] == POSCTRL_MODE){	//PC���ƽǶ�ģʽ
//			myRXCtrlData->uart_position_set[0] = usart3_rx_buffer[2];
//			myRXCtrlData->uart_position_set[1] = usart3_rx_buffer[3];
//			myRXCtrlData->uart_position_set[2] = usart3_rx_buffer[4];
////			myRXCtrlData->uart_position_set[3] = usart3_rx_buffer[5];
//			myRXCtrlData->uart_position_set[3] = 36;
//
//			//���PC���ƽ�������
//		}
//	}
//	else {	//���ݽ��մ���
//		printf("myUsart3 RX data error\n");
//	}
//
//}









