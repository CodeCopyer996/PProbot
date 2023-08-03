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


//����CAN֡���ͽṹ�����
struct can_std_msg {
	uint32_t 	std_id;
	uint8_t 	dlc;
	uint8_t 	data[Data_Frame_Len];
};
typedef int32_t (*can_stdmsg_rx_callback_t)(CAN_RxHeaderTypeDef *header, uint8_t *data);

//����CAN����ṹ�����
typedef struct {
	CAN_HandleTypeDef *hcan;
	fifo_t tx_fifo;
	uint8_t *tx_fifo_buffer;
	uint8_t is_sending;
	can_stdmsg_rx_callback_t can_rec_callback;
}can_mange_obj;


//CAN���ͻ��߽��յ�IDö�ٶ���
typedef enum {
	//CAN 3508 Moter ID
	CAN_3508_M1_ID = 0x201,
	CAN_3508_M2_ID = 0x202,
	CAN_3508_M3_ID = 0x203,
	CAN_3508_M4_ID = 0x204,

	CAN_3508_M5_ID = 0x205,    //��ʱδ�õ�
	CAN_3508_M6_ID = 0x206,
	CAN_3508_M7_ID = 0x207,

} can_msg_id_e;

//CAN���շ�����Ϣ�����ṹ��
typedef struct {

	uint16_t	angle;			//���ת��ת���Ƕ�:[0,8191]
	int16_t		speed_rpm;		//���ת�٣�������ת
	int16_t		given_current;	//�����ǰ����ֵ
	int16_t		last_angle;		//�ϴλ�ȡ���ת�ӽǶ�ֵ������Ƕ���һ���൱ֵ��ֻ��������ԽǶȲ�������
	uint8_t 	temperrate;		//�����ǰ�¶�ֵ

	uint8_t  	buff_idx;		//����ID����
}moto_measure_t;


moto_measure_t	motor_chassis[4];	//�����ĸ�������������ṹ��������

void can_filter_init_recv_all (void);
void CAN_RX_Feedback_Data_Handle(void);
void can1_send_set_moto_current(int16_t iq1, int16_t iq2, int16_t iq3, int16_t iq4);
void __test_fun_(void);

const moto_measure_t *get_chassis_motor_measure_point(uint8_t i);
const moto_measure_t *get_yaw_gimbal_motor_measure_point(void);

#endif
