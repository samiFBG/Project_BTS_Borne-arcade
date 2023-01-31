/*
 * Tache_ges_volet.c
 *
 *  Created on: 22 févr. 2022
 *      Author: edouard
 */
#include "main.h"
#include "commun.h"
#include "Tache_IT_Matrice.h"


//------------------ definition variable globales visibles -------------------//

uint16_t TimeOut;


//---------------------- variables dglobale tache ----------------------------//

uint8_t TempoVolet = 0;
uint8_t DebutVolet = VRAI;


uint8_t MemITTimer = 0;


//----------------------- constantes communes --------------------------------//

#define G_INIT_VG_O 0x7F
#define G_INIT_VD_O 0x7E
#define G_INIT_VG_F 0
#define G_INIT_VD_F 0x7E

#define D_INIT_VG_O 0x7F
#define D_INIT_VD_O 0
#define D_INIT_VG_F 0
#define D_INIT_VD_F 0x7E

#define C_INIT_VG_O 0x40
#define C_INIT_VD_O 0x3F
#define C_INIT_VG_F 0
#define C_INIT_VD_F 0x7E

//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//          spg d'interruption timer 1                   //
//     (gestion volet: IT cyclique à 1ms)                /
//                                                       //
//-------------------------------------------------------//
//
// Ce sous programme permet la gestion des volets. Elle
// est cyclique à 1 ms.
//
// Variable:
//
//
void SpgIntVolet()
{
	  TempoVolet++;
	  if (TempoVolet == AppelImg.TempoVolet)
	  {
	      TempoVolet = 0;
	      //-- maj volet en cours --//
	      switch (AppelImg.TypeVolet)
	      {
	         //-- ouverture volet gauche --//
	         case V_GAUCHE_O:
	         {
	             if (DebutVolet == VRAI)
	             {
	                //-- Init volet --//
	                VoletGauche = G_INIT_VG_O;
	                VoletDroit  = G_INIT_VD_O;
	                DebutVolet = FAUX;
	             }
	             else
	             {
	                 //-- ouverture --//
	                 VoletGauche--;
	                 if (VoletGauche == G_INIT_VG_F)
	                 {
	                     DebutVolet = VRAI;
	                     //#########################//
	                     //pie1.TMR1IE = 0;
	                     VoletDroit = G_INIT_VD_O+1;  //correction bug affichage dernier colonne
	                     HAL_TIM_Base_Stop_IT(&htim1);
	                     MemITTimer = 0;
	                 }
	             }
	             break;
	         }
	         //-- fermeture volet gauche --//
	         case V_GAUCHE_F:
	         {
	             if (DebutVolet == VRAI)
	             {
	                //-- Init volet --//
	                VoletGauche = G_INIT_VG_F;
	                VoletDroit  = G_INIT_VD_F;
	                DebutVolet = FAUX;
	             }
	             else
	             {
	                 //-- fermeture --//
	                 VoletGauche++;
	                 if (VoletGauche == G_INIT_VG_O)
	                 {
	                     DebutVolet = VRAI;
	                     //########################//
	                     //pie1.TMR1IE = 0;
	                     HAL_TIM_Base_Stop_IT(&htim1);
	                     MemITTimer = 0;
	                 }
	             }
	             break;
	         }
	         //-- ouverture volet droit --//
	         case V_DROITE_O:
	         {
	             if (DebutVolet == VRAI)
	             {
	                //-- Init volet --//
	                VoletGauche = D_INIT_VG_O;
	                VoletDroit  = D_INIT_VD_O;
	                DebutVolet = FAUX;
	             }
	             else
	             {
	                 //-- ouverture --//
	                 if (VoletGauche == D_INIT_VG_O)    //cas particulier ouverture volet droit
	                     VoletGauche = D_INIT_VG_F;     //
	                 else
	                     VoletDroit++;
	                 if (VoletDroit == D_INIT_VD_F)
	                 {
	                     DebutVolet = VRAI;
	                     //#############################//
	                     //pie1.TMR1IE = 0;
	                     VoletDroit = D_INIT_VD_F+1;  //correction bug affichage dernier colonne
	                     HAL_TIM_Base_Stop_IT(&htim1);
	                     MemITTimer = 0;
	                 }
	             }
	             break;
	         }
	         //-- fermeture volet droit --//
	         case V_DROITE_F:
	         {
	             if (DebutVolet == VRAI)
	             {
	                //-- Init volet --//
	                VoletGauche = D_INIT_VG_F;
	                VoletDroit  = D_INIT_VD_F;
	                DebutVolet = FAUX;
	             }
	             else
	             {
	                 //-- fermeture --//
	                 if (VoletGauche == D_INIT_VG_O)
	                 {
	                     DebutVolet = VRAI;
	                     //#############################//
	                     //pie1.TMR1IE = 0;
	                     HAL_TIM_Base_Stop_IT(&htim1);
	                     MemITTimer = 0;
	                 }
	                 if (VoletDroit == D_INIT_VD_O)
	                    VoletGauche = D_INIT_VG_O;
	                 if (VoletGauche == D_INIT_VG_F)
	                    VoletDroit--;
	             }
	             break;
	         }
	         //-- ouverture volet central --//
	         case V_CENTRE_O:
	         {
	             if (DebutVolet == VRAI)
	             {
	                //-- Init volet --//
	                VoletGauche = C_INIT_VG_O;
	                VoletDroit  = C_INIT_VD_O;
	                DebutVolet = FAUX;
	             }
	             else
	             {
	                 //-- ouverture --//
	                 VoletGauche--;
	                 VoletDroit++;
	                 if (VoletGauche == C_INIT_VG_F)
	                 {
	                     DebutVolet = VRAI;
	                     //#############################//
	                     //pie1.TMR1IE = 0;
	                     HAL_TIM_Base_Stop_IT(&htim1);
	                     MemITTimer = 0;
	                 }
	             }
	             break;
	         }
	         //-- fermeture volet central --//
	         case V_CENTRE_F:
	         {
	             if (DebutVolet == VRAI)
	             {
	                //-- Init volet --//
	                VoletGauche = C_INIT_VG_F;
	                VoletDroit  = C_INIT_VD_F;
	                DebutVolet = FAUX;
	             }
	             else
	             {
	                 //-- fermeture --//
	                 VoletGauche++;
	                 VoletDroit--;
	                 if (VoletGauche == C_INIT_VG_O)
	                 {
	                     DebutVolet = VRAI;
	                     //#############################//
	                     //pie1.TMR1IE = 0;
	                     HAL_TIM_Base_Stop_IT(&htim1);
	                     MemITTimer = 0;
	                 }
	             }
	             break;
	         }
	      }
	  }
}
