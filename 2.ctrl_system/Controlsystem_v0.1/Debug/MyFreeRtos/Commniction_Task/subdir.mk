################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MyFreeRtos/Commniction_Task/CANCom.c \
../MyFreeRtos/Commniction_Task/ComTask.c \
../MyFreeRtos/Commniction_Task/NRF24L01.c \
../MyFreeRtos/Commniction_Task/PC_CtrlPos.c \
../MyFreeRtos/Commniction_Task/Uart8_DMA_RT.c \
../MyFreeRtos/Commniction_Task/bsp_NRF24L01.c \
../MyFreeRtos/Commniction_Task/remoteCom.c 

OBJS += \
./MyFreeRtos/Commniction_Task/CANCom.o \
./MyFreeRtos/Commniction_Task/ComTask.o \
./MyFreeRtos/Commniction_Task/NRF24L01.o \
./MyFreeRtos/Commniction_Task/PC_CtrlPos.o \
./MyFreeRtos/Commniction_Task/Uart8_DMA_RT.o \
./MyFreeRtos/Commniction_Task/bsp_NRF24L01.o \
./MyFreeRtos/Commniction_Task/remoteCom.o 

C_DEPS += \
./MyFreeRtos/Commniction_Task/CANCom.d \
./MyFreeRtos/Commniction_Task/ComTask.d \
./MyFreeRtos/Commniction_Task/NRF24L01.d \
./MyFreeRtos/Commniction_Task/PC_CtrlPos.d \
./MyFreeRtos/Commniction_Task/Uart8_DMA_RT.d \
./MyFreeRtos/Commniction_Task/bsp_NRF24L01.d \
./MyFreeRtos/Commniction_Task/remoteCom.d 


# Each subdirectory must supply rules for building sources it contributes
MyFreeRtos/Commniction_Task/%.o: ../MyFreeRtos/Commniction_Task/%.c MyFreeRtos/Commniction_Task/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F427xx -DUSE_HAL_DRIVER -DDEBUG -c -I"F:/robot_arm/2.1 conotrolsystem/Controlsystem_v0.1/MyFreeRtos/Include" -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MyFreeRtos-2f-Commniction_Task

clean-MyFreeRtos-2f-Commniction_Task:
	-$(RM) ./MyFreeRtos/Commniction_Task/CANCom.d ./MyFreeRtos/Commniction_Task/CANCom.o ./MyFreeRtos/Commniction_Task/ComTask.d ./MyFreeRtos/Commniction_Task/ComTask.o ./MyFreeRtos/Commniction_Task/NRF24L01.d ./MyFreeRtos/Commniction_Task/NRF24L01.o ./MyFreeRtos/Commniction_Task/PC_CtrlPos.d ./MyFreeRtos/Commniction_Task/PC_CtrlPos.o ./MyFreeRtos/Commniction_Task/Uart8_DMA_RT.d ./MyFreeRtos/Commniction_Task/Uart8_DMA_RT.o ./MyFreeRtos/Commniction_Task/bsp_NRF24L01.d ./MyFreeRtos/Commniction_Task/bsp_NRF24L01.o ./MyFreeRtos/Commniction_Task/remoteCom.d ./MyFreeRtos/Commniction_Task/remoteCom.o

.PHONY: clean-MyFreeRtos-2f-Commniction_Task

