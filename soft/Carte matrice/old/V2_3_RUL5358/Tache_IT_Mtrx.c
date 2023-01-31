//----------------------------------------------------------------------------//
//                                                                            //
// Borne d'arcade : carte gestion matrice led                                 //
//                                                                            //
//                                                                            //
//----------------------------------------------------------------------------//
//
//


#include "commun.h"
#include "GesMatrix.h"
#include "Tache_IT_Mtrx.h"
//#include "built_in.h"

//----------- definition des variable du SPG d'interuption  ------------------//



//------------------ definition variable globales visibles -------------------//

unsigned short NumColonne = 0x0f;           //[0 .. 15]
unsigned short NumLigne   = 0;           //[0 .. 127]

//-- les volets sont fermés a la MST
unsigned short VoletDroit  = 0;   //128        //[0  .. 126]
unsigned short VoletGauche = 127; //0          //[0  .. 127]


//----------------- variables définie dans d'autre taches --------------------//



//----------------------------- constantes -----------------------------------//

#define VAL_INIT_TMR3_H   0xFF      //Periode = 4µs  (tcyc = 0.1µs)
#define VAL_INIT_TMR3_L   0xE2      //temps election tache )

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
// Variable:
//
//
void interrupt()
{
  //portb.BIT_DEBUG_1 = 1;
  
  tmr3h = VAL_INIT_TMR3_H;
  tmr3l = VAL_INIT_TMR3_L;

  // gestion des volets
  if ((NumLigne >= VoletGauche) && (NumLigne <= VoletDroit))
  {
     portc.BIT_OE_MEM = 0;
     portc.BIT_CLK_MTRX = 1;     //-- gene front d'horloge
     portc.BIT_CLK_MEM = 0;
     portc.BIT_CLK_MTRX = 0;
     portc.BIT_CLK_MEM = 1;
  }
  else
  {
     portc.BIT_OE_MEM = 1;       //-- on force a zro la donnée
     portc.BIT_CLK_MTRX = 1;     //-- gene front d'horloge
     portc.BIT_CLK_MEM = 0;
     portc.BIT_CLK_MTRX = 0;
     portc.BIT_CLK_MEM = 1;
  }
  
  NumLigne++;
  if (NumLigne.F7)
  {
     portc.BIT_LATCH_MTRX = 1;
     NumLigne = 0;
     //porta++;
     //------ modification compatibilité RULxxx
     porta.BIT_LG_D = NumColonne.F3;
     if ((NumColonne == 0) || (NumColonne == 8))
       porta.BIT_LG_B = 1;
     else
       porta.BIT_LG_B = 0;
     porta.BIT_LG_A = 1;
     porta.BIT_LG_A = 1;
     porta.BIT_LG_A = 0;
     NumColonne++;
     NumColonne = (NumColonne & RESET_B7B4);
     //     porta = NumColonne;
     portc.BIT_LATCH_MTRX = 0;
     porta.BIT_LG_C = 0;
     
     tmr3h = VAL_INIT_TMR3_H;
     tmr3l = VAL_INIT_TMR3_L;
  }

  PIR2.TMR3IF = 0;
  //portb.BIT_DEBUG_1 = 0;
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                       projet :              //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------- initialisation periphérique  ------------//
//
//      PE : Aucun
//      PS : Aucun
//
//   Variable : toutes les variables globales
//



void InitPeriphITMatrix()
{

  //---------------- initialisation timer 3 ------------------//
  tmr3h = VAL_INIT_TMR3_H;
  tmr3l = VAL_INIT_TMR3_L;
  t3con = VAL_CONF_T3CON_HS;

  //-- demasquage IT --//
  ipr2.TMR3IP = 1;     //haute priorité
  pie2.TMR3IE = 1;

}