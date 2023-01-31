//----------------------------------------------------------------------------//
//                                                                            //
// Objet du programme : Gestion horloge temps réélle                          //
//                                                                            //
// par E. BURTZ                                                               //
// Commencé le 23/02/2007                                                     //
//                                                                            //
//----------------------------------------------------------------------------//
//
// tache emission reception I2C
//

#ifndef EMI_REC_I2C

#define EMI_REC_I2C 1

//void InterruptSpgEmiRecI2C();
void InitPeriphEmiRecI2C();
void IniTVarGlEmiRecI2C();
//void EcrCAT24M01 (char NbOctetEcr, char AdresseInt, char *ptBuffEcr);
//void LecCAT24M01 (char NbOctetLec, unsigned int AdresseInt, char *ptBuffLec);
unsigned short EcrI2CPoll(unsigned int AdresseInt, unsigned short PageHaute,
                          unsigned short *ptBuffEcr, unsigned int NbData);
unsigned short EcrAdrIntPoll(unsigned int AdresseInt, unsigned short PageHaute);
void LecI2CPoll(unsigned int NbByte2Read, unsigned short *ptBufferRead);


//----------------- definition des variable du SPG I2C -----------------------//

extern unsigned short WordAdressI2C;
extern unsigned short NbOctetEcrI2C;
extern unsigned short AdresseI2C;
extern unsigned short *PtBuffEcrI2C;
extern unsigned short StatusI2C;
#define BIT_EMI_ADR_INT      F0
#define BIT_START_EMI        F1
#define BIT_REC_FIRST_BYTE   F5
#define BIT_EMI_ACK          F6
#define BIT_RECEPTION_I2C    F7
extern unsigned short NbOctetLecI2C;
extern unsigned short *PtBuffLecI2C;

#endif