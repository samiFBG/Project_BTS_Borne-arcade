################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Src/Eeprom_flash.c \
../Src/Ges_I2C_Polling.c \
../Src/Matrice_Led.c \
../Src/Micro_delay.c \
../Src/Tache_IT_Matrice.c \
../Src/Tache_ges_volet.c \
../Src/Tache_rec_emi_CAN.c \
../Src/main.c \
../Src/stm32f1xx_hal_msp.c \
../Src/stm32f1xx_it.c \
../Src/syscalls.c \
../Src/system_stm32f1xx.c 

OBJS += \
./Src/Eeprom_flash.o \
./Src/Ges_I2C_Polling.o \
./Src/Matrice_Led.o \
./Src/Micro_delay.o \
./Src/Tache_IT_Matrice.o \
./Src/Tache_ges_volet.o \
./Src/Tache_rec_emi_CAN.o \
./Src/main.o \
./Src/stm32f1xx_hal_msp.o \
./Src/stm32f1xx_it.o \
./Src/syscalls.o \
./Src/system_stm32f1xx.o 

C_DEPS += \
./Src/Eeprom_flash.d \
./Src/Ges_I2C_Polling.d \
./Src/Matrice_Led.d \
./Src/Micro_delay.d \
./Src/Tache_IT_Matrice.d \
./Src/Tache_ges_volet.d \
./Src/Tache_rec_emi_CAN.d \
./Src/main.d \
./Src/stm32f1xx_hal_msp.d \
./Src/stm32f1xx_it.d \
./Src/syscalls.d \
./Src/system_stm32f1xx.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.c Src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -Og -ffunction-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

