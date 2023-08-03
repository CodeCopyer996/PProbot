################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MyFreeRtos/Motordrive_Task/Motor_behaviour.c \
../MyFreeRtos/Motordrive_Task/Motor_task.c 

OBJS += \
./MyFreeRtos/Motordrive_Task/Motor_behaviour.o \
./MyFreeRtos/Motordrive_Task/Motor_task.o 

C_DEPS += \
./MyFreeRtos/Motordrive_Task/Motor_behaviour.d \
./MyFreeRtos/Motordrive_Task/Motor_task.d 


# Each subdirectory must supply rules for building sources it contributes
MyFreeRtos/Motordrive_Task/%.o: ../MyFreeRtos/Motordrive_Task/%.c MyFreeRtos/Motordrive_Task/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F427xx -DUSE_HAL_DRIVER -DDEBUG -c -I"F:/robot_arm/2.1 conotrolsystem/Controlsystem_v0.1/MyFreeRtos/Include" -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MyFreeRtos-2f-Motordrive_Task

clean-MyFreeRtos-2f-Motordrive_Task:
	-$(RM) ./MyFreeRtos/Motordrive_Task/Motor_behaviour.d ./MyFreeRtos/Motordrive_Task/Motor_behaviour.o ./MyFreeRtos/Motordrive_Task/Motor_task.d ./MyFreeRtos/Motordrive_Task/Motor_task.o

.PHONY: clean-MyFreeRtos-2f-Motordrive_Task

