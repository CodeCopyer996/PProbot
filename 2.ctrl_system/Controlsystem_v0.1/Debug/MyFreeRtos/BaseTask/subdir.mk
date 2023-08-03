################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MyFreeRtos/BaseTask/base_calculation.c \
../MyFreeRtos/BaseTask/base_task.c \
../MyFreeRtos/BaseTask/bsp_spi_dma.c \
../MyFreeRtos/BaseTask/pid_task.c 

OBJS += \
./MyFreeRtos/BaseTask/base_calculation.o \
./MyFreeRtos/BaseTask/base_task.o \
./MyFreeRtos/BaseTask/bsp_spi_dma.o \
./MyFreeRtos/BaseTask/pid_task.o 

C_DEPS += \
./MyFreeRtos/BaseTask/base_calculation.d \
./MyFreeRtos/BaseTask/base_task.d \
./MyFreeRtos/BaseTask/bsp_spi_dma.d \
./MyFreeRtos/BaseTask/pid_task.d 


# Each subdirectory must supply rules for building sources it contributes
MyFreeRtos/BaseTask/%.o: ../MyFreeRtos/BaseTask/%.c MyFreeRtos/BaseTask/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F427xx -DUSE_HAL_DRIVER -DDEBUG -c -I"F:/robot_arm/2.Controlsystem/Controlsystem_v0.1/MyFreeRtos/Include" -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I"F:/Practice/Stm32F427_Con_Sys/MyFreeRtos/Include" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MyFreeRtos-2f-BaseTask

clean-MyFreeRtos-2f-BaseTask:
	-$(RM) ./MyFreeRtos/BaseTask/base_calculation.d ./MyFreeRtos/BaseTask/base_calculation.o ./MyFreeRtos/BaseTask/base_task.d ./MyFreeRtos/BaseTask/base_task.o ./MyFreeRtos/BaseTask/bsp_spi_dma.d ./MyFreeRtos/BaseTask/bsp_spi_dma.o ./MyFreeRtos/BaseTask/pid_task.d ./MyFreeRtos/BaseTask/pid_task.o

.PHONY: clean-MyFreeRtos-2f-BaseTask

