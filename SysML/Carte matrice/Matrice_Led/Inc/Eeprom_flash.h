//#define EEPROM_START_ADDRESS   ((uint32_t)0x08019000) // EEPROM emulation start address: after 100KByte of used Flash memory
#define EEPROM_START_ADDRESS   ((uint32_t)0x0801C000) // EEPROM emulation start address: after 112KByte of used Flash memory
//#define EEPROM_START_ADDRESS   ((uint32_t)0x0801E000) // EEPROM emulation start address: after 112KByte of used Flash memory
void enableEEPROMWriting(); // Unlock and keep PER cleared
void disableEEPROMWriting(); // Lock

// Write functions
HAL_StatusTypeDef writeEEPROMHalfWord(uint32_t address, uint16_t data);
HAL_StatusTypeDef writeEEPROMWord(uint32_t address, uint32_t data);

// Read functions
uint16_t readEEPROMHalfWord(uint32_t address);
uint32_t readEEPROMWord(uint32_t address);


//##################################################################//
// Attention : la totalité de la zone de sauvefgarde doit être lue  //
//                ou ecrite en une seul foix !!!!!				    //
//##################################################################//
void EcrLecEEprom(uint8_t *ptZoneData, uint8_t NbData, uint8_t EcrData, uint16_t AdrEEprom);
