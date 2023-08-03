#ifndef _CAN_TASK_H_
#define _CAN_TASK_H_

#include <Basic_Task/base_task.h>
#include "can.h"


#define MUTEX_DECLARE(mutex) unsigned long mutex
#define FILTER_BUF_LEN 5
#define Data_Frame_Len 8




typedef struct {
	char *p_start_addr; //!< FIFO Memory Pool Start Address
    char *p_end_addr;   //!< FIFO Memory Pool End Address
    int free_num;       //!< The remain capacity of FIFO
    int used_num;       //!< The number of elements in FIFO
    int unit_size;      //!< FIFO Element Size(Unit: Byte)
    char *p_read_addr;  //!< FIFO Data Read Index Pointer
    char *p_write_addr; //!< FIFO Data Write Index Pointer
    MUTEX_DECLARE(mutex);
} fifo_t;


//创建CAN帧类型结构体参数
struct can_std_msg {
	uint32_t 	std_id;
	uint8_t 	dlc;
	uint8_t 	data[Data_Frame_Len];
};
typedef int32_t (*can_stdmsg_rx_callback_t)(CAN_RxHeaderTypeDef *header, uint8_t *data);

//构建CAN管理结构体参数
typedef struct {
	CAN_HandleTypeDef *hcan;
	fifo_t tx_fifo;
	uint8_t *tx_fifo_buffer;
	uint8_t is_sending;
	can_stdmsg_rx_callback_t can_rec_callback;
}can_mange_obj;


//CAN发送或者接收的ID枚举定义
typedef enum {
	//CAN 3508 Moter ID
	CAN_3508_M1_ID = 0x201,
	CAN_3508_M2_ID = 0x202,
	CAN_3508_M3_ID = 0x203,
	CAN_3508_M4_ID = 0x204,

	CAN_3508_M5_ID = 0x205,    //暂时未用到
	CAN_3508_M6_ID = 0x206,
	CAN_3508_M7_ID = 0x207,

} can_msg_id_e;

//CAN接收反馈信息参数结构体
typedef struct {

	uint16_t	angle;			//电机转子转过角度:[0,8191]
	int16_t		speed_rpm;		//电机转速，有正反转
	int16_t		given_current;	//电机当前电流值
	int16_t		last_angle;		//上次获取电机转子角度值，电机角度是一个相当值，只有两个相对角度才有意义
	uint8_t 	temperrate;		//电机当前温度值

	uint8_t  	buff_idx;		//保存ID数组
}moto_measure_t;


moto_measure_t	motor_chassis[4];	//定义四个电机测量参数结构体类型组

void can_filter_init_recv_all (void);
void CAN_RX_Feedback_Data_Handle(void);
void can1_send_set_moto_current(int16_t iq1, int16_t iq2, int16_t iq3, int16_t iq4);
void __test_fun_(void);

const moto_measure_t *get_chassis_motor_measure_point(uint8_t i);
const moto_measure_t *get_yaw_gimbal_motor_measure_point(void);

#endif
