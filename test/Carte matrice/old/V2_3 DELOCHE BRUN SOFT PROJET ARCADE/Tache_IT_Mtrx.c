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

unsigned short NumColonne = 0xff;        //[0 .. 15]
unsigned short NumLigne   = 0;           //[0 .. 127]

//-- les volets sont fermés a la MST
unsigned short VoletDroit  = 0;   //128        //[0  .. 126]
unsigned short VoletGauche = 127; //0          //[0  .. 127]


//----------------- variables définie dans d'autre taches --------------------//



//----------------------------- constantes -----------------------------------//

//############################## DELOCHE #####################################//

#define VAL_INIT_TMR3_H   0b11111111      //Periode = 4µs  (tcyc = 0.1µs) 0.1µsx40 = 40µs
//#define VAL_INIT_TMR3_L   0b11011000    //temps election tache )       65536-40 = 65496 => 0b1111111111011000
#define VAL_INIT_TMR3_L   0b11100010      //ajusté a 0xE2 pour prendre en compta le temps d'élection de la tâche


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
//  ATTENTION : le code doit être optimisé afin d'utiliser le moins
//              possible de temps CPU.
//
// (1) Rechargement des registre tmr3h et tmr3l pour une nouvelle it
// (2) gestion des volets :
//        Si le numero du pixel dans la ligne est superieur ou egale au volet gauche ET
//        inférieure ou égale au volet droit :
//             on connecte les sorties de la memoire RAM vers la matrice (R1,B1,V1 et R2,B2,V2 : voir doc TC5020)
//             on genere un front montant sur la matrice (memorisation pixel : voir doc TC5020)
//             on genere un front descendant sur la mémoire (passage au pixel suivant : voir doc 4040)
//        Si non
//             on deconnecte les sorties de la memoire RAM vers la matrice (extinction pixel garce au resistances de rappel)
//             on genere un front montant sur la matrice (memorisation pixel noir)
//             on genere un front descendant sur la mémoire (passage au pixel suivant)
// (3) passage au pixel de la ligne suivante
// (4) si on est au dernier pixel (128)
//        On affiche les pixel de la ligne (latch matrice : voir doc TC5020)
//        On reinitialise le numero de pixel dans la ligne (0)
//        on passe a la colonne suivante
// (5) on acquitte l'interuption (pir2)
//
// Variable globale:
//    NumLigne : Numero du pixel dans la ligne [0..127]
//    VoletGauche : Numero du premier pixel a etre visualisé dans la ligne [0..127]
//    VoletDroit  : Numero du dernier pixel a etre visualisé dans la ligne [0..127]
//    NumColonne  : Numero de la colonne (multiplexage) [0..15]
//
void interrupt()
{
     tmr3h = VAL_INIT_TMR3_H;                                  //(1)
     tmr3l = VAL_INIT_TMR3_L;
     if(NumLigne>=VoletGauche && NumLigne<=VoletDroit)         //(2)
     {
        portc.BIT_OE_MEM = 0;
        //portc.BIT_RW_MEM = 1;    inutile car RW_MEM est deja à 1 par defaut
        portc.BIT_CLK_MTRX = 1;
        portc.BIT_CLK_MEM = 0;
        portc.BIT_CLK_MTRX = 0;
        portc.BIT_CLK_MEM = 1;
     }
     else
     {
        portc.BIT_OE_MEM = 1;
        portc.BIT_CLK_MTRX = 1;
        portc.BIT_CLK_MEM = 0;
        portc.BIT_CLK_MTRX = 0;
        portc.BIT_CLK_MEM = 1;
     }
     NumLigne = Numligne++;                                    //(3)
     if(NumLigne > 127)                                        //(4)
     {
         portc.BIT_LATCH_MTRX = 1;
         NumLigne = 0;
         NumColonne = NumColonne++;
         porta = NumColonne;
         portc.BIT_LATCH_MTRX = 0;
     }
     PIR2.TMR3IF = 0;                                          //(5)
}

//############################################################################//

//############################## DELOCHE #####################################//

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
//   Variable :
//       t3con         : préscaler = 1/1, fosc/4, timer3 on
//       tmr3h - tmr3l : interupption toutes les 4 µs (avec quartz 40 Mhz)
//       ipr2  - pie2  : demasquage IT timer 3 en haute priorité
//                       voir doc PIC18F458 p86 et p89

#define VAL_CONF_T3CON_EL 0b00000001  // R/W 2x8bits ; Timer 3 source clock CCP1/ECCP1 ; préscaler = 1/1 ; Ne pas synchro clock externe ;fosc/4 ; timer3 on

void InitPeriphITMatrix()
{

  //---------------- initialisation timer 3 ------------------//
  tmr3h = VAL_INIT_TMR3_H;
  tmr3l = VAL_INIT_TMR3_L;
  t3con = VAL_CONF_T3CON_EL;

  //-- demasquage IT : affectation ipr2 et pie2 --//
  ipr2.TMR3IP = 1;                   //p86 registre 8-8  00000010 : Priorité Haute d'intéruption de débordement TMR3
  pie2.TMR3IE = 1;                   //p89 registre 8-11 00000010 : Active l'intéruption de débordement TMR3

}

//############################################################################//