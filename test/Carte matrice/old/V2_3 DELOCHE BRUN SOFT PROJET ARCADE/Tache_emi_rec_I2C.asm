
_InterruptSpgEmiRecI2C:

;Tache_emi_rec_I2C.c,83 :: 		void InterruptSpgEmiRecI2C()
;Tache_emi_rec_I2C.c,86 :: 		if (!StatusI2C.BIT_RECEPTION_I2C)
	BTFSC       _StatusI2C+0, 7 
	GOTO        L_InterruptSpgEmiRecI2C0
;Tache_emi_rec_I2C.c,89 :: 		if (!StatusI2C.BIT_START_EMI)
	BTFSC       _StatusI2C+0, 1 
	GOTO        L_InterruptSpgEmiRecI2C1
;Tache_emi_rec_I2C.c,92 :: 		StatusI2C.BIT_START_EMI = 1;
	BSF         _StatusI2C+0, 1 
;Tache_emi_rec_I2C.c,93 :: 		AdresseI2C.F0 = 0;
	BCF         _AdresseI2C+0, 0 
;Tache_emi_rec_I2C.c,94 :: 		sspbuf = AdresseI2C;
	MOVF        _AdresseI2C+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,95 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C2
L_InterruptSpgEmiRecI2C1:
;Tache_emi_rec_I2C.c,98 :: 		if (!sspstat.P)
	BTFSC       SSPSTAT+0, 4 
	GOTO        L_InterruptSpgEmiRecI2C3
;Tache_emi_rec_I2C.c,101 :: 		if (!StatusI2C.BIT_EMI_ADR_INT)
	BTFSC       _StatusI2C+0, 0 
	GOTO        L_InterruptSpgEmiRecI2C4
;Tache_emi_rec_I2C.c,104 :: 		StatusI2C.BIT_EMI_ADR_INT = 1;
	BSF         _StatusI2C+0, 0 
;Tache_emi_rec_I2C.c,105 :: 		sspbuf = WordAdressI2C;
	MOVF        _WordAdressI2C+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,106 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C5
L_InterruptSpgEmiRecI2C4:
;Tache_emi_rec_I2C.c,109 :: 		if (NbOctetEcrI2C != 0)
	MOVF        _NbOctetEcrI2C+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_InterruptSpgEmiRecI2C6
;Tache_emi_rec_I2C.c,112 :: 		NbOctetEcrI2C--;
	DECF        _NbOctetEcrI2C+0, 1 
;Tache_emi_rec_I2C.c,113 :: 		sspbuf = *PtBuffEcrI2C;
	MOVFF       _PtBuffEcrI2C+0, FSR0
	MOVFF       _PtBuffEcrI2C+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,114 :: 		PtBuffEcrI2C++;
	INFSNZ      _PtBuffEcrI2C+0, 1 
	INCF        _PtBuffEcrI2C+1, 1 
;Tache_emi_rec_I2C.c,115 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C7
L_InterruptSpgEmiRecI2C6:
;Tache_emi_rec_I2C.c,119 :: 		sspcon2.PEN = 1;
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,120 :: 		}
L_InterruptSpgEmiRecI2C7:
;Tache_emi_rec_I2C.c,121 :: 		}
L_InterruptSpgEmiRecI2C5:
;Tache_emi_rec_I2C.c,122 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C8
L_InterruptSpgEmiRecI2C3:
;Tache_emi_rec_I2C.c,125 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,126 :: 		}
L_InterruptSpgEmiRecI2C8:
;Tache_emi_rec_I2C.c,127 :: 		}
L_InterruptSpgEmiRecI2C2:
;Tache_emi_rec_I2C.c,128 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C9
L_InterruptSpgEmiRecI2C0:
;Tache_emi_rec_I2C.c,132 :: 		if (!StatusI2C.BIT_START_EMI)
	BTFSC       _StatusI2C+0, 1 
	GOTO        L_InterruptSpgEmiRecI2C10
;Tache_emi_rec_I2C.c,135 :: 		StatusI2C.BIT_START_EMI = 1;
	BSF         _StatusI2C+0, 1 
;Tache_emi_rec_I2C.c,136 :: 		AdresseI2C.F0 = 1;
	BSF         _AdresseI2C+0, 0 
;Tache_emi_rec_I2C.c,137 :: 		sspbuf = AdresseI2C;
	MOVF        _AdresseI2C+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,138 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C11
L_InterruptSpgEmiRecI2C10:
;Tache_emi_rec_I2C.c,141 :: 		if (!StatusI2C.BIT_REC_FIRST_BYTE)
	BTFSC       _StatusI2C+0, 5 
	GOTO        L_InterruptSpgEmiRecI2C12
;Tache_emi_rec_I2C.c,145 :: 		sspcon2.RCEN = 1;
	BSF         SSPCON2+0, 3 
;Tache_emi_rec_I2C.c,146 :: 		StatusI2C.BIT_REC_FIRST_BYTE = 1;
	BSF         _StatusI2C+0, 5 
;Tache_emi_rec_I2C.c,147 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C13
L_InterruptSpgEmiRecI2C12:
;Tache_emi_rec_I2C.c,151 :: 		if (!StatusI2C.BIT_EMI_ACK)
	BTFSC       _StatusI2C+0, 6 
	GOTO        L_InterruptSpgEmiRecI2C14
;Tache_emi_rec_I2C.c,154 :: 		StatusI2C.BIT_EMI_ACK = 1;
	BSF         _StatusI2C+0, 6 
;Tache_emi_rec_I2C.c,155 :: 		*PtBuffLecI2C = sspbuf;
	MOVFF       _PtBuffLecI2C+0, FSR1
	MOVFF       _PtBuffLecI2C+1, FSR1H
	MOVF        SSPBUF+0, 0 
	MOVWF       POSTINC1+0 
;Tache_emi_rec_I2C.c,156 :: 		NbOctetLecI2C--;
	DECF        _NbOctetLecI2C+0, 1 
;Tache_emi_rec_I2C.c,157 :: 		PtBuffLecI2C++;
	INFSNZ      _PtBuffLecI2C+0, 1 
	INCF        _PtBuffLecI2C+1, 1 
;Tache_emi_rec_I2C.c,158 :: 		if (NbOctetLecI2C != 0)
	MOVF        _NbOctetLecI2C+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_InterruptSpgEmiRecI2C15
;Tache_emi_rec_I2C.c,161 :: 		sspcon2.ACKDT = 0;
	BCF         SSPCON2+0, 5 
;Tache_emi_rec_I2C.c,162 :: 		sspcon2.ACKEN = 1;
	BSF         SSPCON2+0, 4 
;Tache_emi_rec_I2C.c,163 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C16
L_InterruptSpgEmiRecI2C15:
;Tache_emi_rec_I2C.c,167 :: 		sspcon2.ACKDT = 1;
	BSF         SSPCON2+0, 5 
;Tache_emi_rec_I2C.c,168 :: 		sspcon2.ACKEN = 1;
	BSF         SSPCON2+0, 4 
;Tache_emi_rec_I2C.c,169 :: 		}
L_InterruptSpgEmiRecI2C16:
;Tache_emi_rec_I2C.c,170 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C17
L_InterruptSpgEmiRecI2C14:
;Tache_emi_rec_I2C.c,174 :: 		if (NbOctetLecI2C == 0)
	MOVF        _NbOctetLecI2C+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_InterruptSpgEmiRecI2C18
;Tache_emi_rec_I2C.c,178 :: 		if (!sspstat.P)
	BTFSC       SSPSTAT+0, 4 
	GOTO        L_InterruptSpgEmiRecI2C19
;Tache_emi_rec_I2C.c,181 :: 		sspcon2.PEN = 1;
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,182 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C20
L_InterruptSpgEmiRecI2C19:
;Tache_emi_rec_I2C.c,185 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
L_InterruptSpgEmiRecI2C20:
;Tache_emi_rec_I2C.c,186 :: 		}
	GOTO        L_InterruptSpgEmiRecI2C21
L_InterruptSpgEmiRecI2C18:
;Tache_emi_rec_I2C.c,191 :: 		sspcon2.RCEN = 1;
	BSF         SSPCON2+0, 3 
;Tache_emi_rec_I2C.c,192 :: 		StatusI2C.BIT_EMI_ACK = 0;
	BCF         _StatusI2C+0, 6 
;Tache_emi_rec_I2C.c,193 :: 		}
L_InterruptSpgEmiRecI2C21:
;Tache_emi_rec_I2C.c,194 :: 		}
L_InterruptSpgEmiRecI2C17:
;Tache_emi_rec_I2C.c,195 :: 		}
L_InterruptSpgEmiRecI2C13:
;Tache_emi_rec_I2C.c,196 :: 		}
L_InterruptSpgEmiRecI2C11:
;Tache_emi_rec_I2C.c,197 :: 		}
L_InterruptSpgEmiRecI2C9:
;Tache_emi_rec_I2C.c,198 :: 		}
L_end_InterruptSpgEmiRecI2C:
	RETURN      0
; end of _InterruptSpgEmiRecI2C

_InitPeriphEmiRecI2C:

;Tache_emi_rec_I2C.c,221 :: 		void InitPeriphEmiRecI2C()
;Tache_emi_rec_I2C.c,224 :: 		sspstat = CONF_SSPSTAT;
	MOVLW       128
	MOVWF       SSPSTAT+0 
;Tache_emi_rec_I2C.c,225 :: 		sspcon1 = CONF_SSPCON;
	MOVLW       40
	MOVWF       SSPCON1+0 
;Tache_emi_rec_I2C.c,226 :: 		sspcon2 = CONF_SSPCON2;
	CLRF        SSPCON2+0 
;Tache_emi_rec_I2C.c,227 :: 		sspadd = CONF_SSPADD;
	MOVLW       9
	MOVWF       SSPADD+0 
;Tache_emi_rec_I2C.c,230 :: 		pie1.SSPIE      = 0;      //gestion I2C
	BCF         PIE1+0, 3 
;Tache_emi_rec_I2C.c,232 :: 		}
L_end_InitPeriphEmiRecI2C:
	RETURN      0
; end of _InitPeriphEmiRecI2C

_IniTVarGlEmiRecI2C:

;Tache_emi_rec_I2C.c,247 :: 		void IniTVarGlEmiRecI2C()
;Tache_emi_rec_I2C.c,249 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,250 :: 		}
L_end_IniTVarGlEmiRecI2C:
	RETURN      0
; end of _IniTVarGlEmiRecI2C

_EcrCAT24M01:

;Tache_emi_rec_I2C.c,276 :: 		void EcrCAT24M01 (char NbOctetEcr, char AdresseInt, char *ptBuffEcr)
;Tache_emi_rec_I2C.c,282 :: 		WordAdressI2C = AdresseInt;                // adresse interne composant I2C
	MOVF        FARG_EcrCAT24M01_AdresseInt+0, 0 
	MOVWF       _WordAdressI2C+0 
;Tache_emi_rec_I2C.c,283 :: 		NbOctetEcrI2C = NbOctetEcr;                // Nombre d'octet a ecrire
	MOVF        FARG_EcrCAT24M01_NbOctetEcr+0, 0 
	MOVWF       _NbOctetEcrI2C+0 
;Tache_emi_rec_I2C.c,284 :: 		AdresseI2C = ADR_CAT24M01;                 // adresse composant I2C
	MOVLW       160
	MOVWF       _AdresseI2C+0 
;Tache_emi_rec_I2C.c,285 :: 		PtBuffEcrI2C = ptBuffEcr;                  // pointeur sur les données a ecrire
	MOVF        FARG_EcrCAT24M01_ptBuffEcr+0, 0 
	MOVWF       _PtBuffEcrI2C+0 
	MOVF        FARG_EcrCAT24M01_ptBuffEcr+1, 0 
	MOVWF       _PtBuffEcrI2C+1 
;Tache_emi_rec_I2C.c,286 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,287 :: 		StatusI2C.BIT_RECEPTION_I2C = 0;
	BCF         _StatusI2C+0, 7 
;Tache_emi_rec_I2C.c,289 :: 		sspcon2.SEN = 1;                           // lancement ecriture sous IT
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,292 :: 		delay_ms(5);
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
;Tache_emi_rec_I2C.c,297 :: 		}
L_end_EcrCAT24M01:
	RETURN      0
; end of _EcrCAT24M01

_LecCAT24M01:

;Tache_emi_rec_I2C.c,321 :: 		void LecCAT24M01(char NbOctetLec, unsigned int AdresseInt, char *ptBuffLec)
;Tache_emi_rec_I2C.c,326 :: 		WordAdressI2C = hi(AdresseInt);                // adresse interne composant I2C
	MOVF        FARG_LecCAT24M01_AdresseInt+1, 0 
	MOVWF       _WordAdressI2C+0 
;Tache_emi_rec_I2C.c,327 :: 		AdrLo = lo(AdresseInt);
	MOVF        FARG_LecCAT24M01_AdresseInt+0, 0 
	MOVWF       LecCAT24M01_AdrLo_L0+0 
;Tache_emi_rec_I2C.c,328 :: 		NbOctetEcrI2C = 1;                             // Nombre d'octet a ecrire
	MOVLW       1
	MOVWF       _NbOctetEcrI2C+0 
;Tache_emi_rec_I2C.c,329 :: 		AdresseI2C = ADR_CAT24M01;                     // adresse composant I2C
	MOVLW       160
	MOVWF       _AdresseI2C+0 
;Tache_emi_rec_I2C.c,330 :: 		PtBuffEcrI2C = &AdrLo;                         // pointeur sur les données a ecrire
	MOVLW       LecCAT24M01_AdrLo_L0+0
	MOVWF       _PtBuffEcrI2C+0 
	MOVLW       hi_addr(LecCAT24M01_AdrLo_L0+0)
	MOVWF       _PtBuffEcrI2C+1 
;Tache_emi_rec_I2C.c,331 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,332 :: 		StatusI2C.BIT_RECEPTION_I2C = 0;
	BCF         _StatusI2C+0, 7 
;Tache_emi_rec_I2C.c,333 :: 		sspcon2.SEN = 1;                               // lancement ecriture sous IT
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,336 :: 		delay_us(60);
	MOVLW       199
	MOVWF       R13, 0
L_LecCAT24M0123:
	DECFSZ      R13, 1, 1
	BRA         L_LecCAT24M0123
	NOP
	NOP
;Tache_emi_rec_I2C.c,339 :: 		NbOctetLecI2C = NbOctetLec;
	MOVF        FARG_LecCAT24M01_NbOctetLec+0, 0 
	MOVWF       _NbOctetLecI2C+0 
;Tache_emi_rec_I2C.c,340 :: 		AdresseI2C = ADR_CAT24M01;;
	MOVLW       160
	MOVWF       _AdresseI2C+0 
;Tache_emi_rec_I2C.c,341 :: 		PtBuffLecI2C = ptBuffLec;                      // tableau dans lequel stocké la donnée
	MOVF        FARG_LecCAT24M01_ptBuffLec+0, 0 
	MOVWF       _PtBuffLecI2C+0 
	MOVF        FARG_LecCAT24M01_ptBuffLec+1, 0 
	MOVWF       _PtBuffLecI2C+1 
;Tache_emi_rec_I2C.c,342 :: 		StatusI2C = 0;
	CLRF        _StatusI2C+0 
;Tache_emi_rec_I2C.c,343 :: 		StatusI2C.BIT_RECEPTION_I2C = 1;
	BSF         _StatusI2C+0, 7 
;Tache_emi_rec_I2C.c,345 :: 		sspcon2.SEN = 1;                               // lancement lecture sous IT
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,349 :: 		}
L_end_LecCAT24M01:
	RETURN      0
; end of _LecCAT24M01

_EcrI2CPoll:

;Tache_emi_rec_I2C.c,390 :: 		unsigned short *ptBuffEcr, unsigned int NbData)
;Tache_emi_rec_I2C.c,392 :: 		unsigned short EcrOK = VRAI;
	MOVLW       1
	MOVWF       EcrI2CPoll_EcrOK_L0+0 
	CLRF        EcrI2CPoll_i_L0+0 
;Tache_emi_rec_I2C.c,397 :: 		sspcon2.SEN = 1;
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,398 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll24:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll24
	NOP
	NOP
;Tache_emi_rec_I2C.c,400 :: 		if(PageHaute == VRAI)                                 //si Page = Haute alors
	MOVF        FARG_EcrI2CPoll_PageHaute+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_EcrI2CPoll25
;Tache_emi_rec_I2C.c,402 :: 		sspbuf = ADR_CAT24M01_PH;                      //l'adresse I2C prend la valeur 0b10100010
	MOVLW       162
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,403 :: 		}
	GOTO        L_EcrI2CPoll26
L_EcrI2CPoll25:
;Tache_emi_rec_I2C.c,406 :: 		sspbuf = ADR_CAT24M01_PB;                       //l'adresse I2C prend la valeur 0b10100000
	MOVLW       160
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,407 :: 		}
L_EcrI2CPoll26:
;Tache_emi_rec_I2C.c,408 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll27:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll27
	NOP
	NOP
;Tache_emi_rec_I2C.c,410 :: 		if(sspcon2.ACKSTAT == 0)                             //si ACK = OK
	BTFSC       SSPCON2+0, 6 
	GOTO        L_EcrI2CPoll28
;Tache_emi_rec_I2C.c,413 :: 		sspbuf = hi(AdresseInt);
	MOVF        FARG_EcrI2CPoll_AdresseInt+1, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,414 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll29:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll29
	NOP
	NOP
;Tache_emi_rec_I2C.c,416 :: 		if(sspcon2.ACKSTAT == 0)                             //si ACK = OK
	BTFSC       SSPCON2+0, 6 
	GOTO        L_EcrI2CPoll30
;Tache_emi_rec_I2C.c,419 :: 		sspbuf = lo(AdresseInt);
	MOVF        FARG_EcrI2CPoll_AdresseInt+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,420 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll31:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll31
	NOP
	NOP
;Tache_emi_rec_I2C.c,422 :: 		if(sspcon2.ACKSTAT == 0)                             //si ACK = OK
	BTFSC       SSPCON2+0, 6 
	GOTO        L_EcrI2CPoll32
;Tache_emi_rec_I2C.c,424 :: 		while ((NbData != 0) && (EcrOK == VRAI))
L_EcrI2CPoll33:
	MOVLW       0
	XORWF       FARG_EcrI2CPoll_NbData+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__EcrI2CPoll70
	MOVLW       0
	XORWF       FARG_EcrI2CPoll_NbData+0, 0 
L__EcrI2CPoll70:
	BTFSC       STATUS+0, 2 
	GOTO        L_EcrI2CPoll34
	MOVF        EcrI2CPoll_EcrOK_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_EcrI2CPoll34
L__EcrI2CPoll63:
;Tache_emi_rec_I2C.c,427 :: 		sspbuf = ptBuffEcr[i];
	MOVF        EcrI2CPoll_i_L0+0, 0 
	ADDWF       FARG_EcrI2CPoll_ptBuffEcr+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EcrI2CPoll_ptBuffEcr+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,428 :: 		NbData=NbData-1;
	MOVLW       1
	SUBWF       FARG_EcrI2CPoll_NbData+0, 1 
	MOVLW       0
	SUBWFB      FARG_EcrI2CPoll_NbData+1, 1 
;Tache_emi_rec_I2C.c,429 :: 		i++;
	INCF        EcrI2CPoll_i_L0+0, 1 
;Tache_emi_rec_I2C.c,430 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll37:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll37
	NOP
	NOP
;Tache_emi_rec_I2C.c,431 :: 		if(sspcon2.ACKSTAT == 1)
	BTFSS       SSPCON2+0, 6 
	GOTO        L_EcrI2CPoll38
;Tache_emi_rec_I2C.c,433 :: 		EcrOK = FAUX;
	CLRF        EcrI2CPoll_EcrOK_L0+0 
;Tache_emi_rec_I2C.c,434 :: 		}
L_EcrI2CPoll38:
;Tache_emi_rec_I2C.c,435 :: 		}
	GOTO        L_EcrI2CPoll33
L_EcrI2CPoll34:
;Tache_emi_rec_I2C.c,436 :: 		}
	GOTO        L_EcrI2CPoll39
L_EcrI2CPoll32:
;Tache_emi_rec_I2C.c,438 :: 		EcrOK = FAUX;
	CLRF        EcrI2CPoll_EcrOK_L0+0 
L_EcrI2CPoll39:
;Tache_emi_rec_I2C.c,439 :: 		}
	GOTO        L_EcrI2CPoll40
L_EcrI2CPoll30:
;Tache_emi_rec_I2C.c,441 :: 		EcrOK = FAUX;
	CLRF        EcrI2CPoll_EcrOK_L0+0 
L_EcrI2CPoll40:
;Tache_emi_rec_I2C.c,442 :: 		}
	GOTO        L_EcrI2CPoll41
L_EcrI2CPoll28:
;Tache_emi_rec_I2C.c,444 :: 		EcrOK = FAUX;
	CLRF        EcrI2CPoll_EcrOK_L0+0 
L_EcrI2CPoll41:
;Tache_emi_rec_I2C.c,446 :: 		sspcon2.PEN = 1;
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,447 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrI2CPoll42:
	DECFSZ      R13, 1, 1
	BRA         L_EcrI2CPoll42
	NOP
	NOP
;Tache_emi_rec_I2C.c,449 :: 		return EcrOK;
	MOVF        EcrI2CPoll_EcrOK_L0+0, 0 
	MOVWF       R0 
;Tache_emi_rec_I2C.c,450 :: 		}
L_end_EcrI2CPoll:
	RETURN      0
; end of _EcrI2CPoll

_EcrAdrIntPoll:

;Tache_emi_rec_I2C.c,482 :: 		unsigned short EcrAdrIntPoll(unsigned int AdresseInt, unsigned short PageHaute)
;Tache_emi_rec_I2C.c,484 :: 		unsigned short EcrOK = VRAI;
	MOVLW       1
	MOVWF       EcrAdrIntPoll_EcrOK_L0+0 
;Tache_emi_rec_I2C.c,488 :: 		sspcon2.SEN = 1;
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,489 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll43:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll43
	NOP
	NOP
;Tache_emi_rec_I2C.c,492 :: 		if(PageHaute == VRAI)                                 //si Page = Haute alors
	MOVF        FARG_EcrAdrIntPoll_PageHaute+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_EcrAdrIntPoll44
;Tache_emi_rec_I2C.c,494 :: 		sspbuf = ADR_CAT24M01_PH;                      //l'adresse I2C prend la valeur 0b10100010
	MOVLW       162
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,495 :: 		}
	GOTO        L_EcrAdrIntPoll45
L_EcrAdrIntPoll44:
;Tache_emi_rec_I2C.c,498 :: 		sspbuf = ADR_CAT24M01_PB;                       //l'adresse I2C prend la valeur 0b10100000
	MOVLW       160
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,499 :: 		}
L_EcrAdrIntPoll45:
;Tache_emi_rec_I2C.c,500 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll46:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll46
	NOP
	NOP
;Tache_emi_rec_I2C.c,503 :: 		if(sspcon2.ACKSTAT == 0)                             //si ACK = OK
	BTFSC       SSPCON2+0, 6 
	GOTO        L_EcrAdrIntPoll47
;Tache_emi_rec_I2C.c,506 :: 		sspbuf = hi(AdresseInt);
	MOVF        FARG_EcrAdrIntPoll_AdresseInt+1, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,507 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll48:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll48
	NOP
	NOP
;Tache_emi_rec_I2C.c,509 :: 		if(sspcon2.ACKSTAT == 0)                             //si ACK = OK
	BTFSC       SSPCON2+0, 6 
	GOTO        L_EcrAdrIntPoll49
;Tache_emi_rec_I2C.c,512 :: 		sspbuf = lo(AdresseInt);
	MOVF        FARG_EcrAdrIntPoll_AdresseInt+0, 0 
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,513 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll50:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll50
	NOP
	NOP
;Tache_emi_rec_I2C.c,514 :: 		}
	GOTO        L_EcrAdrIntPoll51
L_EcrAdrIntPoll49:
;Tache_emi_rec_I2C.c,516 :: 		EcrOK = FAUX;
	CLRF        EcrAdrIntPoll_EcrOK_L0+0 
L_EcrAdrIntPoll51:
;Tache_emi_rec_I2C.c,517 :: 		}
	GOTO        L_EcrAdrIntPoll52
L_EcrAdrIntPoll47:
;Tache_emi_rec_I2C.c,519 :: 		EcrOK = FAUX;
	CLRF        EcrAdrIntPoll_EcrOK_L0+0 
L_EcrAdrIntPoll52:
;Tache_emi_rec_I2C.c,521 :: 		sspcon2.PEN = 1;
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,522 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_EcrAdrIntPoll53:
	DECFSZ      R13, 1, 1
	BRA         L_EcrAdrIntPoll53
	NOP
	NOP
;Tache_emi_rec_I2C.c,524 :: 		return EcrOK;
	MOVF        EcrAdrIntPoll_EcrOK_L0+0, 0 
	MOVWF       R0 
;Tache_emi_rec_I2C.c,525 :: 		}
L_end_EcrAdrIntPoll:
	RETURN      0
; end of _EcrAdrIntPoll

_LecI2CPoll:

;Tache_emi_rec_I2C.c,561 :: 		void LecI2CPoll(unsigned int NbByte2Read, unsigned short *ptBufferRead)
;Tache_emi_rec_I2C.c,563 :: 		unsigned short i = 0;
	CLRF        LecI2CPoll_i_L0+0 
;Tache_emi_rec_I2C.c,566 :: 		sspcon2.SEN = 1;
	BSF         SSPCON2+0, 0 
;Tache_emi_rec_I2C.c,567 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll54:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll54
	NOP
	NOP
;Tache_emi_rec_I2C.c,568 :: 		sspbuf = ADR_CAT24M01_PB+1;    //---- +1 car on est en lecture -----//
	MOVLW       161
	MOVWF       SSPBUF+0 
;Tache_emi_rec_I2C.c,569 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll55:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll55
	NOP
	NOP
;Tache_emi_rec_I2C.c,570 :: 		while(i != NbByte2Read-1)
L_LecI2CPoll56:
	MOVLW       1
	SUBWF       FARG_LecI2CPoll_NbByte2Read+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      FARG_LecI2CPoll_NbByte2Read+1, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LecI2CPoll73
	MOVF        R1, 0 
	XORWF       LecI2CPoll_i_L0+0, 0 
L__LecI2CPoll73:
	BTFSC       STATUS+0, 2 
	GOTO        L_LecI2CPoll57
;Tache_emi_rec_I2C.c,573 :: 		sspcon2.RCEN = 1;
	BSF         SSPCON2+0, 3 
;Tache_emi_rec_I2C.c,574 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll58:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll58
	NOP
	NOP
;Tache_emi_rec_I2C.c,575 :: 		ptBufferRead[i] = sspbuf;
	MOVF        LecI2CPoll_i_L0+0, 0 
	ADDWF       FARG_LecI2CPoll_ptBufferRead+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_LecI2CPoll_ptBufferRead+1, 0 
	MOVWF       FSR1H 
	MOVF        SSPBUF+0, 0 
	MOVWF       POSTINC1+0 
;Tache_emi_rec_I2C.c,576 :: 		sspcon2.ACKDT = 0;
	BCF         SSPCON2+0, 5 
;Tache_emi_rec_I2C.c,577 :: 		sspcon2.ACKEN = 1;
	BSF         SSPCON2+0, 4 
;Tache_emi_rec_I2C.c,578 :: 		i++;
	INCF        LecI2CPoll_i_L0+0, 1 
;Tache_emi_rec_I2C.c,579 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll59:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll59
	NOP
	NOP
;Tache_emi_rec_I2C.c,580 :: 		}
	GOTO        L_LecI2CPoll56
L_LecI2CPoll57:
;Tache_emi_rec_I2C.c,581 :: 		sspcon2.RCEN = 1;            //la derniere donnée lue doit etre suivi
	BSF         SSPCON2+0, 3 
;Tache_emi_rec_I2C.c,582 :: 		delay_us(ATTENTE_POLLING);   //d'un NACK (indique a la memoire la fin de lecture
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll60:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll60
	NOP
	NOP
;Tache_emi_rec_I2C.c,583 :: 		ptBufferRead[i] = sspbuf;
	MOVF        LecI2CPoll_i_L0+0, 0 
	ADDWF       FARG_LecI2CPoll_ptBufferRead+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_LecI2CPoll_ptBufferRead+1, 0 
	MOVWF       FSR1H 
	MOVF        SSPBUF+0, 0 
	MOVWF       POSTINC1+0 
;Tache_emi_rec_I2C.c,584 :: 		sspcon2.ACKDT = 1;
	BSF         SSPCON2+0, 5 
;Tache_emi_rec_I2C.c,585 :: 		sspcon2.ACKEN = 1;
	BSF         SSPCON2+0, 4 
;Tache_emi_rec_I2C.c,586 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll61:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll61
	NOP
	NOP
;Tache_emi_rec_I2C.c,589 :: 		sspcon2.PEN = 1;
	BSF         SSPCON2+0, 2 
;Tache_emi_rec_I2C.c,590 :: 		delay_us(ATTENTE_POLLING);
	MOVLW       49
	MOVWF       R13, 0
L_LecI2CPoll62:
	DECFSZ      R13, 1, 1
	BRA         L_LecI2CPoll62
	NOP
	NOP
;Tache_emi_rec_I2C.c,592 :: 		}
L_end_LecI2CPoll:
	RETURN      0
; end of _LecI2CPoll
