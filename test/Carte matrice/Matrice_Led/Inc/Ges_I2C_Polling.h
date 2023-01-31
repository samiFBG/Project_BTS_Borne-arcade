

uint8_t EcrI2CPoll(uint16_t AdresseInt, uint8_t PageHaute, uint8_t *ptBuffEcr, uint16_t NbData);
uint8_t EcrAdrIntPoll(uint16_t AdresseInt, uint8_t PageHaute);
void LecI2CPoll(uint16_t NbByte2Read, uint8_t *ptBufferRead);
