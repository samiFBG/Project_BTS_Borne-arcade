/*
 * Tache_IT_Matrice.c
 *
 *  Created on: 29 janv. 2022
 *      Author: edouard
 */

#include "main.h"
#include "Tache_IT_Matrice.h"
//#include "Eeprom_flash.h"
#include "commun.h"



//------------------ definition variable globales visibles -------------------//

uint8_t NumColonne = 0; //0xff;        //[0 .. 15]  (-1 pour la 1ere fois à la MST)
uint8_t NumLigne   = 0;           //[0 .. 127]

//-- les volets sont fermés a la MST

uint8_t VoletDroit  = 0;   //128        //[0  .. 126]
uint8_t VoletGauche = 127; //0          //[0  .. 127]

uint32_t SaveODR;
//uint16_t OffAcces = 0;

uint8_t RazLigneColonne = FAUX;


//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//          spg d'interruption timer 3                   //
//     (gestion matrice led: IT cyclique à 4µs)          //
//                                                       //
//-------------------------------------------------------//
//
//
// (1) gestion des volets :
//        Si le numero du pixel dans la ligne est superieur ou egale au volet gauche ET
//        inférieure ou égale au volet droit :
//             on genere un front montant sur la matrice (Passage au pixel suivant): voir doc TC5020)
//        Si non
//             on ecrit un 0 sur les données de la matrice, R1,G1,B1,R2, G2,B2 (extinction pixel), utilisez un seul HAL_GPIO_WritePin()!
//             on genere un front montant sur la matrice (Passage au pixel suivant : noir) voir doc TC5020
// (3) passage au pixel de la ligne suivante (incrementation variable)
// (4) si on est au dernier pixel (128)
//        On affiche les pixel de la ligne mémorisés (latch matrice : voir doc TC5020)
//        On reinitialise le numero de pixel dans la ligne (0)
//        on passe a la colonne suivante (modulo 16)
// (5) Si une demande de raz lingne et colonne est demandé, on l'effectue (image transmise completement)
//
// Variable globale:
//
//    NumLigne : Numero du pixel dans la ligne [0..127]
//    VoletGauche : Numero du premier pixel a etre visualisé dans la ligne [0..127]
//    VoletDroit  : Numero du dernier pixel a etre visualisé dans la ligne [0..127]
//    NumColonne  : Numero de la colonne (multiplexage) [0..15]
//    RazLigneColonne : demande de raz ligne et colonne [VRAI, FAUX]
//
//
//#define RESET_PB15_PB10 0xFFFF03FF
#define NB_COLONNE 128
#define MASQUE_16 0b00001111

void SpgIntMatrice()
{
	if(NumLigne >= VoletGauche && NumLigne <= VoletDroit ){
		HAL_GPIO_WritePin(CLK_MTRX_GPIO_Port,CLK_MTRX_PIN,GPIO_PIN_SET);
		HAL_GPIO_WritePin(CLK_MTRX_GPIO_Port,CLK_MTRX_PIN,GPIO_PIN_RESET);

	}else{
		HAL_GPIO_WritePin(R1_GPIO_Port,R1_PIN | R2_PIN | B1_PIN | B2_PIN | G1_PIN | G2_PIN,GPIO_PIN_RESET);
		HAL_GPIO_WritePin(CLK_MTRX_GPIO_Port,CLK_MTRX_PIN,GPIO_PIN_SET);
		HAL_GPIO_WritePin(CLK_MTRX_GPIO_Port,CLK_MTRX_PIN,GPIO_PIN_RESET);

	}
	NumLigne++;
	if(NumLigne == NB_COLONNE){
		HAL_GPIO_WritePin(LATCH_MTRX_GPIO_Port,LATCH_MTRX_PIN,GPIO_PIN_SET);
		HAL_GPIO_WritePin(LATCH_MTRX_GPIO_Port,LATCH_MTRX_PIN,GPIO_PIN_RESET);
		NumLigne = 0;
		NumColonne = (Numcolonne++) & MASQUE_16;
	}
	if(RazLigneColonne == VRAI){
		NumLigne   = 0;
		NumColonne = 0;
		RazLigneColonne = FAUX;
	}
}

//################################################################//
// Attention, apres toute génération par CubeMX, il faut modifier //
// la fonction "TIM2_Irq_Handler" dans "stm32f1xx_it.c"           //
//################################################################//

/*  en remplacement de l'IRQ handler
  HAL_GPIO_WritePin(DBG1_GPIO_Port,DBG1_Pin, GPIO_PIN_SET);
  if (__HAL_TIM_GET_IT_SOURCE(&htim2, TIM_IT_UPDATE) != RESET)
  {
     __HAL_TIM_CLEAR_IT(&htim2, TIM_IT_UPDATE);
  }
  SpgIntMatrice();
  HAL_GPIO_WritePin(DBG1_GPIO_Port,DBG1_Pin, GPIO_PIN_RESET);
 */
