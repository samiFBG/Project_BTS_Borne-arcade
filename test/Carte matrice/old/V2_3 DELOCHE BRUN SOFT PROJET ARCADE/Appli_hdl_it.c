//----------------------------------------------------------------------------//
//                                                                            //
// AFFICHEUR GEANT                                                            //
//                                                                            //
// Objet du programme : Gestion horloge temps réélle pour afficheur géant     //
//                                                                            //
// par E. BURTZ                                                               //
// Commencé le 23/02/2007                                                     //
//                                                                            //
// V7.2 : 12/03/07 : tronconnage tache                                        //
//                                                                            //
//----------------------------------------------------------------------------//
//
// handler d'interruption
//

#include "Tache_emi_rec_I2C.h"
#include "Tache_ges_time_out.h"
#include "Tache_com_CAN.h"
#include "Tache_IT_Mtrx.h"
#include "GesMatrix.h"



//
//------------ handler d'interruption haute priorité -------------------------//
//
//   spg IT directement dans Tache IT_Mtrx //

/*void interrupt()
{
  portb.BIT_DEBUG_1 = 1;
  InterruptSpgGesMatrix();
  PIR2.TMR3IF = 0;
  portb.BIT_DEBUG_1 = 0;
}  */

//
//------------ handler d'interruption basse priorité -------------------------//
//
void interrupt_low()
{
/*  if ((PIE1.TXIE) && (PIR1.TXIF))
  {
      //---- gestion emi RS232 -----//
      InterruptSpgEmiRS232();
      PIR1.TXIF = 0;
  }
  else if ((PIE1.RCIE) && (PIR1.RCIF))
  {
      //---- gestion reception RS232 -----//
      InterruptSpgRecRS232();
      PIR1.RCIF = 0;
  }
  else if ((intcon.T0IE) && (intcon.T0IF))
  {
      //---- gestion lecture RFID -----//
      isr_rtcc();
      intcon.T0IF = 0;
  }
  else if ((PIE1.CCP1IE) && (PIR1.CCP1IF))
  {
      //---- gestion lecture RFID -----//
      isr_ccp1();
      PIR1.CCP1IF = 0;
//      lata.BIT_LED_JAUNE = !lata.BIT_LED_JAUNE;
  }
//  else if ((PIE2.CCP2IE) && (PIR2.CCP2IF))  ###
  else if ((PIE2.eccp1ie) && (PIR2.eccp1if))
  {
      //---- gestion lecture RFID -----//
      isr_ccp2();
//      PIR2.CCP2IF = 0; ###
      PIR2.eccp1if = 0;
//      lata.BIT_LED_JAUNE = !lata.BIT_LED_JAUNE;

  }    */
  /*if ((PIE1.SSPIE) && (PIR1.SSPIF))
  {
      //---- gestion I2C ----//
      InterruptSpgEmiRecI2C();
      PIR1.SSPIF = 0;
  }  */

  if ((PIE3.RXB0IE) && (PIR3.RXB0IF))
  {
      //---- gestion com CAN -----//
      InterruptSpgComCAN();
      PIR3.RXB0IF = 0;
  }
  else if ((PIE3.RXB1IE) && (PIR3.RXB1IF))
  {
      //---- gestion com CAN -----//
      InterruptSpgComCAN();
      PIR3.RXB1IF = 0;
  }
  else if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
  {
      //---- gestion time out ----//
      InterruptSpgGesTimeOut();
      PIR1.TMR1IF = 0;

  }
}