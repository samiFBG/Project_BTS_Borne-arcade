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

#define VAL_INIT_TMR3_H   0      //Periode = 4µs  (tcyc = 0.1µs) A definir !!!
#define VAL_INIT_TMR3_L   0      //temps election tache )        A définir !!!

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
//             on connecte les sorties de la memoire RAM vers la matrice (R1,B1,V1 et R2,B2,V2 : voir doc 4040)
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
//    NumColonne  : Numero de la colonne (multiplexage) [0..31]
//
void interrupt()
{



























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

#define VAL_CONF_T3CON_EL 0  //A définir !!!

void InitPeriphITMatrix()
{

  //---------------- initialisation timer 3 ------------------//
  tmr3h = VAL_INIT_TMR3_H;
  tmr3l = VAL_INIT_TMR3_L;
  t3con = VAL_CONF_T3CON_EL;

  //-- demasquage IT : affectation ipr2 et pie2 --//





}

//############################################################################//