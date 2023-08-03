#ifndef __CHASSIS_BEHAVIOUR_H__
#define __CHASSIS_BEHAVIOUR_H__


#include "Basic_Task/base_calculation.h"
#include "Motor_task.h"
#include <Commnication_Task/Uart8_DMA_RT.h>

//#define ROBOT_STOP_MODE 1
//#define ROBOT_MOTOR_SPEED_PID_MODE 2
//#define ROBOT_UART_POSITION_PID_MODE 3
//底盘行为模式设置
void chassis_behaviour_mode_set(chassis_move_t *chassis_move_mode);
//底盘行为对应控制变量设置
extern void chassis_behaviour_ctrl_var_set(chassis_move_t *chassis_move_rc_to_vec);

#endif
