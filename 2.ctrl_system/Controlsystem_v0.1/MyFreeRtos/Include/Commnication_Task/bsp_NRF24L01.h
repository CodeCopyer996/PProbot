#ifndef __BSP_NRF24L01_H__
#define __BSP_NRF24L01_H__

#include <Basic_Task/base_task.h>
#include "gpio.h"
#include "spi.h"



//NRF24L01�Ĵ�����������
#define NRF_READ_REG    0x00  // �����üĴ�������5λΪ�Ĵ�����ַ
#define NRF_WRITE_REG   0x20  // д���üĴ�������5λΪ�Ĵ�����ַ
#define RD_RX_PLOAD     0x61  // ��RX��Ч���ݣ�1��32�ֽڣ����ܳ���32�ֽ�
#define WR_TX_PLOAD     0xA0  // д��Ч���ݣ�1��32�ֽ�
#define FLUSH_TX        0xE1  // ���TX_FIEO�Ĵ���������ģʽ��
#define FLUSH_RX        0xE2  // ���RX_FIFO�Ĵ���������ģʽ��
#define REUSE_TX_PL     0xE3  // �ظ�ʹ����һ�����ݣ�CEΪ�ߣ����ݰ����ϱ�����
#define NOP             0xFF  // �ղ��������ڶ�ȡ״̬�Ĵ���

//NRF24L01�Ĵ�����ַ����
#define CONFIG          0x00  // ���üĴ�����ַ����Ҫ��

#define EN_AA           0x01  // ʹ���Զ�Ӧ��Ĵ���
#define EN_RXADDR       0x02  // ���յ�ַ����
#define SETUP_AW        0x03  // ���õ�ַ��ȣ���λ��ģ��Ҫ��5�ֽ�
#define SETUP_RETR      0x04  // �����Զ��ط�
#define RF_CH           0x05  // RFͨ��
#define RF_SETUP        0x06  // RF״̬�Ĵ���
#define STATUS          0x07  // ״̬�Ĵ���

#define MAX_TX  		0x10  // �ﵽ����ʹ����ж�
#define TX_OK   		0x20  // TX��������ж�
#define RX_OK   		0x40  // ���������ж�

#define OBSERVE_TX      0x08  // ���ͼ��Ĵ���
#define CD              0x09  // �ز����Ĵ���
#define RX_ADDR_P0      0x0A  // ����ͨ��0���յ�ַ����󳤶�5�ֽڣ����ֽ���ǰ
#define RX_ADDR_P1      0x0B  // ����ͨ��1���յ�ַ
#define RX_ADDR_P2      0x0C  // ����ͨ��2���յ�ַ������ֽڿ�����
#define RX_ADDR_P3      0x0D  // ����ͨ��3���յ�ַ������ֽڿ�����
#define RX_ADDR_P4      0x0E  // ����ͨ��4���յ�ַ������ֽڿ�����
#define RX_ADDR_P5      0x0F  // ����ͨ��5���յ�ַ������ֽڿ�����

#define TX_ADDR         0x10  // ���͵�ַ
#define RX_PW_P0        0x11  // ��������ͨ��0��Ч��ȣ�1��32�ֽڣ�
#define RX_PW_P1        0x12  // ��������ͨ��1��Ч��ȣ�1��32�ֽڣ�
#define RX_PW_P2        0x13  // ��������ͨ��2��Ч��ȣ�1��32�ֽڣ�
#define RX_PW_P3        0x14  // ��������ͨ��3��Ч��ȣ�1��32�ֽڣ�
#define RX_PW_P4        0x15  // ��������ͨ��4��Ч��ȣ�1��32�ֽڣ�
#define RX_PW_P5        0x16  // ��������ͨ��5��Ч��ȣ�1��32�ֽڣ�
#define NRF_FIFO_STATUS 0x17  // FIFO״̬�Ĵ���



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


#define TX_ADR_WIDTH    5   	// ����5�ֽڵ�ַ���
#define RX_ADR_WIDTH    5   	// ����5�ֽڵ�ַ���
#define TX_PLOAD_WIDTH  32  	// ����32�ֽ��������ݿ��
#define RX_PLOAD_WIDTH  32  	// ����32�ֽ��û����ݿ��


//��������
uint8_t NRF24L01_Write_Byte(uint8_t  reg, uint8_t  data);
uint8_t NRF24L01_Write_Bytes(uint8_t  regAddr, uint8_t* pBuffer, uint8_t len);
uint8_t NRF24L01_Read_Byte(uint8_t reg);
uint8_t NRF24L01_Read_Bytes(uint8_t  regAddr, uint8_t* pData, uint8_t len);


void NRF24L01_PowerCtrl(uint8_t NRF_Ctrl_Flag);

#endif
