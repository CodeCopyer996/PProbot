/**
  ******************************************************************************
  * @file   bsp_NRF24L01.c
  * @brief  NRF24L01无线通讯模块
  ******************************************************************************
  * @attention
  * 		NRF24L01电源模块开启
  * 		NRF24L01SPI传输配置
  * 		NRF24L01寄存器配置
  * 		NRF24L01发送配置
  * 		NRF24L01接收配置
  * @author	YM
  * @date	2021/5/14
  ******************************************************************************
  */
#include <Commnication_Task/bsp_NRF24L01.h>

extern SPI_HandleTypeDef hspi4;		//使用SPI4对NRF24L01进行寄存器配置


//本文件内全局变量定义
static uint8_t NRF24L01_tx, NRF24L01_rx;					//定义接收与发送变量
/*static uint8_t NRF24L01_tx_buff[32] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
		0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
		0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};		*/		//定义连续读取寄存器地址

static uint8_t NRF24L01_tx_buff[32] = {0xff};				//定义连续读取寄存器地址


/*
  * @func 	NRF24L01寄存器访问函数
  * @param	reg:指定寄存器地址；data：待发送数据
  * @note	使用SPI发送数据到相关寄存器，对寄存器进行配置
  * 		在使用时，使用0x20+寄存器地址进行访问
  * @retval NRF24L01_rx:返回寄存器写入状态
  */

uint8_t NRF24L01_Write_Byte(uint8_t  reg, uint8_t  data)
{
	uint8_t reg_status;
	NRF24L01_NSS_LOW;									//拉低SPI_NSS_PIN,用于读取数据
	//NRF24L01_tx = reg;
	HAL_SPI_TransmitReceive(&hspi4,&reg,&reg_status,1,55);		//发送寄存器号
	//NRF24L01_tx = data;
	HAL_SPI_TransmitReceive(&hspi4,&data,&NRF24L01_rx,1,55);		//向寄存器中写入数据
	NRF24L01_NSS_HIGH;									//拉高SPI_NSS_PIN，停止读取数据
	return reg_status;
}

/*
  * @func 	NRF24L01读取指定寄存器的单字节数据
  * @param	reg:指定寄存器地址
  * @note	使用SPI通讯获取NRF24L01获取相关寄存器数据
  * @retval	reg_status:返回寄存器读取状态
  */

uint8_t NRF24L01_Read_Byte(uint8_t reg)
{
	uint8_t reg_status;
	NRF24L01_NSS_LOW;									//拉低SPI_NSS_PIN,用于读取数据
	NRF24L01_tx = reg;
	HAL_SPI_TransmitReceive(&hspi4,&NRF24L01_tx,&NRF24L01_rx,1,55);		//写入寄存器号
	NRF24L01_tx = 0xFF;
	HAL_SPI_TransmitReceive(&hspi4,&NRF24L01_tx,&reg_status,1,55);		//读取寄存器中数据
	NRF24L01_NSS_HIGH;											//拉高SPI_NSS_PIN，停止读取数据
	return reg_status;										//返回寄存器地址对应数据
}

/*
  * @func 	NRF24L01【读取】寄存器的指定字节长度数据
  * @param	regAddr:指定寄存器地址
  * 		pData;接收数据数据指针
  * 		len：接收数据长度
  *	@note	接收缓冲函数，主要用来接收在读取FIFO缓冲区的值
  *			基本思路就是通过READ_REG命令，把数据从FIFO（RD_RX_PLOAD）中读取并存在数组中。
  * @retval reg_status:寄存器访问状态
  */

uint8_t NRF24L01_Read_Bytes(uint8_t regAddr, uint8_t* pBuffer, uint8_t len)
{
	uint8_t reg_status, i;
	NRF24L01_NSS_LOW;			//拉低SPI_NSS_PIN,用于读取数据

	NRF24L01_tx = regAddr;
	HAL_SPI_TransmitReceive(&hspi4, &NRF24L01_tx, &reg_status, 1, 55);			//写入寄存器号
	NRF24L01_tx = 0xff;
	HAL_SPI_TransmitReceive(&hspi4, &NRF24L01_tx, pBuffer, len, 55);		//接收指定长度的数据
/*	for (i = 0; i < len; i++) {
		HAL_SPI_TransmitReceive(&hspi4, &NRF24L01_tx, pBuffer++, 1, 55);
	}*/

/*	temp = 0xff;
	for (i = 0; i < len; i++) {
		HAL_SPI_TransmitReceive(&hspi4, &temp, pBuffer++, 1, 55);
	}*/


	NRF24L01_NSS_HIGH;			//拉高SPI_NSS_PIN，停止读取数据

	return reg_status;
}

/*
  * @func 	NRF24L01【写入】指定寄存器并指定字节长度数据
  * @param	regAddr:指定寄存器地址
  * 		pData;接收数据数据指针
  * 		len：接收数据长度
  *	@note	发射缓冲区访问函数，主要用来把数组里的数放在发射FIFO缓冲区中
  *			基本思路就是通过WRITE_REG命令，把数据【存】到FIFO（WR_TX_PLOAD）中去
  * @retval Null
  */

uint8_t NRF24L01_Write_Bytes(uint8_t  regAddr, uint8_t* pBuffer, uint8_t len)
{
	uint8_t reg_status, i;
	NRF24L01_NSS_LOW;

	HAL_SPI_TransmitReceive(&hspi4, &regAddr, &reg_status, 1, 55);			//写入寄存器号


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
  * @func 	NRF24L01电源模块开启
  * @param
  * @note	IO口PG13控制
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









