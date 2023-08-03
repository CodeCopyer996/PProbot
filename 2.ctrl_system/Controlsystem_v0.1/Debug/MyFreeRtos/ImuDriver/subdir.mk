################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MyFreeRtos/ImuDriver/MahonyAHRS.c \
../MyFreeRtos/ImuDriver/MahonySimplify.c \
../MyFreeRtos/ImuDriver/imu_reg_fun.c \
../MyFreeRtos/ImuDriver/imu_task.c 

OBJS += \
./MyFreeRtos/ImuDriver/MahonyAHRS.o \
./MyFreeRtos/ImuDriver/MahonySimplify.o \
./MyFreeRtos/ImuDriver/imu_reg_fun.o \
./MyFreeRtos/ImuDriver/imu_task.o 

C_DEPS += \
./MyFreeRtos/ImuDriver/MahonyAHRS.d \
./MyFreeRtos/ImuDriver/MahonySimplify.d \
./MyFreeRtos/ImuDriver/imu_reg_fun.d \
./MyFreeRtos/ImuDriver/imu_task.d 


# Each subdirectory must supply rules for building sources it contributes
MyFreeRtos/ImuDriver/%.o: ../MyFreeRtos/ImuDriver/%.c MyFreeRtos/ImuDriver/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F427xx -DUSE_HAL_DRIVER -DDEBUG -c -I"F:/robot_arm/2.Controlsystem/Stm32F427_Con_Sys_modify/MyFreeRtos/Include" -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I"F:/Practice/Stm32F427_Con_Sys/MyFreeRtos/Include" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MyFreeRtos-2f-ImuDriver

clean-MyFreeRtos-2f-ImuDriver:
	-$(RM) ./MyFreeRtos/ImuDriver/MahonyAHRS.d ./MyFreeRtos/ImuDriver/MahonyAHRS.o ./MyFreeRtos/ImuDriver/MahonySimplify.d ./MyFreeRtos/ImuDriver/MahonySimplify.o ./MyFreeRtos/ImuDriver/imu_reg_fun.d ./MyFreeRtos/ImuDriver/imu_reg_fun.o ./MyFreeRtos/ImuDriver/imu_task.d ./MyFreeRtos/ImuDriver/imu_task.o

.PHONY: clean-MyFreeRtos-2f-ImuDriver

