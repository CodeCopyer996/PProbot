################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MyFreeRtos/GimbalTask/gimbal_behaviour.c \
../MyFreeRtos/GimbalTask/gimbal_task.c 

OBJS += \
./MyFreeRtos/GimbalTask/gimbal_behaviour.o \
./MyFreeRtos/GimbalTask/gimbal_task.o 

C_DEPS += \
./MyFreeRtos/GimbalTask/gimbal_behaviour.d \
./MyFreeRtos/GimbalTask/gimbal_task.d 


# Each subdirectory must supply rules for building sources it contributes
MyFreeRtos/GimbalTask/%.o: ../MyFreeRtos/GimbalTask/%.c MyFreeRtos/GimbalTask/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F427xx -DUSE_HAL_DRIVER -DDEBUG -c -I"F:/robot_arm/2.Controlsystem/Stm32F427_Con_Sys_modify/MyFreeRtos/Include" -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I"F:/Practice/Stm32F427_Con_Sys/MyFreeRtos/Include" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MyFreeRtos-2f-GimbalTask

clean-MyFreeRtos-2f-GimbalTask:
	-$(RM) ./MyFreeRtos/GimbalTask/gimbal_behaviour.d ./MyFreeRtos/GimbalTask/gimbal_behaviour.o ./MyFreeRtos/GimbalTask/gimbal_task.d ./MyFreeRtos/GimbalTask/gimbal_task.o

.PHONY: clean-MyFreeRtos-2f-GimbalTask

