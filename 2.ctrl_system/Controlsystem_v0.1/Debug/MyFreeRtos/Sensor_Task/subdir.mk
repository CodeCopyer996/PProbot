################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MyFreeRtos/Sensor_Task/MeasureTask.c \
../MyFreeRtos/Sensor_Task/PressureMeasure.c \
../MyFreeRtos/Sensor_Task/UltrasonicMeasure.c 

OBJS += \
./MyFreeRtos/Sensor_Task/MeasureTask.o \
./MyFreeRtos/Sensor_Task/PressureMeasure.o \
./MyFreeRtos/Sensor_Task/UltrasonicMeasure.o 

C_DEPS += \
./MyFreeRtos/Sensor_Task/MeasureTask.d \
./MyFreeRtos/Sensor_Task/PressureMeasure.d \
./MyFreeRtos/Sensor_Task/UltrasonicMeasure.d 


# Each subdirectory must supply rules for building sources it contributes
MyFreeRtos/Sensor_Task/%.o: ../MyFreeRtos/Sensor_Task/%.c MyFreeRtos/Sensor_Task/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F427xx -DUSE_HAL_DRIVER -DDEBUG -c -I"F:/robot_arm/2.1 conotrolsystem/Controlsystem_v0.1/MyFreeRtos/Include" -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MyFreeRtos-2f-Sensor_Task

clean-MyFreeRtos-2f-Sensor_Task:
	-$(RM) ./MyFreeRtos/Sensor_Task/MeasureTask.d ./MyFreeRtos/Sensor_Task/MeasureTask.o ./MyFreeRtos/Sensor_Task/PressureMeasure.d ./MyFreeRtos/Sensor_Task/PressureMeasure.o ./MyFreeRtos/Sensor_Task/UltrasonicMeasure.d ./MyFreeRtos/Sensor_Task/UltrasonicMeasure.o

.PHONY: clean-MyFreeRtos-2f-Sensor_Task

