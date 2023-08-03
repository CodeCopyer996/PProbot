#ifndef _BASE_TASK_H
#define _BASE_TASK_H

#include "stdio.h"
#include "usart.h"
#include "gpio.h"
#include "stm32f4xx.h"
#include "stm32f4xx_hal.h"
#include "adc.h"
#include "tim.h"
//功能使能位
#define 	EN_USART1_RX			0
#define		EN_LED					1
#define 	EN_KEY					1
#define 	PRINTF_ERROR_INFO		1
#define 	EN_POWER				1
#define 	EN_DELAY_US				1
#define 	EN_ADC1_IN8				1
#define		EN_BEEP					1
//#define	EN_DEFINE_DELAY			1

//串口打印输出长度统计
#define COUNTOF(__BUFFER__)   (sizeof(__BUFFER__) / sizeof(*(__BUFFER__)))

#define USART_REC_LEN		200
#define RXBUFFER_SIZE		50


typedef float fp32;

extern uint16_t USART_RX_BUF[USART_REC_LEN];
extern uint16_t	USART_RX_STA;
extern uint16_t Times;
extern UART_HandleTypeDef huart6;
extern UART_HandleTypeDef huart2;


#define KEY0	HAL_GPIO_ReadPin( USER_KEY_GPIO_Port, USER_KEY_Pin )
#define KEY0_Press	1


//蜂鸣器定义
#define MAX_BUZZER_PWM      22499
#define MIN_BUZZER_PWM      10000




//功能函数声明
void Usart2_Send_Data(uint8_t data);
void Usart1_RX_Data(void);
void Led0_Delay(uint16_t __timer);
void Led1_Delay(uint16_t __timer);
uint8_t Key_Scan (void);
void ctrl_power_enable(uint8_t flag);
void switch_ctrl_power(void);
void myDelay_us(uint32_t us);

//ADC函数声明
void ADC1_IN8_ReferenceVoltage();
uint16_t ADC1_IN8_GetCurrentVoltage();
uint16_t adcx_get_chx_value(ADC_HandleTypeDef *ADCx, uint32_t ch);
void Buzzer_Control(uint16_t time);



#endif
