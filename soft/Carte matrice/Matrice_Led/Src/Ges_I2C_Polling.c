#include "main.h"
#include "Ges_I2C_Polling.h"
//#include "Matrice_Led.h"
#include "commun.h"

#define ADR_CAT24M01  0b10100000
#define SET_PAGE_H    0b00000010

#define TO_ECR_I2C_DATA 50   	//-- ecriture 256 octet en memoire : 26 ms
#define TO_ECR_I2C_ADR_INT 1
#define TO_READ_I2C     50


//##################### Etudiant 1 ######################//

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
//   En fonction de la page demandée, on positionne l'adresse de la mémoire I2C correspondante (voir doc technique)
//   On effectue l'ecriture dans la memoire a l'adresse interne spécifiée du buffer df'ecriture
//   Si le resultat de l'ecriture n est pas OK, on positionne le parametre de retour a FAUX
//
//   Variable : hi2c1
//
//   Fonction utilisées : voir librairie HAL pour la gestion de l'I2C
//
uint8_t EcrI2CPoll(uint16_t AdresseInt, uint8_t PageHaute, uint8_t *ptBuffEcr, uint16_t NbData)
{

uint8_t   Res = VRAI;











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
//   En fonction de la page demandée, on positionne l'adresse de la mémoire I2C correspondante (voir doc technique)
//   On effectue l'ecriture du pointeur interne de la mémoire (attention sur 2 octets !)
//   Si le resultat de l'ecriture n est pas OK, on positionne le parametre de retour a FAUX
//
//   Variable : hi2c1
//
//   Fonction utilisées : voir librairie HAL pour la gestion de l'I2C
//
uint8_t EcrAdrIntPoll(uint16_t AdresseInt, uint8_t PageHaute)
{
uint8_t Res = VRAI;












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
//   On effectue la lecture du nombre d'octet demandée et on les places dans le buffer de reception
//
//   Variable : hi2c1
//
//   Fonction utilisées : voir librairie HAL pour la gestion de l'I2C
//
void LecI2CPoll(uint16_t NbByte2Read, uint8_t *ptBufferRead)
{




}


//#######################################################//
