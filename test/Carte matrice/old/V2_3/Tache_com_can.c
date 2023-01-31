//----------------------------------------------------------------------------//
//                                                                            //
//                                                                            //
//----------------------------------------------------------------------------//
//
//

#include "Commun.h"
#include "GesMatrix.h"
#include "Tache_IT_Mtrx.h"
#include "Tache_com_CAN.h"
#include "built_in.h"
#include "Tache_emi_rec_I2C.h"
//#include "Tache_ges_time_out.h"

//------------- déclaration des entetes de procédure -------------------------//

void InitComCAN();
void GesRecImage(unsigned short *ptDataRec);
void GesCmdImage(unsigned short *ptDataRec, t_AppImg *ptAppelImg);
void GesMajEEprom(long Id_, unsigned short *ptDataRec);

//----------- definition des variable du SPG d'interuption timer3 ------------//

//-- variable CAN --//
long id;
unsigned short DataRec[8];
unsigned short Len;
unsigned short StatusCAN;

unsigned short Config_can1;
unsigned short DataEEp[32];


//------------------ definition variable globales visibles -------------------//

//#define REC_OK  0
//#define BIT_ERR_EEP 0
//#define BIT_ERR_CHK 1
//#define BIT_ERR_HDF 2
unsigned short RecOK = REC_OK;
unsigned short ModeEnCours = RETROPI;


//#define LG_TAB_MATRIX 256
unsigned short TabMatrix[512] absolute 0x100;



//-------------------------------------------------------//
//                                                       //
// Sociéte :         projet : distributeur jeton casino  //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//          spg de recption bus CAN (asynchrone)         //
//                                                       //
//-------------------------------------------------------//
//
#define HEADER_1 0x55
#define HEADER_2 0xAA

void InterruptSpgComCAN()
{
unsigned short Res, i, Param;


    //
    //--------------- reception CAN --------------------//
    //
    Res = CANRead(&id, DataRec , &Len, &StatusCAN);
    if (Res != 0)
    {
       //
       //-------- reception trame image bitmap ----------//
       //
       if (id == ID_REC_IMG_BMP)
       {
           GesRecImage(DataRec);
       }
       //
       //-------- reception trame commaned image ----------//
       //
       if (id == ID_REC_IMG_CMD)
       {
           GesCmdImage(DataRec, &AppelImg);
       }
       //
       //---------- reception jeu en cours ----------------//
       //
       if (id == ID_MSG_REC_ST_PAY)
       {
           ModeEnCours = DataRec[1];
       }
       //
       //---------- reception maj eeprom ------------------//
       if ((id & MASK_ACCEPT_B2) == ID_MSG_CONFIG_EEP)
       {
           GesMajEEprom(id, DataRec);
       }
    }

}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ gestion reception et memo image ----------//
//
//      PE : ptDataRec : pointeur sur les données CAN recues
//
//
//      PS : Aucun
//
// Variable globale : TabMatrix[], RecOK
//
void GesRecImage(unsigned short *ptDataRec)
{
static unsigned short HeaderOK  = FAUX;
static unsigned short RecHeader = FAUX;
static unsigned short HeaderFin = FAUX;

static unsigned short NumOctet = 0;
//#define NB_PART_IMG 16              //-- 1 image = 4096 Octets (16 pages de 256 octets)
static unsigned short NumPartImg = 0;      //-- partie de l'image [0 .. 15]
static unsigned short NumImage = 0;        //-- numero de l'image [0 .. 31]  (32 images mémorisables)
static unsigned short ChkImg   = 0;



//#define IMG_PAGE_BAS 16             //image stockée dans Page basse eep
static unsigned short PageHt = FAUX;
static unsigned int AdrInt = 0;

unsigned short i, Res;

     //--------------- test reception header debut -----------//
     if ((ptDataRec[0] == HEADER_1) && (ptDataRec[7] == HEADER_2))
     {
        //portb.BIT_DEBUG_1 = 1;
        //-- reconnaissance header --//
        HeaderOK = VRAI;
        NumImage = ptDataRec[1];
        for (i=2 ; i!=7 ; i++)
          if (ptDataRec[i] != 0) HeaderOK = FAUX;
        if (HeaderOK == VRAI)
        {
            //-- initialisation reception image --//
            RecHeader = VRAI;
            NumOctet   = 0;
            NumPartImg = 0;
            ChkImg     = 0;
            RecOK = REC_OK;
            t3con = VAL_CONF_T3CON_LS;  //diminution vitesse affichage
            //pie2.TMR3IE = 0;            //debug
        }
     }
     //--------------- test reception header Fin -----------//
     if (HeaderFin == VRAI)
     {
        //-- verification header de fin --//
        if ((ptDataRec[0] == HEADER_2) && (ptDataRec[7] == HEADER_1))
        {
            //-- verification checksum --//
            if (ChkImg == DataRec[2])
            {
                //-- ecriture chk en eeprom --//
                EEPROM_Write(OFF_CHK_IMG+NumImage, ChkImg);
            }
            else
                RecOK.BIT_ERR_CHK = 1;
        }
        else
            RecOK.BIT_ERR_HDF = 1;
        HeaderFin = FAUX;
        t3con = VAL_CONF_T3CON_HS;  //reinitialisation vitesse affichage
        //pie2.TMR3IE = 1;            //debug
        //portb.BIT_DEBUG_1 = 0;
     }
     //------------- test reception donnée utile -----------//
     if (HeaderOK == VRAI)
     {
        if (RecHeader == VRAI)
              RecHeader = FAUX;
        else
        {
              //-- calcul checksum --//
              ChkImg = ChkImg + ptDataRec[0] + ptDataRec[1] + ptDataRec[2] + ptDataRec[3];
              ChkImg = ChkImg + ptDataRec[4] + ptDataRec[5] + ptDataRec[6] + ptDataRec[7];
              //-- Reception trame utile --//
              TabMatrix[NumOctet++] = ptDataRec[0];
              TabMatrix[NumOctet++] = ptDataRec[1];
              TabMatrix[NumOctet++] = ptDataRec[2];
              TabMatrix[NumOctet++] = ptDataRec[3];
              TabMatrix[NumOctet++] = ptDataRec[4];
              TabMatrix[NumOctet++] = ptDataRec[5];
              TabMatrix[NumOctet++] = ptDataRec[6];
              TabMatrix[NumOctet++] = ptDataRec[7];
              if (NumOctet == 0)
              {
                  //-- RAM pleine, on ecrit dans l'eeprom --//
                  //-- durée d ecriture < à 14ms --//
                  //-- selection page eeprom
                  if (NumImage >= IMG_PAGE_BAS)
                  {
                      PageHt = VRAI;
                      //-- calcul adresse interne
                      AdrInt     = 0;
                      Hi(AdrInt) = ((NumImage - IMG_PAGE_BAS) << 4) + NumPartImg;
                  }
                  else
                  {
                      PageHt = FAUX;
                      //-- calcul adresse interne
                      AdrInt     = 0;
                      Hi(AdrInt) = (NumImage << 4) + NumPartImg;
                  }
                  Res = EcrI2CPoll(AdrInt, PageHt, TabMatrix, LG_TAB_MATRIX);
                  if (Res == FAUX)
                      RecOK.BIT_ERR_EEP = 1;
                  NumPartImg++;
              }
              if ( NumPartImg == NB_PART_IMG)
              {
                  //-- dernière partie de l'image reçue --//
                  HeaderOK = FAUX;
                  HeaderFin = VRAI;
              }
        }
     }
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//---------------- gestion commande image ---------------//
//
//      PE : ptDataRec : pointeur sur les données CAN recues
//           ptAppelImg : pointeur sur la structure de gestion des images
//
//      PS : Aucun
//
// Variable globale : AppelImg
//
void GesCmdImage(unsigned short *ptDataRec, t_AppImg *ptAppelImg)
{
unsigned short Param;

     //-- determibnation commande a maj --//
     switch  (ptDataRec[CMD_IMG])
     {
         case MAJ_LUMINOSITE:
         {
               //-- maj luminosité --//
               ccpr1l = ptDataRec[LUM_VAL_PWM];
               ptAppelImg->ValPWM = ptDataRec[LUM_VAL_PWM];
               break;
         }
         case APP_IMG_SIMPLE:
         {
               Param = ptDataRec[IMG_NUM_IMG];
               ptAppelImg->MajImg = VRAI;
               if (Param.BIT_PAGE_IMG)
                   ptAppelImg->PageHaut = VRAI;
               else
                   ptAppelImg->PageHaut = FAUX;
               ptAppelImg->NumImage  = Param & MASQ_NUM_IMG;
               //ptAppelImg->TypeVolet = V_AUCUN;
               break;
         }
         case APP_IMG_VOLET:
         {
               //VoletGauche = ptDataRec[1];
               //VoletDroit  = ptDataRec[2];
               ptAppelImg->TypeVolet  = ptDataRec[IMG_VOLET_TYP];
               ptAppelImg->TempoVolet = ptDataRec[IMG_VOLET_PER];
               pie1.TMR1IE = 1;      //It gestion volet
               break;
         }
         case MAJ_CLIGNOTTE:
         {
               ptAppelImg->TempoCli = ptDataRec[CLI_VITESSE];
               break;
         }
         case APP_2_IMAGE:
         {
               ptAppelImg->Tempo2Img = ptDataRec[APP_VITESSE];
               break;
         }
     }
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ gestion reception et memo image ----------//
//
//      PE : ptDataRec : pointeur sur les données CAN recues
//
//
//      PS : Aucun
//
// Variable globale : TabMatrix[], RecOK
//
#define ATT_ECR 25

void GesMajEEprom(long Id_, unsigned short *ptDataRec)
{
unsigned short i;

      switch (Id_)
      {
         case (ID_MSG_CONFIG_EEP+OFF_NUM_IMAG_PROC_L):
         {
            t3con = VAL_CONF_T3CON_LS;  //diminution vitesse affichage
            for (i=0 ; i!= LG_EEP_CONFIG ; i++)
            {
                //intcon.GIE = 0;
                //EEPROM_Write(EEP_NUM_IMAG_PROC_L+i, ptDataRec[i]);
                //intcon.GIE = 1;
                DataEEp[i+EEP_NUM_IMAG_PROC_L] = ptDataRec[i];
            }
            break;
         }
         case (ID_MSG_CONFIG_EEP+OFF_NUM_IMAG_PROC_H):
         {
            for (i=0 ; i!= LG_EEP_CONFIG ; i++)
            {
                //intcon.GIE = 0;
                //EEPROM_Write(EEP_NUM_IMAG_PROC_H+i, ptDataRec[i]);
                //intcon.GIE = 1;
                DataEEp[i+EEP_NUM_IMAG_PROC_H] = ptDataRec[i];
            }
            break;
         }
         case (ID_MSG_CONFIG_EEP+OFF_NUM_DURE_PROC_L):
         {
            for (i=0 ; i!= LG_EEP_CONFIG ; i++)
            {
                //intcon.GIE = 0;
                //EEPROM_Write(EEP_NUM_DURE_PROC_L+i, ptDataRec[i]);
                //intcon.GIE = 1;
                DataEEp[i+EEP_NUM_DURE_PROC_L] = ptDataRec[i];
            }
            break;
         }
         case (ID_MSG_CONFIG_EEP+OFF_NUM_DURE_PROC_H):
         {
            for (i=0 ; i!= LG_EEP_CONFIG ; i++)
            {
                //intcon.GIE = 0;
                //EEPROM_Write(EEP_NUM_DURE_PROC_H+i, ptDataRec[i]);
                //intcon.GIE = 1;
                DataEEp[i+EEP_NUM_DURE_PROC_H] = ptDataRec[i];
            }
            for (i=0 ; i!= (4*LG_EEP_CONFIG) ; i++)
            {
                //intcon.GIE = 0;
                EEPROM_Write(EEP_NUM_IMAG_PROC_L+i, DataEEp[i]);
                delay_ms(10);
            }
            t3con = VAL_CONF_T3CON_HS;  //reinitialisation vitesse affichage
            delay_ms(ATT_ECR);
            asm {
            reset
            }
            break;
         }
      }

}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                     projet :                //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------- initialisation periphérique  ------------//
//
//      PE : Aucun
//      PS : Aucun
//


void InitPeriphComCAN()
{
  InitComCAN();

  //-- demasquage IT reception --//
  ipr3.RXB1IP = 0;     //passage basse priorité
  ipr3.RXB0IP = 0;
  pie3.RXB1IE = 1;
  pie3.RXB0IE = 1;
  
}


//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ initialisation comunication CAN ----------//
//
//      PE : Aucun
//      PS : Aucun
//


void InitComCAN()
{

unsigned short Config_can2;
long id;

//-------------- initialisation CAN -------------------//
  Config_can1 = _CAN_TX_PRIORITY_0  &
        _CAN_TX_STD_FRAME   &
        _CAN_TX_NO_RTR_FRAME;

  // Form value to be used with CANInitialize
  Config_can2 =  _CAN_CONFIG_SAMPLE_THRICE  &
        _CAN_CONFIG_PHSEG2_PRG_ON  &
        _CAN_CONFIG_STD_MSG        &
        _CAN_CONFIG_DBL_BUFFER_ON  &
        _CAN_CONFIG_VALID_STD_MSG  &
        _CAN_CONFIG_LINE_FILTER_OFF;

  // Initialize CAN
  CANInitialize(1,4,8,8,8,Config_can2);

  // Set CAN to CONFIG mode
  CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);

  //id = -1;
  // Set all mask1 bits to ones
  CANSetMask(_CAN_MASK_B1,MASK_ACCEPT_B1,_CAN_CONFIG_STD_MSG);
  CANSetFilter(_CAN_FILTER_B1_F1,ID_REC_IMG_BMP,_CAN_CONFIG_STD_MSG);


  CANSetMask(_CAN_MASK_B2,MASK_ACCEPT_B2,_CAN_CONFIG_STD_MSG);
  CANSetFilter(_CAN_FILTER_B2_F1,ID_MSG_CONFIG_EEP,_CAN_CONFIG_STD_MSG);

  // Set CAN to NORMAL mode
  CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);

}


//-------------------------------------------------------//
//                                                       //
// Sociéte :                       projet :              //
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
void IniTVarGlComCAN()
{


}