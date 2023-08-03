/**
  ******************************************************************************
  * @file   NRF24L01.c
  * @brief  NRF24L01����ͨѶģ��
  ******************************************************************************
  * @attention
  * 		NRF24L01��Դģ�鿪��
  * 		NRF24L01SPI��������
  * 		NRF24L01�Ĵ�������
  * 		NRF24L01��������
  * 		NRF24L01��������
  * @author	YM
  * @date	2021/5/14
  ******************************************************************************
  */
#include <Commnication_Task/NRF24L01.h>

//��ַ����
uint8_t NRF24L01_TX_Addr[NRF24L01_TX_ADDT_WIDTH] = {0x7f,0x10,0x00,0x59,0x40};	//���͵�ַ��PC�˵�ַ
uint8_t NRF24L01_RX_Addr[NRF24L01_RX_ADDT_WIDTH] = {0x7f,0x10,0x00,0x59,0x40};	//���յ�ַ��MCU�˵�ַ


/**
  * @func 	NRF24L01ģ���ʼ��
  * @param
  * @note	������Դģ��
  * @retval initFlag: 0: ���� 	1������
  */

uint8_t NRF24L01_Init()
{
	uint8_t tempCounter = 0;
	uint8_t initFlag = 0;
	NRF24L01_PowerCtrl(1);
	HAL_Delay(10);
	NRF24L01_CE_LOW;		//ʹ��24L01ģ��
	NRF24L01_NSS_HIGH;		//ȡ��SPIƬѡ

	while (NRF24L01_Self_Test() != 0) {
		if (tempCounter >= 30) {		//20���Լ첻ͨ��������ѭ��
			printf("NRF24L01 Self_Test Error!\n");
			initFlag = 1;
			break;
		}
		tempCounter++;
		HAL_Delay(20);
	}
	return initFlag;
}



/**
  * @func 	NRF24L01ģ���Լ�
  * @param
  * @note
  * @retval None
  */
uint8_t NRF24L01_Self_Test()
{
	uint8_t TestBuffer[5] = {0x0f,0x0f,0x0f,0x0f,0x0f};
	uint8_t i;

	hspi4.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_16;		//ͨ���޸�SPI�Ĳ����ʣ���SPI���м��ٲ���
	if(HAL_SPI_Init(&hspi4) != HAL_OK){
		printf("SPI Accelerate Error! \n");
	}
	NRF24L01_Write_Bytes(NRF_WRITE_REG + TX_ADDR, TestBuffer, 5);	//��Ĵ�����д���ַ
	NRF24L01_Read_Bytes(TX_ADDR, TestBuffer, 5);					//����д��ĵ�ַ

	for (i = 0; i < 5; i++) {
		if (TestBuffer[i] != 0x0f) {
			break;
		}
	}
	if (i != 5) {
		return 1;		//���24L01����
	}
	return 0;
}


/**
  * @func 	NRF24L01���͡�����ģʽѡ��
  * @param
  * @note	������Դģ��
  * @retval None
  */

void NRF24L01_Mode_Choose(uint8_t modeFlag, uint8_t *dataBuffer)
{
//	uint8_t nrfPacketRetrun;
//	if (modeFlag == TX_MODE) {
//		//NRF24L01_TX_Mode();
//		nrfPacketRetrun = NRF24L01_Tx_Packet(dataBuffer);
//		if (nrfPacketRetrun != TX_OK) {
//			printf("NRF24L01 TX Data Error!***nrf_TXPacketRetrun = %d\n",nrfPacketRetrun);
//		}
//	}
//	else if (modeFlag == RX_MODE) {
//		NRF24L01_RX_Mode();
//		//HAL_Delay(1);
//		nrfPacketRetrun = NRF24L01_Rx_Packet(dataBuffer);
//		if (NRF24L01_Tx_Packet(dataBuffer) != TX_OK) {
//			printf("NRF24L01 RX Data Error!***nrf_RXPacketRetrun = %d\n",nrfPacketRetrun);
//		}
//	}
}


/**
  * @func 	NRF24L01���ͺ���
  * @param	*tx_buffer:	��Ҫ���͵�һ֡����
  * @note	�������͵�����д�뵽FIFO��������
  * @retval MAX_TX(16): ���ʹﵽ������	0����������	32:���ͳɹ�
  */

uint8_t NRF24L01_Tx_Packet(uint8_t *tx_buffer)
{
	uint8_t CurrSta,tempsta;
	//SPIͨѶ���٣����ڼ���SPI�Ĵ����ٶ�,NRF���֧��10MHZ��SPI�ٶȲ��ܳ������ֵ
	hspi4.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_16;		//ͨ���޸�SPI�Ĳ����ʣ���SPI���м��ٲ���
	if(HAL_SPI_Init(&hspi4) != HAL_OK){
		printf("SPI Accelerate Error! \n");
	}

	tempsta = NRF24L01_Read_Byte(STATUS);
	//printf("NRF24L01 TX Data Befor STATUS = %d \r\n",tempsta);

	NRF24L01_CE_LOW;
	NRF24L01_Write_Bytes(WR_TX_PLOAD, tx_buffer, TX_PLOAD_WIDTH);		//������д�뵽FIFO��������

	NRF24L01_CE_HIGH;
	HAL_Delay(1);

	while (NRF24L01_IRQ_STATUS);	//��ʾ����λ��ɣ��ȴ�ֱ���������

	CurrSta = NRF24L01_Read_Byte(STATUS);					//��ȡ״̬�Ĵ���ֵ
	//printf("NRF24L01 TX Data After STATUS = %d \r\n",CurrSta);
	NRF24L01_Write_Byte(NRF_WRITE_REG + STATUS,CurrSta);		//��״̬�Ĵ�����д���ݣ����״̬�Ĵ����������жϱ�־
	if (CurrSta & MAX_TX) {							//�ﵽ��������
		NRF24L01_Write_Byte(FLUSH_TX, 0xff);		//���TX FIFO�Ĵ���
		return MAX_TX;
	}
	if (CurrSta & TX_OK) {
		return 0;
	}
	return 1;
}

/**
  * @func 	NRF24L01���պ���
  * @param	*rx_buffer:	��Ҫ���յ�һ֡����
  * @note	�������͵�����д�뵽FIFO��������
  * @retval None
  */

uint8_t NRF24L01_Rx_Packet(uint8_t *rx_buffer)
{
	uint8_t CurrSta, WhileConter = 0;
	//SPIͨѶ���٣����ڼ���SPI�Ĵ����ٶ�,NRF���֧��10MHZ��SPI�ٶȲ��ܳ������ֵ
	hspi4.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_16;		//ͨ���޸�SPI�Ĳ����ʣ���SPI���м��ٲ���
	if(HAL_SPI_Init(&hspi4) != HAL_OK){
		printf("SPI Accelerate Error! \n");
	}
	while (NRF24L01_IRQ_STATUS){
		HAL_Delay(10);
		if (WhileConter == 20) {	//200msû���յ����ݣ�������������
			WhileConter = 0;
			break;
		}
		WhileConter++;
	}
	CurrSta = NRF24L01_Read_Byte(STATUS);					//��ȡ״̬�Ĵ���ֵ
	NRF24L01_Write_Byte(NRF_WRITE_REG + STATUS,CurrSta);	//��״̬�Ĵ�����д���ݣ����״̬�Ĵ����������жϱ�־
	if (CurrSta & RX_OK) {		//���ճɹ�
		NRF24L01_Read_Bytes(RD_RX_PLOAD, rx_buffer, RX_PLOAD_WIDTH);		//���RX FIFO�Ĵ���
		NRF24L01_Write_Byte(FLUSH_RX, 0xff);		//���TX FIFO�Ĵ���
		return 0;
	}
	return 1;
}


/**
  * @func 	NRF24L01����ģʽ
  * @param
  * @note
  * @retval None
  */

void NRF24L01_TX_Mode(void)
{
	NRF24L01_CE_LOW;			//CEΪ0�����뷢��ģʽ

	NRF24L01_Write_Bytes(NRF_WRITE_REG + TX_ADDR, NRF24L01_TX_Addr, NRF24L01_TX_ADDT_WIDTH);		//д��TX�ڵ��ַ��PC��ַ
	NRF24L01_Write_Bytes(NRF_WRITE_REG + RX_ADDR_P0,  NRF24L01_TX_Addr, NRF24L01_RX_ADDT_WIDTH);		//����TX�ڵ��ַ������RX��ַ��ͬʱʹ��ACKӦ��

	NRF24L01_Write_Byte(NRF_WRITE_REG + EN_AA, 0x01);		//ʹ��ͨ��0��ACKӦ��
	NRF24L01_Write_Byte(NRF_WRITE_REG + EN_RXADDR, 0x01);	//ʹ��ͨ��0�Ľ��յ�ַ
	NRF24L01_Write_Byte(NRF_WRITE_REG + SETUP_RETR, 0x1a);	//����ͨ��0���Զ��ط�ʱ��
	NRF24L01_Write_Byte(NRF_WRITE_REG + RF_CH, 40);			//����RFͨ��Ϊ2.440GHz
	NRF24L01_Write_Byte(NRF_WRITE_REG + RF_SETUP, 0x0f);	//����TX���������0db���棬2Mbps�����������濪��
	NRF24L01_Write_Byte(NRF_WRITE_REG + CONFIG, 0x0e);		//���û�������ģʽ������PWR_UP,EN_CRC,16BIT_CRC,����ģʽ�����������ж�

	NRF24L01_CE_HIGH;	//CEΪ�ߣ�10usΪ�Զ�����
}


/**
  * @func 	NRF24L01����ģʽ
  * @param
  * @note
  * @retval None
  */

void NRF24L01_RX_Mode(void)
{
	NRF24L01_CE_LOW;
	//NRF24L01_Write_Bytes(NRF_WRITE_REG + TX_ADDR, NRF24L01_TX_Addr, NRF24L01_TX_ADDT_WIDTH);
	NRF24L01_Write_Bytes(NRF_WRITE_REG + RX_ADDR_P0, NRF24L01_RX_Addr, NRF24L01_RX_ADDT_WIDTH);		//����TX�ڵ��ַ������RX��ַ��ͬʱʹ��ACKӦ��

	NRF24L01_Write_Byte(NRF_WRITE_REG + EN_AA, 0x01);		//ʹ��ͨ��0��ACKӦ��
	NRF24L01_Write_Byte(NRF_WRITE_REG + EN_RXADDR, 0x01);	//ʹ��ͨ��0�Ľ��յ�ַ
	NRF24L01_Write_Byte(NRF_WRITE_REG + RF_CH, 40);			//����RFͨ��Ϊ2.440GHZ
	NRF24L01_Write_Byte(NRF_WRITE_REG + RX_PW_P0, RX_PLOAD_WIDTH);			//����ͨ��0����Ч���ݿ��
	NRF24L01_Write_Byte(NRF_WRITE_REG + RF_SETUP, 0x0f);	//����TX���������0db���棬2Mbps�����������濪��
	NRF24L01_Write_Byte(NRF_WRITE_REG + CONFIG, 0x0f);		//���û�������ģʽ������PWR_UP,EN_CRC,16BIT_CRC,����ģʽ�����������ж�

	NRF24L01_CE_HIGH;	//CEΪ�ߣ�10usΪ�Զ�����
}
