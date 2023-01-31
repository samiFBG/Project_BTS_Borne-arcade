/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f1xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

#define V_AUCUN  0
#define V_GAUCHE_O 1     //Volet ouvrant
#define V_DROITE_O 2
#define V_CENTRE_O 3
#define V_GAUCHE_F 4     //Volet fermant
#define V_DROITE_F 5
#define V_CENTRE_F 6

typedef struct strAppImg
{
   uint8_t MajImg;        //[VRAI, FAUX]
   uint8_t PageHaut;      //[VRAI, FAUX]
   uint8_t NumImage;      //0..32
   uint8_t TypeVolet;     //[V_GAUCHE_O, V_DROITE_O, V_CENTRE_O, V_GAUCHE_F, V_DROITE_F, V_CENTRE_F]
   uint8_t TempoVolet;    //en n*1ms ???
   uint8_t ValPWM;        //[0 (maxi) .. FF (mini)]
   uint8_t TempoCli;
   uint8_t Tempo2Img;
} t_AppImg;

extern t_AppImg AppelImg;
extern TIM_OC_InitTypeDef sConfigOCUser;
extern TIM_HandleTypeDef htim3;
extern TIM_HandleTypeDef htim2;
extern TIM_HandleTypeDef htim1;
extern I2C_HandleTypeDef hi2c1;


/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */


/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define LED_BP_Pin GPIO_PIN_13
#define LED_BP_GPIO_Port GPIOC
#define DBG1_Pin GPIO_PIN_15
#define DBG1_GPIO_Port GPIOA
#define DBG2_Pin GPIO_PIN_5
#define DBG2_GPIO_Port GPIOB
/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
