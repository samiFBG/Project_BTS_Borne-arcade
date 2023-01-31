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

uint8_t NumColonne = 0xff;        //[0 .. 15]
uint8_t NumLigne   = 0;           //[0 .. 127]

//-- les volets sont fermés a la MST

uint8_t VoletDroit  = 0;   //128        //[0  .. 126]
uint8_t VoletGauche = 127; //0          //[0  .. 127]


//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//          spg d'interruption timer 3                   //
//     (gestion matrice led: IT cyclique à 5µs)          //
//                                                       //
//-------------------------------------------------------//
//
//
// Variable:
//
//
void SpgIntMatrice()
{
  //portb.BIT_DEBUG_1 = 1;
  // gestion des volets
  if ((NumLigne >= VoletGauche) && (NumLigne <= VoletDroit))
  {
     /*portc.BIT_OE_MEM = 0;
     portc.BIT_CLK_MTRX = 1;     //-- gene front d'horloge
     portc.BIT_CLK_MEM = 0;
     portc.BIT_CLK_MTRX = 0;
     portc.BIT_CLK_MEM = 1;*/
	 HAL_GPIO_WritePin(OE_MEM_GPIO_Port, OE_MEM_Pin, GPIO_PIN_RESET);
	 HAL_GPIO_WritePin(CLK_MTRX_GPIO_Port, CLK_MTRX_Pin, GPIO_PIN_SET);
	 HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_RESET);
	 HAL_GPIO_WritePin(CLK_MTRX_GPIO_Port, CLK_MTRX_Pin, GPIO_PIN_RESET);
	 HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_SET);

  }
  else
  {
     /*portc.BIT_OE_MEM = 1;       //-- on force a zro la donnée
     portc.BIT_CLK_MTRX = 1;     //-- gene front d'horloge
     portc.BIT_CLK_MEM = 0;
     portc.BIT_CLK_MTRX = 0;
     portc.BIT_CLK_MEM = 1; */
     HAL_GPIO_WritePin(OE_MEM_GPIO_Port, OE_MEM_Pin, GPIO_PIN_SET);
     HAL_GPIO_WritePin(CLK_MTRX_GPIO_Port, CLK_MTRX_Pin, GPIO_PIN_SET);
     HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_RESET);
     HAL_GPIO_WritePin(CLK_MTRX_GPIO_Port, CLK_MTRX_Pin, GPIO_PIN_RESET);
     HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_SET);
  }

  NumLigne++;
  //if (NumLigne.F7)
  if ((NumLigne & TST_BIT7) != 0)  //en fait, le numero du point dans la ligne (colonne)
  {
     //portc.BIT_LATCH_MTRX = 1;
	 HAL_GPIO_WritePin(LATCH_MTRX_GPIO_Port, LATCH_MTRX_Pin, GPIO_PIN_SET);
     NumLigne = 0;
     //porta++;
     NumColonne++;                 //en fait, le numero de la ligne
     //porta = NumColonne;
     HAL_GPIO_WritePin(LIGNE_A_GPIO_Port, LIGNE_A_Pin, (NumColonne & TST_BIT0));
     HAL_GPIO_WritePin(LIGNE_B_GPIO_Port, LIGNE_B_Pin, ((NumColonne & TST_BIT1) >> 1));
     HAL_GPIO_WritePin(LIGNE_C_GPIO_Port, LIGNE_C_Pin, ((NumColonne & TST_BIT2) >> 2));
     HAL_GPIO_WritePin(LIGNE_D_GPIO_Port, LIGNE_D_Pin, ((NumColonne & TST_BIT3) >> 3));
     //portc.BIT_LATCH_MTRX = 0;
     HAL_GPIO_WritePin(LATCH_MTRX_GPIO_Port, LATCH_MTRX_Pin, GPIO_PIN_RESET);
  }


  //PIR2.TMR3IF = 0;
  //portb.BIT_DEBUG_1 = 0;
}


/*  en remplacement de l'IRQ handler
void EB_TIM_IRQHandler(TIM_HandleTypeDef *htim)
{
  // TIM Update event //
  if (__HAL_TIM_GET_FLAG(htim, TIM_FLAG_UPDATE) != RESET)
  {
    if (__HAL_TIM_GET_IT_SOURCE(htim, TIM_IT_UPDATE) != RESET)
    {
      __HAL_TIM_CLEAR_IT(htim, TIM_IT_UPDATE);
      //HAL_TIM_PeriodElapsedCallback(htim);
    }
  }
} */
