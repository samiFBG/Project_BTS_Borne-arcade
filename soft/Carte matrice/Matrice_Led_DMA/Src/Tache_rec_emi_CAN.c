#include "main.h"
#include "Tache_rec_emi_CAN.h"
#include "Matrice_Led.h"
#include "Eeprom_flash.h"
#include "commun.h"
#include "Ges_I2C_Polling.h"
#include "Tache_ges_volet.h"



//-------------------- constante ------------------------//


//#define PAS_MASK 0xFFFFFFFF
//#define SET_MASK 0xFFFFFF00

#define VAL_PER_IT_MTRX_LS 32
#define VAL_PER_IT_MTRX_HS 4

//------------------- prototype -------------------------//

void TrtRecCAN(HAL_StatusTypeDef Status, uint32_t IdTrame, uint32_t Len, uint8_t *ptDataTrame);
//void ModifFiltreMaskCAN(CAN_FilterTypeDef *ptFilterConfig, uint32_t Filtre, uint32_t Mask);
//uint8_t VerifFiltreCAN(DataCan_t *ptDataCAN, uint8_t *ptDataRec, uint32_t Len);
//void EcrBufferEspCAN(uint8_t Carac);
void GesRecImage(uint8_t *ptDataRec);
void GesCmdImage(uint8_t *ptDataRec, t_AppImg *ptAppelImg);
void GesMajEEprom(uint32_t Id_, uint8_t *ptDataRec);


//----------------- variable globale --------------------//

CAN_TxHeaderTypeDef   TxHeader;      //-- variable necessaire en bus can

uint8_t               TxData[8];
//uint8_t               RxData[8];

uint32_t              TxMailbox;
CAN_FilterTypeDef  	  sFilterConfig;

uint8_t CmdCAN = PAS_CMD;

DataCan_t DataCanWrite;

uint8_t IndBuffEcrEspCAN = 0;
uint8_t IndBuffLecEspCAN = 0;

//uint8_t BufferRecEspCAN[LG_BUFF_REC_ESP_CAN];


extern CAN_HandleTypeDef hcan;

//---------------------------------------------------------//

uint8_t RecOK = REC_OK;
//uint8_t ModeEnCours = MODE_JEU;
uint8_t ModeEnCours = RETROPI;

uint8_t TabMatrix[512];
uint8_t DataEEp[32];

//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//          spg d'interruption reception bus CAN         //
//       (tache asynchrone suspendue sur IT rec CAN)     //
//                                                       //
//-------------------------------------------------------//
//
//
void HAL_CAN_RxFifo0MsgPendingCallback (CAN_HandleTypeDef * hcan)
{
	HAL_StatusTypeDef     StatusCAN;
	CAN_RxHeaderTypeDef   RxHeader;
	uint8_t               RxData[8];

	StatusCAN = HAL_CAN_GetRxMessage(hcan, CAN_RX_FIFO0, &RxHeader, RxData);
	TrtRecCAN(StatusCAN, RxHeader.StdId, RxHeader.DLC, RxData);
}

void HAL_CAN_RxFifo1MsgPendingCallback (CAN_HandleTypeDef * hcan)
{
	HAL_StatusTypeDef     StatusCAN;
	CAN_RxHeaderTypeDef   RxHeader;
	uint8_t               RxData[8];

	StatusCAN = HAL_CAN_GetRxMessage(hcan, CAN_RX_FIFO1, &RxHeader, RxData);
	TrtRecCAN(StatusCAN, RxHeader.StdId, RxHeader.DLC, RxData);
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//--------------- spg de reception CAN ------------------//
//                                                       //
//      PE : Status      : status reception CAN
//           IdTrame     : Identificateur de la trame recue
//           ptDataTrame : pointeur sur la charge utile
//
//      PS : Aucun
//
void TrtRecCAN(HAL_StatusTypeDef Status, uint32_t IdTrame, uint32_t Len, uint8_t *DataRec)
{
	uint8_t Res, i;

	if (Status == HAL_OK)
	{
		//
		//-------- reception trame image bitmap ----------//
		//
		if (IdTrame == ID_REC_IMG_BMP)
		{
		     GesRecImage(DataRec);
		}
		//
		//-------- reception trame commaned image ----------//
		//
		if (IdTrame == ID_REC_IMG_CMD)
		{
		     GesCmdImage(DataRec, &AppelImg);
		}
		//
		//---------- reception jeu en cours ----------------//
		//
		if (IdTrame == ID_MSG_REC_ST_PAY)
		{
		     ModeEnCours = DataRec[1];
		}
		//
		//---------- reception maj eeprom ------------------//
		if ((IdTrame & MASK_ACCEPT_B2) == ID_MSG_CONFIG_EEP)
		{
		     GesMajEEprom(IdTrame, DataRec);
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

#define HEADER_1 0x55
#define HEADER_2 0xAA


void GesRecImage(uint8_t *ptDataRec)
{
static uint8_t HeaderOK  = FAUX;
static uint8_t RecHeader = FAUX;
static uint8_t HeaderFin = FAUX;

static uint8_t NumOctet = 0;
//#define NB_PART_IMG 16            //-- 1 image = 4096 Octets (16 pages de 256 octets)
static uint8_t NumPartImg = 0;      //-- partie de l'image [0 .. 15]
static uint8_t NumImage = 0;        //-- numero de l'image [0 .. 31]  (32 images mémorisables)
static uint8_t ChkImg   = 0;



//#define IMG_PAGE_BAS 16             //image stockée dans Page basse eep
static uint8_t PageHt = FAUX;
static uint16_t AdrInt = 0;

uint8_t i, Res;
HAL_StatusTypeDef Etat;

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

            //t3con = VAL_CONF_T3CON_LS;  //diminution vitesse affichage
            Etat = HAL_TIM_Base_Stop_IT (&htim2);
            htim2.Init.Period = VAL_PER_IT_MTRX_LS;
            Etat = HAL_TIM_Base_Init(&htim2);
            Etat = HAL_TIM_Base_Start_IT (&htim2);
        }
     }
     //--------------- test reception header Fin -----------//
     if (HeaderFin == VRAI)
     {
        //-- verification header de fin --//
        if ((ptDataRec[0] == HEADER_2) && (ptDataRec[7] == HEADER_1))
        {
            //-- verification checksum --//
            if (ChkImg == ptDataRec[2])
            {
                //-- ecriture chk en eeprom --//
                //EEPROM_Write(OFF_CHK_IMG+NumImage, ChkImg);
            	//#####################################################
            	//fonction inutilisé et ne marche pas en stm32
            	//(ecr/lec eep de toutes les valeurs en 1 fois obligatoire)
            	//EcrLecEEprom(&ChkImg, 1, VRAI, OFF_CHK_IMG+NumImage);
            }
            else
                //RecOK.BIT_ERR_CHK = 1;
            	RecOK = RecOK | BIT_ERR_CHK;
        }
        else
            //RecOK.BIT_ERR_HDF = 1;
        	RecOK = RecOK | BIT_ERR_HDF;
        HeaderFin = FAUX;
        //t3con = VAL_CONF_T3CON_HS;  //reinitialisation vitesse affichage
        Etat = HAL_TIM_Base_Stop_IT (&htim2);
        htim2.Init.Period = VAL_PER_IT_MTRX_HS;
        Etat = HAL_TIM_Base_Init(&htim2);
        Etat = HAL_TIM_Base_Start_IT (&htim2);
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
                      //AdrInt     = 0;
                      //Hi(AdrInt) = ((NumImage - IMG_PAGE_BAS) << 4) + NumPartImg;
                      AdrInt = (((NumImage - IMG_PAGE_BAS) << 4) + NumPartImg) << 8;
                  }
                  else
                  {
                      PageHt = FAUX;
                      //-- calcul adresse interne
                      //AdrInt     = 0;
                      //Hi(AdrInt) = (NumImage << 4) + NumPartImg;
                      AdrInt = ((NumImage << 4) + NumPartImg) << 8;
                  }
                  //Res = EcrAdrIntPoll(AdrInt, PageHt);

                  Res = EcrI2CPoll(AdrInt, PageHt, TabMatrix, LG_TAB_MATRIX);
                  if (Res == FAUX)
                      //RecOK.BIT_ERR_EEP = 1;
                	  RecOK = RecOK | BIT_ERR_EEP;
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
// Variable globale : AppelImg, htim3
//
void GesCmdImage(uint8_t *ptDataRec, t_AppImg *ptAppelImg)
{
uint8_t Param;
HAL_StatusTypeDef Etat;

     //-- determibnation commande a maj --//
     switch  (ptDataRec[CMD_IMG])
     {
         case MAJ_LUMINOSITE:
         {
               //-- maj luminosité --//
               // ccpr1l = ptDataRec[LUM_VAL_PWM];
        	   Etat = HAL_TIM_PWM_Stop (&htim3, TIM_CHANNEL_3);
        	   sConfigOCUser.Pulse = ptDataRec[LUM_VAL_PWM];
        	   Etat = HAL_TIM_PWM_ConfigChannel (&htim3, &sConfigOCUser, TIM_CHANNEL_3);
        	   Etat = HAL_TIM_PWM_Start (&htim3, TIM_CHANNEL_3);

               ptAppelImg->ValPWM = ptDataRec[LUM_VAL_PWM];
               break;
         }
         case APP_IMG_SIMPLE:
         {
               Param = ptDataRec[IMG_NUM_IMG];
               ptAppelImg->MajImg = VRAI;
               if ((Param & BIT_PAGE_IMG) != 0)
                   ptAppelImg->PageHaut = VRAI;
               else
                   ptAppelImg->PageHaut = FAUX;
               ptAppelImg->NumImage  = Param & MASQ_NUM_IMG;
               break;
         }
         case APP_IMG_VOLET:
         {
               ptAppelImg->TypeVolet  = ptDataRec[IMG_VOLET_TYP];
               ptAppelImg->TempoVolet = ptDataRec[IMG_VOLET_PER];
               //pie1.TMR1IE = 1;      //It gestion volet
               HAL_TIM_Base_Start_IT(&htim1);
               MemITTimer = 1;
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

void GesMajEEprom(uint32_t Id_, uint8_t *ptDataRec)
{
uint8_t i;

      switch (Id_)
      {
         case (ID_MSG_CONFIG_EEP+OFF_NUM_IMAG_PROC_L):
         {
        	//############### a voir, le stm3é permet peut etre de se passer de la reduction
        	//############### freq IT
            //###############t3con = VAL_CONF_T3CON_LS;  //diminution vitesse affichage
        	//############### A priori OK le 21/02/2022 ####################
            for (i=0 ; i!= LG_EEP_CONFIG ; i++)
            {
                DataEEp[i+EEP_NUM_IMAG_PROC_L] = ptDataRec[i];
            }
            break;
         }
         case (ID_MSG_CONFIG_EEP+OFF_NUM_IMAG_PROC_H):
         {
            for (i=0 ; i!= LG_EEP_CONFIG ; i++)
            {
                DataEEp[i+EEP_NUM_IMAG_PROC_H] = ptDataRec[i];
            }
            break;
         }
         case (ID_MSG_CONFIG_EEP+OFF_NUM_DURE_PROC_L):
         {
            for (i=0 ; i!= LG_EEP_CONFIG ; i++)
            {
                DataEEp[i+EEP_NUM_DURE_PROC_L] = ptDataRec[i];
            }
            break;
         }
         case (ID_MSG_CONFIG_EEP+OFF_NUM_DURE_PROC_H):
         {
            for (i=0 ; i!= LG_EEP_CONFIG ; i++)
            {
                DataEEp[i+EEP_NUM_DURE_PROC_H] = ptDataRec[i];
            }
            /*for (i=0 ; i!= (4*LG_EEP_CONFIG) ; i++)
            {
                //intcon.GIE = 0;
                //EEPROM_Write(EEP_NUM_IMAG_PROC_L+i, DataEEp[i]);

                delay_ms(10);
            }*/
            EcrLecEEprom(DataEEp, 4*LG_EEP_CONFIG, VRAI, EEP_NUM_IMAG_PROC_L);
            //############### a voir, le stm32 permet peut etre de se passer de la reduction
            //############### freq IT
            //############### t3con = VAL_CONF_T3CON_HS;  //reinitialisation vitesse affichage
            //############### A priori OK le 21/02/2022 ####################
            HAL_Delay(ATT_ECR);
            /*asm {
            reset
            }*/
            HAL_NVIC_SystemReset();
            break;
         }
      }

}


//-------------------------------------------------------//
//                                                       //
// Sociéte :                          projet :           //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ initialisation comunication CAN ----------//
//
//      PE : ptTxHeader     : pointeur sur le descripteur de trame a emettre
//           ptTxData       : pointeur sur la charge utile des trame a émettre
//           ptFilterConfig : pointeur sur la config des filtres et masque en reception
//
//      PS : Aucun
//

#define ID_MSG_TEST_EMI 0x64

void InitBusCAN(CAN_TxHeaderTypeDef *ptTxHeader, uint8_t *ptTxData, CAN_FilterTypeDef *ptFilterConfig)
{

	HAL_StatusTypeDef StatusCAN;

	ptTxHeader->StdId = ID_MSG_TEST_EMI;      // D�termine l'adresse du p�riph�rique au quel la trame est destin�.

	ptTxHeader->ExtId = 0x01;       // Adresse �tendue, non utilis�e dans note cas
	ptTxHeader->RTR = CAN_RTR_DATA; // Pr�cise que la trame contient des donn�es
	ptTxHeader->IDE = CAN_ID_STD;   // Pr�cise que la trame est de type Standard
	ptTxHeader->DLC = 2;            // Pr�cise le nombre d'octets de donn�es que la trame transporte ( De 0 � 8 )
	ptTxHeader->TransmitGlobalTime = DISABLE;
	ptTxData[0] = 0xAA;
	ptTxData[1] = 0x55;

	//-- filtre 1 --//
    ptFilterConfig->FilterBank = 0;
	ptFilterConfig->FilterMode = CAN_FILTERMODE_IDMASK;
	ptFilterConfig->FilterScale = CAN_FILTERSCALE_32BIT;
	ptFilterConfig->FilterIdHigh = ID_REC_IMG_BMP << 5;           // Ici, 320 est l'adresse de la carte. Il peux �tre diff�rent pour chaque carte.
	ptFilterConfig->FilterIdLow  = 0;
	ptFilterConfig->FilterMaskIdHigh = MASK_ACCEPT_B1 << 5;       // Le masque peux servir � accepter une plage d'adresse au lieu d'une adresse unique.
	ptFilterConfig->FilterMaskIdLow = 0;
	ptFilterConfig->FilterFIFOAssignment = CAN_RX_FIFO0;
	ptFilterConfig->FilterActivation = ENABLE;
	ptFilterConfig->SlaveStartFilterBank = 14;			 // de 0 � 27
	StatusCAN = HAL_CAN_ConfigFilter(&hcan, ptFilterConfig);      // Configure le filtre comme ci-dessus


	//-- filtre 2 --//
	ptFilterConfig->FilterBank = 1;
	ptFilterConfig->FilterMode = CAN_FILTERMODE_IDMASK;
	ptFilterConfig->FilterScale = CAN_FILTERSCALE_32BIT;
	ptFilterConfig->FilterIdHigh = ID_MSG_CONFIG_EEP << 5;           // Ici, 320 est l'adresse de la carte. Il peux �tre diff�rent pour chaque carte.
	ptFilterConfig->FilterIdLow  = 0;
	ptFilterConfig->FilterMaskIdHigh = MASK_ACCEPT_B2 << 5;       // Le masque peux servir � accepter une plage d'adresse au lieu d'une adresse unique.
	ptFilterConfig->FilterMaskIdLow = 0;
	ptFilterConfig->FilterFIFOAssignment = CAN_RX_FIFO1;
	ptFilterConfig->FilterActivation = ENABLE;
	ptFilterConfig->SlaveStartFilterBank = 14;			 // de 0 � 27
	StatusCAN = HAL_CAN_ConfigFilter(&hcan, ptFilterConfig);      // Configure le filtre comme ci-dessus



	StatusCAN = HAL_CAN_Start(&hcan);

	//-- initialisation des notifications sous IT --//
	HAL_CAN_ActivateNotification(&hcan, CAN_IT_RX_FIFO0_MSG_PENDING | CAN_IT_RX_FIFO1_MSG_PENDING);


}


