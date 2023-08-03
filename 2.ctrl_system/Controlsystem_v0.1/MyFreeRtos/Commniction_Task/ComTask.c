/****************************************************************
 * @file	ComTask.c
 * @brief	����MCU��ͨ������
 * @Func	MCU��PC�Ĵ���ͨ��
 * 			MCU��ң�����Ĵ���ͨ��
 * 			MCU�ڲ�����ģ���CANͨ��
 * @Author	YM
 * @Data 2021/5/8
 *
 ****************************************************************/

#include <Commnication_Task/ComTask.h>


/*******************************����ʹ��λ******************************************/

#define		EN_NRF24L01			0		//NRF24L01���ܿ��أ�1������0�ر�
#define		EN_NRF_TX_RX_Mode	0		//˫���շ�ģʽ
#define		En_NRF_TX_Mode		0		//NRF24L01����ģʽ���ء�������ģʽ��
#define		En_Com_Printf_Info	0		//��ӡ��Ϣʹ��

/*****************************�ⲿ��������******************************************/
extern CAN_HandleTypeDef 	hcan1;
extern UART_HandleTypeDef 	huart2;
extern SPI_HandleTypeDef 	hspi4;
extern UART_HandleTypeDef 	huart3;
extern chassis_move_t 		Com_move;			//��������˶���������
extern my_Ctrl_RX_Data_t	myrxctrldata_t;    //����PC����ָ��

extern UltrasonicDate_t 	UltraStruData;		//��������������

uint8_t pcComSendDataTest[32];

uint8_t mcuRXDataBuffer[32];		//�����������

char 	Com_Info_buf[300];		//��ӡ�������



/**
  * @func 	ͨѶ����
  * @param
  * @note	MCU��PC��ͨѶ��ʵ��
  * 		MCU��ң�ص�ͨѶʵ��
  * 		MCU���ڲ����ģ���CANͨѶ��ʼ��
  * @retval None
  */

void comTask(void const * argument)
{
	vPortEnterCritical();		//�����ٽ籣��

	dr16_uart_dma_init(&huart1);	//���ô���1��DMA���������ݰ���
	can_filter_init_recv_all();		//����CAN�˲��������ڿ���CAN
	Usart3Tx_DmaInit();		//����3���ͳ�ʼ��
	PC_usart3_dma_init(&huart3);		//����3���ճ�ʼ��
	MyUart8_DMArx_Init(&huart8);

#if EN_NRF24L01		//NRFģ���ʼ��
	uint8_t nrfInitFlag; //NrfCounter = 1;
	nrfInitFlag = NRF24L01_Init();
	if (nrfInitFlag == HAL_OK) {
		 HAL_GPIO_WritePin(GPIOG,NRF_LED_Pin, GPIO_PIN_RESET);
	}
#endif

	vPortExitCritical();		//�˳��ٽ籣��

	for(;;)
	{

		MyUart8_DMArx_Process(&huart8);

#if EN_UART3_RX_MODE

#endif
#if En_NRF_TX_Mode
		if (nrfInitFlag == HAL_OK) {	//NRFͨ���Լ�
			//�������ݴ������
			Run_DataSend_Handle(NRF_TX_MODE,RUN_TXDATAFRAME_1,pcComSendDataTest,&Com_move, &UltraStruData);
			//���Է���ģʽ
			//HAL_UART_Transmit(&huart2, pcComSendDataTest, 32, 100);
			vPortEnterCritical();		//�����ٽ籣��
			NRFComModeChoose(NRF_TX_MODE, pcComSendDataTest, 32);
			vPortExitCritical();		//�˳��ٽ籣��
		}
#endif

#if EN_NRF_TX_RX_Mode
		if (nrfInitFlag == HAL_OK) {	//NRFͨ���Լ�
			//�������ݴ������
			Run_DataSend_Handle(NRF_TX_MODE,PID_TXDATAFRAME,pcComSendDataTest,&Com_move,NULL,NULL);
			HAL_UART_Transmit(&huart2, pcComSendDataTest, 16, 100);

			/**********�������Ϊ���Գɹ�����************/
			if (NrfCounter % 2 == 0) {		//��������
				//���Խ���ģʽ
				NRFComModeChoose(NRF_RX_MODE, mcuRXDataBuffer, 32);		//���Խ���ģʽ
				NrfCounter = 1;
			}else {		//����3������
				//��������ѭ���շ�ģʽ
				NRFComModeChoose(NRF_TX_MODE, pcComSendDataTest, 32);		//���Է���ģʽ
				NrfCounter ++;
			}
		}
#endif
#if En_Com_Printf_Info
		//����IMU���
		sprintf(Com_Info_buf, " Yaw: %d    Pitch: %d    roll: %d	Temp:%d\n",
				mpu_FeedbackData.yaw, mpu_FeedbackData.pitch, mpu_FeedbackData.roll, mpu_FeedbackData.temp);
		HAL_UART_Transmit(&huart2, (uint8_t *)Com_Info_buf, (COUNTOF(Com_Info_buf)-1), 55);
		//���Գ��������
		sprintf(Com_Info_buf, " WS1: %d    WS2: %d    WS3: %d	WS4:%d\n",UltraStruData.DataUltrStation1,
				UltraStruData.DataUltrStation2, UltraStruData.DataUltrStation3, UltraStruData.DataUltrStation4);
		HAL_UART_Transmit(&huart2, (uint8_t *)Com_Info_buf, (COUNTOF(Com_Info_buf)-1), 55);
#endif
		 osDelay(30);
	}
}


/**
  * @func 	����3��MCU��PC��ͨѶʵ��
  * @param	ComFlag:	ͨѶ��־λ
  * 		ComData:	���ݻ���
  * 		Len	:		ͨѶ���ݳ���
  * @note
  * @retval None
  */

void USART3ComModeChoose(uint8_t ComFlag, uint8_t *ComData, uint16_t Len)
{
	if (ComFlag == USART3_TX_MODE) {		//����ģʽ

	}
	else if (ComFlag == USART3_RX_MODE) {	//����ģʽ

	}
}

/**
  * @func 	NRF24L01ͨѶģʽѡ����
  * @param	NRFComFlag:	ͨѶ��־λ
  * 					NRF_TX_MODE :MCU��������		NRF_RX_MODE:MCU��������
  * @note	ComData��	ͨѶ����
  * 		Len:		���ݳ���
  * @retval �����������ʱ500ms����ʱ�����յ����ݣ�������������ݽ���
  */
void NRFComModeChoose(uint8_t NRFComFlag, uint8_t *NRFComData, uint16_t NRFLen)
{
	uint8_t ComReturnFlag;
	if (NRFComFlag == NRF_TX_MODE) {	//����ģʽѡ��
		NRF24L01_TX_Mode();					//����ģʽ��ʼ��
		HAL_Delay(5);						//��ʱ����
		ComReturnFlag = NRF24L01_Tx_Packet(NRFComData);
	}
	else if (NRFComFlag == NRF_RX_MODE) {	//����ģʽ
		NRF24L01_RX_Mode();		//����ģʽ��ʼ��
		HAL_Delay(5);			//��ʱ����
		ComReturnFlag = NRF24L01_Rx_Packet(NRFComData);
		//������üĴ���
		NRF24L01_Read_Bytes(RD_RX_PLOAD, NRFComData, RX_PLOAD_WIDTH);		//���RX FIFO�Ĵ���
		NRF24L01_Write_Byte(FLUSH_RX, 0xff);								//���TX FIFO�Ĵ���
	}
}


/**
  * @func 	������ݴ������
  * @param	TxModeChoose:	���ݷ���ģʽ
  * 		frameMode	:	����֡ģʽ
  * 		dataFrame	:	�������ָ֡��
  * 		motorData	:	�������ָ��
  * 		mpuFeedback	:	IMU����ָ��
  * 		ultrFeedback:	����������ָ��
  * @note
  * @retval None
  */
void Run_DataSend_Handle(uint8_t TxModeChoose, uint8_t frameMode, uint8_t *dataFrame, chassis_move_t *motorData, UltrasonicDate_t *ultrFeedback)
{
	if (TxModeChoose == NRF_TX_MODE) {	//NRFͨѶģʽ
		//PID������ʾ֡
		if (frameMode == PID_TXDATAFRAME) {
			dataFrame[0] = 32;		//���ݳ���
			dataFrame[1] = 0x0F;	//��ʼλ
			dataFrame[2] = 0x00;	//2,3�ֽڱ�ʾ0001��ʾPID����
			dataFrame[3] = 0x01;
			//����ٶȴ��,4 - 15 �ֽ�
			Motor_data_packHandle(dataFrame, motorData);
		}
		//������ʾ����֡1,��������ٶȡ�IMUλ�ˡ�IMU�¶�ֵ
		else if (TxModeChoose == RUN_TXDATAFRAME_1) {
			dataFrame[0] = 32;		//���ݳ���
			dataFrame[1] = 0x0F;	//��ʼλ
			dataFrame[2] = 0x00;	//2,3�ֽڱ�ʾ0010����ʾ����ģʽ����֡1
			dataFrame[3] = 0x01;
			//����ٶȴ��,4 - 15 �ֽ�
			Motor_data_packHandle(dataFrame, motorData);
			//���������ݴ��
			dataFrame[24] = ( ultrFeedback->DataUltrStation1 >> 8) & 0xff;		//station_1����
			dataFrame[25] =	  ultrFeedback->DataUltrStation1 & 0xff;
			dataFrame[26] = ( ultrFeedback->DataUltrStation2>> 8) & 0xff;		//station_2����
			dataFrame[27] =	  ultrFeedback->DataUltrStation2 & 0xff;
			dataFrame[28] = ( ultrFeedback->DataUltrStation3 >> 8) & 0xff;		//station_3����
			dataFrame[29] =	  ultrFeedback->DataUltrStation3 & 0xff;
			dataFrame[30] = ( ultrFeedback->DataUltrStation4 >> 8) & 0xff;		//station_4����
			dataFrame[31] =	  ultrFeedback->DataUltrStation4 & 0xff;
		}
	}
	else if (TxModeChoose == USART3_TX_MODE) {		//����ͨѶģʽ

	}
}


/**
  * @func 	������ݴ������
  * @param	TxModeChoose:	���ݷ���ģʽ
  * 		frameMode	:	����֡ģʽ
  * 		dataFrame	:	�������ָ֡��
  * 		motorData	:	�������ָ��
  *
  * @note
  * @retval None
  */
void Motor_data_packHandle(uint8_t *dataFrame, chassis_move_t *motorData)
{
	dataFrame[4] = ((motorData->motor_chassis[0].chassis_motor_measure->speed_rpm) >> 8) & 0xff;
	dataFrame[5] = (motorData->motor_chassis[0].chassis_motor_measure->speed_rpm) & 0xff;
	dataFrame[6] = ((motorData->motor_chassis[1].chassis_motor_measure->speed_rpm) >> 8) & 0xff;
	dataFrame[7] = (motorData->motor_chassis[1].chassis_motor_measure->speed_rpm) & 0xff;
	dataFrame[8] = ((motorData->motor_chassis[2].chassis_motor_measure->speed_rpm) >> 8) & 0xff;
	dataFrame[9] = (motorData->motor_chassis[2].chassis_motor_measure->speed_rpm) & 0xff;
	dataFrame[10] = ((motorData->motor_chassis[3].chassis_motor_measure->speed_rpm) >> 8 ) & 0xff;
	dataFrame[11] = (motorData->motor_chassis[3].chassis_motor_measure->speed_rpm) & 0xff;
	dataFrame[12] = motorData->motor_chassis[0].chassis_motor_measure->temperrate;
	dataFrame[13] = motorData->motor_chassis[1].chassis_motor_measure->temperrate;
	dataFrame[14] = motorData->motor_chassis[2].chassis_motor_measure->temperrate;
	dataFrame[15] = motorData->motor_chassis[3].chassis_motor_measure->temperrate;
}
