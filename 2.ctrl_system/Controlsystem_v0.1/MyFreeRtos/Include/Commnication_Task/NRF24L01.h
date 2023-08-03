#ifndef _NRF24L01_H__
#define _NRF24L01_H__


#include <Commnication_Task/bsp_NRF24L01.h>

#define NRF24L01_TX_ADDT_WIDTH	5
#define NRF24L01_RX_ADDT_WIDTH	5


#define TX_MODE		1
#define RX_MODE		2


void NRF24L01_Mode_Choose(uint8_t modeFlag, uint8_t *dataBuffer);
uint8_t NRF24L01_Init();
uint8_t NRF24L01_Self_Test();
uint8_t NRF24L01_Tx_Packet(uint8_t *tx_buffer);
uint8_t NRF24L01_Rx_Packet(uint8_t *rx_buffer);
void NRF24L01_TX_Mode(void);
void NRF24L01_RX_Mode(void);


#endif
