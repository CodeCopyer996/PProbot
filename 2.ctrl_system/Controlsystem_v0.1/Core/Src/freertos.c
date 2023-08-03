/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * File Name          : freertos.c
  * Description        : Code for freertos applications
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under Ultimate Liberty license
  * SLA0044, the "License"; You may not use this file except in compliance with
  * the License. You may obtain a copy of the License at:
  *                             www.st.com/SLA0044
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "FreeRTOS.h"
#include "task.h"
#include "main.h"
#include "cmsis_os.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "gpio.h"
#include "stm32f4xx_it.h"
#include "usart.h"
#include "can.h"

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN Variables */
//extern uint8_t rcbuffer[18];
//extern RC_Ctl_t RC_CtrlData;
//extern CAN_HandleTypeDef hcan1;
//extern UART_HandleTypeDef huart2;
//extern CAN_HandleTypeDef hcan2;

//extern UART_HandleTypeDef huart1;
/* USER CODE END Variables */
osThreadId defaultTaskHandle;
osThreadId MotorTaskHandle;
osThreadId ARHSTaskHandle;
osThreadId GimbalTaskHandle;
osThreadId MeasureTaskHandle;
osThreadId ComTaskHandle;

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN FunctionPrototypes */

/* USER CODE END FunctionPrototypes */

void StartDefaultTask(void const * argument);
void Motordrive_task(void const * argument);
void arhs_task(void const * argument);
void gimbal_task(void const * argument);
void measureTask(void const * argument);
void comTask(void const * argument);

void MX_FREERTOS_Init(void); /* (MISRA C 2004 rule 8.1) */

/* GetIdleTaskMemory prototype (linked to static allocation support) */
void vApplicationGetIdleTaskMemory( StaticTask_t **ppxIdleTaskTCBBuffer, StackType_t **ppxIdleTaskStackBuffer, uint32_t *pulIdleTaskStackSize );

/* USER CODE BEGIN GET_IDLE_TASK_MEMORY */
static StaticTask_t xIdleTaskTCBBuffer;
static StackType_t xIdleStack[configMINIMAL_STACK_SIZE];

void vApplicationGetIdleTaskMemory( StaticTask_t **ppxIdleTaskTCBBuffer, StackType_t **ppxIdleTaskStackBuffer, uint32_t *pulIdleTaskStackSize )
{
  *ppxIdleTaskTCBBuffer = &xIdleTaskTCBBuffer;
  *ppxIdleTaskStackBuffer = &xIdleStack[0];
  *pulIdleTaskStackSize = configMINIMAL_STACK_SIZE;
  /* place for user code */
}
/* USER CODE END GET_IDLE_TASK_MEMORY */

/**
  * @brief  FreeRTOS initialization
  * @param  None
  * @retval None
  */
void MX_FREERTOS_Init(void) {
  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* USER CODE BEGIN RTOS_MUTEX */
  /* add mutexes, ... */
  /* USER CODE END RTOS_MUTEX */

  /* USER CODE BEGIN RTOS_SEMAPHORES */
  /* add semaphores, ... */
  /* USER CODE END RTOS_SEMAPHORES */

  /* USER CODE BEGIN RTOS_TIMERS */
  /* start timers, add new ones, ... */
  /* USER CODE END RTOS_TIMERS */

  /* USER CODE BEGIN RTOS_QUEUES */
  /* add queues, ... */
  /* USER CODE END RTOS_QUEUES */

  /* Create the thread(s) */
  /* definition and creation of defaultTask */
  osThreadDef(defaultTask, StartDefaultTask, osPriorityIdle, 0, 128);
  defaultTaskHandle = osThreadCreate(osThread(defaultTask), NULL);

  /* definition and creation of MotorTask */
  osThreadDef(MotorTask, Motordrive_task, osPriorityRealtime, 0, 128);
  MotorTaskHandle = osThreadCreate(osThread(MotorTask), NULL);

  /* definition and creation of ARHSTask */
  osThreadDef(ARHSTask, arhs_task, osPriorityHigh, 0, 512);
  ARHSTaskHandle = osThreadCreate(osThread(ARHSTask), NULL);

  /* definition and creation of GimbalTask */
  osThreadDef(GimbalTask, gimbal_task, osPriorityLow, 0, 256);
  GimbalTaskHandle = osThreadCreate(osThread(GimbalTask), NULL);

  /* definition and creation of MeasureTask */
  osThreadDef(MeasureTask, measureTask, osPriorityAboveNormal, 0, 128);
  MeasureTaskHandle = osThreadCreate(osThread(MeasureTask), NULL);

  /* definition and creation of ComTask */
  osThreadDef(ComTask, comTask, osPriorityNormal, 0, 256);
  ComTaskHandle = osThreadCreate(osThread(ComTask), NULL);

  /* USER CODE BEGIN RTOS_THREADS */
  /* add threads, ... */
  /* USER CODE END RTOS_THREADS */

}

/* USER CODE BEGIN Header_StartDefaultTask */
/**
  * @brief  Function implementing the defaultTask thread.
  * @param  argument: Not used
  * @retval None
  */
/* USER CODE END Header_StartDefaultTask */
void StartDefaultTask(void const * argument)
{
  /* USER CODE BEGIN StartDefaultTask */
  /* Infinite loop */

  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END StartDefaultTask */
}

/* USER CODE BEGIN Header_Motordrive_task */
/**
* @brief Function implementing the MotorTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_Motordrive_task */
__weak void Motordrive_task(void const * argument)
{
  /* USER CODE BEGIN Motordrive_task */
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END Motordrive_task */
}

/* USER CODE BEGIN Header_arhs_task */
/**
* @brief Function implementing the ARHS_TASK thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_arhs_task */
__weak void arhs_task(void const * argument)
{
  /* USER CODE BEGIN arhs_task */
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END arhs_task */
}

/* USER CODE BEGIN Header_gimbal_task */
/**
* @brief Function implementing the GIMBAL_TASK thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_gimbal_task */
__weak void gimbal_task(void const * argument)
{
  /* USER CODE BEGIN gimbal_task */
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END gimbal_task */
}

/* USER CODE BEGIN Header_measureTask */
/**
* @brief Function implementing the MeasureTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_measureTask */
__weak void measureTask(void const * argument)
{
  /* USER CODE BEGIN measureTask */
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END measureTask */
}

/* USER CODE BEGIN Header_comTask */
/**
* @brief Function implementing the ComTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_comTask */
__weak void comTask(void const * argument)
{
  /* USER CODE BEGIN comTask */
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END comTask */
}

/* Private application code --------------------------------------------------*/
/* USER CODE BEGIN Application */

/* USER CODE END Application */
