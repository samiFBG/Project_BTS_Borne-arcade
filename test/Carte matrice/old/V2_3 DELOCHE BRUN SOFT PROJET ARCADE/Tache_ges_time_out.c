//----------------------------------------------------------------------------//
//                                                                            //
// Objet du programme : Tache de gestion time out                             //
//                                                                            //
//                                                                            //
//----------------------------------------------------------------------------//
//
//

#include "Tache_ges_time_out.h"
#include "commun.h"
//#include "Tache_com_CAN.h"
#include "GesMatrix.h"
#include "Tache_IT_Mtrx.h"


//------------------ definition variable globales visibles -------------------//

unsigned int TimeOut;


//---------------------- variables dglobale tache ----------------------------//

unsigned short TempoVolet = 0;
unsigned short DebutVolet = VRAI;


//----------------------- constantes communes --------------------------------//



#define VAL_INIT_TMR1_H  0xFB            // IT toute les 1000 µs avec quartz 40 MHz
#define VAL_INIT_TMR1_L  0x1E            //

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
//               spg d'interruption timer 1              //
//           gestion time out cyclique (1 ms)            //
//                                                       //
//-------------------------------------------------------//
//
// Ce sous programme permet la gestion des volets. Elle
// est cyclique à 1 ms.
//
// Variable :
//

void InterruptSpgGesTimeOut()
{

  tmr1h = VAL_INIT_TMR1_H;
  tmr1l = VAL_INIT_TMR1_L;

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
                     pie1.TMR1IE = 0;
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
                     pie1.TMR1IE = 0;
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
                     pie1.TMR1IE = 0;
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
                     pie1.TMR1IE = 0;
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
                     pie1.TMR1IE = 0;
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
                     pie1.TMR1IE = 0;
                 }
             }
             break;
         }
      }
  }
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

//-------------------------------- init timer 2 --------------------------------//

#define VAL_CONF_T1CON 0b00110001        // préscaler = 1/8, fosc/4, timer1 on


void InitPeriphGesTimeOut()
{

  //---------------- initialisation timer 2 ------------------//
  tmr1h = VAL_INIT_TMR1_H;
  tmr1l = VAL_INIT_TMR1_L;
  t1con = VAL_CONF_T1CON;

  //-- demasquage IT --//
  ipr1.TMR1IP = 0;     //basse priorité
  pie1.TMR1IE = 0;     //IT masquée au démarrage
  
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                          projet :           //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//--------- initialisation variable globales ------------//
//
//      PE : Aucun
//      PS : Aucun
//
//   Variable : toutes les variables globales
//
void IniTVarGlGesTimeOut()
{


}