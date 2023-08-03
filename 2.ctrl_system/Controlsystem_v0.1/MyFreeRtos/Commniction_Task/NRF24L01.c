/**
  ******************************************************************************
  * @file   NRF24L01.c
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
#include <Commnication_Task/NRF24L01.h>

//地址定义
uint8_t NRF24L01_TX_Addr[NRF24L01_TX_ADDT_WIDTH] = {0x7f,0x10,0x00,0x59,0x40};	//发送地址，PC端地址
uint8_t NRF24L01_RX_Addr[NRF24L01_RX_ADDT_WIDTH] = {0x7f,0x10,0x00,0x59,0x40};	//接收地址，MCU端地址


/**
  * @func 	NRF24L01模块初始化
  * @param
  * @note	开启电源模块
  * @retval initFlag: 0: 正常 	1：错误
  */

uint8_t NRF24L01_Init()
{
	uint8_t tempCounter = 0;
	uint8_t initFlag = 0;
	NRF24L01_PowerCtrl(1);
	HAL_Delay(10);
	NRF24L01_CE_LOW;		//使能24L01模块
	NRF24L01_NSS_HIGH;		//取消SPI片选

	while (NRF24L01_Self_Test() != 0) {
		if (tempCounter >= 30) {		//20次自检不通过，跳出循环
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
  * @func 	NRF24L01模块自检
  * @param
  * @note
  * @retval None
  */
uint8_t NRF24L01_Self_Test()
{
	uint8_t TestBuffer[5] = {0x0f,0x0f,0x0f,0x0f,0x0f};
	uint8_t i;

	hspi4.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_16;		//通过修改SPI的波特率，对SPI进行加速操作
	if(HAL_SPI_Init(&hspi4) != HAL_OK){
		printf("SPI Accelerate Error! \n");
	}
	NRF24L01_Write_Bytes(NRF_WRITE_REG + TX_ADDR, TestBuffer, 5);	//向寄存器中写入地址
	NRF24L01_Read_Bytes(TX_ADDR, TestBuffer, 5);					//读出写入的地址

	for (i = 0; i < 5; i++) {
		if (TestBuffer[i] != 0x0f) {
			break;
		}
	}
	if (i != 5) {
		return 1;		//检测24L01错误
	}
	return 0;
}


/**
  * @func 	NRF24L01发送、接收模式选择
  * @param
  * @note	开启电源模块
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
  * @func 	NRF24L01发送函数
  * @param	*tx_buffer:	需要发送的一帧数据
  * @note	将待发送的数据写入到FIFO缓冲区中
  * @retval MAX_TX(16): 发送达到最大次数	0：其他错误	32:发送成功
  */

uint8_t NRF24L01_Tx_Packet(uint8_t *tx_buffer)
{
	uint8_t CurrSta,tempsta;
	//SPI通讯加速，用于加速SPI的传输速度,NRF最大支持10MHZ，SPI速度不能超过这个值
	hspi4.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_16;		//通过修改SPI的波特率，对SPI进行加速操作
	if(HAL_SPI_Init(&hspi4) != HAL_OK){
		printf("SPI Accelerate Error! \n");
	}

	tempsta = NRF24L01_Read_Byte(STATUS);
	//printf("NRF24L01 TX Data Befor STATUS = %d \r\n",tempsta);

	NRF24L01_CE_LOW;
	NRF24L01_Write_Bytes(WR_TX_PLOAD, tx_buffer, TX_PLOAD_WIDTH);		//将数据写入到FIFO缓冲区中

	NRF24L01_CE_HIGH;
	HAL_Delay(1);

	while (NRF24L01_IRQ_STATUS);	//表示发送位完成，等待直到发送完成

	CurrSta = NRF24L01_Read_Byte(STATUS);					//读取状态寄存器值
	//printf("NRF24L01 TX Data After STATUS = %d \r\n",CurrSta);
	NRF24L01_Write_Byte(NRF_WRITE_REG + STATUS,CurrSta);		//向状态寄存器中写数据，清除状态寄存器产生的中断标志
	if (CurrSta & MAX_TX) {							//达到最大发射次数
		NRF24L01_Write_Byte(FLUSH_TX, 0xff);		//清除TX FIFO寄存器
		return MAX_TX;
	}
	if (CurrSta & TX_OK) {
		return 0;
	}
	return 1;
}

/**
  * @func 	NRF24L01接收函数
  * @param	*rx_buffer:	需要接收的一帧数据
  * @note	将待发送的数据写入到FIFO缓冲区中
  * @retval None
  */

uint8_t NRF24L01_Rx_Packet(uint8_t *rx_buffer)
{
	uint8_t CurrSta, WhileConter = 0;
	//SPI通讯加速，用于加速SPI的传输速度,NRF最大支持10MHZ，SPI速度不能超过这个值
	hspi4.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_16;		//通过修改SPI的波特率，对SPI进行加速操作
	if(HAL_SPI_Init(&hspi4) != HAL_OK){
		printf("SPI Accelerate Error! \n");
	}
	while (NRF24L01_IRQ_STATUS){
		HAL_Delay(10);
		if (WhileConter == 20) {	//200ms没有收到数据，结束接收数据
			WhileConter = 0;
			break;
		}
		WhileConter++;
	}
	CurrSta = NRF24L01_Read_Byte(STATUS);					//读取状态寄存器值
	NRF24L01_Write_Byte(NRF_WRITE_REG + STATUS,CurrSta);	//向状态寄存器中写数据，清除状态寄存器产生的中断标志
	if (CurrSta & RX_OK) {		//接收成功
		NRF24L01_Read_Bytes(RD_RX_PLOAD, rx_buffer, RX_PLOAD_WIDTH);		//清除RX FIFO寄存器
		NRF24L01_Write_Byte(FLUSH_RX, 0xff);		//清除TX FIFO寄存器
		return 0;
	}
	return 1;
}


/**
  * @func 	NRF24L01发送模式
  * @param
  * @note
  * @retval None
  */

void NRF24L01_TX_Mode(void)
{
	NRF24L01_CE_LOW;			//CE为0，进入发送模式

	NRF24L01_Write_Bytes(NRF_WRITE_REG + TX_ADDR, NRF24L01_TX_Addr, NRF24L01_TX_ADDT_WIDTH);		//写入TX节点地址，PC地址
	NRF24L01_Write_Bytes(NRF_WRITE_REG + RX_ADDR_P0,  NRF24L01_TX_Addr, NRF24L01_RX_ADDT_WIDTH);		//设置TX节点地址后，设置RX地址，同时使能ACK应答

	NRF24L01_Write_Byte(NRF_WRITE_REG + EN_AA, 0x01);		//使能通道0的ACK应答
	NRF24L01_Write_Byte(NRF_WRITE_REG + EN_RXADDR, 0x01);	//使能通道0的接收地址
	NRF24L01_Write_Byte(NRF_WRITE_REG + SETUP_RETR, 0x1a);	//设置通道0的自动重发时间
	NRF24L01_Write_Byte(NRF_WRITE_REG + RF_CH, 40);			//设置RF通道为2.440GHz
	NRF24L01_Write_Byte(NRF_WRITE_REG + RF_SETUP, 0x0f);	//设置TX发射参数，0db增益，2Mbps，低噪声增益开启
	NRF24L01_Write_Byte(NRF_WRITE_REG + CONFIG, 0x0e);		//配置基本工作模式参数：PWR_UP,EN_CRC,16BIT_CRC,发送模式，开启所有中断

	NRF24L01_CE_HIGH;	//CE为高，10us为自动发射
}


/**
  * @func 	NRF24L01接收模式
  * @param
  * @note
  * @retval None
  */

void NRF24L01_RX_Mode(void)
{
	NRF24L01_CE_LOW;
	//NRF24L01_Write_Bytes(NRF_WRITE_REG + TX_ADDR, NRF24L01_TX_Addr, NRF24L01_TX_ADDT_WIDTH);
	NRF24L01_Write_Bytes(NRF_WRITE_REG + RX_ADDR_P0, NRF24L01_RX_Addr, NRF24L01_RX_ADDT_WIDTH);		//设置TX节点地址后，设置RX地址，同时使能ACK应答

	NRF24L01_Write_Byte(NRF_WRITE_REG + EN_AA, 0x01);		//使能通道0的ACK应答
	NRF24L01_Write_Byte(NRF_WRITE_REG + EN_RXADDR, 0x01);	//使能通道0的接收地址
	NRF24L01_Write_Byte(NRF_WRITE_REG + RF_CH, 40);			//设置RF通道为2.440GHZ
	NRF24L01_Write_Byte(NRF_WRITE_REG + RX_PW_P0, RX_PLOAD_WIDTH);			//设置通道0的有效数据宽度
	NRF24L01_Write_Byte(NRF_WRITE_REG + RF_SETUP, 0x0f);	//设置TX发射参数，0db增益，2Mbps，低噪声增益开启
	NRF24L01_Write_Byte(NRF_WRITE_REG + CONFIG, 0x0f);		//配置基本工作模式参数：PWR_UP,EN_CRC,16BIT_CRC,接收模式，开启所有中断

	NRF24L01_CE_HIGH;	//CE为高，10us为自动接收
}
