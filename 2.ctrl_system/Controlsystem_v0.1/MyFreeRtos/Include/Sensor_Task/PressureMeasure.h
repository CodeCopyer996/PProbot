#ifndef __PRESSUREMEASURE_H__
#define __PRESSUREMEASURE_H__

#include <Basic_Task/base_task.h>
#include "gpio.h"

//GPIO操作定义
//DAT1
#define HX711_DAT1_STATUS	HAL_GPIO_ReadPin(PRE_DAT1_GPIO_Port, PRE_DAT1_Pin)
#define HX711_DAT1_HIGH		HAL_GPIO_WritePin(PRE_DAT1_GPIO_Port, PRE_DAT1_Pin, GPIO_PIN_SET)
#define HX711_DAT1_LOW		HAL_GPIO_WritePin(PRE_DAT1_GPIO_Port, PRE_DAT1_Pin, GPIO_PIN_RESET)


//CLK1
#define HX711_CLK1_LOW		HAL_GPIO_WritePin(PRE_CLK1_GPIO_Port, PRE_CLK1_Pin, GPIO_PIN_RESET)
#define HX711_CLK1_HIGH		HAL_GPIO_WritePin(PRE_CLK1_GPIO_Port, PRE_CLK1_Pin, GPIO_PIN_SET)

//函数声明
uint32_t HX711ReadData(void);

#endif




