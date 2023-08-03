#ifndef _REMOTE_CTL_TASK
#define _REMOTE_CTL_TASK
#include <Basic_Task/base_task.h>
#include "usart.h"


/*				RC Channel Definition			*/
#define RC_CH_VALUE_MIN		((uint16_t) 364)
#define RC_CH_VALUE_OFFSET	((uint16_t) 1024)
#define RC_CH_VALUE_MAX		((uint16_t) 1684)

/*				RC Switch Definition			*/
#define	RC_SW_UP			((uint16_t) 1)
#define RC_SW_MID			((uint16_t) 2)
#define RC_SW_DOWN			((uint16_t) 3)

#define switch_s1_is_down(s)	(s == RC_SW_DOWN)
#define switch_s1_is_up(s)		(s == RC_SW_UP)
#define switch_s1_is_mid(s)		(s == RC_SW_MID)

#define switch_s2_is_down(s)	(s == RC_SW_DOWN)
#define switch_s2_is_up(s)		(s == RC_SW_UP)
#define switch_s2_is_mid(s)		(s == RC_SW_MID)

//通道分配
//由于通道在不同模式下功能不同，暂时未使用以下定义
//后期待修改
#define CHASSIS_FORWARD_CHANNEL			1
#define CHASSIS_LEFT_OR_RIGHT_CHANNEL	0
#define CHASSIS_REVOLVE_CHANNEL			2
#define CHANNEL_3						3
#define SWITCH_S1						4
#define SWITCH_S2						5



#define DR16_Rx_DATA_FRAME_LEN	18
#define DR16_RX_BUFFER_SIZE		50


#define RC_DEADLINE		10	//遥控器死区控制
#define RC_MAX_VALUE	660	//遥控器最大值


uint8_t rcbuffer[18];


//遥控器属性结构体
typedef struct {
	struct {
		int16_t ch0;
		int16_t ch1;
		int16_t ch2;
		int16_t ch3;
		uint8_t s1;
		uint8_t s2;
	} rc;
} RC_Ctl_t;

RC_Ctl_t RC_CtrlData;


void Usart1_Recieve_IRQ_Handle( UART_HandleTypeDef *huart );
void RemoteDataProcess (RC_Ctl_t *RC_CtrlData, uint8_t *pData );
void dr16_uart_dma_init(UART_HandleTypeDef *huart);


#endif
