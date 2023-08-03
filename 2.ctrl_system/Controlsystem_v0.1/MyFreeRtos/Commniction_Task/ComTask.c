/****************************************************************
 * @file	ComTask.c
 * @brief	用于MCU的通信任务
 * @Func	MCU与PC的串口通信
 * 			MCU与遥控器的串口通信
 * 			MCU内部与电机模块的CAN通信
 * @Author	YM
 * @Data 2021/5/8
 *
 ****************************************************************/

#include <Commnication_Task/ComTask.h>


/*******************************功能使能位******************************************/

#define		EN_NRF24L01			0		//NRF24L01功能开关；1开启，0关闭
#define		EN_NRF_TX_RX_Mode	0		//双向收发模式
#define		En_NRF_TX_Mode		0		//NRF24L01发送模式开关【仅发送模式】
#define		En_Com_Printf_Info	0		//打印信息使能

/*****************************外部变量声明******************************************/
extern CAN_HandleTypeDef 	hcan1;
extern UART_HandleTypeDef 	huart2;
extern SPI_HandleTypeDef 	hspi4;
extern UART_HandleTypeDef 	huart3;
extern chassis_move_t 		Com_move;			//定义底盘运动反馈数据
extern my_Ctrl_RX_Data_t	myrxctrldata_t;    //定义PC发送指令

extern UltrasonicDate_t 	UltraStruData;		//超声波反馈数据

uint8_t pcComSendDataTest[32];

uint8_t mcuRXDataBuffer[32];		//定义接收数组

char 	Com_Info_buf[300];		//打印输出缓存



/**
  * @func 	通讯任务
  * @param
  * @note	MCU与PC的通讯初实现
  * 		MCU与遥控的通讯实现
  * 		MCU与内部电机模块的CAN通讯初始化
  * @retval None
  */

void comTask(void const * argument)
{
	vPortEnterCritical();		//进入临界保护

	dr16_uart_dma_init(&huart1);	//配置串口1的DMA，进行数据搬运
	can_filter_init_recv_all();		//开启CAN滤波器，用于开启CAN
	Usart3Tx_DmaInit();		//串口3发送初始化
	PC_usart3_dma_init(&huart3);		//串口3接收初始化
	MyUart8_DMArx_Init(&huart8);

#if EN_NRF24L01		//NRF模块初始化
	uint8_t nrfInitFlag; //NrfCounter = 1;
	nrfInitFlag = NRF24L01_Init();
	if (nrfInitFlag == HAL_OK) {
		 HAL_GPIO_WritePin(GPIOG,NRF_LED_Pin, GPIO_PIN_RESET);
	}
#endif

	vPortExitCritical();		//退出临界保护

	for(;;)
	{

		MyUart8_DMArx_Process(&huart8);

#if EN_UART3_RX_MODE

#endif
#if En_NRF_TX_Mode
		if (nrfInitFlag == HAL_OK) {	//NRF通过自检
			//发送数据打包测试
			Run_DataSend_Handle(NRF_TX_MODE,RUN_TXDATAFRAME_1,pcComSendDataTest,&Com_move, &UltraStruData);
			//测试发送模式
			//HAL_UART_Transmit(&huart2, pcComSendDataTest, 32, 100);
			vPortEnterCritical();		//进入临界保护
			NRFComModeChoose(NRF_TX_MODE, pcComSendDataTest, 32);
			vPortExitCritical();		//退出临界保护
		}
#endif

#if EN_NRF_TX_RX_Mode
		if (nrfInitFlag == HAL_OK) {	//NRF通过自检
			//发送数据打包测试
			Run_DataSend_Handle(NRF_TX_MODE,PID_TXDATAFRAME,pcComSendDataTest,&Com_move,NULL,NULL);
			HAL_UART_Transmit(&huart2, pcComSendDataTest, 16, 100);

			/**********下面代码为测试成功代码************/
			if (NrfCounter % 2 == 0) {		//接收数据
				//测试接收模式
				NRFComModeChoose(NRF_RX_MODE, mcuRXDataBuffer, 32);		//测试接收模式
				NrfCounter = 1;
			}else {		//发送3个数据
				//测试无线循环收发模式
				NRFComModeChoose(NRF_TX_MODE, pcComSendDataTest, 32);		//测试发送模式
				NrfCounter ++;
			}
		}
#endif
#if En_Com_Printf_Info
		//测试IMU输出
		sprintf(Com_Info_buf, " Yaw: %d    Pitch: %d    roll: %d	Temp:%d\n",
				mpu_FeedbackData.yaw, mpu_FeedbackData.pitch, mpu_FeedbackData.roll, mpu_FeedbackData.temp);
		HAL_UART_Transmit(&huart2, (uint8_t *)Com_Info_buf, (COUNTOF(Com_Info_buf)-1), 55);
		//测试超声波输出
		sprintf(Com_Info_buf, " WS1: %d    WS2: %d    WS3: %d	WS4:%d\n",UltraStruData.DataUltrStation1,
				UltraStruData.DataUltrStation2, UltraStruData.DataUltrStation3, UltraStruData.DataUltrStation4);
		HAL_UART_Transmit(&huart2, (uint8_t *)Com_Info_buf, (COUNTOF(Com_Info_buf)-1), 55);
#endif
		 osDelay(30);
	}
}


/**
  * @func 	串口3，MCU与PC的通讯实现
  * @param	ComFlag:	通讯标志位
  * 		ComData:	数据缓存
  * 		Len	:		通讯数据长度
  * @note
  * @retval None
  */

void USART3ComModeChoose(uint8_t ComFlag, uint8_t *ComData, uint16_t Len)
{
	if (ComFlag == USART3_TX_MODE) {		//发送模式

	}
	else if (ComFlag == USART3_RX_MODE) {	//接收模式

	}
}

/**
  * @func 	NRF24L01通讯模式选择函数
  * @param	NRFComFlag:	通讯标志位
  * 					NRF_TX_MODE :MCU发送数据		NRF_RX_MODE:MCU接收数据
  * @note	ComData：	通讯数据
  * 		Len:		数据长度
  * @retval 接收数据最长延时500ms，超时不接收到数据，这放弃本次数据接收
  */
void NRFComModeChoose(uint8_t NRFComFlag, uint8_t *NRFComData, uint16_t NRFLen)
{
	uint8_t ComReturnFlag;
	if (NRFComFlag == NRF_TX_MODE) {	//发送模式选择
		NRF24L01_TX_Mode();					//发送模式初始化
		HAL_Delay(5);						//延时处理
		ComReturnFlag = NRF24L01_Tx_Packet(NRFComData);
	}
	else if (NRFComFlag == NRF_RX_MODE) {	//接收模式
		NRF24L01_RX_Mode();		//接收模式初始化
		HAL_Delay(5);			//延时处理
		ComReturnFlag = NRF24L01_Rx_Packet(NRFComData);
		//清除配置寄存器
		NRF24L01_Read_Bytes(RD_RX_PLOAD, NRFComData, RX_PLOAD_WIDTH);		//清除RX FIFO寄存器
		NRF24L01_Write_Byte(FLUSH_RX, 0xff);								//清除TX FIFO寄存器
	}
}


/**
  * @func 	电机数据打包处理
  * @param	TxModeChoose:	数据发送模式
  * 		frameMode	:	数据帧模式
  * 		dataFrame	:	打包数据帧指针
  * 		motorData	:	电机属性指针
  * 		mpuFeedback	:	IMU数据指针
  * 		ultrFeedback:	超声波数据指针
  * @note
  * @retval None
  */
void Run_DataSend_Handle(uint8_t TxModeChoose, uint8_t frameMode, uint8_t *dataFrame, chassis_move_t *motorData, UltrasonicDate_t *ultrFeedback)
{
	if (TxModeChoose == NRF_TX_MODE) {	//NRF通讯模式
		//PID数据显示帧
		if (frameMode == PID_TXDATAFRAME) {
			dataFrame[0] = 32;		//数据长度
			dataFrame[1] = 0x0F;	//起始位
			dataFrame[2] = 0x00;	//2,3字节表示0001表示PID功能
			dataFrame[3] = 0x01;
			//电机速度打包,4 - 15 字节
			Motor_data_packHandle(dataFrame, motorData);
		}
		//运行显示数据帧1,包括电机速度、IMU位姿、IMU温度值
		else if (TxModeChoose == RUN_TXDATAFRAME_1) {
			dataFrame[0] = 32;		//数据长度
			dataFrame[1] = 0x0F;	//起始位
			dataFrame[2] = 0x00;	//2,3字节表示0010，表示运行模式数据帧1
			dataFrame[3] = 0x01;
			//电机速度打包,4 - 15 字节
			Motor_data_packHandle(dataFrame, motorData);
			//超声波数据打包
			dataFrame[24] = ( ultrFeedback->DataUltrStation1 >> 8) & 0xff;		//station_1数据
			dataFrame[25] =	  ultrFeedback->DataUltrStation1 & 0xff;
			dataFrame[26] = ( ultrFeedback->DataUltrStation2>> 8) & 0xff;		//station_2数据
			dataFrame[27] =	  ultrFeedback->DataUltrStation2 & 0xff;
			dataFrame[28] = ( ultrFeedback->DataUltrStation3 >> 8) & 0xff;		//station_3数据
			dataFrame[29] =	  ultrFeedback->DataUltrStation3 & 0xff;
			dataFrame[30] = ( ultrFeedback->DataUltrStation4 >> 8) & 0xff;		//station_4数据
			dataFrame[31] =	  ultrFeedback->DataUltrStation4 & 0xff;
		}
	}
	else if (TxModeChoose == USART3_TX_MODE) {		//串口通讯模式

	}
}


/**
  * @func 	电机数据打包处理
  * @param	TxModeChoose:	数据发送模式
  * 		frameMode	:	数据帧模式
  * 		dataFrame	:	打包数据帧指针
  * 		motorData	:	电机属性指针
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
