
_InterruptSpgEmiRecI2C:

;Tache_emi_rec_I2C.c,80 :: 		void InterruptSpgEmiRecI2C()
;Tache_emi_rec_I2C.c,83 :: 		if (!StatusI2C.BIT_RECEPTION_I2C)
	BTFSC       _StatusI2C+0, 7 
	GOTO        L_InterruptSpgEmiRecI2C0
;Tache_emi_rec_I2C.c,86 :: 		if (!StatusI2C.BIT_START_EMI)
	BTFSC       _StatusI2C+0, 1 
	GOTO        L_InterruptSpgEmiRecI2C1
;Tache_emi_rec_I2C.c,89 :: 		StatusI2C.BIT_START_EMI = 1;
	BSF         _StatusI2C+0, 1 
;Tache_emi_rec_I2C.c,90 :: 		AdresseI2C.F0 = 0;
	BCF         _AdresseI2C+0, 0 
;Tache_emi_rec_I2C.c,91 :: 		sspbuf = AdresseI2C;
	MOVF        _AdresseI2C+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,92 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C2
L_InterruptSpgEmiRecI2C1:
;Tache_emi_rec_I2C.c,95 :: 		if (!sspstat.P)
	BTFSC       SSPSTAT+0, 4 
	GOTO        L_InterruptSpgEmiRecI2C3
;Tache_emi_rec_I2C.c,98 :: 		if (!StatusI2C.BIT_EMI_ADR_INT)
	BTFSC       _StatusI2C+0, 0 
	GOTO        L_InterruptSpgEmiRecI2C4
;Tache_emi_rec_I2C.c,101 :: 		StatusI2C.BIT_EMI_ADR_INT = 1;
	BSF         _StatusI2C+0, 0 
;Tache_emi_rec_I2C.c,102 :: 		sspbuf = WordAdressI2C;
	MOVF        _WordAdressI2C+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,103 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C5
L_InterruptSpgEmiRecI2C4:
;Tache_emi_rec_I2C.c,106 :: 		if (NbOctetEcrI2C != 0)
	MOVF        _NbOctetEcrI2C+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_InterruptSpgEmiRecI2C6
;Tache_emi_rec_I2C.c,109 :: 		NbOctetEcrI2C--;
	DECF        _NbOctetEcrI2C+0, 1 
;Tache_emi_rec_I2C.c,110 :: 		sspbuf = *PtBuffEcrI2C;
	MOVFF       _PtBuffEcrI2C+0, FSR0
	MOVFF       _PtBuffEcrI2C+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,111 :: 		PtBuffEcrI2C++;
	INFSNZ      _PtBuffEcrI2C+0, 1 
	INCF        _PtBuffEcrI2C+1, 1 
;Tache_emi_rec_I2C.c,112 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C7
L_InterruptSpgEmiRecI2C6:
;Tache_emi_rec_I2C.c,116 :: 		sspcon2.PEN = 1;
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,117 :: 		}
L_InterruptSpgEmiRecI2C7:
;Tache_emi_rec_I2C.c,118 :: 		}
L_InterruptSpgEmiRecI2C5:
;Tache_emi_rec_I2C.c,119 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C8
L_InterruptSpgEmiRecI2C3:
;Tache_emi_rec_I2C.c,122 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,123 :: 		}
L_InterruptSpgEmiRecI2C8:
;Tache_emi_rec_I2C.c,124 :: 		}
L_InterruptSpgEmiRecI2C2:
;Tache_emi_rec_I2C.c,125 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C9
L_InterruptSpgEmiRecI2C0:
;Tache_emi_rec_I2C.c,129 :: 		if (!StatusI2C.BIT_START_EMI)
	BTFSC       _StatusI2C+0, 1 
	GOTO        L_InterruptSpgEmiRecI2C10
;Tache_emi_rec_I2C.c,132 :: 		StatusI2C.BIT_START_EMI = 1;
	BSF         _StatusI2C+0, 1 
;Tache_emi_rec_I2C.c,133 :: 		AdresseI2C.F0 = 1;
	BSF         _AdresseI2C+0, 0 
;Tache_emi_rec_I2C.c,134 :: 		sspbuf = AdresseI2C;
	MOVF        _AdresseI2C+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,135 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C11
L_InterruptSpgEmiRecI2C10:
;Tache_emi_rec_I2C.c,138 :: 		if (!StatusI2C.BIT_REC_FIRST_BYTE)
	BTFSC       _StatusI2C+0, 5 
	GOTO        L_InterruptSpgEmiRecI2C12
;Tache_emi_rec_I2C.c,142 :: 		sspcon2.RCEN = 1;
	BSF         SSPCON2+0, 3 
;Tache_emi_rec_I2C.c,143 :: 		StatusI2C.BIT_REC_FIRST_BYTE = 1;
	BSF         _StatusI2C+0, 5 
;Tache_emi_rec_I2C.c,144 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C13
L_InterruptSpgEmiRecI2C12:
;Tache_emi_rec_I2C.c,148 :: 		if (!StatusI2C.BIT_EMI_ACK)
	BTFSC       _StatusI2C+0, 6 
	GOTO        L_InterruptSpgEmiRecI2C14
;Tache_emi_rec_I2C.c,151 :: 		StatusI2C.BIT_EMI_ACK = 1;
	BSF         _StatusI2C+0, 6 
;Tache_emi_rec_I2C.c,152 :: 		*PtBuffLecI2C = sspbuf;
	MOVFF       _PtBuffLecI2C+0, FSR1
	MOVFF       _PtBuffLecI2C+1, FSR1H
	MOVF        SSPBUF+0, 0 
	MOVWF       POSTINC1+0 
;Tache_emi_rec_I2C.c,153 :: 		NbOctetLecI2C--;
	DECF        _NbOctetLecI2C+0, 1 
;Tache_emi_rec_I2C.c,154 :: 		PtBuffLecI2C++;
	INFSNZ      _PtBuffLecI2C+0, 1 
	INCF        _PtBuffLecI2C+1, 1 
;Tache_emi_rec_I2C.c,155 :: 		if (NbOctetLecI2C != 0)
	MOVF        _NbOctetLecI2C+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_InterruptSpgEmiRecI2C15
;Tache_emi_rec_I2C.c,158 :: 		sspcon2.ACKDT = 0;
	BCF         SSPCON2+0, 5 
;Tache_emi_rec_I2C.c,159 :: 		sspcon2.ACKEN = 1;
	BSF         SSPCON2+0, 4 
;Tache_emi_rec_I2C.c,160 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C16
L_InterruptSpgEmiRecI2C15:
;Tache_emi_rec_I2C.c,164 :: 		sspcon2.ACKDT = 1;
	BSF         SSPCON2+0, 5 
;Tache_emi_rec_I2C.c,165 :: 		sspcon2.ACKEN = 1;
	BSF         SSPCON2+0, 4 
;Tache_emi_rec_I2C.c,166 :: 		}
L_InterruptSpgEmiRecI2C16:
;Tache_emi_rec_I2C.c,167 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C17
L_InterruptSpgEmiRecI2C14:
;Tache_emi_rec_I2C.c,171 :: 		if (NbOctetLecI2C == 0)
	MOVF        _NbOctetLecI2C+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_InterruptSpgEmiRecI2C18
;Tache_emi_rec_I2C.c,175 :: 		if (!sspstat.P)
	BTFSC       SSPSTAT+0, 4 
	GOTO        L_InterruptSpgEmiRecI2C19
;Tache_emi_rec_I2C.c,178 :: 		sspcon2.PEN = 1;
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,179 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C20
L_InterruptSpgEmiRecI2C19:
;Tache_emi_rec_I2C.c,182 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
L_InterruptSpgEmiRecI2C20:
;Tache_emi_rec_I2C.c,183 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C21
L_InterruptSpgEmiRecI2C18:
;Tache_emi_rec_I2C.c,188 :: 		sspcon2.RCEN = 1;
	BSF         SSPCON2+0, 3 
;Tache_emi_rec_I2C.c,189 :: 		StatusI2C.BIT_EMI_ACK = 0;
	BCF         _StatusI2C+0, 6 
;Tache_emi_rec_I2C.c,190 :: 		}
L_InterruptSpgEmiRecI2C21:
;Tache_emi_rec_I2C.c,191 :: 		}
L_InterruptSpgEmiRecI2C17:
;Tache_emi_rec_I2C.c,192 :: 		}
L_InterruptSpgEmiRecI2C13:
;Tache_emi_rec_I2C.c,193 :: 		}
L_InterruptSpgEmiRecI2C11:
;Tache_emi_rec_I2C.c,194 :: 		}
L_InterruptSpgEmiRecI2C9:
;Tache_emi_rec_I2C.c,195 :: 		}
L_end_InterruptSpgEmiRecI2C:
	RETURN      0
; end of _InterruptSpgEmiRecI2C

_InitPeriphEmiRecI2C:

;Tache_emi_rec_I2C.c,218 :: 		void InitPeriphEmiRecI2C()
;Tache_emi_rec_I2C.c,221 :: 		sspstat = CONF_SSPSTAT;
	MOVLW       128
	MOVWF       SSPSTAT+0 
;Tache_emi_rec_I2C.c,222 :: 		sspcon1 = CONF_SSPCON;
	MOVLW       40
	MOVWF       SSPCON1+0 
;Tache_emi_rec_I2C.c,223 :: 		sspcon2 = CONF_SSPCON2;
	CLRF        SSPCON2+0 
;Tache_emi_rec_I2C.c,224 :: 		sspadd = CONF_SSPADD;
	MOVLW       9
	MOVWF       SSPADD+0 
;Tache_emi_rec_I2C.c,227 :: 		pie1.SSPIE      = 0;      //gestion I2C
	BCF         PIE1+0, 3 
;Tache_emi_rec_I2C.c,229 :: 		}
L_end_InitPeriphEmiRecI2C:
	RETURN      0
; end of _InitPeriphEmiRecI2C

_IniTVarGlEmiRecI2C:

;Tache_emi_rec_I2C.c,244 :: 		void IniTVarGlEmiRecI2C()
;Tache_emi_rec_I2C.c,246 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,247 :: 		}
L_end_IniTVarGlEmiRecI2C:
	RETURN      0
; end of _IniTVarGlEmiRecI2C

_EcrCAT24M01:

;Tache_emi_rec_I2C.c,273 :: 		void EcrCAT24M01 (char NbOctetEcr, char AdresseInt, char *ptBuffEcr)
;Tache_emi_rec_I2C.c,279 :: 		WordAdressI2C = AdresseInt;                // adresse interne composant I2C
	MOVF        FARG_EcrCAT24M01_AdresseInt+0, 0 
	MOVWF       _WordAdressI2C+0 
;Tache_emi_rec_I2C.c,280 :: 		NbOctetEcrI2C = NbOctetEcr;                // Nombre d'octet a ecrire
	MOVF        FARG_EcrCAT24M01_NbOctetEcr+0, 0 
	MOVWF       _NbOctetEcrI2C+0 
;Tache_emi_rec_I2C.c,281 :: 		AdresseI2C = ADR_CAT24M01;                 // adresse composant I2C
	MOVLW       160
	MOVWF       _AdresseI2C+0 
;Tache_emi_rec_I2C.c,282 :: 		PtBuffEcrI2C = ptBuffEcr;                  // pointeur sur les données a ecrire
	MOVF        FARG_EcrCAT24M01_ptBuffEcr+0, 0 
	MOVWF       _PtBuffEcrI2C+0 
	MOVF        FARG_EcrCAT24M01_ptBuffEcr+1, 0 
	MOVWF       _PtBuffEcrI2C+1 
;Tache_emi_rec_I2C.c,283 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,284 :: 		StatusI2C.BIT_RECEPTION_I2C = 0;
	BCF         _StatusI2C+0, 7 
;Tache_emi_rec_I2C.c,286 :: 		sspcon2.SEN = 1;                           // lancement ecriture sous IT
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,289 :: 		delay_ms(5);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_EcrCAT24M0122:
	DECFSZ      R13, 1, 1
	BRA         L_EcrCAT24M0122
	DECFSZ      R12, 1, 1
	BRA         L_EcrCAT24M0122
	NOP
;Tache_emi_rec_I2C.c,294 :: 		}
L_end_EcrCAT24M01:
	RETURN      0
; end of _EcrCAT24M01

_LecCAT24M01:

;Tache_emi_rec_I2C.c,318 :: 		void LecCAT24M01(char NbOctetLec, unsigned int AdresseInt, char *ptBuffLec)
;Tache_emi_rec_I2C.c,323 :: 		WordAdressI2C = hi(AdresseInt);                // adresse interne composant I2C
	MOVF        FARG_LecCAT24M01_AdresseInt+1, 0 
	MOVWF       _WordAdressI2C+0 
;Tache_emi_rec_I2C.c,324 :: 		AdrLo = lo(AdresseInt);
	MOVF        FARG_LecCAT24M01_AdresseInt+0, 0 
	MOVWF       LecCAT24M01_AdrLo_L0+0 
;Tache_emi_rec_I2C.c,325 :: 		NbOctetEcrI2C = 1;                             // Nombre d'octet a ecrire
	MOVLW       1
	MOVWF       _NbOctetEcrI2C+0 
;Tache_emi_rec_I2C.c,326 :: 		AdresseI2C = ADR_CAT24M01;                     // adresse composant I2C
	MOVLW       160
	MOVWF       _AdresseI2C+0 
;Tache_emi_rec_I2C.c,327 :: 		PtBuffEcrI2C = &AdrLo;                         // pointeur sur les données a ecrire
	MOVLW       LecCAT24M01_AdrLo_L0+0
	MOVWF       _PtBuffEcrI2C+0 
	MOVLW       hi_addr(LecCAT24M01_AdrLo_L0+0)
	MOVWF       _PtBuffEcrI2C+1 
;Tache_emi_rec_I2C.c,328 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,329 :: 		StatusI2C.BIT_RECEPTION_I2C = 0;
	BCF         _StatusI2C+0, 7 
;Tache_emi_rec_I2C.c,330 :: 		sspcon2.SEN = 1;                               // lancement ecriture sous IT
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,333 :: 		delay_us(60);
	MOVLW       199
	MOVWF       R13, 0
L_LecCAT24M0123:
	DECFSZ      R13, 1, 1
	BRA         L_LecCAT24M0123
	NOP
	NOP
;Tache_emi_rec_I2C.c,336 :: 		NbOctetLecI2C = NbOctetLec;
	MOVF        FARG_LecCAT24M01_NbOctetLec+0, 0 
	MOVWF       _NbOctetLecI2C+0 
;Tache_emi_rec_I2C.c,337 :: 		AdresseI2C = ADR_CAT24M01;;
	MOVLW       160
	MOVWF       _AdresseI2C+0 
;Tache_emi_rec_I2C.c,338 :: 		PtBuffLecI2C = ptBuffLec;                      // tableau dans lequel stocké la donnée
	MOVF        FARG_LecCAT24M01_ptBuffLec+0, 0 
	MOVWF       _PtBuffLecI2C+0 
	MOVF        FARG_LecCAT24M01_ptBuffLec+1, 0 
	MOVWF       _PtBuffLecI2C+1 
;Tache_emi_rec_I2C.c,339 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,340 :: 		StatusI2C.BIT_RECEPTION_I2C = 1;
	BSF         _StatusI2C+0, 7 
;Tache_emi_rec_I2C.c,342 :: 		sspcon2.SEN = 1;                               // lancement lecture sous IT
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,346 :: 		}
L_end_LecCAT24M01:
	RETURN      0
; end of _LecCAT24M01

_EcrI2CPoll:

;Tache_emi_rec_I2C.c,368 :: 		unsigned short *ptBuffEcr, unsigned int NbData)
;Tache_emi_rec_I2C.c,370 :: 		unsigned short Res = VRAI;
	MOVLW       1
	MOVWF       EcrI2CPoll_Res_L0+0 
	MOVLW       160
	MOVWF       EcrI2CPoll_AdrCAT_L0+0 
;Tache_emi_rec_I2C.c,374 :: 		if (PageHaute == VRAI)
	MOVF        FARG_EcrI2CPoll_PageHaute+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_EcrI2CPoll24
;Tache_emi_rec_I2C.c,375 :: 		AdrCAT = AdrCAT | SET_PAGE_H;
	BSF         EcrI2CPoll_AdrCAT_L0+0, 1 
L_EcrI2CPoll24:
;Tache_emi_rec_I2C.c,377 :: 		sspcon2.SEN = 1;              // start bit
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,378 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll25:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll25
	NOP
	NOP
;Tache_emi_rec_I2C.c,379 :: 		sspbuf = AdrCAT;              // écriture adresse composant I2C
	MOVF        EcrI2CPoll_AdrCAT_L0+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,380 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll26:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll26
	NOP
	NOP
;Tache_emi_rec_I2C.c,381 :: 		sspbuf = hi(AdresseInt);      // ecriture poids fort adresse interne
	MOVF        FARG_EcrI2CPoll_AdresseInt+1, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,382 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll27:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll27
	NOP
	NOP
;Tache_emi_rec_I2C.c,383 :: 		sspbuf = lo(AdresseInt);      // ecriture poids faible adresse interne
	MOVF        FARG_EcrI2CPoll_AdresseInt+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,384 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll28:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll28
	NOP
	NOP
;Tache_emi_rec_I2C.c,385 :: 		for (i=0 ; i!=NbData ; i++)
	CLRF        R1 
	CLRF        R2 
L_EcrI2CPoll29:
	MOVF        R2, 0 
	XORWF       FARG_EcrI2CPoll_NbData+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__EcrI2CPoll56
	MOVF        FARG_EcrI2CPoll_NbData+0, 0 
	XORWF       R1, 0 
L__EcrI2CPoll56:
	BTFSC       STATUS+0, 2 
	GOTO        L_EcrI2CPoll30
;Tache_emi_rec_I2C.c,387 :: 		sspbuf = ptBuffEcr[i];
	MOVF        R1, 0 
	ADDWF       FARG_EcrI2CPoll_ptBuffEcr+0, 0 
	MOVWF       FSR0 
	MOVF        R2, 0 
	ADDWFC      FARG_EcrI2CPoll_ptBuffEcr+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,388 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll32:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll32
	NOP
	NOP
;Tache_emi_rec_I2C.c,385 :: 		for (i=0 ; i!=NbData ; i++)
	INFSNZ      R1, 1 
	INCF        R2, 1 
;Tache_emi_rec_I2C.c,389 :: 		}
	GOTO        L_EcrI2CPoll29
L_EcrI2CPoll30:
;Tache_emi_rec_I2C.c,390 :: 		if (sspcon2.ACKSTAT)          // vérifiaction acquittement
	BTFSS       SSPCON2+0, 6 
	GOTO        L_EcrI2CPoll33
;Tache_emi_rec_I2C.c,391 :: 		Res = FAUX;
	CLRF        EcrI2CPoll_Res_L0+0 
L_EcrI2CPoll33:
;Tache_emi_rec_I2C.c,392 :: 		sspcon2.PEN = 1;              // stop bit
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,395 :: 		return Res;
	MOVF        EcrI2CPoll_Res_L0+0, 0 
	MOVWF       R0 
;Tache_emi_rec_I2C.c,396 :: 		}
L_end_EcrI2CPoll:
	RETURN      0
; end of _EcrI2CPoll

_EcrAdrIntPoll:

;Tache_emi_rec_I2C.c,412 :: 		unsigned short EcrAdrIntPoll(unsigned int AdresseInt, unsigned short PageHaute)
;Tache_emi_rec_I2C.c,414 :: 		unsigned short Res = VRAI;
	MOVLW       1
	MOVWF       EcrAdrIntPoll_Res_L0+0 
	MOVLW       160
	MOVWF       EcrAdrIntPoll_AdrCAT_L0+0 
;Tache_emi_rec_I2C.c,417 :: 		if (PageHaute == VRAI)
	MOVF        FARG_EcrAdrIntPoll_PageHaute+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_EcrAdrIntPoll34
;Tache_emi_rec_I2C.c,418 :: 		AdrCAT = AdrCAT | SET_PAGE_H;
	BSF         EcrAdrIntPoll_AdrCAT_L0+0, 1 
L_EcrAdrIntPoll34:
;Tache_emi_rec_I2C.c,420 :: 		sspcon2.SEN = 1;                // start bit
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,421 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll35:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll35
	NOP
	NOP
;Tache_emi_rec_I2C.c,422 :: 		sspbuf = AdrCAT;                // écriture adresse composant I2C
	MOVF        EcrAdrIntPoll_AdrCAT_L0+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,423 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll36:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll36
	NOP
	NOP
;Tache_emi_rec_I2C.c,424 :: 		sspbuf = hi(AdresseInt);        // ecriture poids fort adresse interne
	MOVF        FARG_EcrAdrIntPoll_AdresseInt+1, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,425 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll37:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll37
	NOP
	NOP
;Tache_emi_rec_I2C.c,426 :: 		sspbuf = lo(AdresseInt);        // ecriture poids faible adresse interne
	MOVF        FARG_EcrAdrIntPoll_AdresseInt+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,427 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll38:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll38
	NOP
	NOP
;Tache_emi_rec_I2C.c,428 :: 		if (sspcon2.ACKSTAT)            // vérifiaction acquittement
	BTFSS       SSPCON2+0, 6 
	GOTO        L_EcrAdrIntPoll39
;Tache_emi_rec_I2C.c,429 :: 		Res = FAUX;
	CLRF        EcrAdrIntPoll_Res_L0+0 
L_EcrAdrIntPoll39:
;Tache_emi_rec_I2C.c,430 :: 		sspcon2.PEN = 1;                // stop bit
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,431 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll40:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll40
	NOP
	NOP
;Tache_emi_rec_I2C.c,433 :: 		return Res;
	MOVF        EcrAdrIntPoll_Res_L0+0, 0 
	MOVWF       R0 
;Tache_emi_rec_I2C.c,434 :: 		}
L_end_EcrAdrIntPoll:
	RETURN      0
; end of _EcrAdrIntPoll

_LecI2CPoll:

;Tache_emi_rec_I2C.c,450 :: 		void LecI2CPoll(unsigned int NbByte2Read, unsigned short *ptBufferRead)
;Tache_emi_rec_I2C.c,452 :: 		unsigned short Res = VRAI;
;Tache_emi_rec_I2C.c,454 :: 		sspcon2.SEN = 1;                // start bit
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,455 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll41:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll41
	NOP
	NOP
;Tache_emi_rec_I2C.c,456 :: 		sspbuf = ADR_CAT24M01+1;        // écriture adresse composant I2C
	MOVLW       161
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,457 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll42:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll42
	NOP
	NOP
;Tache_emi_rec_I2C.c,459 :: 		while (NbByte2Read != 1)
L_LecI2CPoll43:
	MOVLW       0
	XORWF       FARG_LecI2CPoll_NbByte2Read+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LecI2CPoll59
	MOVLW       1
	XORWF       FARG_LecI2CPoll_NbByte2Read+0, 0 
L__LecI2CPoll59:
	BTFSC       STATUS+0, 2 
	GOTO        L_LecI2CPoll44
;Tache_emi_rec_I2C.c,461 :: 		sspcon2.RCEN = 1;            // passage en mode reception
	BSF         SSPCON2+0, 3 
;Tache_emi_rec_I2C.c,462 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll45:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll45
	NOP
	NOP
;Tache_emi_rec_I2C.c,463 :: 		*ptBufferRead = sspbuf;      // lecture octet I2C
	MOVFF       FARG_LecI2CPoll_ptBufferRead+0, FSR1
	MOVFF       FARG_LecI2CPoll_ptBufferRead+1, FSR1H
	MOVF        SSPBUF+0, 0 
	MOVWF       POSTINC1+0 
;Tache_emi_rec_I2C.c,464 :: 		sspcon2.ACKDT = 0;           //emission acquittement
	BCF         SSPCON2+0, 5 
;Tache_emi_rec_I2C.c,465 :: 		sspcon2.ACKEN = 1;
	BSF         SSPCON2+0, 4 
;Tache_emi_rec_I2C.c,466 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll46:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll46
	NOP
	NOP
;Tache_emi_rec_I2C.c,467 :: 		NbByte2Read--;
	MOVLW       1
	SUBWF       FARG_LecI2CPoll_NbByte2Read+0, 1 
	MOVLW       0
	SUBWFB      FARG_LecI2CPoll_NbByte2Read+1, 1 
;Tache_emi_rec_I2C.c,468 :: 		ptBufferRead++;
	INFSNZ      FARG_LecI2CPoll_ptBufferRead+0, 1 
	INCF        FARG_LecI2CPoll_ptBufferRead+1, 1 
;Tache_emi_rec_I2C.c,469 :: 		}
	GOTO        L_LecI2CPoll43
L_LecI2CPoll44:
;Tache_emi_rec_I2C.c,470 :: 		sspcon2.RCEN = 1;               // passage en mode reception
	BSF         SSPCON2+0, 3 
;Tache_emi_rec_I2C.c,471 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll47:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll47
	NOP
	NOP
;Tache_emi_rec_I2C.c,472 :: 		*ptBufferRead = sspbuf;         // lecture octet I2C
	MOVFF       FARG_LecI2CPoll_ptBufferRead+0, FSR1
	MOVFF       FARG_LecI2CPoll_ptBufferRead+1, FSR1H
	MOVF        SSPBUF+0, 0 
	MOVWF       POSTINC1+0 
;Tache_emi_rec_I2C.c,473 :: 		sspcon2.ACKDT = 1;              //emission non acquittement
	BSF         SSPCON2+0, 5 
;Tache_emi_rec_I2C.c,474 :: 		sspcon2.ACKEN = 1;
	BSF         SSPCON2+0, 4 
;Tache_emi_rec_I2C.c,475 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll48:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll48
	NOP
	NOP
;Tache_emi_rec_I2C.c,476 :: 		sspcon2.PEN = 1;                //bit de stop
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,477 :: 		delay_us(10);
	MOVLW       33
	MOVWF       R13, 0
L_LecI2CPoll49:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll49
;Tache_emi_rec_I2C.c,479 :: 		}
L_end_LecI2CPoll:
	RETURN      0
; end of _LecI2CPoll
