

#include "main.h"
#include "Matrice_Led.h"
#include "Eeprom_flash.h"
#include "Tache_IT_Matrice.h"
#include "Tache_rec_emi_CAN.h"
#include "Tache_ges_volet.h"
#include "Ges_I2C_Polling.h"
#include "Micro_delay.h"
#include "commun.h"
#include "stdlib.h"


void ImageEEp2RAM(uint8_t PageRAMHaute, uint8_t NumImgEEp);
void InitEcrMem(uint8_t PageMemHaute);
void InitLecMem(uint8_t PageMemHaute);
void AppImageFond(uint8_t PageImg, uint8_t NumImg);
uint8_t GeneNbAlea(uint8_t NbMini, uint8_t NbMaxi);



uint8_t ImgJeux[2*LG_EEP_CONFIG]      = {8,6,12,6,6,2,6,10,4,0,0,0,0,0,0,0};       //liste image a afficher
uint8_t ImgTempoJeux[2*LG_EEP_CONFIG] = {5,30,10,30,30,8,30,15,10,0,0,0,0,0,0,0};  //durée entre 2 images

//uint8_t ImgJeux[2*LG_EEP_CONFIG]      = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};       //liste image a afficher
//uint8_t ImgTempoJeux[2*LG_EEP_CONFIG] = {20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35};  //durée entr
uint8_t ImgEEP[4*LG_EEP_CONFIG];


//--------------------------- Constante projet -------------------------------//

#define TAILLE_IMAGE 4096
#define VIT_OUV_VOLET_DEF 25       //vitesse ouverture volet en ms

//----------------------------- type défini ----------------------------------//

typedef struct strCliImg
{
   unsigned short CliEnCours;        //[VRAI, FAUX]
   unsigned short AffCli;            //[VRAI, FAUX]
   unsigned short TempoCli;
} t_CliImg;


//-------------------------------------------------------//
//                                                       //
// Sociéte :                            projet :         //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//----------- initialisation image process --------------//
//           à partir des données EEPROM
//
//      PE : Aucun
//      PS : Aucun
//
//   Variable : ImgJeux, ImgTempoJeux
//
void LecConfigEEP()
{
uint8_t i;


    //for(i=0 ; i!= LG_EEP_CONFIG ; i++)
    //  ImgJeux[i] = EEPROM_Read(EEP_NUM_IMAG_PROC_L+i);
    //EcrLecEEprom(ImgJeux, LG_EEP_CONFIG, FAUX, EEP_NUM_IMAG_PROC_L);
    //for(i=0 ; i!= LG_EEP_CONFIG ; i++)
    //    ImgJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_IMAG_PROC_H+i);
    //EcrLecEEprom(ImgJeux+LG_EEP_CONFIG, LG_EEP_CONFIG, FAUX, EEP_NUM_IMAG_PROC_H);
    //for(i=0 ; i!= LG_EEP_CONFIG ; i++)
    //    ImgTempoJeux[i] = EEPROM_Read(EEP_NUM_DURE_PROC_L+i);
    //EcrLecEEprom(ImgTempoJeux, LG_EEP_CONFIG, FAUX, EEP_NUM_DURE_PROC_L);
    //for(i=0 ; i!= LG_EEP_CONFIG ; i++)
    //    ImgTempoJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_DURE_PROC_H+i);
    //EcrLecEEprom(ImgTempoJeux+LG_EEP_CONFIG, LG_EEP_CONFIG, FAUX, EEP_NUM_DURE_PROC_H);

	EcrLecEEprom(ImgEEP, 4*LG_EEP_CONFIG, FAUX, EEP_NUM_IMAG_PROC_L);
	for(i=0 ; i!= 2*LG_EEP_CONFIG ; i++)
	   	ImgJeux[i] = ImgEEP[i];
    for(i=0; i!= 2*LG_EEP_CONFIG ; i++)
    	ImgTempoJeux[i] = ImgEEP[i+2*LG_EEP_CONFIG] * 4;    //-- on multiplie par 2 pour prendre en compte le temps de scrutation plus rapide du stm 32
    														//##########################################################################################//
}


//-------------------------------------------------------//
//                                                       //
// Sociéte :                            projet :         //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//----------- initialisation image process --------------//
//           à partir des données EEPROM
//
//      PE : Aucun
//      PS : Aucun
//
//   Variable : ImgJeux, ImgTempoJeux
//
void EcrConfigEEPDebug()
{
uint8_t i;

    for(i=0 ; i!= 2*LG_EEP_CONFIG ; i++)
    	ImgEEP[i] = ImgJeux[i];
    for(i=0 ; i!= 2*LG_EEP_CONFIG ; i++)
        ImgEEP[i+2*LG_EEP_CONFIG] = ImgTempoJeux[i];

    EcrLecEEprom(ImgEEP, 4*LG_EEP_CONFIG, VRAI, EEP_NUM_IMAG_PROC_L);
    //EcrLecEEprom(ImgJeux, LG_EEP_CONFIG, VRAI, EEP_NUM_IMAG_PROC_L);
    //EcrLecEEprom(ImgJeux+LG_EEP_CONFIG, LG_EEP_CONFIG, VRAI, EEP_NUM_IMAG_PROC_H);
    //EcrLecEEprom(ImgTempoJeux, LG_EEP_CONFIG, VRAI, EEP_NUM_DURE_PROC_L);
    //EcrLecEEprom(ImgTempoJeux+LG_EEP_CONFIG, LG_EEP_CONFIG, VRAI, EEP_NUM_DURE_PROC_H);

}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ Appelle d'une nouvelle image -------------//
//
// Affichage de différentes image lors de la mise sous tension
// avec bandeau aleatoire.
//
//      PE : PageImg : Page haut [VRAI, FAUX]
//           NumImg  : numero image [0..31]
//      PS : N/A
//
#define NUM_MAX_IMG 32

#define VAL_MAX_PWM 255	//la periode du PWM etant réglé a 254, cette valeur force
						//la sortie du PWM a 1

void AppImageFond(uint8_t PageImg, uint8_t NumImg)
{
uint8_t SaveVD;
uint8_t SaveVG;

HAL_StatusTypeDef Etat;

       if (NumImg < NUM_MAX_IMG)
       {
            //-- extinction image en cours
            //ccp1con = STOP_PWM;
    	    Etat = HAL_TIM_PWM_Stop (&htim3, TIM_CHANNEL_3);
    	    //portc.BIT_OE_MTRX = 1;
    	    sConfigOCUser.Pulse = VAL_MAX_PWM;
    	    Etat = HAL_TIM_PWM_ConfigChannel (&htim3, &sConfigOCUser, TIM_CHANNEL_3);
    	    Etat = HAL_TIM_PWM_Start (&htim3, TIM_CHANNEL_3);

            //-- arret IT tache visu matrix --//
            //pie2.TMR3IE = 0;
    	    HAL_TIM_Base_Stop_IT(&htim2);

            SaveVD = VoletDroit;     //volet droit et gauche sont ecrasé lors du
            SaveVG = VoletGauche;    //chargement d'une image !!!!!!!!!!!
            //-- lecture eep et ecriture RAM --//
            ImageEEp2RAM(PageImg, NumImg);
            //delay_us(20);
            HAL_Delay_Microseconds(20);
            //-- redemarrage IT tache visu matrix --//
            VoletDroit = SaveVD;
            VoletGauche = SaveVG;
            //pie2.TMR3IE = 1;
            HAL_TIM_Base_Start_IT(&htim2);
            //-- commutation luminosité initiale --//
            //ccp1con = INIT_CCP_CON;
            //ccpr1l = AppelImg.ValPWM;
            Etat = HAL_TIM_PWM_Stop (&htim3, TIM_CHANNEL_3);  //######
            sConfigOCUser.Pulse = AppelImg.ValPWM;
            Etat = HAL_TIM_PWM_ConfigChannel (&htim3, &sConfigOCUser, TIM_CHANNEL_3);
            Etat = HAL_TIM_PWM_Start (&htim3, TIM_CHANNEL_3);

       }
}

//-----------------------------------------------------//
//                                                     //
// Sociéte :                            projet :       //
//                                                     //
// Modifié par (Date, Libellé):                        //
//                                                     //
//--------- transfert image eep en memoire RAM --------//
//
//  PE : PageRAMHaute : Page memoire haute [VRAI, FAUX]
//       NumImage     : numero d'image eeprom [0 .. 31]
//
//  Variable globale:
//       NumLigne   : numero de ligne (Tache_IT_Mtrx)
//       NumColonne : numero de colonne (Tache_IT_Mtrx)
//
void ImageEEp2RAM(uint8_t PageRAMHaute, uint8_t NumImgEEP)
{
uint16_t AdrIntEEp = 0;
uint8_t PageEEpHaute;

uint16_t i, k;
uint16_t Cpt = 0;
uint8_t Res, j;

  //-- Raz numero de ligne et de colonne --//
  NumColonne = 0xff;
  NumLigne   = 0;

  //-- calcul adresse interne EEP --//
  if (NumImgEEP >= IMG_PAGE_BAS)
  {
    PageEEpHaute = VRAI;
    NumImgEEP = NumImgEEP - IMG_PAGE_BAS;
  }
  else
    PageEEpHaute = FAUX;
  //Hi(AdrIntEEp) = (NumImgEEp << 4);
  AdrIntEEp = NumImgEEP << 12;

  //-- initialisation position lecture EEP --//
  Res = EcrAdrIntPoll(AdrIntEEp, PageEEpHaute);
  //-- init memoire page basse ou haute --//
  InitEcrMem(PageRAMHaute);
  Cpt = 0;
  for (j=0 ; j != NB_PART_IMG ; j++)
  {
      //-- lecture 256 octet memoire eep --//
      LecI2CPoll(LG_TAB_MATRIX, TabMatrix);
      //-- ecriture 256 octets dans memoire --//
      for (k=0 ; k != LG_TAB_MATRIX ; k++)
      {
         //latd = TabMatrix[k];
    	 HAL_GPIO_WritePin(R1_GPIO_Port, R1_Pin, (TabMatrix[k] & TST_BIT0));
    	 HAL_GPIO_WritePin(G1_GPIO_Port, G1_Pin, ((TabMatrix[k] & TST_BIT1) >> 1));
    	 HAL_GPIO_WritePin(B1_GPIO_Port, B1_Pin, ((TabMatrix[k] & TST_BIT2) >> 2));
    	 HAL_GPIO_WritePin(R2_GPIO_Port, R2_Pin, ((TabMatrix[k] & TST_BIT3) >> 3));
    	 HAL_GPIO_WritePin(G2_GPIO_Port, G2_Pin, ((TabMatrix[k] & TST_BIT4) >> 4));
    	 HAL_GPIO_WritePin(B2_GPIO_Port, B2_Pin, ((TabMatrix[k] & TST_BIT5) >> 5));

         //portc.BIT_RW_MEM = 1;    //ack donnée
    	 HAL_GPIO_WritePin(R_W_GPIO_Port, R_W_Pin, GPIO_PIN_SET);

         //portc.BIT_CLK_MEM = 0;   //adresse suivante
         //delay_us(1);
    	 HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_RESET);
    	 HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_RESET);

         //portc.BIT_CLK_MEM = 1;
         //delay_us(1);
    	 HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_SET);
    	 HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_SET);

         Cpt++;
         if (Cpt != TAILLE_IMAGE-1)
         {
            //portc.BIT_RW_MEM = 0;
        	//delay_us(1);
        	 HAL_GPIO_WritePin(R_W_GPIO_Port, R_W_Pin, GPIO_PIN_RESET);
        	 HAL_GPIO_WritePin(R_W_GPIO_Port, R_W_Pin, GPIO_PIN_RESET);
         }
      }
  }
  //-- init memoire pour lecture --//
  InitLecMem(PageRAMHaute);

}


//
//-----------------------------------------------------//
//                                                     //
// Sociéte :                            projet :       //
//                                                     //
// Modifié par (Date, Libellé):                        //
//                                                     //
//---- initialisation ecriture image en memoire -------//
//
//  PE : PageMemHaute : Page memoire haute [VRAI, FAUX]
//
//  Variable globale: N/A
//
//
void InitEcrMem(uint8_t PageMemHaute)
{

GPIO_InitTypeDef GPIO_InitStruct = {0};

  //-- init compteur (RAZ) --//
  //portc.BIT_CLK_MEM = 1;
  HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_SET);

  //portb.BIT_RAZ_CPT = 1;
  //delay_us(10);
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_SET);
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_SET);
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_SET);
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_SET);

  //portb.BIT_RAZ_CPT = 0;
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_RESET);

  //-- init memoire pour ecriture --//
  //portc.BIT_OE_MEM = 0;
  HAL_GPIO_WritePin(OE_MEM_GPIO_Port, OE_MEM_Pin, GPIO_PIN_RESET);

  if (PageMemHaute == VRAI)
     //portb.BIT_PAGE_MEM = 1;
	 HAL_GPIO_WritePin(PAGE_MEM_GPIO_Port, PAGE_MEM_Pin, GPIO_PIN_SET);
  else
     //portb.BIT_PAGE_MEM = 0;
     HAL_GPIO_WritePin(PAGE_MEM_GPIO_Port, PAGE_MEM_Pin, GPIO_PIN_RESET);

  //portc.BIT_RW_MEM = 0;
  HAL_GPIO_WritePin(R_W_GPIO_Port, R_W_Pin, GPIO_PIN_RESET);

  //trisd = CONF_PORT_D_OUT;  ###########
  GPIO_InitStruct.Pin = R1_Pin|G1_Pin|B1_Pin|R2_Pin|G2_Pin|B2_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

}

//-----------------------------------------------------//
//                                                     //
// Sociéte :                            projet :       //
//                                                     //
// Modifié par (Date, Libellé):                        //
//                                                     //
//---- initialisation lecture image en memoire --------//
//
//  PE : PageMemHaute : Page memoire haute [VRAI, FAUX]
//
//  Variable globale: N/A
//
//
void InitLecMem(uint8_t PageMemHaute)
{
GPIO_InitTypeDef GPIO_InitStruct = {0};

  //-- init memoire pour lecture --//
  //trisd = CONF_PORT_D_IN;
  GPIO_InitStruct.Pin = R1_Pin|G1_Pin|B1_Pin|R2_Pin|G2_Pin|B2_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  //portc.BIT_RW_MEM = 1;
  HAL_GPIO_WritePin(R_W_GPIO_Port, R_W_Pin, GPIO_PIN_SET);

  //portc.BIT_OE_MEM = 0;
  HAL_GPIO_WritePin(OE_MEM_GPIO_Port, OE_MEM_Pin, GPIO_PIN_RESET);

  if (PageMemHaute == VRAI)
     //portb.BIT_PAGE_MEM = 1;
	 HAL_GPIO_WritePin(PAGE_MEM_GPIO_Port, PAGE_MEM_Pin, GPIO_PIN_SET);
  else
     //portb.BIT_PAGE_MEM = 0;
	 HAL_GPIO_WritePin(PAGE_MEM_GPIO_Port, PAGE_MEM_Pin, GPIO_PIN_RESET);

  //-- init compteur (RAZ) --//
  //portc.BIT_CLK_MEM = 1;
  HAL_GPIO_WritePin(CLK_MEM_GPIO_Port, CLK_MEM_Pin, GPIO_PIN_SET);

  //portb.BIT_RAZ_CPT = 1;
  //delay_us(10);
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_SET);
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_SET);
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_SET);
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_SET);

  //portb.BIT_RAZ_CPT = 0;
  HAL_GPIO_WritePin(RAZ_CPT_GPIO_Port, RAZ_CPT_Pin, GPIO_PIN_RESET);

}

//
//-----------------------------------------------------//
//                                                     //
// Sociéte :                            projet :       //
//                                                     //
// Modifié par (Date, Libellé):                        //
//                                                     //
//---------- gestion clignottement bandeau -----------//
//
//  PE : ptAppelImg : pointeur sur la structure de gestion des images
//
//  Variable globale: N/A
//
//
void GesCliBandeau (t_AppImg *ptAppelImg)
{
static t_CliImg CliImg = {FAUX, FAUX, 0};
HAL_StatusTypeDef Etat;

       if (ptAppelImg->TempoCli == 0)
       {
          if (CliImg.CliEnCours == VRAI)
          {
             //-- pas de clignottement --//
             //-- commutation luminosité initiale --//
             //ccp1con = INIT_CCP_CON;
             //ccpr1l = ptAppelImg->ValPWM;
        	 Etat = HAL_TIM_PWM_Stop (&htim3, TIM_CHANNEL_3);
       	     sConfigOCUser.Pulse = ptAppelImg->ValPWM;
       	     Etat = HAL_TIM_PWM_ConfigChannel (&htim3, &sConfigOCUser, TIM_CHANNEL_3);
       	     Etat = HAL_TIM_PWM_Start (&htim3, TIM_CHANNEL_3);
             CliImg.CliEnCours = FAUX;
             CliImg.TempoCli = 0;
          }
       }
       else
       {
           CliImg.CliEnCours = VRAI;
           CliImg.TempoCli++;
           if (CliImg.TempoCli == ptAppelImg->TempoCli)
           {
                CliImg.TempoCli = 0;
                if (CliImg.AffCli == FAUX)
                {
                     //-- extinction image en cours
                     //ccp1con = STOP_PWM;
                     //portc.BIT_OE_MTRX = 1;
                	 Etat = HAL_TIM_PWM_Stop (&htim3, TIM_CHANNEL_3);
                	 sConfigOCUser.Pulse = VAL_MAX_PWM;
                	 Etat = HAL_TIM_PWM_ConfigChannel (&htim3, &sConfigOCUser, TIM_CHANNEL_3);
                	 Etat = HAL_TIM_PWM_Start (&htim3, TIM_CHANNEL_3);
                     CliImg.AffCli = VRAI;
                }
                else
                {
                     //-- commutation luminosité initiale --//
                     //ccp1con = INIT_CCP_CON;
                     //ccpr1l = AppelImg.ValPWM;
                	 Etat = HAL_TIM_PWM_Stop (&htim3, TIM_CHANNEL_3);
                	 sConfigOCUser.Pulse = ptAppelImg->ValPWM;
                	 Etat = HAL_TIM_PWM_ConfigChannel (&htim3, &sConfigOCUser, TIM_CHANNEL_3);
                	 Etat = HAL_TIM_PWM_Start (&htim3, TIM_CHANNEL_3);
                     CliImg.AffCli = FAUX;
                }
           }
       }
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ Gestion du bandeau a l'init  -------------//
//
// Affichage de différentes image lors de la mise sous tension
// avec bandeau aleatoire.
//
//      PE : ptTempoImg : tempo basculement 2 images
//           ptAppelImg : pointeur sur la structure de gestion des images
//      PS :
//
//  variable : MemITTimer : memorisation IT timer gestion Volet [0,1]
//
#define NUM_LIST_IMG 8
const uint8_t ImgInit[NUM_LIST_IMG]  = {6,12,6,2,6,4,6,8};       //liste image a afficher
const uint8_t ImgTempo[NUM_LIST_IMG] = {100,40,100,32,100,40,100,20};    //* par 4 pour tenir compte du tps d'execution stm32

#define VOLET_MINI_O 1
#define VOLET_MAXI_O 3
#define VOLET_MINI_F 4
#define VOLET_MAXI_F 6

void GesBandeauInit (uint8_t *ptTempoImg, t_AppImg *ptAppelImg)
{
static uint8_t NumImage_ = 0;
static uint8_t VoletOuvrant = VRAI;
#define TEMPO_AFF_IMG 1200
static uint16_t TempoAffImg = 0;   //######

uint8_t TypeVoletA;


    if (VoletOuvrant == VRAI)
    {
       //if (!pie1.TMR1IE)  on passe par la variable globale DebutVolet TBC
       //if (DebutVolet == VRAI)
       if (MemITTimer == 0)
       {
          //-- le volet precedant est fermé --//
          //-- appelle image  --//
          AppImageFond(FAUX,ImgInit[NumImage_]);
          //delay_us(20);
          HAL_Delay_Microseconds(20);
          AppImageFond(VRAI,ImgInit[NumImage_]+1);
          //delay_us(20);
          HAL_Delay_Microseconds(20);
          ptAppelImg->Tempo2Img = ImgTempo[NumImage_];
          *ptTempoImg = 0;
          //-- init volet central --//
          TypeVoletA = GeneNbAlea(VOLET_MINI_O, VOLET_MAXI_O);  //###################
          //TypeVoletA = 2;
          ptAppelImg->TypeVolet  = TypeVoletA;
          ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
          //pie1.TMR1IE = 1;      //It gestion volet
          HAL_TIM_Base_Start_IT(&htim1);
          MemITTimer = 1;
          //-- image suivante --//
          VoletOuvrant = FAUX;
          NumImage_++;
          if (NumImage_ == NUM_LIST_IMG)
             NumImage_ = 0;
       }
    }
    else
    {
        TempoAffImg++;
        if (TempoAffImg == TEMPO_AFF_IMG)
        {
           TempoAffImg = 0;
           //-- Fin d'affichage --//
           TypeVoletA = GeneNbAlea(VOLET_MINI_F, VOLET_MAXI_F); //###################
           //TypeVoletA = 5;
           ptAppelImg->TypeVolet  = TypeVoletA;
           ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
           //pie1.TMR1IE = 1;      //It gestion volet
           HAL_TIM_Base_Start_IT(&htim1);
           MemITTimer = 1;
           VoletOuvrant = VRAI;
        }
    }
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ generation nombre aleatoire  -------------//
//
//      PE : NbMini : nombre minimum
//           NbMaxi : nombre maximum
//      PS : NbAlea : nombre aleatoire compris entre mini et maximum inclus
//
uint8_t GeneNbAlea(uint8_t NbMini, uint8_t NbMaxi)
{
uint8_t  NbAlea;
uint16_t Temp;

   Temp = rand();
   NbAlea = (uint8_t)(Temp + (Temp>> 8));
   NbAlea = NbAlea % (NbMaxi - NbMini + 1);
   NbAlea = NbAlea + NbMini;

   return NbAlea;

}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//---------- Gestion du bandeau pour un jeu -------------//
//
// Affichage de l'image concernant le jeux en cour
//
//      PE : ptTempoImg : tempo basculement 2 images
//           JeuEnCours : jeu en cours [1..5]
//           ptAppelImg : pointeur sur la structure de gestion des images
//      PS : N/A
//
//      liste process raspberry: (si pas d'image, on visualise retropie)
//            1 : asteroïd
//            2 : centiped
//            3 : Defender
//            4 : Donkey kong
//            5 : Galaxian
//            6 : Pac-man
//            7 : Space invader
//            8 : Tempest
//            9 : xevious
//
// Variables globales : VoletGauche : Numero colonne en cours pour volet
//

#define NUM_LIST_JEUX 15
//const unsigned short ImgJeux[NUM_LIST_JEUX] = {8,6,12,6,6,2,6,10,4};  //liste image a afficher
//const unsigned short ImgTempoJeux[NUM_LIST_JEUX] = {5,30,10,30,30,8,30,15,10};
#define NUM_JEU_DEFAUT 14

#define VOLET_MAX 255

void GesBandeauJeu (uint8_t *ptTempoImg, uint8_t JeuEnCours_, t_AppImg *ptAppelImg)
{
uint8_t TypeVoletA;

    JeuEnCours_--;
    if (JeuEnCours_ > NUM_LIST_JEUX)
       JeuEnCours_ = NUM_JEU_DEFAUT;
    //-- le volet precedant est fermé --//
    //-- appelle image  --//
    AppImageFond(FAUX,ImgJeux[JeuEnCours_]);
    AppImageFond(VRAI,ImgJeux[JeuEnCours_]+1);
    ptAppelImg->Tempo2Img = ImgTempoJeux[JeuEnCours_];
    *ptTempoImg = 0;
    //-- on force l'extinction --//
    VoletGauche  = VOLET_MAX;  //bidouille pour forcer l'extinction avant ouverture volet
                               //et eviter le beug de l'affichage temporaire d'image avant début volet
    						   //lié a la durée de mise en route de la tache de gestion de volet

    //-- init volet central --//
    TypeVoletA = GeneNbAlea(VOLET_MINI_O, VOLET_MAXI_O);
    ptAppelImg->TypeVolet  = TypeVoletA;
    ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
    //pie1.TMR1IE = 1;      //It gestion volet
    HAL_TIM_Base_Start_IT(&htim1);
    MemITTimer = 1;

}
