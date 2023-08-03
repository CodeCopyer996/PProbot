################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MyFreeRtos/ImuDriver/dmp_driver/i2c_simulation.c \
../MyFreeRtos/ImuDriver/dmp_driver/inv_mpu.c \
../MyFreeRtos/ImuDriver/dmp_driver/inv_mpu_dmp_motion_driver.c \
../MyFreeRtos/ImuDriver/dmp_driver/mpu6500_dmp_driver.c 

OBJS += \
./MyFreeRtos/ImuDriver/dmp_driver/i2c_simulation.o \
./MyFreeRtos/ImuDriver/dmp_driver/inv_mpu.o \
./MyFreeRtos/ImuDriver/dmp_driver/inv_mpu_dmp_motion_driver.o \
./MyFreeRtos/ImuDriver/dmp_driver/mpu6500_dmp_driver.o 

C_DEPS += \
./MyFreeRtos/ImuDriver/dmp_driver/i2c_simulation.d \
./MyFreeRtos/ImuDriver/dmp_driver/inv_mpu.d \
./MyFreeRtos/ImuDriver/dmp_driver/inv_mpu_dmp_motion_driver.d \
./MyFreeRtos/ImuDriver/dmp_driver/mpu6500_dmp_driver.d 


# Each subdirectory must supply rules for building sources it contributes
MyFreeRtos/ImuDriver/dmp_driver/%.o: ../MyFreeRtos/ImuDriver/dmp_driver/%.c MyFreeRtos/ImuDriver/dmp_driver/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F427xx -DUSE_HAL_DRIVER -DDEBUG -c -I"F:/robot_arm/2.Controlsystem/Stm32F427_Con_Sys_modify/MyFreeRtos/Include" -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I"F:/Practice/Stm32F427_Con_Sys/MyFreeRtos/Include" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MyFreeRtos-2f-ImuDriver-2f-dmp_driver

clean-MyFreeRtos-2f-ImuDriver-2f-dmp_driver:
	-$(RM) ./MyFreeRtos/ImuDriver/dmp_driver/i2c_simulation.d ./MyFreeRtos/ImuDriver/dmp_driver/i2c_simulation.o ./MyFreeRtos/ImuDriver/dmp_driver/inv_mpu.d ./MyFreeRtos/ImuDriver/dmp_driver/inv_mpu.o ./MyFreeRtos/ImuDriver/dmp_driver/inv_mpu_dmp_motion_driver.d ./MyFreeRtos/ImuDriver/dmp_driver/inv_mpu_dmp_motion_driver.o ./MyFreeRtos/ImuDriver/dmp_driver/mpu6500_dmp_driver.d ./MyFreeRtos/ImuDriver/dmp_driver/mpu6500_dmp_driver.o

.PHONY: clean-MyFreeRtos-2f-ImuDriver-2f-dmp_driver

