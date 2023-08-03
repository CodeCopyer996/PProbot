/**
  ******************************************************************************
  * @file   PressureMeasurt.c
  * @brief  压力数据采集
  ******************************************************************************
  * @attention	采集压力数据
  * @Date		2021/6/17
  * @author		YM
  ******************************************************************************
  */
#include <Sensor_Task/PressureMeasure.h>

/**
  * @func 	压力传感器模块数据获取
  * @param
  * @note	在使用压力传感器模块的时候，需要注意的是对于高电平的脉冲时间有要求，使用时需要注意
  * @retval None
  */

uint32_t HX711ReadData(void)
{
	uint32_t	count;
	HX711_CLK1_LOW;				//CLK拉低，使能模块AD
	count = 0;
	while (HX711_DAT1_STATUS);	//等待AD转换结束
	for (uint8_t i = 0; i < 24; i ++) {
		HX711_CLK1_HIGH;		//CLK置高，发送脉冲
		myDelay_us(10);
		count = count << 1;		//下降沿来时变量Count左移一位，右侧补领
		HX711_CLK1_LOW;			//CLK置低
		if (HX711_DAT1_STATUS) {
			count++;
		}
	}
	HX711_CLK1_HIGH;
	myDelay_us(10);
	count = count ^ 0x800000;	//第25个脉冲下降沿来时，转换数据
	HX711_CLK1_LOW;
	myDelay_us(5);
	return(count);
}
