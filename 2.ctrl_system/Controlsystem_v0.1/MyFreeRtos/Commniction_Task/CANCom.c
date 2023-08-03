/****************************************************************
 * @Func	CANɸѡ�����ó�ʼ��
 * 			CAN1�������ݶ���
 * 			CAN1���������жϻص�
 * 			CAN1�������ݴ������ڻ�ȡ�����ǰ����
 * @brief
 * @Author ym
 * @Data 2020/12/6
 *
 ****************************************************************/
#include <Commnication_Task/CANCom.h>
extern CAN_HandleTypeDef hcan1;
//extern CAN_HandleTypeDef hcan2;

/**
  * @brief  CAN��������Ԥ����ʹ��Ԥ����ķ�ʽ��ʵ�ֿռ任ʱ��
  * @param
  * @retval None
  */
#define get_motor_measure_handle(motor_chassis_ptr, data)							\
{																					\
	(motor_chassis_ptr)->last_angle 	= (motor_chassis_ptr)->angle;				\
	(motor_chassis_ptr)->angle			= (uint16_t)((data)[0] << 8 | (data)[1]); 	\
	(motor_chassis_ptr)->speed_rpm 		= (uint16_t)((data)[2] << 8 | (data)[3]);	\
	(motor_chassis_ptr)->given_current 	= (uint16_t)((data)[4] << 8 | (data)[5]);	\
	(motor_chassis_ptr)->temperrate 	= (data)[6];								\
}

/**
  * @brief  CANȫ�ֱ�������
  * @param  ����Ϊ��̬�������������ڱ��ļ��к�������
  * @retval None
  */
static CAN_TxHeaderTypeDef Can_Tx1_Message;		//CAN������Ϣ
static CAN_TxHeaderTypeDef Can_Tx1_Message_Id;	//CAN������Ϣ
static CAN_RxHeaderTypeDef rx_header;			//CAN ������Ϣ
static uint8_t Moto_RxData[8];
static uint8_t send_temp_msg[8];

/**
  * @Func  	CAN�˲����ã�����ɸѡCAN���ͱ���
  * @param
  * @retval None
  */
void can_filter_init_recv_all (void)
{
	CAN_FilterTypeDef Can_Filter_config_Strc;	//����Filter���ýṹ�壬���ڳ�ʼ��CAN_Filter����
	//Can Filter ����
	Can_Filter_config_Strc.FilterActivation = CAN_FILTER_ENABLE;	//��ʼ����ɺ���ʹ��Filter
	Can_Filter_config_Strc.FilterMode = CAN_FILTERMODE_IDMASK;	//ѡ��Filter_ID_MASKģʽ
	Can_Filter_config_Strc.FilterScale = CAN_FILTERSCALE_32BIT;	//�����˲�����СΪ32λ
	Can_Filter_config_Strc.FilterIdHigh = 0x0000;
	Can_Filter_config_Strc.FilterIdLow = 0x0000;
	Can_Filter_config_Strc.FilterMaskIdHigh =0x0000;
	Can_Filter_config_Strc.FilterMaskIdLow = 0x0000;
	Can_Filter_config_Strc.FilterBank = 0;	//ѡ��Filter0 ����г�ʼ��
	Can_Filter_config_Strc.FilterFIFOAssignment = CAN_FILTER_FIFO0;	//����FIFO-0�����Filter

	//CAN1 Filter ����
	if (HAL_CAN_ConfigFilter(&hcan1, &Can_Filter_config_Strc) != HAL_OK) {
		#ifdef PRINTF_ERROR_INFO
			printf("filter config error\n");
		#endif
	}

	//����CAN1
	if (HAL_CAN_Start(&hcan1) != HAL_OK) {
		#ifdef PRINTF_ERROR_INFO
			printf("can start error\n");
		#endif
	}
	//����CAN1�ж�
	HAL_CAN_ActivateNotification(&hcan1, CAN_IT_RX_FIFO0_MSG_PENDING);
	Can_Filter_config_Strc.SlaveStartFilterBank = 14;	//ѡ��filter14���г�ʼ��
	Can_Filter_config_Strc.FilterBank = 14;

/*	//CAN2 Filter ����
	if (HAL_CAN_ConfigFilter(&hcan2, &Can_Filter_config_Strc) != HAL_OK) {
		#ifdef PRINTF_ERROR_INFO
			printf("filter config error\n");
		#endif
	}
	//����CAN2
	if (HAL_CAN_Start(&hcan2) != HAL_OK) {
		#ifdef PRINTF_ERROR_INFO
			printf("can start error\n");
		#endif
	}
	//����CAN2�ж�
	HAL_CAN_ActivateNotification(&hcan2, CAN_IT_RX_FIFO0_MSG_PENDING);*/
}

/**
  * @Func  	CAN���Ϳ������ݵ����������������
  * @param  4����������ʾ�����͸�4������ĵ���ֵ
  * @note
  * @retval None
  */
void can1_send_set_moto_current(int16_t iq1, int16_t iq2, int16_t iq3, int16_t iq4)
{
	uint32_t TxMailbox;
	Can_Tx1_Message.StdId = 0x200;			//ʹ�ñ�׼��ʶ��
	Can_Tx1_Message.IDE = CAN_ID_STD;		//ʹ�ñ�׼֡
	Can_Tx1_Message.RTR = CAN_RTR_DATA;		//����֡
	Can_Tx1_Message.DLC = 0x08;				//��������֡���ȣ�8�ֽ�

	send_temp_msg[0] = iq1 >> 8;
	send_temp_msg[1] = iq1;
	send_temp_msg[2] = iq2 >> 8;
	send_temp_msg[3] = iq2;
	send_temp_msg[4] = iq3 >> 8;
	send_temp_msg[5] = iq3;
	send_temp_msg[6] = iq4 >> 8;
	send_temp_msg[7] = iq4;

	//CAN���ͺ���
	if (HAL_CAN_AddTxMessage(&hcan1, &Can_Tx1_Message, send_temp_msg, &TxMailbox) != HAL_OK) {
	#ifdef PRINTF_ERROR_INFO
		printf("Can send data error!\n");
	#endif
	}
}

/**
  * @Func  	CAN���Ϳ������ݵ���̨���
  * @param  yaw:	(0x205)	������Ƶ�����Χ[-30000,30000]
  * 		pitch:
  * 		rev:	��������
  *
  * @note
  * @retval None
  */
//void can1_send_gimbal_moto(int16_t yaw, int16_t pitch, int16_t shoot, int16_t rev)
//{
//	uint32_t TxMailbox;
//	Can_Tx1_Message.StdId = CAN_GIMBAL_ALL_ID;			//ʹ�ñ�׼��ʶ��
//	Can_Tx1_Message.IDE = CAN_ID_STD;		//ʹ�ñ�׼֡
//	Can_Tx1_Message.RTR = CAN_RTR_DATA;		//����֡
//	Can_Tx1_Message.DLC = 0x08;				//��������֡���ȣ�8�ֽ�
//
//	send_temp_msg[0] = yaw >> 8;
//	send_temp_msg[1] = yaw;
//	send_temp_msg[2] = pitch >> 8;
//	send_temp_msg[3] = pitch;
//	send_temp_msg[4] = shoot >> 8;
//	send_temp_msg[5] = shoot;
//	send_temp_msg[6] = rev >> 8;
//	send_temp_msg[7] = rev;
//
//	//CAN���ͺ���
//	if (HAL_CAN_AddTxMessage(&hcan1, &Can_Tx1_Message, send_temp_msg, &TxMailbox) != HAL_OK) {
//	#ifdef PRINTF_ERROR_INFO
//		printf("Can send data error!\n");
//	#endif
//	}
//}


/**
  * @Func  	����CAN�����������õ��ID
  * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
  *         the configuration information for the specified CAN.
  * @retval None
  */
void CAN_send_set_moto_id(CAN_HandleTypeDef* hcan1)
{
	uint8_t temp_msg_id[8];
	uint32_t TxMailbox_id;
	Can_Tx1_Message_Id.StdId = 0x700;			//ʹ�ñ�׼��ʶ��
	Can_Tx1_Message_Id.IDE = CAN_ID_STD;		//ʹ�ñ�׼֡
	Can_Tx1_Message_Id.RTR = CAN_RTR_DATA;		//����֡
	Can_Tx1_Message_Id.DLC = 0x08;

	temp_msg_id[0] = 0;
	temp_msg_id[1] = 0;
	temp_msg_id[2] = 0;
	temp_msg_id[3] = 0;
	temp_msg_id[4] = 0;
	temp_msg_id[5] = 0;
	temp_msg_id[6] = 0;
	temp_msg_id[7] = 0;

	//CAN���ͺ���
	if (HAL_CAN_AddTxMessage(hcan1, &Can_Tx1_Message_Id, temp_msg_id, &TxMailbox_id) != HAL_OK) {
		#ifdef PRINTF_ERROR_INFO
			printf("Can send id error!\n");
		#endif
	}
}

/**
  * @Func  	CAN����0���������жϻص���������ȡ�����������
  * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
  *         the configuration information for the specified CAN.
  * @retval None
  * @local	stm32f4xx_han_can.c
  * @ym		�жϻص������У���ȡ���������Ϣ���˺����н�ֹ�������ݴ�������
  */
void HAL_CAN_RxFifo0MsgPendingCallback(CAN_HandleTypeDef *hcan)
{
	HAL_CAN_GetRxMessage(hcan, CAN_RX_FIFO0, &rx_header,Moto_RxData);
	CAN_RX_Feedback_Data_Handle();
}

/**
  * @Func  	CAN�����ж����ݺ���������������������
  * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
  *         the configuration information for the specified CAN.
  * @retval None
  */
void CAN_RX_Feedback_Data_Handle(void)
{
	static uint8_t temp_moto_num = 0;
	switch(rx_header.StdId){
		case CAN_3508_M1_ID:
		case CAN_3508_M2_ID:
		case CAN_3508_M3_ID:
		case CAN_3508_M4_ID:
		case CAN_3508_M5_ID:
		case CAN_3508_M6_ID:
		case CAN_3508_M7_ID:
		{
			temp_moto_num =rx_header.StdId - CAN_3508_M1_ID;	//��ȡ���ID��
			get_motor_measure_handle(&motor_chassis[temp_moto_num], Moto_RxData);
			break;
		}
		default:
			break;
	}
}

/**
  * @Func  	****************�����ڲ��Ժ���************
  * @param	������������ID�š�����ֵ��ת��ֵ
  * @retval None
  */
void __test_fun_(void)
{
	uint8_t temp_i = 0;
	uint8_t temp_j = 4;
	for(temp_i = 0;temp_i <temp_j;temp_i++){
		printf("chassis_temperrate = %d  chassis_speed_rpm = %d  chassis_given_current = %d  chassis_angle = %d \r\n",
				motor_chassis[temp_i].temperrate, motor_chassis[temp_i].speed_rpm,
				motor_chassis[temp_i].given_current, motor_chassis[temp_i].angle);
	}
}

/**
  * @Func  	�����������ָ�뺯��
  * @param  i����ʾ������
  * @retval ���ص��������Ϣ����
  */
const moto_measure_t *get_chassis_motor_measure_point(uint8_t i)
{
	return &motor_chassis[i & 0x03];
}

