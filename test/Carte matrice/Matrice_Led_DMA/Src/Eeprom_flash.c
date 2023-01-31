/*
 * Eeprom_flash.c
 *
 *  Created on: Sep 26, 2020
 *      Author: Edouard
 */


#include "main.h"
#include "eeprom_flash.h"
//#include "stm32f1xx_hal.h"
#include "commun.h"

void FLASH_PageErase_(uint32_t PageAddress)
{
    // Proceed to erase the page //
    SET_BIT(FLASH->CR, FLASH_CR_PER);
    while (FLASH->SR & FLASH_SR_BSY);
    WRITE_REG(FLASH->AR, PageAddress);
    SET_BIT(FLASH->CR, FLASH_CR_STRT);
    while (FLASH->SR & FLASH_SR_BSY);
    CLEAR_BIT(FLASH->CR, FLASH_CR_PER);
}


/*
 * Must call this first to enable writing
 */
void enableEEPROMWriting() {
    HAL_StatusTypeDef status = HAL_FLASH_Unlock();
    FLASH_PageErase_(EEPROM_START_ADDRESS); // required to re-write
    CLEAR_BIT(FLASH->CR, FLASH_CR_PER);    // Bug fix: bit PER has been set in Flash_PageErase(), must clear it here
}

void disableEEPROMWriting() {
    HAL_FLASH_Lock();
}

/*
 * Writing functions
 * Must call enableEEPROMWriting() first
 */
HAL_StatusTypeDef writeEEPROMHalfWord(uint32_t address, uint16_t data) {
    HAL_StatusTypeDef status;
    address = address + EEPROM_START_ADDRESS;

    status = HAL_FLASH_Program(FLASH_TYPEPROGRAM_HALFWORD, address, data);

    return status;
}

HAL_StatusTypeDef writeEEPROMWord(uint32_t address, uint32_t data) {
    HAL_StatusTypeDef status;
    address = address + EEPROM_START_ADDRESS;

    status = HAL_FLASH_Program(FLASH_TYPEPROGRAM_WORD, address, data);

    return status;
}

/*
 * Reading functions
 */
uint16_t readEEPROMHalfWord(uint32_t address) {
    uint16_t val = 0;
    address = address + EEPROM_START_ADDRESS;
    val = *(__IO uint16_t*)address;

    return val;
}

uint32_t readEEPROMWord(uint32_t address) {
    uint32_t val = 0;
    address = address + EEPROM_START_ADDRESS;
    val = *(__IO uint32_t*)address;

    return val;
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------- lecture ecriture eeprom -----------------//
//
//##################################################################//
// Attention : la totalité de la zone de sauvefgarde doit être lue  //
//                ou ecrite en une seul fois !!!!!				    //
//##################################################################//
//
//   lecture ou ecriture d'une zone de donnée en eeprom
//
//      PE : ptZoneData : pointeur sur la zone de donnée a lire ou ecrire
//           NbData     : nombre d'octet a lire ou ecrire
//           EcrData    : flag de lecture ecriture [VRAI, FAUX]
//           AdrEEprom  : Adresse interne eeprom
//
//      PS : Aucun
//
//   Variable : N/A
//
void EcrLecEEprom(uint8_t *ptZoneData, uint8_t NbData, uint8_t EcrData, uint16_t AdrEEprom)
{
uint8_t i;
HAL_StatusTypeDef Res;
uint16_t Data;


         if (EcrData == VRAI)
         {
        	 enableEEPROMWriting();
        	 HAL_Delay(10);
        	 for (i=0 ; i != NbData ; i++)
        	 {
        		 Data = ptZoneData[i];
        		 Res = writeEEPROMHalfWord((uint32_t)(AdrEEprom+i*2), Data);
        		 HAL_Delay(20);
        	 }
        	 disableEEPROMWriting();
         }
         else
         {
        	 for (i=0 ; i != NbData ; i++)
        	 {
        		 ptZoneData[i] = (uint8_t)(readEEPROMHalfWord((uint32_t)(AdrEEprom+i*2)));
        	 }
         }
}
