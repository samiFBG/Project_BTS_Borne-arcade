/**
 ******************************************************************************
 * @file    delay_hal.c
 * @author  Matthew McGowan + grosses modif Edouard BURTZ
 * @version V1.0.0
 * @date    25-Sept-2014
 * @brief
 ******************************************************************************
  Copyright (c) 2013-2015 Particle Industries, Inc.  All rights reserved.
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation, either
  version 3 of the License, or (at your option) any later version.
  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.
  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************
 */


#include "stm32f1xx.h"


/*******************************************************************************
 * Function Name  : Delay_Microsecond
 * Description    : Inserts a delay time in microseconds using 32-bit DWT->CYCCNT
 * Input          : uSec: specifies the delay time length, in microseconds.
 * Output         : None
 * Return         : None
 *******************************************************************************/
#define SYSTEM_US_TICKS 72   //fonction de la frequence systeme (72MHz ici)
void HAL_Delay_Microseconds(uint16_t uSec)
{
  volatile uint32_t DWT_START = DWT->CYCCNT;
  volatile uint32_t DWT_TOTAL = (SYSTEM_US_TICKS * uSec);

  if ((UINT32_MAX - DWT_START) < DWT_TOTAL)
  {
	  DWT_TOTAL = DWT_TOTAL - (UINT32_MAX - DWT_START);
	  while ((DWT->CYCCNT > DWT_START) || (DWT->CYCCNT  < DWT_TOTAL));
  }
  else
  {
	  while((DWT->CYCCNT - DWT_START) < DWT_TOTAL)
	  {
		  //HAL_Notify_WDT(); //a remettre en cas d'utilisation du chien de garde
	  }
  }
}

void HAL_InitDelayUs()
{

  ITM->LAR = 0xC5ACCE55; // unlock (CM7)
  CoreDebug->DEMCR |= 0x01000000;
  DWT->CYCCNT = 0; // reset the counter
  DWT->CTRL |= 1 ; // enable the counter

}

