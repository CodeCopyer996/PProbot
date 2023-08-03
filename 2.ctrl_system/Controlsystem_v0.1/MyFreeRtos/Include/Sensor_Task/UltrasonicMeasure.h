#ifndef __ULTRASONIC_MEASURE_H__
#define __ULTRASONIC_MEASURE_H__

#include <Basic_Task/base_task.h>
#include "usart.h"

#define STARTBIT 	0x7F

#define STATION1	0x01
#define STATION2	0x02
#define STATION3	0x03
#define STATION4	0x04

#define READBIT		0x12	//读取命令
#define DIRECTBIT	0x01	//MCU到模块
#define ENDBIT		0x03

typedef struct{
	uint8_t		RecriveFrameDataFalg;
	uint8_t		StationNum;				//获取站号
	uint8_t		StationNumCurrent;

	uint16_t 	DataUltrStation1;		//超声波传感器站1数据，单位：mm
	uint16_t 	DataUltrStation2;
	uint16_t 	DataUltrStation3;
	uint16_t 	DataUltrStation4;

	uint16_t	DataUltrCurrent;

}UltrasonicDate_t;



void ultrStationSendDataFun(uint8_t ultraStationNum);
void myUsart7RecieveIRQHandle( UART_HandleTypeDef *huart );
void ultrSationDaraReceiveHandle();

#endif
