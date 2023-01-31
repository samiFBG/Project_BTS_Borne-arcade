#include "main.h"
#include "Ges_I2C_Polling.h"
//#include "Matrice_Led.h"
#include "commun.h"

#define ADR_CAT24M01  0b10100000
#define SET_PAGE_H    0b00000010

#define TO_ECR_I2C_DATA 50   	//-- ecriture 256 octet en memoire : 26 ms
#define TO_ECR_I2C_ADR_INT 1
#define TO_READ_I2C     50

//-------------------------------------------------------//
//                                                       //
// Sociéte :                           projet :          //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//---------- spg d'ecriture I2C (en polling) ------------//
//
//      PE : AdresseInt : adresse interne composant I2C (16 bits)
//           PageHaute  : page superieur [VRAI, FAUX]
//           ptBuffEcr  : pointeur sur les données a ecrire
//           NbData     : nombre de donnée à écrire
//      PS : EcrOK      EcrAdr: resultat positionnement [VRAI, FAUX]
//
//   Variable : hi2c1
//
uint8_t EcrI2CPoll(uint16_t AdresseInt, uint8_t PageHaute, uint8_t *ptBuffEcr, uint16_t NbData)
{

uint16_t  AdrCAT = ADR_CAT24M01;
HAL_StatusTypeDef Etat;
uint8_t   Res = VRAI;

    if (PageHaute == VRAI)
       AdrCAT = AdrCAT | SET_PAGE_H;

    //Etat = HAL_I2C_Master_Transmit (&hi2c1, AdrCAT, ptBuffEcr, NbData, TO_ECR_I2C_DATA);
    Etat = HAL_I2C_Mem_Write(&hi2c1, AdrCAT, AdresseInt, 2,  ptBuffEcr, NbData, TO_ECR_I2C_DATA);
    if (Etat != HAL_OK)
      Res = FAUX;

    return Res;
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//---- spg de positionnement de l'adresse interne -------//
//
//      PE : AdresseInt : adresse interne composant I2C (16 bits)
//           PageHaute  : page superieur [VRAI, FAUX]
//      PS : EcrOK      EcrAdr: resultat positionnement [VRAI, FAUX]
//
//   Variable :
//
uint8_t EcrAdrIntPoll(uint16_t AdresseInt, uint8_t PageHaute)
{
uint8_t Res = VRAI;
uint16_t AdrCAT = ADR_CAT24M01;
uint8_t AdrIntTab[2];
HAL_StatusTypeDef Etat;

    AdrIntTab[0] = (uint8_t)(AdresseInt >> 8);
    AdrIntTab[1] = (uint8_t)(AdresseInt);


    if (PageHaute == VRAI)
       AdrCAT = AdrCAT | SET_PAGE_H;

    Etat = HAL_I2C_Master_Transmit (&hi2c1, AdrCAT, AdrIntTab, 2, TO_ECR_I2C_ADR_INT);
    if (Etat != HAL_OK)            // vérifiaction acquittement
       Res = FAUX;


    return Res;
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//---- spg de positionnement de l'adresse interne -------//
//
//      PE : NbByte2Read : Nb d'octet a lire [1 à 256]
//           ptBuffread  : pointeur sur le buffer ou stocker les données lues
//      PS : LecOK       : resultat lecture [VRAI, FAUX]
//
//   Variable :
//
void LecI2CPoll(uint16_t NbByte2Read, uint8_t *ptBufferRead)
{

HAL_StatusTypeDef Etat;

    Etat = HAL_I2C_Master_Receive (&hi2c1, ADR_CAT24M01+1, ptBufferRead, NbByte2Read, TO_READ_I2C);

}

