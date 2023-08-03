/**
  ******************************************************************************
  * @file   bsp_spi_dma.c
  * @brief  ��Ҫ����imuͨѶ��SPI_DMA��ʼ��
  ******************************************************************************
  * @attention
  *
  ******************************************************************************
  */


//#include "bsp_spi_dma.h"

/*
extern SPI_HandleTypeDef hspi5;


//��־λ����

//bit_0����ʾ�������ݴ����data ready ���½����ⲿ�жϺ���1
//bit_1���Ѿ��ɹ�����SPI��DMA����
//bit_2���Ѿ����SPI��DMA���ݴ�������
//bit[3:7]:����
volatile uint8_t gyro_accel_temp_updata_flag = 0;	//MPU6500�����ǡ����ٶȼơ��¶ȸ��±�ʶ
//�����Ʊ�ʶ��ͬ��
volatile uint8_t mag_updata_flag = 0;				//���������ݸ��±�ʶ
volatile uint8_t imu_start_dma_flag = 0;			//imu��ʼʹ��DMA�����ʶ

//DMA_RX-->Stream_3(Channel_2)		DMA_TX-->Stream_4(Channel_2)
*/

/**
  * @func	SPI_DMA��ʼ��
  * @param	tx_buffer:	�������ݻ�����
  * 		rx_buffer��	�������ݻ�����
  * 		num��		���ݴ��䳤��
  * @note
  * @retval
  */
/*

void spi_dma_init(uint32_t tx_buffer, uint32_t rx_buffer, uint16_t num)
{
	//CR�Ĵ������ڿ���DMA�����������ã�DMA_SxCR�Ĵ���
	SET_BIT(hspi5.Instance->CR2, SPI_CR2_TXDMAEN);		//����DMAʹ��
	SET_BIT(hspi5.Instance->CR2, SPI_CR2_RXDMAEN);		//����DMAʹ��

	__HAL_SPI_ENABLE(&hspi5);			//ʹ��SPI5

*******************************DMA��������*******************************************************
	//ʧЧDMA������������ֻ�н���(ʧ��)DMA�������Ĵ����󣬲ſ��Զ����мĴ�����������
	__HAL_DMA_DISABLE(&hdma_spi5_rx);
	while(hdma_spi5_rx.Instance->CR & DMA_SxCR_EN){	//���DMA_SxCR_ENʹ��DMA�������Ƿ�ʧ�ܡ��ɹ�
		__HAL_DMA_DISABLE(&hdma_spi5_rx);
	}


	//�ڡ�ʹ�ܡ�DMA�������Ĵ���ǰ�������DMA_LISR��DMA_HISR�Ĵ����е���Ӧ��־λ����
	__HAL_DMA_CLEAR_FLAG(&hdma_spi5_rx, DMA_LISR_TCIF3);		//���ͼĴ���Ϊ������3��д1����


	//PAR�Ĵ���Ϊ�����������ַ�Ĵ��������������������ݼĴ����Ļ�ַ���üĴ���Ϊ32λ�Ĵ���
	//�üĴ�����λ�ܵ�д������ֻ����DMA_SxCR�Ĵ�����ENλΪ0ʱ���ſ���д��
	//���õ��������ݼĴ�����ַΪSPI5�����ݼĴ���
	hdma_spi5_rx.Instance->PAR = (uint32_t) & (SPI5->DR);

	//�ڴ���ջ���������
	//�üĴ����ܵ�д������ֻ����DMA_SxCR�Ĵ�����ENλΪ0ʱ��
	//(����DMA_SxCR�Ĵ�����ENλΪ1ʱ)����DMA_SxCR�Ĵ�����CTλ(˫������ģʽ��)���ſ���д��
	//����DMA�洢��0��ַ�ġ���ַ��Ϊrx_buffer
	hdma_spi5_rx.Instance->M0AR = (uint32_t)(rx_buffer);

	//�������ݽ��ճ���
	__HAL_DMA_SET_COUNTER(&hdma_spi5_rx, num);

	//DMA�ж�ʹ��
	__HAL_DMA_ENABLE_IT(&hdma_spi5_rx, DMA_IT_TC);

	*******************************DMA��������*******************************************************
	__HAL_DMA_DISABLE(&hdma_spi5_tx);
	while(hdma_spi5_tx.Instance->CR & DMA_SxCR_EN){
		__HAL_DMA_DISABLE(&hdma_spi5_tx);
	}

	__HAL_DMA_CLEAR_FLAG(&hdma_spi5_tx, DMA_LISR_TCIF3);
	hdma_spi5_tx.Instance->PAR = (uint32_t) & (SPI5->DR);
	hdma_spi5_tx.Instance->M0AR = (uint32_t)(tx_buffer);
	__HAL_DMA_SET_COUNTER(&hdma_spi5_tx, num);

	//DMA���Ͳ����ж�ʹ��
}
*/


/**
  * @func	SPI_DMAʹ��
  * @param	tx_buffer:	�������ݻ�����
  * 		rx_buffer��	�������ݻ�����
  * @note
  * @retval
  */
/*

void spi_dma_enable(uint32_t tx_buffer, uint32_t rx_buffer, uint16_t num)
{
	//ʹ��DMA�����뷢��
	__HAL_DMA_DISABLE(&hdma_spi5_rx);
	__HAL_DMA_DISABLE(&hdma_spi5_tx);

	while(hdma_spi5_rx.Instance->CR & DMA_SxCR_EN){
		__HAL_DMA_DISABLE(&hdma_spi5_rx);
	}
	while(hdma_spi5_tx.Instance->CR & DMA_SxCR_EN){
		__HAL_DMA_DISABLE(&hdma_spi5_tx);
	}

	//�����־λ
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_TC_FLAG_INDEX(hspi5.hdmarx));		//������x��������жϱ�־����
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_HT_FLAG_INDEX(hspi5.hdmarx));		//������x�봫���жϱ�־����
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_TE_FLAG_INDEX(hspi5.hdmarx));		//������x��������жϱ�־����
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_DME_FLAG_INDEX(hspi5.hdmarx));	//������xֱ��ģʽ�����жϱ�־����
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmarx, __HAL_DMA_GET_FE_FLAG_INDEX(hspi5.hdmarx));		//������xFIFO�����жϱ�־����

    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_TC_FLAG_INDEX(hspi5.hdmatx));
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_HT_FLAG_INDEX(hspi5.hdmatx));
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_TE_FLAG_INDEX(hspi5.hdmatx));
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_DME_FLAG_INDEX(hspi5.hdmatx));
    __HAL_DMA_CLEAR_FLAG (hspi5.hdmatx, __HAL_DMA_GET_FE_FLAG_INDEX(hspi5.hdmatx));

    //�������ݵ�ַ
    hdma_spi5_rx.Instance->M0AR = (uint32_t)(rx_buffer);
    hdma_spi5_tx.Instance->M0AR = (uint32_t)(tx_buffer);

    //�������ݳ���
    __HAL_DMA_SET_COUNTER(&hdma_spi5_rx, num);
    __HAL_DMA_SET_COUNTER(&hdma_spi5_tx, num);

    //ʹ��DMA
    __HAL_DMA_ENABLE(&hdma_spi5_rx);
    __HAL_DMA_ENABLE(&hdma_spi5_tx);
}

*/

/**
  * @func	DMA�����жϷ�����
  * @param
  * @note
  * @retval
  */
/*

void DMA2_Stream3_IRQHandler(void)
{
	//��������жϱ�־λ�жϣ��ñ�־λ��Ӳ������
	if(__HAL_DMA_GET_FLAG(hspi5.hdmarx, __HAL_DMA_GET_TC_FLAG_INDEX(hspi5.hdmarx)) != RESET){
		 __HAL_DMA_CLEAR_FLAG(hspi5.hdmarx, __HAL_DMA_GET_TC_FLAG_INDEX(hspi5.hdmarx));	//����жϱ�־λ
	}
	//�����ǡ����ٶȼơ��¶�ֵ��ȡ���
	if(gyro_accel_temp_updata_flag & (1 << IMU_SPI_SHIFT)){



	}
	//���������ݶ�ȡ���
}


*/

