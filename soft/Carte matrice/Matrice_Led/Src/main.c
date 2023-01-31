/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
//
// V1_1 par E.BURTZ le 13/04/2022 : portage PIC18F --> STM32
// V1_2 par E.BURTZ le 13/04/2022 : correction bug d'affichage passage retro --> Jeu

#include "commun.h"
#include "Matrice_Led.h"
#include "Tache_rec_emi_CAN.h"
#include "Tache_IT_Matrice.h"
#include "Tache_ges_volet.h"
#include "Micro_delay.h"
#include "Tache_ges_volet.h"

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

typedef struct strCliImg
{
   unsigned short CliEnCours;        //[VRAI, FAUX]
   unsigned short AffCli;            //[VRAI, FAUX]
   unsigned short TempoCli;
} t_CliImg;

#define NB_MAX_DATA 8
typedef struct strFiltre
{
uint8_t AdrFiltre;
uint8_t AdrMask;
uint8_t DataFiltre[NB_MAX_DATA];
uint8_t DataMask[NB_MAX_DATA];
} FiltreI2C_t;

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#define TEMPO_BOUCLE 20



//#define RESET_B7B4 0b00001111
//#define RESET_B3B0 0b11110000

//#define ATT_EOC 1

#define TEMPO_WDOG 20


//#define HAUTEUR_MARCHE 30
//#define FIN_ESCALIER 300

//###################### constantes liées au bus CAN ##########################//

//#define VAL_EXTD_ID     0x01
#define NB_DATA_MSG_POT 2
#define ID_MSG_POT      128
#define ID_MSG_DAC      192

#define ID_MSG_AFF      48
#define ID_MSG_MUX      49
#define MSQ_MSG_AFF     0xFFE

#define TEMPO_EMI_CAN 25

//#############################################################################//

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
TIM_HandleTypeDef htim1;
TIM_HandleTypeDef htim2;
TIM_HandleTypeDef htim3;

/* USER CODE BEGIN PV */

//-------------- tableau transcodage hexa -> 7 segments ------------------//
// Correspondance bit donnée tableau Tabdec7seg avec segment afficheur :
//                              b7..b0 => 0abcdefg
// en indice du tableau (entrée) on a le quartet héxa a decoder
// en donnée du tableau (sortie) on a les segments a allumer ou eteindre
//

/*uint8_t TabDec7seg[16] = {0x01,0x4F,0x12,0x06,0x4C,0x24,0x20,0x0F,0x00,0x04,0x08,0x60,0x31,0x42,0x30,0x38};

#define TST_BIT6 0b01000000
#define TST_BIT5 0b00100000
#define TST_BIT4 0b00010000
#define TST_BIT3 0b00001000
#define TST_BIT2 0b00000100
#define TST_BIT1 0b00000010
#define TST_BIT0 0b00000001
#define SET_DP 1
#define RESET_DP 0
#define RESET_B7B4 0b00001111 */
//-------------------------------------------------------------------------//

//uint8_t ResConv8b  = 0xA2;   //résultat de conversion sur 8 bits
//uint8_t ResConvBcd = 0;	     //resultat de conversion BCD
//uint8_t ValAAff8b = 0;       //Valeur a afficher sur 2 digits

//ADC_ChannelConfTypeDef sConfigUser = {0};  // changement canal conversion

//-------------------------------------------------------------------------//

TIM_OC_InitTypeDef sConfigOCUser = {0};

//uint8_t DureeBip = 0;
//uint8_t ValLum   = 100;

//-------------------------------------------------------------------------//



t_AppImg AppelImg;



/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_TIM1_Init(void);
static void MX_TIM3_Init(void);
static void MX_TIM2_Init(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */



//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//          spg d'interruption fin de comptage           //
//                                                       //
//-------------------------------------------------------//
//
// Ce sous programme est appelé lorsqu'un des timer arrive en
// fin de comptage (quelque soit le timer)
//
//      PE :  htim : pointeur sur la structure d'initialisation du timer
//            générateur de l'IT
//      PS : N/A
//
// Variable globale :
//   ValAAff8b : Valeur a visualiser 8 bits
//
#define MAX_CPT_RC 100

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{


/*	if (htim->Instance == TIM2)
	{
		//-- IT Timer 2 (tache matrice) --//
		//HAL_GPIO_TogglePin(DBG1_GPIO_Port,DBG1_Pin);
		SpgIntMatrice();
	} */
	if (htim->Instance == TIM1)
	{
		//-- IT timer 1 (tache time out) --//
		//HAL_GPIO_TogglePin(DBG1_GPIO_Port,DBG1_Pin);
		SpgIntVolet();
	}

}

/*
//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//          spg d'interruption fin de comptage           //
//                                                       //
//-------------------------------------------------------//
//
// Ce sous programme est appelé lorsqu'une entrée externe
// génère une interruption
//
//      PE :  GPIO_Pin : Numéro du GPIO générateur de l'interruption
//      PS : N/A
//
// Variable globale :
//   ValComptage : Valeur du comptage en cours
//
void HAL_GPIO_EXTI_Callback (uint16_t GPIO_Pin)
{




} */



/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  HAL_StatusTypeDef Etat;
  uint8_t CptWDog = 0;

  uint8_t TempoImg = 0;
  uint8_t ModeEnCoursPrec = RETROPI;
  uint8_t ModeEnCoursLoc = RETROPI;



  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_TIM1_Init();
  MX_TIM3_Init();
  MX_TIM2_Init();
  /* USER CODE BEGIN 2 */

  HAL_InitDelayUs();

  //
  //------------------ demarrage PWM --------------------//
  //
  Etat = HAL_TIM_PWM_Start (&htim3, TIM_CHANNEL_3);

  //
  //------------------- init bus CAN --------------------//
  //
  InitBusCAN(&TxHeader, TxData, &sFilterConfig);

  //
  //------------------ init matrice ---------------------//
  //
  //InitPeriphITMatrix();   //inutile car géré par CubeMx

  //
  //---------------- debug init eeprom ------------------//
  //
  //EcrConfigEEPDebug();    //-- a supprimer apres debug
  HAL_Delay(50);
  LecConfigEEP();

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */

	//
	//---------------------------- changement image ----------------------//
	//
	if (AppelImg.MajImg == VRAI)
	{
	     AppImageFond(AppelImg.PageHaut, AppelImg.NumImage);
	     AppelImg.MajImg = FAUX;
	}

	//
	//-------------------- gestion clignottement --------------------------//
	//
	GesCliBandeau (&AppelImg);

	//
	//------------------ gestion bandeau d'init ----------------------------//
	//
	ModeEnCoursLoc = ModeEnCours;
	if (ModeEnCoursLoc == RETROPI)
	{
	     ModeEnCoursPrec = ModeEnCoursLoc;
	     GesBandeauInit(&TempoImg, &AppelImg);
	}
	//else if ((ModeEnCoursLoc != ModeEnCoursPrec) && (!pie1.TMR1IE))
	//else if ((ModeEnCoursLoc != ModeEnCoursPrec) && (DebutVolet == VRAI))
	else if ((ModeEnCoursLoc != ModeEnCoursPrec) && (MemITTimer == 0))
	{
	     //-- on affiche le nom du jeu uniquement
	     //-- si un volet est complétement fermé ou ouvert
	     ModeEnCoursPrec = ModeEnCoursLoc;
	     GesBandeauJeu(&TempoImg, ModeEnCoursLoc, &AppelImg);
	}

	//
	//--------------- gestion affichage double vue ------------------------//
	//
	if (AppelImg.Tempo2Img != 0)
	{
	     TempoImg++;
	     if (TempoImg == AppelImg.Tempo2Img)
	     {
	         TempoImg = 0;
	         //portb.BIT_PAGE_MEM = !portb.BIT_PAGE_MEM;
	         HAL_GPIO_TogglePin (PAGE_MEM_GPIO_Port, PAGE_MEM_Pin);
	     }
	}
	else
	     TempoImg = 0;




	//
	//-----------------------------------------------------------------------//
	//
	CptWDog++;
    if (CptWDog == TEMPO_WDOG)
    {
    	HAL_GPIO_TogglePin (LED_BP_GPIO_Port, LED_BP_Pin);
    	CptWDog = 0;
    }



    //----------------- tempo boucle prog principal --------------//
  	HAL_Delay(10);
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL9;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }
  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief TIM1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM1_Init(void)
{

  /* USER CODE BEGIN TIM1_Init 0 */

  /* USER CODE END TIM1_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};

  /* USER CODE BEGIN TIM1_Init 1 */

  /* USER CODE END TIM1_Init 1 */
  htim1.Instance = TIM1;
  htim1.Init.Prescaler = 72;
  htim1.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim1.Init.Period = 1000;
  htim1.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim1.Init.RepetitionCounter = 0;
  htim1.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_ENABLE;
  if (HAL_TIM_Base_Init(&htim1) != HAL_OK)
  {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim1, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim1, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM1_Init 2 */
  //-- arret IT timer 1 au demarrage --//
  //HAL_TIM_Base_Start_IT(&htim1);     //##################################//
  /* USER CODE END TIM1_Init 2 */

}

/**
  * @brief TIM2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM2_Init(void)
{

  /* USER CODE BEGIN TIM2_Init 0 */

  /* USER CODE END TIM2_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};

  /* USER CODE BEGIN TIM2_Init 1 */

  /* USER CODE END TIM2_Init 1 */
  htim2.Instance = TIM2;
  htim2.Init.Prescaler = 36;
  htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim2.Init.Period = 4;
  htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim2.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_ENABLE;
  if (HAL_TIM_Base_Init(&htim2) != HAL_OK)
  {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim2, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim2, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM2_Init 2 */
  HAL_TIM_Base_Start_IT(&htim2);     //##################################//
  /* USER CODE END TIM2_Init 2 */

}

/**
  * @brief TIM3 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM3_Init(void)
{

  /* USER CODE BEGIN TIM3_Init 0 */

  /* USER CODE END TIM3_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};

  /* USER CODE BEGIN TIM3_Init 1 */

  /* USER CODE END TIM3_Init 1 */
  htim3.Instance = TIM3;
  htim3.Init.Prescaler = 36;
  htim3.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim3.Init.Period = 254;
  htim3.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim3.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim3) != HAL_OK)
  {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim3, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim3, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM3_Init 2 */
  //##############################################################//
  sConfigOCUser.OCMode     = sConfigOC.OCMode;
  sConfigOCUser.OCPolarity = sConfigOC.OCPolarity;
  sConfigOCUser.OCFastMode = sConfigOC.OCFastMode;
  //##############################################################//
  /* USER CODE END TIM3_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOD_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(LED_BP_GPIO_Port, LED_BP_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(DBG1_GPIO_Port, DBG1_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(DBG2_GPIO_Port, DBG2_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin : LED_BP_Pin */
  GPIO_InitStruct.Pin = LED_BP_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(LED_BP_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pin : DBG1_Pin */
  GPIO_InitStruct.Pin = DBG1_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(DBG1_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pin : DBG2_Pin */
  GPIO_InitStruct.Pin = DBG2_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(DBG2_GPIO_Port, &GPIO_InitStruct);

}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */

  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     tex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
