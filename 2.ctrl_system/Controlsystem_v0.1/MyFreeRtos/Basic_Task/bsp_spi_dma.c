/**
  ******************************************************************************
  * @file   bsp_spi_dma.c
  * @brief  主要用于imu通讯的SPI_DMA初始化
  ******************************************************************************
  * @attention
  *
  ******************************************************************************
  */


//#include "bsp_spi_dma.h"

/*
extern SPI_HandleTypeDef hspi5;


//标志位声明

//bit_0：表示进入数据传输的data ready 的下降沿外部中断后置1
//bit_1：已经成功开启SPI的DMA传输
//bit_2：已经完成SPI的DMA数据传输任务
//bit[3:7]:保留
volatile uint8_t gyro_accel_temp_updata_flag = 0;	//MPU6500陀螺仪、加速度计、温度更新标识
//磁力计标识符同上
volatile uint8_t mag_updata_flag = 0;				//磁力计数据更新标识
volatile uint8_t imu_start_dma_flag = 0;			//imu开始使用DMA传输标识

//DMA_RX-->Stream_3(Channel_2)		DMA_TX-->Stream_4(Channel_2)
*/

/**
  * @func	SPI_DMA初始化
  * @param	tx_buffer:	发送数据缓冲区
  * 		rx_buffer：	接收数据缓冲区
  * 		num：		数据传输长度
  * @note
  * @retval
  */
/*

void spi_dma_init(uint32_t tx_buffer, uint32_t rx_buffer, uint16_t num)
{
	//CR寄存器用于控制DMA的数据流配置，DMA_SxCR寄存器
	SET_BIT(hspi5.Instance->CR2, SPI_CR2_TXDMAEN);		//发送DMA使能
	SET_BIT(hspi5.Instance->CR2, SPI_CR2_RXDMAEN);		//接收DMA使能

	__HAL_SPI_ENABLE(&hspi5);			//使能SPI5

*******************************DMA接收配置*******************************************************
	//失效DMA接收数据流；只有禁用(失能)DMA数据流寄存器后，才可以对下列寄存器进行配置
	__HAL_DMA_DISABLE(&hdma_spi5_rx);
	while(hdma_spi5_rx.Instance->CR & DMA_SxCR_EN){	//检查DMA_SxCR_EN使能DMA数据流是否【失能】成功
		__HAL_DMA_DISABLE(&hdma_spi5_rx);
	}


	//在【使能】DMA数据流寄存器前，必须对DMA_LISR和DMA_HISR寄存器中的响应标志位清零
	__HAL_DMA_CLEAR_FLAG(&hdma_spi5_rx, DMA_LISR_TCIF3);		//发送寄存器为数据流3，写1清零


	//PAR寄存器为数据流外设地址寄存器，用于设置外设数据寄存器的基址，该寄存器为32位寄存器
	//该寄存器的位受到写保护，只有在DMA_SxCR寄存器的EN位为0时，才可以写入
	//配置的外设数据寄存器基址为SPI5的数据寄存器
	hdma_spi5_rx.Instance->PAR = (uint32_t) & (SPI5->DR);

	//内存接收缓冲区定义
	//该寄存器受到写保护，只有在DMA_SxCR寄存器的EN位为0时，
	//(或者DMA_SxCR寄存器的EN位为1时)并且DMA_SxCR寄存器的CT位(双缓冲区模式下)，才可以写入
	//定义DMA存储器0地址的【基址】为rx_buffer
	hdma_spi5_rx.Instance->M0AR = (uint32_t)(rx_buffer);

	//定义数据接收长度
	__HAL_DMA_SET_COUNTER(&hdma_spi5_rx, num);

	//DMA中断使能
	__HAL_DMA_ENABLE_IT(&hdma_spi5_rx, DMA_IT_TC);

	*******************************DMA发送配置*******************************************************
	__HAL_DMA_DISABLE(&hdma_spi5_tx);
	while(hdma_spi5_tx.Instance->CR & DMA_SxCR_EN){
		__HAL_DMA_DISABLE(&hdma_spi5_tx);
	}

	__HAL_DMA_CLEAR_FLAG(&hdma_spi5_tx, DMA_LISR_TCIF3);
	hdma_spi5_tx.Instance->PAR = (uint32_t) & (SPI5->DR);
	hdma_spi5_tx.Instance->M0AR = (uint32_t)(tx_buffer);
	__HAL_DMA_SET_COUNTER(&hdma_spi5_tx, num);

	//DMA发送不用中断使能
}
*/


/**
  * @func	SPI_DMA使能
  * @param	tx_buffer:	发送数据缓冲区
  * 		rx_buffer：	接收数据缓冲区
  * @note
  * @retval
  */
/*

void spi_dma_enable(uint32_t tx_buffer, uint32_t rx_buffer, uint16_t num)
{
	//使能DMA接收与发送
	__HAL_DMA_DISABLE(&hdma_spi5_rx);
	__HAL_DMA_DISABLE(&hdma_spi5_tx);

	while(hdma_spi5_rx.Instance->CR & DMA_SxCR_EN){
		__HAL_DMA_DISABLE(&hdma_spi5_rx);
	}
	while(hdma_spi5_tx.Instance->CR & DMA_SxCR_EN){
		__HAL_DMA_DISABLE(&hdma_spi5_tx);
	}

	//清除标志位
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_TC_FLAG_INDEX(hspi5.hdmarx));		//数据流x传输完成中断标志清零
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_HT_FLAG_INDEX(hspi5.hdmarx));		//数据流x半传输中断标志清零
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_TE_FLAG_INDEX(hspi5.hdmarx));		//数据流x传输错误中断标志清零
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_DME_FLAG_INDEX(hspi5.hdmarx));	//数据流x直接模式错误中断标志清零
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_FE_FLAG_INDEX(hspi5.hdmarx));		//数据流xFIFO错误中断标志清零

    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_TC_FLAG_INDEX(hspi5.hdmatx));
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_HT_FLAG_INDEX(hspi5.hdmatx));
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_TE_FLAG_INDEX(hspi5.hdmatx));
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_DME_FLAG_INDEX(hspi5.hdmatx));
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_FE_FLAG_INDEX(hspi5.hdmatx));

    //设置数据地址
    hdma_spi5_rx.Instance->M0AR = (uint32_t)(rx_buffer);
    hdma_spi5_tx.Instance->M0AR = (uint32_t)(tx_buffer);

    //设置数据长度
    __HAL_DMA_SET_COUNTER(&hdma_spi5_rx, num);
    __HAL_DMA_SET_COUNTER(&hdma_spi5_tx, num);

    //使能DMA
    __HAL_DMA_ENABLE(&hdma_spi5_rx);
    __HAL_DMA_ENABLE(&hdma_spi5_tx);
}

*/

/**
  * @func	DMA接收中断服务函数
  * @param
  * @note
  * @retval
  */
/*

void DMA2_Stream3_IRQHandler(void)
{
	//接收完成中断标志位判断，该标志位由硬件产生
	if(__HAL_DMA_GET_FLAG(hspi5.hdmarx, __HAL_DMA_GET_TC_FLAG_INDEX(hspi5.hdmarx)) != RESET){
		 __HAL_DMA_CLEAR_FLAG(hspi5.hdmarx, __HAL_DMA_GET_TC_FLAG_INDEX(hspi5.hdmarx));	//清除中断标志位
	}
	//陀螺仪、加速度计、温度值读取完毕
	if(gyro_accel_temp_updata_flag & (1 << IMU_SPI_SHIFT)){



	}
	//磁力计数据读取完毕
}


*/

