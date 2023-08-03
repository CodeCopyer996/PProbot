################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MyFreeRtos/MeasureTask/MeasureTask.c \
../MyFreeRtos/MeasureTask/PressureMeasure.c \
../MyFreeRtos/MeasureTask/UltrasonicMeasure.c 

OBJS += \
./MyFreeRtos/MeasureTask/MeasureTask.o \
./MyFreeRtos/MeasureTask/PressureMeasure.o \
./MyFreeRtos/MeasureTask/UltrasonicMeasure.o 

C_DEPS += \
./MyFreeRtos/MeasureTask/MeasureTask.d \
./MyFreeRtos/MeasureTask/PressureMeasure.d \
./MyFreeRtos/MeasureTask/UltrasonicMeasure.d 


# Each subdirectory must supply rules for building sources it contributes
MyFreeRtos/MeasureTask/%.o: ../MyFreeRtos/MeasureTask/%.c MyFreeRtos/MeasureTask/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F427xx -DUSE_HAL_DRIVER -DDEBUG -c -I"F:/robot_arm/2.Controlsystem/Controlsystem_v0.1/MyFreeRtos/Include" -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I"F:/Practice/Stm32F427_Con_Sys/MyFreeRtos/Include" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MyFreeRtos-2f-MeasureTask

clean-MyFreeRtos-2f-MeasureTask:
	-$(RM) ./MyFreeRtos/MeasureTask/MeasureTask.d ./MyFreeRtos/MeasureTask/MeasureTask.o ./MyFreeRtos/MeasureTask/PressureMeasure.d ./MyFreeRtos/MeasureTask/PressureMeasure.o ./MyFreeRtos/MeasureTask/UltrasonicMeasure.d ./MyFreeRtos/MeasureTask/UltrasonicMeasure.o

.PHONY: clean-MyFreeRtos-2f-MeasureTask

