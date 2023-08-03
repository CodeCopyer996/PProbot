/**
  ******************************************************************************
  * @file   bsp_NRF24L01.c
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
#include <Commnication_Task/bsp_NRF24L01.h>

extern SPI_HandleTypeDef hspi4;		//ʹ��SPI4��NRF24L01���мĴ�������


//���ļ���ȫ�ֱ�������
static uint8_t NRF24L01_tx, NRF24L01_rx;					//��������뷢�ͱ���
/*static uint8_t NRF24L01_tx_buff[32] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
		0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
		0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};		*/		//����������ȡ�Ĵ�����ַ

static uint8_t NRF24L01_tx_buff[32] = {0xff};				//����������ȡ�Ĵ�����ַ


/*
  * @func 	NRF24L01�Ĵ������ʺ���
  * @param	reg:ָ���Ĵ�����ַ��data������������
  * @note	ʹ��SPI�������ݵ���ؼĴ������ԼĴ�����������
  * 		��ʹ��ʱ��ʹ��0x20+�Ĵ�����ַ���з���
  * @retval NRF24L01_rx:���ؼĴ���д��״̬
  */

uint8_t NRF24L01_Write_Byte(uint8_t  reg, uint8_t  data)
{
	uint8_t reg_status;
	NRF24L01_NSS_LOW;									//����SPI_NSS_PIN,���ڶ�ȡ����
	//NRF24L01_tx = reg;
	HAL_SPI_TransmitReceive(&hspi4,&reg,&reg_status,1,55);		//���ͼĴ�����
	//NRF24L01_tx = data;
	HAL_SPI_TransmitReceive(&hspi4,&data,&NRF24L01_rx,1,55);		//��Ĵ�����д������
	NRF24L01_NSS_HIGH;									//����SPI_NSS_PIN��ֹͣ��ȡ����
	return reg_status;
}

/*
  * @func 	NRF24L01��ȡָ���Ĵ����ĵ��ֽ�����
  * @param	reg:ָ���Ĵ�����ַ
  * @note	ʹ��SPIͨѶ��ȡNRF24L01��ȡ��ؼĴ�������
  * @retval	reg_status:���ؼĴ�����ȡ״̬
  */

uint8_t NRF24L01_Read_Byte(uint8_t reg)
{
	uint8_t reg_status;
	NRF24L01_NSS_LOW;									//����SPI_NSS_PIN,���ڶ�ȡ����
	NRF24L01_tx = reg;
	HAL_SPI_TransmitReceive(&hspi4,&NRF24L01_tx,&NRF24L01_rx,1,55);		//д��Ĵ�����
	NRF24L01_tx = 0xFF;
	HAL_SPI_TransmitReceive(&hspi4,&NRF24L01_tx,&reg_status,1,55);		//��ȡ�Ĵ���������
	NRF24L01_NSS_HIGH;											//����SPI_NSS_PIN��ֹͣ��ȡ����
	return reg_status;										//���ؼĴ�����ַ��Ӧ����
}

/*
  * @func 	NRF24L01����ȡ���Ĵ�����ָ���ֽڳ�������
  * @param	regAddr:ָ���Ĵ�����ַ
  * 		pData;������������ָ��
  * 		len���������ݳ���
  *	@note	���ջ��庯������Ҫ���������ڶ�ȡFIFO��������ֵ
  *			����˼·����ͨ��READ_REG��������ݴ�FIFO��RD_RX_PLOAD���ж�ȡ�����������С�
  * @retval reg_status:�Ĵ�������״̬
  */

uint8_t NRF24L01_Read_Bytes(uint8_t regAddr, uint8_t* pBuffer, uint8_t len)
{
	uint8_t reg_status, i;
	NRF24L01_NSS_LOW;			//����SPI_NSS_PIN,���ڶ�ȡ����

	NRF24L01_tx = regAddr;
	HAL_SPI_TransmitReceive(&hspi4, &NRF24L01_tx, &reg_status, 1, 55);			//д��Ĵ�����
	NRF24L01_tx = 0xff;
	HAL_SPI_TransmitReceive(&hspi4, &NRF24L01_tx, pBuffer, len, 55);		//����ָ�����ȵ�����
/*	for (i = 0; i < len; i++) {
		HAL_SPI_TransmitReceive(&hspi4, &NRF24L01_tx, pBuffer++, 1, 55);
	}*/

/*	temp = 0xff;
	for (i = 0; i < len; i++) {
		HAL_SPI_TransmitReceive(&hspi4, &temp, pBuffer++, 1, 55);
	}*/


	NRF24L01_NSS_HIGH;			//����SPI_NSS_PIN��ֹͣ��ȡ����

	return reg_status;
}

/*
  * @func 	NRF24L01��д�롿ָ���Ĵ�����ָ���ֽڳ�������
  * @param	regAddr:ָ���Ĵ�����ַ
  * 		pData;������������ָ��
  * 		len���������ݳ���
  *	@note	���仺�������ʺ�������Ҫ������������������ڷ���FIFO��������
  *			����˼·����ͨ��WRITE_REG��������ݡ��桿��FIFO��WR_TX_PLOAD����ȥ
  * @retval Null
  */

uint8_t NRF24L01_Write_Bytes(uint8_t  regAddr, uint8_t* pBuffer, uint8_t len)
{
	uint8_t reg_status, i;
	NRF24L01_NSS_LOW;

	HAL_SPI_TransmitReceive(&hspi4, &regAddr, &reg_status, 1, 55);			//д��Ĵ�����


	for (i = 0; i < len; i++) {
		HAL_SPI_Transmit(&hspi4, pBuffer++, 1, 55);
	}
	//HAL_SPI_Transmit(&hspi4, pBuffer, len, 55);

	//HAL_SPI_TransmitReceive(&hspi4, pBuffer, &reg_status1, len, 55);


/*	for (i = 0; i < len; i++) {
		HAL_SPI_TransmitReceive(&hspi4, pBuffer++, &reg_status, 1, 55);
	}*/

	NRF24L01_NSS_HIGH;

	return reg_status;
}

/**
  * @func 	NRF24L01��Դģ�鿪��
  * @param
  * @note	IO��PG13����
  * @retval None
  */
void NRF24L01_PowerCtrl(uint8_t NRF_Ctrl_Flag)
{

	if (NRF_Ctrl_Flag == 1) {
		HAL_GPIO_WritePin(NRF24L01_POWER_GPIO_Port, NRF24L01_POWER_Pin, GPIO_PIN_SET);
	}
	else if (NRF_Ctrl_Flag == 0) {
		HAL_GPIO_WritePin(NRF24L01_POWER_GPIO_Port, NRF24L01_POWER_Pin, GPIO_PIN_RESET);
	}
}









