#include <Basic_Task/base_task.h>

/****************************************************************
 * @Func	串口1重定向printf收发数据
 * 			串口1定义接收数据
 * 			定义LED闪烁
 * 			定义Key按键功能
 * 			开启、关闭四个可控电流源开关
 * 			微秒延时定时
 *
 * @brief
 * @Author ym
 * @Data 2020/12
 *
 ****************************************************************/
extern TIM_HandleTypeDef htim14;
/**
  * @brief  重定向printf函数，用于打印数据
  * @param	__GNUC__为0，关闭此功能；__GNUC__为1，开启此功能
  * 		__GNUC__值与编译器有关
  * @retval None
  */


#ifdef __GNUC__
#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif
PUTCHAR_PROTOTYPE
{

    while ((USART2->SR & 0X40) == 0);
    USART2->DR = (uint8_t) ch;
    return ch;
}


/**
  * @brief  串口2发送函数
  * @param	data:待发送数据
  * @retval None
  */
void Usart2_Send_Data(uint8_t data)
{
	  while ((USART2->SR & 0X40) == 0);
	  USART2->DR = (uint8_t) data;
}

/**
  * @brief  串口1接收定义函数
  * @param	EN_USART1_RX为0，关闭此功能；EN_USART1_RX为1，开启此功能
  * @retval None
  */

#if EN_USART1_RX
	uint16_t  USART_RX_BUF[USART_REC_LEN];
	uint16_t USART_RX_STA=0;

	uint16_t Times=0;
	extern   UART_HandleTypeDef huart1;

	void USART1_IRQHandler(void)
	{
		uint8_t Res;
		if(__HAL_UART_GET_FLAG(&huart1,UART_FLAG_RXNE)!= RESET)
		{
			Res = USART1->DR;
			if((USART_RX_STA&0x8000)==0)
				{
					if(USART_RX_STA&0x4000)
					{
						if(Res!=0x0a)
							USART_RX_STA = 0;
						else
							USART_RX_STA |= 0x8000;
					}
					else
					{
						if(Res ==0x0d)
							USART_RX_STA |= 0x4000;
						else
						{
							USART_RX_BUF[USART_RX_STA++] = Res;
							if(USART_RX_STA > (USART_REC_LEN - 1))
								USART_RX_STA = 0;
						}
					}
				}
		}
	}

	void Usart1_RX_Data(void)
	{
		uint8_t	i;
		uint8_t Len_Size;

		if(USART_RX_STA&0x8000)
		{
			Len_Size = USART_RX_STA&0x3fff;
			printf("please input date:\r\n");
			for(i=0;i<Len_Size;i++)
			{
				USART1->DR = USART_RX_BUF[i];
				while(__HAL_UART_GET_FLAG(&huart1,UART_FLAG_TC) != SET);
			}
			USART_RX_STA =  0;
		}
		else
		{
			printf("please input date:\r\n");
			Times++;
			if(Times%2 == 0)
				Led1_Delay(200);
		}
	}

#endif

	/**
	  * @brief  LED定义函数
	  * @param	EN_LED为0，关闭此功能；EN_LED为1，开启此功能
	  * @retval None
	  */

#if EN_LED
	void Led0_Delay( uint16_t __timer )
	{
		HAL_GPIO_WritePin( LED0_GPIO_Port, LED0_Pin, GPIO_PIN_RESET );
		HAL_Delay( __timer );
		HAL_GPIO_WritePin(LED0_GPIO_Port, LED0_Pin, GPIO_PIN_SET);
		HAL_Delay( __timer );
	}


	void Led1_Delay( uint16_t __timer )
	{
		HAL_GPIO_WritePin( LED1_GPIO_Port, LED1_Pin, GPIO_PIN_RESET );
		HAL_Delay( __timer );
		HAL_GPIO_WritePin( LED1_GPIO_Port, LED1_Pin, GPIO_PIN_SET );
		HAL_Delay( __timer );
	}

#endif

	/**
	  * @brief  KEY定义函数
	  * @param	EN_KEY为0，关闭此功能；EN_KEY为1，开启此功能
	  * @retval None
	  */
#if EN_KEY
	uint8_t Key_Scan (void) {
		if ( KEY0 == 1 ) {
			HAL_Delay(10);
			if ( KEY0 == 0 )
				return KEY0_Press;
		}
		return 0;
	}

#endif

	/**
	  * @brief  开启可控输出源
	  * @param	EN_KEY为0，关闭此功能；EN_KEY为1，开启此功能
	  * 		flag = 1，开启所有电源
	  * 		flag = 0，关闭所有电源
	  * @retval None
	  */
#if EN_POWER
	void ctrl_power_enable(uint8_t flag)
	{
		if(flag){
			HAL_GPIO_WritePin( VCC_OUT1_GPIO_Port, VCC_OUT1_Pin, GPIO_PIN_SET );
			HAL_GPIO_WritePin( VCC_OUT2_GPIO_Port, VCC_OUT2_Pin, GPIO_PIN_SET );
			HAL_GPIO_WritePin( VCC_OUT3_GPIO_Port, VCC_OUT3_Pin, GPIO_PIN_SET );
			HAL_GPIO_WritePin( VCC_OUT4_GPIO_Port, VCC_OUT4_Pin, GPIO_PIN_SET );
			printf("VCC_OUT_Enable \n");

		}
		else {
			HAL_GPIO_WritePin( VCC_OUT1_GPIO_Port, VCC_OUT1_Pin, GPIO_PIN_RESET );
			HAL_GPIO_WritePin( VCC_OUT2_GPIO_Port, VCC_OUT2_Pin, GPIO_PIN_RESET );
			HAL_GPIO_WritePin( VCC_OUT3_GPIO_Port, VCC_OUT3_Pin, GPIO_PIN_RESET );
			HAL_GPIO_WritePin( VCC_OUT4_GPIO_Port, VCC_OUT4_Pin, GPIO_PIN_RESET );
			printf("VCC_OUT_Disable \n");
		}

	}
	/**
	  * @brief  控制可控单元的开关
	  * @param	temp_count_i表示按键按下次数，第一次开启，第二次关闭
	  * @retval None
	  */
	void switch_ctrl_power(void)
	{
		static uint8_t temp_count_i = 0;
		uint8_t key_flag = 0;
		key_flag = Key_Scan();
		if(key_flag){
			ctrl_power_enable(1);
			if(temp_count_i%2==0){
				ctrl_power_enable(0);
				temp_count_i = 0;
			}
			temp_count_i++;
		}
	}


#endif

/**
 * @brief	微秒延时自定义
 * @param	us：延时微秒数
 * @note	使用定时器14，通过查询方式，进行微秒定时，移植时注意修改定时器14初始化配置
 * @retval 	None
 * */
#if EN_DELAY_US
	void myDelay_us(uint32_t us)
	{
	uint16_t AutoCounter=0xffff-us-1;
	__HAL_TIM_SET_COUNTER(&htim14,AutoCounter);		//设定定时器计数器重装载值
	HAL_TIM_Base_Start(&htim14);					//启动定时器
	while (AutoCounter < 0xffff-1) {
		AutoCounter = __HAL_TIM_GET_COUNTER(&htim14);			//查询计数器的计数值
	}
	HAL_TIM_Base_Stop(&htim14);
	}
#endif



#if EN_ADC1_IN8
	extern ADC_HandleTypeDef hadc1;
	volatile float Adc1_in8_refVol = 0;


	/**
	  * @brief  获取基准电压
	  * @param
	  * @retval None
	  */
	void ADC1_IN8_ReferenceVoltage()
	{
		uint8_t 	i = 0;
		uint32_t	total_adc = 0;
		for (i = 0; i < 200; i++) {
			total_adc += adcx_get_chx_value(&hadc1, ADC_CHANNEL_8);
		}
		Adc1_in8_refVol = 200  * 3.0 / total_adc;
	}

	/**
	  * @brief  获取当前电压值
	  * @param
	  * @retval None
	  */
	uint16_t ADC1_IN8_GetCurrentVoltage()
	{
		uint8_t		i;
		uint32_t	adcx = 0;
		for (i = 0; i < 50; i++) {
			adcx += adcx_get_chx_value(&hadc1, ADC_CHANNEL_8);
		}
		adcx = adcx / 50;
		return adcx;
	}


	/**
	  * @brief  ADC采集电压
	  * @param
	  * @retval None
	  */
	uint16_t adcx_get_chx_value(ADC_HandleTypeDef *ADCx, uint32_t ch)
	{
	    static ADC_ChannelConfTypeDef sConfig = {0};
	    sConfig.Channel = ch;
	    sConfig.Rank = 1;
	    sConfig.SamplingTime = ADC_SAMPLETIME_3CYCLES;//ADC_SAMPLETIME_3CYCLES;

	    if (HAL_ADC_ConfigChannel(ADCx, &sConfig) != HAL_OK)
	    {
	        Error_Handler();
	    }

	    HAL_ADC_Start(ADCx);

	    HAL_ADC_PollForConversion(ADCx, 10);
	    return (uint16_t)HAL_ADC_GetValue(ADCx);
	}

#endif


#if EN_BEEP
	/**
	  * @brief  蜂鸣器发出声音
	  * @param
	  * @retval None
	  */
	uint16_t 	psc = 0;
	uint16_t 	pwm = MIN_BUZZER_PWM;
	uint16_t	counter = 0;
	extern TIM_HandleTypeDef htim12;
	void Buzzer_Control(uint16_t time)
	{
		while (1) {
			//psc++;
			pwm++;
			counter++;
			if (pwm > MAX_BUZZER_PWM) {
				pwm = MIN_BUZZER_PWM;
			}
	/*		if (psc > MAX_PSC) {
				 psc = 0;
			}*/
			__HAL_TIM_PRESCALER(&htim12, psc);
			__HAL_TIM_SetCompare(&htim12, TIM_CHANNEL_1, pwm);
			if (counter == time) {
				__HAL_TIM_SetCompare(&htim12, TIM_CHANNEL_1, 0);
				break;
			}
			HAL_Delay(1);
		}
	}





#endif








