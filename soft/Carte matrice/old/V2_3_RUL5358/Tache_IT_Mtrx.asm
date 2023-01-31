
_interrupt:

;Tache_IT_Mtrx.c,56 :: 		void interrupt()
;Tache_IT_Mtrx.c,60 :: 		tmr3h = VAL_INIT_TMR3_H;
	MOVLW       255
	MOVWF       TMR3H+0 
;Tache_IT_Mtrx.c,61 :: 		tmr3l = VAL_INIT_TMR3_L;
	MOVLW       226
	MOVWF       TMR3L+0 
;Tache_IT_Mtrx.c,64 :: 		if ((NumLigne >= VoletGauche) && (NumLigne <= VoletDroit))
	MOVF        _VoletGauche+0, 0 
	SUBWF       _NumLigne+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt2
	MOVF        _NumLigne+0, 0 
	SUBWF       _VoletDroit+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt2
L__interrupt10:
;Tache_IT_Mtrx.c,66 :: 		portc.BIT_OE_MEM = 0;
	BCF         PORTC+0, 6 
;Tache_IT_Mtrx.c,67 :: 		portc.BIT_CLK_MTRX = 1;     //-- gene front d'horloge
	BSF         PORTC+0, 7 
;Tache_IT_Mtrx.c,68 :: 		portc.BIT_CLK_MEM = 0;
	BCF         PORTC+0, 1 
;Tache_IT_Mtrx.c,69 :: 		portc.BIT_CLK_MTRX = 0;
	BCF         PORTC+0, 7 
;Tache_IT_Mtrx.c,70 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;Tache_IT_Mtrx.c,71 :: 		}
	GOTO        L_interrupt3
L_interrupt2:
;Tache_IT_Mtrx.c,74 :: 		portc.BIT_OE_MEM = 1;       //-- on force a zro la donnée
	BSF         PORTC+0, 6 
;Tache_IT_Mtrx.c,75 :: 		portc.BIT_CLK_MTRX = 1;     //-- gene front d'horloge
	BSF         PORTC+0, 7 
;Tache_IT_Mtrx.c,76 :: 		portc.BIT_CLK_MEM = 0;
	BCF         PORTC+0, 1 
;Tache_IT_Mtrx.c,77 :: 		portc.BIT_CLK_MTRX = 0;
	BCF         PORTC+0, 7 
;Tache_IT_Mtrx.c,78 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;Tache_IT_Mtrx.c,79 :: 		}
L_interrupt3:
;Tache_IT_Mtrx.c,81 :: 		NumLigne++;
	INCF        _NumLigne+0, 1 
;Tache_IT_Mtrx.c,82 :: 		if (NumLigne.F7)
	BTFSS       _NumLigne+0, 7 
	GOTO        L_interrupt4
;Tache_IT_Mtrx.c,84 :: 		portc.BIT_LATCH_MTRX = 1;
	BSF         PORTC+0, 0 
;Tache_IT_Mtrx.c,85 :: 		NumLigne = 0;
	CLRF        _NumLigne+0 
;Tache_IT_Mtrx.c,88 :: 		porta.BIT_LG_D = NumColonne.F3;
	BTFSC       _NumColonne+0, 3 
	GOTO        L__interrupt13
	BCF         PORTA+0, 3 
	GOTO        L__interrupt14
L__interrupt13:
	BSF         PORTA+0, 3 
L__interrupt14:
;Tache_IT_Mtrx.c,89 :: 		if ((NumColonne == 0) || (NumColonne == 8))
	MOVF        _NumColonne+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__interrupt9
	MOVF        _NumColonne+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L__interrupt9
	GOTO        L_interrupt7
L__interrupt9:
;Tache_IT_Mtrx.c,90 :: 		porta.BIT_LG_B = 1;
	BSF         PORTA+0, 1 
	GOTO        L_interrupt8
L_interrupt7:
;Tache_IT_Mtrx.c,92 :: 		porta.BIT_LG_B = 0;
	BCF         PORTA+0, 1 
L_interrupt8:
;Tache_IT_Mtrx.c,93 :: 		porta.BIT_LG_A = 1;
	BSF         PORTA+0, 0 
;Tache_IT_Mtrx.c,94 :: 		porta.BIT_LG_A = 1;
	BSF         PORTA+0, 0 
;Tache_IT_Mtrx.c,95 :: 		porta.BIT_LG_A = 0;
	BCF         PORTA+0, 0 
;Tache_IT_Mtrx.c,96 :: 		NumColonne++;
	INCF        _NumColonne+0, 1 
;Tache_IT_Mtrx.c,97 :: 		NumColonne = (NumColonne & RESET_B7B4);
	MOVLW       15
	ANDWF       _NumColonne+0, 1 
;Tache_IT_Mtrx.c,99 :: 		portc.BIT_LATCH_MTRX = 0;
	BCF         PORTC+0, 0 
;Tache_IT_Mtrx.c,100 :: 		porta.BIT_LG_C = 0;
	BCF         PORTA+0, 2 
;Tache_IT_Mtrx.c,102 :: 		tmr3h = VAL_INIT_TMR3_H;
	MOVLW       255
	MOVWF       TMR3H+0 
;Tache_IT_Mtrx.c,103 :: 		tmr3l = VAL_INIT_TMR3_L;
	MOVLW       226
	MOVWF       TMR3L+0 
;Tache_IT_Mtrx.c,104 :: 		}
L_interrupt4:
;Tache_IT_Mtrx.c,106 :: 		PIR2.TMR3IF = 0;
	BCF         PIR2+0, 1 
;Tache_IT_Mtrx.c,108 :: 		}
L_end_interrupt:
L__interrupt12:
	RETFIE      1
; end of _interrupt

_InitPeriphITMatrix:

;Tache_IT_Mtrx.c,126 :: 		void InitPeriphITMatrix()
;Tache_IT_Mtrx.c,130 :: 		tmr3h = VAL_INIT_TMR3_H;
	MOVLW       255
	MOVWF       TMR3H+0 
;Tache_IT_Mtrx.c,131 :: 		tmr3l = VAL_INIT_TMR3_L;
	MOVLW       226
	MOVWF       TMR3L+0 
;Tache_IT_Mtrx.c,132 :: 		t3con = VAL_CONF_T3CON_HS;
	MOVLW       1
	MOVWF       T3CON+0 
;Tache_IT_Mtrx.c,135 :: 		ipr2.TMR3IP = 1;     //haute priorité
	BSF         IPR2+0, 1 
;Tache_IT_Mtrx.c,136 :: 		pie2.TMR3IE = 1;
	BSF         PIE2+0, 1 
;Tache_IT_Mtrx.c,138 :: 		}
L_end_InitPeriphITMatrix:
	RETURN      0
; end of _InitPeriphITMatrix
