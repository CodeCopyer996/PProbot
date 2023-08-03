#ifndef __BSP_NRF24L01_H__
#define __BSP_NRF24L01_H__

#include <Basic_Task/base_task.h>
#include "gpio.h"
#include "spi.h"



//NRF24L01寄存器操作定义
#define NRF_READ_REG    0x00  // 读配置寄存器，低5位为寄存器地址
#define NRF_WRITE_REG   0x20  // 写配置寄存器，低5位为寄存器地址
#define RD_RX_PLOAD     0x61  // 读RX有效数据，1—32字节，不能超过32字节
#define WR_TX_PLOAD     0xA0  // 写有效数据，1—32字节
#define FLUSH_TX        0xE1  // 清除TX_FIEO寄存器，发射模式用
#define FLUSH_RX        0xE2  // 清除RX_FIFO寄存器，接收模式用
#define REUSE_TX_PL     0xE3  // 重复使用上一包数据，CE为高，数据包不断被发送
#define NOP             0xFF  // 空操作，用于读取状态寄存器

//NRF24L01寄存器地址定义
#define CONFIG          0x00  // 配置寄存器地址【重要】

#define EN_AA           0x01  // 使能自动应答寄存器
#define EN_RXADDR       0x02  // 接收地址允许
#define SETUP_AW        0x03  // 设置地址宽度，上位机模块要求5字节
#define SETUP_RETR      0x04  // 建立自动重发
#define RF_CH           0x05  // RF通道
#define RF_SETUP        0x06  // RF状态寄存器
#define STATUS          0x07  // 状态寄存器

#define MAX_TX  		0x10  // 达到最大发送次数中断
#define TX_OK   		0x20  // TX发送完成中断
#define RX_OK   		0x40  // 接收数据中断

#define OBSERVE_TX      0x08  // 发送检测寄存器
#define CD              0x09  // 载波检测寄存器
#define RX_ADDR_P0      0x0A  // 数据通道0接收地址，最大长度5字节，低字节在前
#define RX_ADDR_P1      0x0B  // 数据通道1接收地址
#define RX_ADDR_P2      0x0C  // 数据通道2接收地址，最低字节可设置
#define RX_ADDR_P3      0x0D  // 数据通道3接收地址，最低字节可设置
#define RX_ADDR_P4      0x0E  // 数据通道4接收地址，最低字节可设置
#define RX_ADDR_P5      0x0F  // 数据通道5接收地址，最低字节可设置

#define TX_ADDR         0x10  // 发送地址
#define RX_PW_P0        0x11  // 接收数据通道0有效宽度（1—32字节）
#define RX_PW_P1        0x12  // 接收数据通道1有效宽度（1—32字节）
#define RX_PW_P2        0x13  // 接收数据通道2有效宽度（1—32字节）
#define RX_PW_P3        0x14  // 接收数据通道3有效宽度（1—32字节）
#define RX_PW_P4        0x15  // 接收数据通道4有效宽度（1—32字节）
#define RX_PW_P5        0x16  // 接收数据通道5有效宽度（1—32字节）
#define NRF_FIFO_STATUS 0x17  // FIFO状态寄存器



#define NRF24L01_NSS_LOW	HAL_GPIO_WritePin(NRF24L01_SPI_NSS_GPIO_Port, NRF24L01_SPI_NSS_Pin, GPIO_PIN_RESET)
#define NRF24L01_NSS_HIGH 	HAL_GPIO_WritePin(NRF24L01_SPI_NSS_GPIO_Port, NRF24L01_SPI_NSS_Pin, GPIO_PIN_SET)

#define NRF24L01_CE_LOW 	HAL_GPIO_WritePin(NRF24L01_CE_GPIO_Port, NRF24L01_CE_Pin, GPIO_PIN_RESET)
#define NRF24L01_CE_HIGH 	HAL_GPIO_WritePin(NRF24L01_CE_GPIO_Port, NRF24L01_CE_Pin, GPIO_PIN_SET)

#define NRF24L01_IRQ_STATUS	HAL_GPIO_ReadPin(NRF24L01_IRQ_GPIO_Port, NRF24L01_IRQ_Pin)




/*
#define NRF24L01_CE     PGout(6)
#define NRF24L01_CSN    PGout(7)
#define NRF24L01_IRQ    PGin(8)
*/


#define TX_ADR_WIDTH    5   	// 发送5字节地址宽度
#define RX_ADR_WIDTH    5   	// 接收5字节地址宽度
#define TX_PLOAD_WIDTH  32  	// 发送32字节用书数据宽度
#define RX_PLOAD_WIDTH  32  	// 接收32字节用户数据宽度


//函数声明
uint8_t NRF24L01_Write_Byte(uint8_t  reg, uint8_t  data);
uint8_t NRF24L01_Write_Bytes(uint8_t  regAddr, uint8_t* pBuffer, uint8_t len);
uint8_t NRF24L01_Read_Byte(uint8_t reg);
uint8_t NRF24L01_Read_Bytes(uint8_t  regAddr, uint8_t* pData, uint8_t len);


void NRF24L01_PowerCtrl(uint8_t NRF_Ctrl_Flag);

#endif
