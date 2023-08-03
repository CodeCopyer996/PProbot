################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MyFreeRtos/ComTask/CANCom.c \
../MyFreeRtos/ComTask/ComTask.c \
../MyFreeRtos/ComTask/MCUAndPCCom.c \
../MyFreeRtos/ComTask/NRF24L01.c \
../MyFreeRtos/ComTask/bsp_NRF24L01.c \
../MyFreeRtos/ComTask/remoteCom.c 

OBJS += \
./MyFreeRtos/ComTask/CANCom.o \
./MyFreeRtos/ComTask/ComTask.o \
./MyFreeRtos/ComTask/MCUAndPCCom.o \
./MyFreeRtos/ComTask/NRF24L01.o \
./MyFreeRtos/ComTask/bsp_NRF24L01.o \
./MyFreeRtos/ComTask/remoteCom.o 

C_DEPS += \
./MyFreeRtos/ComTask/CANCom.d \
./MyFreeRtos/ComTask/ComTask.d \
./MyFreeRtos/ComTask/MCUAndPCCom.d \
./MyFreeRtos/ComTask/NRF24L01.d \
./MyFreeRtos/ComTask/bsp_NRF24L01.d \
./MyFreeRtos/ComTask/remoteCom.d 


# Each subdirectory must supply rules for building sources it contributes
MyFreeRtos/ComTask/%.o: ../MyFreeRtos/ComTask/%.c MyFreeRtos/ComTask/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F427xx -DUSE_HAL_DRIVER -DDEBUG -c -I"F:/robot_arm/2.Controlsystem/Controlsystem_v0.1/MyFreeRtos/Include" -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I"F:/Practice/Stm32F427_Con_Sys/MyFreeRtos/Include" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MyFreeRtos-2f-ComTask

clean-MyFreeRtos-2f-ComTask:
	-$(RM) ./MyFreeRtos/ComTask/CANCom.d ./MyFreeRtos/ComTask/CANCom.o ./MyFreeRtos/ComTask/ComTask.d ./MyFreeRtos/ComTask/ComTask.o ./MyFreeRtos/ComTask/MCUAndPCCom.d ./MyFreeRtos/ComTask/MCUAndPCCom.o ./MyFreeRtos/ComTask/NRF24L01.d ./MyFreeRtos/ComTask/NRF24L01.o ./MyFreeRtos/ComTask/bsp_NRF24L01.d ./MyFreeRtos/ComTask/bsp_NRF24L01.o ./MyFreeRtos/ComTask/remoteCom.d ./MyFreeRtos/ComTask/remoteCom.o

.PHONY: clean-MyFreeRtos-2f-ComTask

