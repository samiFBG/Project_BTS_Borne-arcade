
_main:

;GesMatrix.c,136 :: 		void main()
;GesMatrix.c,139 :: 		unsigned Cpt = 0;
;GesMatrix.c,141 :: 		unsigned short TempoImg = 0;
	CLRF        main_TempoImg_L0+0 
	CLRF        main_ModeEnCoursPrec_L0+0 
	CLRF        main_ModeEnCoursLoc_L0+0 
;GesMatrix.c,149 :: 		InitPeriphFond();
	CALL        _InitPeriphFond+0, 0
;GesMatrix.c,150 :: 		InitPeriphEmiRecI2C();
	CALL        _InitPeriphEmiRecI2C+0, 0
;GesMatrix.c,151 :: 		delay_ms(500);               //attente reset matrix
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	DECFSZ      R11, 1, 1
	BRA         L_main0
	NOP
;GesMatrix.c,152 :: 		InitPeriphComCAN();
	CALL        _InitPeriphComCAN+0, 0
;GesMatrix.c,153 :: 		InitPeriphITMatrix();
	CALL        _InitPeriphITMatrix+0, 0
;GesMatrix.c,154 :: 		InitPeriphGesTimeOut();
	CALL        _InitPeriphGesTimeOut+0, 0
;GesMatrix.c,158 :: 		IniTVarGlEmiRecI2C();
	CALL        _IniTVarGlEmiRecI2C+0, 0
;GesMatrix.c,159 :: 		IniTVarGlGesTimeOut();
	CALL        _IniTVarGlGesTimeOut+0, 0
;GesMatrix.c,160 :: 		IniTVarGlComCAN();
	CALL        _IniTVarGlComCAN+0, 0
;GesMatrix.c,161 :: 		InitVarGlobal();
	CALL        _InitVarGlobal+0, 0
;GesMatrix.c,165 :: 		LecConfigEEP();
	CALL        _LecConfigEEP+0, 0
;GesMatrix.c,181 :: 		intcon.PEIE = 1;
	BSF         INTCON+0, 6 
;GesMatrix.c,182 :: 		intcon.GIE  = 1;           //autorisation globale des IT
	BSF         INTCON+0, 7 
;GesMatrix.c,185 :: 		for(;;)
L_main1:
;GesMatrix.c,190 :: 		if (AppelImg.MajImg == VRAI)
	MOVF        _AppelImg+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
;GesMatrix.c,192 :: 		AppImageFond(AppelImg.PageHaut, AppelImg.NumImage);
	MOVF        _AppelImg+1, 0 
	MOVWF       FARG_AppImageFond_PageImg+0 
	MOVF        _AppelImg+2, 0 
	MOVWF       FARG_AppImageFond_NumImg+0 
	CALL        _AppImageFond+0, 0
;GesMatrix.c,193 :: 		AppelImg.MajImg = FAUX;
	CLRF        _AppelImg+0 
;GesMatrix.c,194 :: 		}
L_main4:
;GesMatrix.c,199 :: 		GesCliBandeau (&AppelImg);
	MOVLW       _AppelImg+0
	MOVWF       FARG_GesCliBandeau_ptAppelImg+0 
	MOVLW       hi_addr(_AppelImg+0)
	MOVWF       FARG_GesCliBandeau_ptAppelImg+1 
	CALL        _GesCliBandeau+0, 0
;GesMatrix.c,204 :: 		ModeEnCoursLoc = ModeEnCours;
	MOVF        _ModeEnCours+0, 0 
	MOVWF       main_ModeEnCoursLoc_L0+0 
;GesMatrix.c,205 :: 		if (ModeEnCoursLoc == RETROPI)
	MOVF        _ModeEnCours+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;GesMatrix.c,207 :: 		ModeEnCoursPrec = ModeEnCoursLoc;
	MOVF        main_ModeEnCoursLoc_L0+0, 0 
	MOVWF       main_ModeEnCoursPrec_L0+0 
;GesMatrix.c,208 :: 		GesBandeauInit(&TempoImg, &AppelImg);
	MOVLW       main_TempoImg_L0+0
	MOVWF       FARG_GesBandeauInit_ptTempoImg+0 
	MOVLW       hi_addr(main_TempoImg_L0+0)
	MOVWF       FARG_GesBandeauInit_ptTempoImg+1 
	MOVLW       _AppelImg+0
	MOVWF       FARG_GesBandeauInit_ptAppelImg+0 
	MOVLW       hi_addr(_AppelImg+0)
	MOVWF       FARG_GesBandeauInit_ptAppelImg+1 
	CALL        _GesBandeauInit+0, 0
;GesMatrix.c,209 :: 		}
	GOTO        L_main6
L_main5:
;GesMatrix.c,210 :: 		else if ((ModeEnCoursLoc != ModeEnCoursPrec) && (!pie1.TMR1IE))
	MOVF        main_ModeEnCoursLoc_L0+0, 0 
	XORWF       main_ModeEnCoursPrec_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
	BTFSC       PIE1+0, 0 
	GOTO        L_main9
L__main72:
;GesMatrix.c,214 :: 		ModeEnCoursPrec = ModeEnCoursLoc;
	MOVF        main_ModeEnCoursLoc_L0+0, 0 
	MOVWF       main_ModeEnCoursPrec_L0+0 
;GesMatrix.c,215 :: 		GesBandeauJeu(&TempoImg, ModeEnCoursLoc, &AppelImg);
	MOVLW       main_TempoImg_L0+0
	MOVWF       FARG_GesBandeauJeu_ptTempoImg+0 
	MOVLW       hi_addr(main_TempoImg_L0+0)
	MOVWF       FARG_GesBandeauJeu_ptTempoImg+1 
	MOVF        main_ModeEnCoursLoc_L0+0, 0 
	MOVWF       FARG_GesBandeauJeu_JeuEnCours_+0 
	MOVLW       _AppelImg+0
	MOVWF       FARG_GesBandeauJeu_ptAppelImg+0 
	MOVLW       hi_addr(_AppelImg+0)
	MOVWF       FARG_GesBandeauJeu_ptAppelImg+1 
	CALL        _GesBandeauJeu+0, 0
;GesMatrix.c,216 :: 		}
L_main9:
L_main6:
;GesMatrix.c,221 :: 		if (AppelImg.Tempo2Img != 0)
	MOVF        _AppelImg+7, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
;GesMatrix.c,223 :: 		TempoImg++;
	INCF        main_TempoImg_L0+0, 1 
;GesMatrix.c,224 :: 		if (TempoImg == AppelImg.Tempo2Img)
	MOVF        main_TempoImg_L0+0, 0 
	XORWF       _AppelImg+7, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main11
;GesMatrix.c,226 :: 		TempoImg = 0;
	CLRF        main_TempoImg_L0+0 
;GesMatrix.c,227 :: 		portb.BIT_PAGE_MEM = !portb.BIT_PAGE_MEM;
	BTG         PORTB+0, 4 
;GesMatrix.c,228 :: 		}
L_main11:
;GesMatrix.c,229 :: 		}
	GOTO        L_main12
L_main10:
;GesMatrix.c,231 :: 		TempoImg = 0;
	CLRF        main_TempoImg_L0+0 
L_main12:
;GesMatrix.c,235 :: 		gTempoWDOG--;
	DECF        _gTempoWDOG+0, 1 
;GesMatrix.c,236 :: 		if (gTempoWDOG == 0)
	MOVF        _gTempoWDOG+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
;GesMatrix.c,238 :: 		if (RecOK == REC_OK)
	MOVF        _RecOK+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main14
;GesMatrix.c,239 :: 		gTempoWDOG = TEMPO_WDOG;
	MOVLW       1
	MOVWF       _gTempoWDOG+0 
	GOTO        L_main15
L_main14:
;GesMatrix.c,241 :: 		gTempoWDOG = TEMPO_WDOG_ERR;
	MOVLW       25
	MOVWF       _gTempoWDOG+0 
L_main15:
;GesMatrix.c,242 :: 		gTempoWDOG = TEMPO_WDOG;
	MOVLW       1
	MOVWF       _gTempoWDOG+0 
;GesMatrix.c,243 :: 		portb.BIT_WDOG = !portb.BIT_WDOG;
	BTG         PORTB+0, 0 
;GesMatrix.c,244 :: 		}
L_main13:
;GesMatrix.c,245 :: 		Delay_ms(TEMPO_SCRUT);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main16:
	DECFSZ      R13, 1, 1
	BRA         L_main16
	DECFSZ      R12, 1, 1
	BRA         L_main16
	NOP
	NOP
;GesMatrix.c,246 :: 		}
	GOTO        L_main1
;GesMatrix.c,247 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_AppImageFond:

;GesMatrix.c,266 :: 		void AppImageFond(unsigned short PageImg, unsigned short NumImg)
;GesMatrix.c,271 :: 		if (NumImg < NUM_MAX_IMG)
	MOVLW       32
	SUBWF       FARG_AppImageFond_NumImg+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_AppImageFond17
;GesMatrix.c,276 :: 		ccp1con = STOP_PWM;
	CLRF        CCP1CON+0 
;GesMatrix.c,277 :: 		portc.BIT_OE_MTRX = 1;
	BSF         PORTC+0, 2 
;GesMatrix.c,279 :: 		pie2.TMR3IE = 0;
	BCF         PIE2+0, 1 
;GesMatrix.c,281 :: 		SaveVD = VoletDroit;     //volet droit et gauche sont ecrasé lors du
	MOVF        _VoletDroit+0, 0 
	MOVWF       AppImageFond_SaveVD_L0+0 
;GesMatrix.c,282 :: 		SaveVG = VoletGauche;    //chargement d'une image !!!!!!!!!!!
	MOVF        _VoletGauche+0, 0 
	MOVWF       AppImageFond_SaveVG_L0+0 
;GesMatrix.c,284 :: 		ImageEEp2RAM(PageImg, NumImg);
	MOVF        FARG_AppImageFond_PageImg+0, 0 
	MOVWF       FARG_ImageEEp2RAM_PageRAMHaute+0 
	MOVF        FARG_AppImageFond_NumImg+0, 0 
	MOVWF       FARG_ImageEEp2RAM_NumImgEEp+0 
	CALL        _ImageEEp2RAM+0, 0
;GesMatrix.c,285 :: 		delay_us(20);
	MOVLW       66
	MOVWF       R13, 0
L_AppImageFond18:
	DECFSZ      R13, 1, 1
	BRA         L_AppImageFond18
	NOP
;GesMatrix.c,287 :: 		VoletDroit = SaveVD;
	MOVF        AppImageFond_SaveVD_L0+0, 0 
	MOVWF       _VoletDroit+0 
;GesMatrix.c,288 :: 		VoletGauche = SaveVG;
	MOVF        AppImageFond_SaveVG_L0+0, 0 
	MOVWF       _VoletGauche+0 
;GesMatrix.c,289 :: 		pie2.TMR3IE = 1;
	BSF         PIE2+0, 1 
;GesMatrix.c,292 :: 		ccp1con = INIT_CCP_CON;
	MOVLW       28
	MOVWF       CCP1CON+0 
;GesMatrix.c,293 :: 		ccpr1l = AppelImg.ValPWM;
	MOVF        _AppelImg+5, 0 
	MOVWF       CCPR1L+0 
;GesMatrix.c,294 :: 		}
L_AppImageFond17:
;GesMatrix.c,295 :: 		}
L_end_AppImageFond:
	RETURN      0
; end of _AppImageFond

_GesBandeauInit:

;GesMatrix.c,321 :: 		void GesBandeauInit (unsigned short *ptTempoImg, t_AppImg *ptAppelImg)
;GesMatrix.c,331 :: 		if (VoletOuvrant == VRAI)
	MOVF        GesBandeauInit_VoletOuvrant_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_GesBandeauInit19
;GesMatrix.c,333 :: 		if (!pie1.TMR1IE)
	BTFSC       PIE1+0, 0 
	GOTO        L_GesBandeauInit20
;GesMatrix.c,338 :: 		AppImageFond(FAUX,ImgInit[NumImage_]);
	CLRF        FARG_AppImageFond_PageImg+0 
	MOVLW       _ImgInit+0
	ADDWF       GesBandeauInit_NumImage__L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_ImgInit+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_ImgInit+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_AppImageFond_NumImg+0
	CALL        _AppImageFond+0, 0
;GesMatrix.c,339 :: 		delay_us(20);
	MOVLW       66
	MOVWF       R13, 0
L_GesBandeauInit21:
	DECFSZ      R13, 1, 1
	BRA         L_GesBandeauInit21
	NOP
;GesMatrix.c,341 :: 		AppImageFond(VRAI,ImgInit[NumImage_]+1);
	MOVLW       1
	MOVWF       FARG_AppImageFond_PageImg+0 
	MOVLW       _ImgInit+0
	ADDWF       GesBandeauInit_NumImage__L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_ImgInit+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_ImgInit+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_AppImageFond_NumImg+0 
	CALL        _AppImageFond+0, 0
;GesMatrix.c,342 :: 		delay_us(20);
	MOVLW       66
	MOVWF       R13, 0
L_GesBandeauInit22:
	DECFSZ      R13, 1, 1
	BRA         L_GesBandeauInit22
	NOP
;GesMatrix.c,343 :: 		ptAppelImg->Tempo2Img = ImgTempo[NumImage_];
	MOVLW       7
	ADDWF       FARG_GesBandeauInit_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauInit_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       _ImgTempo+0
	ADDWF       GesBandeauInit_NumImage__L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_ImgTempo+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_ImgTempo+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,344 :: 		*ptTempoImg = 0;
	MOVFF       FARG_GesBandeauInit_ptTempoImg+0, FSR1
	MOVFF       FARG_GesBandeauInit_ptTempoImg+1, FSR1H
	CLRF        POSTINC1+0 
;GesMatrix.c,346 :: 		TypeVoletA = GeneNbAlea(VOLET_MINI_O, VOLET_MAXI_O);
	MOVLW       1
	MOVWF       FARG_GeneNbAlea_NbMini+0 
	MOVLW       3
	MOVWF       FARG_GeneNbAlea_NbMaxi+0 
	CALL        _GeneNbAlea+0, 0
;GesMatrix.c,347 :: 		ptAppelImg->TypeVolet  = TypeVoletA;
	MOVLW       3
	ADDWF       FARG_GesBandeauInit_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauInit_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,348 :: 		ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
	MOVLW       4
	ADDWF       FARG_GesBandeauInit_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauInit_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       25
	MOVWF       POSTINC1+0 
;GesMatrix.c,349 :: 		pie1.TMR1IE = 1;      //It gestion volet
	BSF         PIE1+0, 0 
;GesMatrix.c,351 :: 		VoletOuvrant = FAUX;
	CLRF        GesBandeauInit_VoletOuvrant_L0+0 
;GesMatrix.c,352 :: 		NumImage_++;
	INCF        GesBandeauInit_NumImage__L0+0, 1 
;GesMatrix.c,353 :: 		if (NumImage_ == NUM_LIST_IMG)
	MOVF        GesBandeauInit_NumImage__L0+0, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_GesBandeauInit23
;GesMatrix.c,354 :: 		NumImage_ = 0;
	CLRF        GesBandeauInit_NumImage__L0+0 
L_GesBandeauInit23:
;GesMatrix.c,355 :: 		}
L_GesBandeauInit20:
;GesMatrix.c,356 :: 		}
	GOTO        L_GesBandeauInit24
L_GesBandeauInit19:
;GesMatrix.c,359 :: 		TempoAffImg++;
	INCF        GesBandeauInit_TempoAffImg_L0+0, 1 
;GesMatrix.c,360 :: 		if (TempoAffImg == TEMPO_AFF_IMG)
	MOVF        GesBandeauInit_TempoAffImg_L0+0, 0 
	XORLW       200
	BTFSS       STATUS+0, 2 
	GOTO        L_GesBandeauInit25
;GesMatrix.c,362 :: 		TempoAffImg = 0;
	CLRF        GesBandeauInit_TempoAffImg_L0+0 
;GesMatrix.c,364 :: 		TypeVoletA = GeneNbAlea(VOLET_MINI_F, VOLET_MAXI_F);
	MOVLW       4
	MOVWF       FARG_GeneNbAlea_NbMini+0 
	MOVLW       6
	MOVWF       FARG_GeneNbAlea_NbMaxi+0 
	CALL        _GeneNbAlea+0, 0
;GesMatrix.c,365 :: 		ptAppelImg->TypeVolet  = TypeVoletA;
	MOVLW       3
	ADDWF       FARG_GesBandeauInit_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauInit_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,366 :: 		ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
	MOVLW       4
	ADDWF       FARG_GesBandeauInit_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauInit_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       25
	MOVWF       POSTINC1+0 
;GesMatrix.c,367 :: 		pie1.TMR1IE = 1;      //It gestion volet
	BSF         PIE1+0, 0 
;GesMatrix.c,368 :: 		VoletOuvrant = VRAI;
	MOVLW       1
	MOVWF       GesBandeauInit_VoletOuvrant_L0+0 
;GesMatrix.c,369 :: 		}
L_GesBandeauInit25:
;GesMatrix.c,370 :: 		}
L_GesBandeauInit24:
;GesMatrix.c,371 :: 		}
L_end_GesBandeauInit:
	RETURN      0
; end of _GesBandeauInit

_GesBandeauJeu:

;GesMatrix.c,405 :: 		void GesBandeauJeu (unsigned short *ptTempoImg, unsigned short JeuEnCours_, t_AppImg *ptAppelImg)
;GesMatrix.c,409 :: 		JeuEnCours_--;
	DECF        FARG_GesBandeauJeu_JeuEnCours_+0, 1 
;GesMatrix.c,410 :: 		if (JeuEnCours_ > NUM_LIST_JEUX)
	MOVF        FARG_GesBandeauJeu_JeuEnCours_+0, 0 
	SUBLW       15
	BTFSC       STATUS+0, 0 
	GOTO        L_GesBandeauJeu26
;GesMatrix.c,411 :: 		JeuEnCours_ = NUM_JEU_DEFAUT;
	MOVLW       14
	MOVWF       FARG_GesBandeauJeu_JeuEnCours_+0 
L_GesBandeauJeu26:
;GesMatrix.c,414 :: 		AppImageFond(FAUX,ImgJeux[JeuEnCours_]);
	CLRF        FARG_AppImageFond_PageImg+0 
	MOVLW       _ImgJeux+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_ImgJeux+0)
	MOVWF       FSR0H 
	MOVF        FARG_GesBandeauJeu_JeuEnCours_+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_AppImageFond_NumImg+0 
	CALL        _AppImageFond+0, 0
;GesMatrix.c,415 :: 		AppImageFond(VRAI,ImgJeux[JeuEnCours_]+1);
	MOVLW       1
	MOVWF       FARG_AppImageFond_PageImg+0 
	MOVLW       _ImgJeux+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_ImgJeux+0)
	MOVWF       FSR0H 
	MOVF        FARG_GesBandeauJeu_JeuEnCours_+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	ADDLW       1
	MOVWF       FARG_AppImageFond_NumImg+0 
	CALL        _AppImageFond+0, 0
;GesMatrix.c,416 :: 		ptAppelImg->Tempo2Img = ImgTempoJeux[JeuEnCours_];
	MOVLW       7
	ADDWF       FARG_GesBandeauJeu_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauJeu_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       _ImgTempoJeux+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_ImgTempoJeux+0)
	MOVWF       FSR0H 
	MOVF        FARG_GesBandeauJeu_JeuEnCours_+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,417 :: 		*ptTempoImg = 0;
	MOVFF       FARG_GesBandeauJeu_ptTempoImg+0, FSR1
	MOVFF       FARG_GesBandeauJeu_ptTempoImg+1, FSR1H
	CLRF        POSTINC1+0 
;GesMatrix.c,419 :: 		TypeVoletA = GeneNbAlea(VOLET_MINI_O, VOLET_MAXI_O);
	MOVLW       1
	MOVWF       FARG_GeneNbAlea_NbMini+0 
	MOVLW       3
	MOVWF       FARG_GeneNbAlea_NbMaxi+0 
	CALL        _GeneNbAlea+0, 0
;GesMatrix.c,420 :: 		ptAppelImg->TypeVolet  = TypeVoletA;
	MOVLW       3
	ADDWF       FARG_GesBandeauJeu_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauJeu_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,421 :: 		ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
	MOVLW       4
	ADDWF       FARG_GesBandeauJeu_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauJeu_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       25
	MOVWF       POSTINC1+0 
;GesMatrix.c,422 :: 		pie1.TMR1IE = 1;      //It gestion volet
	BSF         PIE1+0, 0 
;GesMatrix.c,423 :: 		}
L_end_GesBandeauJeu:
	RETURN      0
; end of _GesBandeauJeu

_GeneNbAlea:

;GesMatrix.c,438 :: 		unsigned short GeneNbAlea(unsigned short NbMini, unsigned short NbMaxi)
;GesMatrix.c,443 :: 		Temp = rand();
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       GeneNbAlea_Temp_L0+0 
	MOVF        R1, 0 
	MOVWF       GeneNbAlea_Temp_L0+1 
;GesMatrix.c,444 :: 		NbAlea = lo(Temp) + hi(Temp);
	MOVF        GeneNbAlea_Temp_L0+1, 0 
	ADDWF       GeneNbAlea_Temp_L0+0, 0 
	MOVWF       R2 
;GesMatrix.c,445 :: 		NbAlea = NbAlea % (NbMaxi - NbMini + 1);
	MOVF        FARG_GeneNbAlea_NbMini+0, 0 
	SUBWF       FARG_GeneNbAlea_NbMaxi+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       R4 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
;GesMatrix.c,446 :: 		NbAlea = NbAlea + NbMini;
	MOVF        FARG_GeneNbAlea_NbMini+0, 0 
	ADDWF       R0, 1 
;GesMatrix.c,448 :: 		return NbAlea;
;GesMatrix.c,450 :: 		}
L_end_GeneNbAlea:
	RETURN      0
; end of _GeneNbAlea

_GesCliBandeau:

;GesMatrix.c,467 :: 		void GesCliBandeau (t_AppImg *ptAppelImg)
;GesMatrix.c,471 :: 		if (ptAppelImg->TempoCli == 0)
	MOVLW       6
	ADDWF       FARG_GesCliBandeau_ptAppelImg+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesCliBandeau_ptAppelImg+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_GesCliBandeau27
;GesMatrix.c,473 :: 		if (CliImg.CliEnCours == VRAI)
	MOVF        GesCliBandeau_CliImg_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_GesCliBandeau28
;GesMatrix.c,477 :: 		ccp1con = INIT_CCP_CON;
	MOVLW       28
	MOVWF       CCP1CON+0 
;GesMatrix.c,478 :: 		ccpr1l = ptAppelImg->ValPWM;
	MOVLW       5
	ADDWF       FARG_GesCliBandeau_ptAppelImg+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesCliBandeau_ptAppelImg+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       CCPR1L+0 
;GesMatrix.c,479 :: 		CliImg.CliEnCours = FAUX;
	CLRF        GesCliBandeau_CliImg_L0+0 
;GesMatrix.c,480 :: 		CliImg.TempoCli = 0;
	CLRF        GesCliBandeau_CliImg_L0+2 
;GesMatrix.c,481 :: 		}
L_GesCliBandeau28:
;GesMatrix.c,482 :: 		}
	GOTO        L_GesCliBandeau29
L_GesCliBandeau27:
;GesMatrix.c,485 :: 		CliImg.CliEnCours = VRAI;
	MOVLW       1
	MOVWF       GesCliBandeau_CliImg_L0+0 
;GesMatrix.c,486 :: 		CliImg.TempoCli++;
	MOVF        GesCliBandeau_CliImg_L0+2, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       GesCliBandeau_CliImg_L0+2 
;GesMatrix.c,487 :: 		if (CliImg.TempoCli == ptAppelImg->TempoCli)
	MOVLW       6
	ADDWF       FARG_GesCliBandeau_ptAppelImg+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_GesCliBandeau_ptAppelImg+1, 0 
	MOVWF       FSR2H 
	MOVF        GesCliBandeau_CliImg_L0+2, 0 
	XORWF       POSTINC2+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_GesCliBandeau30
;GesMatrix.c,489 :: 		CliImg.TempoCli = 0;
	CLRF        GesCliBandeau_CliImg_L0+2 
;GesMatrix.c,490 :: 		if (CliImg.AffCli == FAUX)
	MOVF        GesCliBandeau_CliImg_L0+1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_GesCliBandeau31
;GesMatrix.c,495 :: 		ccp1con = STOP_PWM;
	CLRF        CCP1CON+0 
;GesMatrix.c,496 :: 		portc.BIT_OE_MTRX = 1;
	BSF         PORTC+0, 2 
;GesMatrix.c,497 :: 		CliImg.AffCli = VRAI;
	MOVLW       1
	MOVWF       GesCliBandeau_CliImg_L0+1 
;GesMatrix.c,498 :: 		}
	GOTO        L_GesCliBandeau32
L_GesCliBandeau31:
;GesMatrix.c,502 :: 		ccp1con = INIT_CCP_CON;
	MOVLW       28
	MOVWF       CCP1CON+0 
;GesMatrix.c,503 :: 		ccpr1l = AppelImg.ValPWM;
	MOVF        _AppelImg+5, 0 
	MOVWF       CCPR1L+0 
;GesMatrix.c,504 :: 		CliImg.AffCli = FAUX;
	CLRF        GesCliBandeau_CliImg_L0+1 
;GesMatrix.c,505 :: 		}
L_GesCliBandeau32:
;GesMatrix.c,506 :: 		}
L_GesCliBandeau30:
;GesMatrix.c,507 :: 		}
L_GesCliBandeau29:
;GesMatrix.c,508 :: 		}
L_end_GesCliBandeau:
	RETURN      0
; end of _GesCliBandeau

_InitEcrMem:

;GesMatrix.c,524 :: 		void InitEcrMem(unsigned short PageMemHaute)
;GesMatrix.c,527 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;GesMatrix.c,528 :: 		portb.BIT_RAZ_CPT = 1;
	BSF         PORTB+0, 6 
;GesMatrix.c,529 :: 		delay_us(10);
	MOVLW       33
	MOVWF       R13, 0
L_InitEcrMem33:
	DECFSZ      R13, 1, 1
	BRA         L_InitEcrMem33
;GesMatrix.c,530 :: 		portb.BIT_RAZ_CPT = 0;
	BCF         PORTB+0, 6 
;GesMatrix.c,533 :: 		portc.BIT_OE_MEM = 0;
	BCF         PORTC+0, 6 
;GesMatrix.c,534 :: 		if (PageMemHaute == VRAI)
	MOVF        FARG_InitEcrMem_PageMemHaute+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_InitEcrMem34
;GesMatrix.c,535 :: 		portb.BIT_PAGE_MEM = 1;
	BSF         PORTB+0, 4 
	GOTO        L_InitEcrMem35
L_InitEcrMem34:
;GesMatrix.c,537 :: 		portb.BIT_PAGE_MEM = 0;
	BCF         PORTB+0, 4 
L_InitEcrMem35:
;GesMatrix.c,538 :: 		portc.BIT_RW_MEM = 0;
	BCF         PORTC+0, 5 
;GesMatrix.c,539 :: 		trisd = CONF_PORT_D_OUT;
	MOVLW       192
	MOVWF       TRISD+0 
;GesMatrix.c,540 :: 		}
L_end_InitEcrMem:
	RETURN      0
; end of _InitEcrMem

_InitLecMem:

;GesMatrix.c,555 :: 		void InitLecMem(unsigned short PageMemHaute)
;GesMatrix.c,558 :: 		trisd = CONF_PORT_D_IN;
	MOVLW       255
	MOVWF       TRISD+0 
;GesMatrix.c,559 :: 		portc.BIT_RW_MEM = 1;
	BSF         PORTC+0, 5 
;GesMatrix.c,560 :: 		portc.BIT_OE_MEM = 0;
	BCF         PORTC+0, 6 
;GesMatrix.c,561 :: 		if (PageMemHaute == VRAI)
	MOVF        FARG_InitLecMem_PageMemHaute+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_InitLecMem36
;GesMatrix.c,562 :: 		portb.BIT_PAGE_MEM = 1;
	BSF         PORTB+0, 4 
	GOTO        L_InitLecMem37
L_InitLecMem36:
;GesMatrix.c,564 :: 		portb.BIT_PAGE_MEM = 0;
	BCF         PORTB+0, 4 
L_InitLecMem37:
;GesMatrix.c,567 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;GesMatrix.c,568 :: 		portb.BIT_RAZ_CPT = 1;
	BSF         PORTB+0, 6 
;GesMatrix.c,569 :: 		delay_us(10);
	MOVLW       33
	MOVWF       R13, 0
L_InitLecMem38:
	DECFSZ      R13, 1, 1
	BRA         L_InitLecMem38
;GesMatrix.c,570 :: 		portb.BIT_RAZ_CPT = 0;
	BCF         PORTB+0, 6 
;GesMatrix.c,572 :: 		}
L_end_InitLecMem:
	RETURN      0
; end of _InitLecMem

_ImageEEp2RAM:

;GesMatrix.c,589 :: 		void ImageEEp2RAM(unsigned short PageRAMHaute, unsigned short NumImgEEp)
;GesMatrix.c,591 :: 		unsigned int AdrIntEEp = 0;
	CLRF        ImageEEp2RAM_AdrIntEEp_L0+0 
	CLRF        ImageEEp2RAM_AdrIntEEp_L0+1 
	CLRF        ImageEEp2RAM_Cpt_L0+0 
	CLRF        ImageEEp2RAM_Cpt_L0+1 
;GesMatrix.c,599 :: 		NumColonne = 0xff;
	MOVLW       255
	MOVWF       _NumColonne+0 
;GesMatrix.c,600 :: 		NumLigne   = 0;
	CLRF        _NumLigne+0 
;GesMatrix.c,603 :: 		if (NumImgEEp >= IMG_PAGE_BAS)
	MOVLW       16
	SUBWF       FARG_ImageEEp2RAM_NumImgEEp+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_ImageEEp2RAM39
;GesMatrix.c,605 :: 		PageEEpHaute = VRAI;
	MOVLW       1
	MOVWF       ImageEEp2RAM_PageEEpHaute_L0+0 
;GesMatrix.c,606 :: 		NumImgEEP = NumImgEEP - IMG_PAGE_BAS;
	MOVLW       16
	SUBWF       FARG_ImageEEp2RAM_NumImgEEp+0, 1 
;GesMatrix.c,607 :: 		}
	GOTO        L_ImageEEp2RAM40
L_ImageEEp2RAM39:
;GesMatrix.c,609 :: 		PageEEpHaute = FAUX;
	CLRF        ImageEEp2RAM_PageEEpHaute_L0+0 
L_ImageEEp2RAM40:
;GesMatrix.c,610 :: 		Hi(AdrIntEEp) = (NumImgEEp << 4);
	MOVF        FARG_ImageEEp2RAM_NumImgEEp+0, 0 
	MOVWF       ImageEEp2RAM_AdrIntEEp_L0+1 
	RLCF        ImageEEp2RAM_AdrIntEEp_L0+1, 1 
	BCF         ImageEEp2RAM_AdrIntEEp_L0+1, 0 
	RLCF        ImageEEp2RAM_AdrIntEEp_L0+1, 1 
	BCF         ImageEEp2RAM_AdrIntEEp_L0+1, 0 
	RLCF        ImageEEp2RAM_AdrIntEEp_L0+1, 1 
	BCF         ImageEEp2RAM_AdrIntEEp_L0+1, 0 
	RLCF        ImageEEp2RAM_AdrIntEEp_L0+1, 1 
	BCF         ImageEEp2RAM_AdrIntEEp_L0+1, 0 
;GesMatrix.c,613 :: 		Res = EcrAdrIntPoll(AdrintEEp, PageEEpHaute);
	MOVF        ImageEEp2RAM_AdrIntEEp_L0+0, 0 
	MOVWF       FARG_EcrAdrIntPoll_AdresseInt+0 
	MOVF        ImageEEp2RAM_AdrIntEEp_L0+1, 0 
	MOVWF       FARG_EcrAdrIntPoll_AdresseInt+1 
	MOVF        ImageEEp2RAM_PageEEpHaute_L0+0, 0 
	MOVWF       FARG_EcrAdrIntPoll_PageHaute+0 
	CALL        _EcrAdrIntPoll+0, 0
;GesMatrix.c,615 :: 		InitEcrMem(PageRAMHaute);
	MOVF        FARG_ImageEEp2RAM_PageRAMHaute+0, 0 
	MOVWF       FARG_InitEcrMem_PageMemHaute+0 
	CALL        _InitEcrMem+0, 0
;GesMatrix.c,616 :: 		Cpt = 0;
	CLRF        ImageEEp2RAM_Cpt_L0+0 
	CLRF        ImageEEp2RAM_Cpt_L0+1 
;GesMatrix.c,617 :: 		for (j=0 ; j != NB_PART_IMG ; j++)
	CLRF        ImageEEp2RAM_j_L0+0 
L_ImageEEp2RAM41:
	MOVF        ImageEEp2RAM_j_L0+0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_ImageEEp2RAM42
;GesMatrix.c,620 :: 		LecI2CPoll(LG_TAB_MATRIX, TabMatrix);
	MOVLW       0
	MOVWF       FARG_LecI2CPoll_NbByte2Read+0 
	MOVLW       1
	MOVWF       FARG_LecI2CPoll_NbByte2Read+1 
	MOVLW       _TabMatrix+0
	MOVWF       FARG_LecI2CPoll_ptBufferRead+0 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FARG_LecI2CPoll_ptBufferRead+1 
	CALL        _LecI2CPoll+0, 0
;GesMatrix.c,622 :: 		for (k=0 ; k != LG_TAB_MATRIX ; k++)
	CLRF        ImageEEp2RAM_k_L0+0 
	CLRF        ImageEEp2RAM_k_L0+1 
L_ImageEEp2RAM44:
	MOVF        ImageEEp2RAM_k_L0+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__ImageEEp2RAM82
	MOVLW       0
	XORWF       ImageEEp2RAM_k_L0+0, 0 
L__ImageEEp2RAM82:
	BTFSC       STATUS+0, 2 
	GOTO        L_ImageEEp2RAM45
;GesMatrix.c,624 :: 		latd = TabMatrix[k];
	MOVLW       _TabMatrix+0
	ADDWF       ImageEEp2RAM_k_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_TabMatrix+0)
	ADDWFC      ImageEEp2RAM_k_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       LATD+0 
;GesMatrix.c,625 :: 		portc.BIT_RW_MEM = 1;    //ack donnée
	BSF         PORTC+0, 5 
;GesMatrix.c,626 :: 		portc.BIT_CLK_MEM = 0;   //adresse suivante
	BCF         PORTC+0, 1 
;GesMatrix.c,627 :: 		delay_us(1);
	MOVLW       3
	MOVWF       R13, 0
L_ImageEEp2RAM47:
	DECFSZ      R13, 1, 1
	BRA         L_ImageEEp2RAM47
;GesMatrix.c,628 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;GesMatrix.c,629 :: 		delay_us(1);
	MOVLW       3
	MOVWF       R13, 0
L_ImageEEp2RAM48:
	DECFSZ      R13, 1, 1
	BRA         L_ImageEEp2RAM48
;GesMatrix.c,631 :: 		Cpt++;
	INFSNZ      ImageEEp2RAM_Cpt_L0+0, 1 
	INCF        ImageEEp2RAM_Cpt_L0+1, 1 
;GesMatrix.c,632 :: 		if (Cpt != TAILLE_IMAGE-1)
	MOVF        ImageEEp2RAM_Cpt_L0+1, 0 
	XORLW       15
	BTFSS       STATUS+0, 2 
	GOTO        L__ImageEEp2RAM83
	MOVLW       255
	XORWF       ImageEEp2RAM_Cpt_L0+0, 0 
L__ImageEEp2RAM83:
	BTFSC       STATUS+0, 2 
	GOTO        L_ImageEEp2RAM49
;GesMatrix.c,633 :: 		portc.BIT_RW_MEM = 0;
	BCF         PORTC+0, 5 
L_ImageEEp2RAM49:
;GesMatrix.c,634 :: 		delay_us(1);
	MOVLW       3
	MOVWF       R13, 0
L_ImageEEp2RAM50:
	DECFSZ      R13, 1, 1
	BRA         L_ImageEEp2RAM50
;GesMatrix.c,622 :: 		for (k=0 ; k != LG_TAB_MATRIX ; k++)
	INFSNZ      ImageEEp2RAM_k_L0+0, 1 
	INCF        ImageEEp2RAM_k_L0+1, 1 
;GesMatrix.c,635 :: 		}
	GOTO        L_ImageEEp2RAM44
L_ImageEEp2RAM45:
;GesMatrix.c,617 :: 		for (j=0 ; j != NB_PART_IMG ; j++)
	INCF        ImageEEp2RAM_j_L0+0, 1 
;GesMatrix.c,636 :: 		}
	GOTO        L_ImageEEp2RAM41
L_ImageEEp2RAM42:
;GesMatrix.c,638 :: 		InitLecMem(PageRAMHaute);
	MOVF        FARG_ImageEEp2RAM_PageRAMHaute+0, 0 
	MOVWF       FARG_InitLecMem_PageMemHaute+0 
	CALL        _InitLecMem+0, 0
;GesMatrix.c,640 :: 		}
L_end_ImageEEp2RAM:
	RETURN      0
; end of _ImageEEp2RAM

_VerifChkChkb:

;GesMatrix.c,658 :: 		unsigned short VerifChkChkb (char *ptData, unsigned short NbOctet)
;GesMatrix.c,664 :: 		ResVerif = FAUX;
	CLRF        R5 
;GesMatrix.c,665 :: 		Somme = 0;
	CLRF        R4 
;GesMatrix.c,666 :: 		for (i=0 ; i!= NbOctet-2 ; i++)
	CLRF        R3 
L_VerifChkChkb51:
	MOVLW       2
	SUBWF       FARG_VerifChkChkb_NbOctet+0, 0 
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	SUBWFB      R2, 1 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__VerifChkChkb85
	MOVF        R1, 0 
	XORWF       R3, 0 
L__VerifChkChkb85:
	BTFSC       STATUS+0, 2 
	GOTO        L_VerifChkChkb52
;GesMatrix.c,668 :: 		Somme = Somme + *(ptData + i);
	MOVF        R3, 0 
	ADDWF       FARG_VerifChkChkb_ptData+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_VerifChkChkb_ptData+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       R4, 1 
;GesMatrix.c,666 :: 		for (i=0 ; i!= NbOctet-2 ; i++)
	INCF        R3, 1 
;GesMatrix.c,669 :: 		}
	GOTO        L_VerifChkChkb51
L_VerifChkChkb52:
;GesMatrix.c,670 :: 		if (Somme == *(ptData + NbOctet - 2))
	MOVF        FARG_VerifChkChkb_NbOctet+0, 0 
	ADDWF       FARG_VerifChkChkb_ptData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_VerifChkChkb_ptData+1, 0 
	MOVWF       R1 
	MOVLW       2
	SUBWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       FSR2H 
	MOVF        R4, 0 
	XORWF       POSTINC2+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_VerifChkChkb54
;GesMatrix.c,672 :: 		Somme = ~Somme;
	COMF        R4, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R4 
;GesMatrix.c,673 :: 		if (Somme == *(ptData + NbOctet -1))
	MOVF        FARG_VerifChkChkb_NbOctet+0, 0 
	ADDWF       FARG_VerifChkChkb_ptData+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_VerifChkChkb_ptData+1, 0 
	MOVWF       R1 
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       FSR2H 
	MOVF        R2, 0 
	XORWF       POSTINC2+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_VerifChkChkb55
;GesMatrix.c,674 :: 		ResVerif = VRAI;
	MOVLW       1
	MOVWF       R5 
L_VerifChkChkb55:
;GesMatrix.c,675 :: 		}
L_VerifChkChkb54:
;GesMatrix.c,677 :: 		return ResVerif;
	MOVF        R5, 0 
	MOVWF       R0 
;GesMatrix.c,678 :: 		}
L_end_VerifChkChkb:
	RETURN      0
; end of _VerifChkChkb

_CalculChk:

;GesMatrix.c,698 :: 		void CalculChk(char *ptTab, unsigned short NbOctTab)
;GesMatrix.c,703 :: 		Somme = 0;
	CLRF        R3 
;GesMatrix.c,704 :: 		for (i=0; i!=NbOctTab-1; i++)
	CLRF        R4 
L_CalculChk56:
	DECF        FARG_CalculChk_NbOctTab+0, 0 
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	SUBWFB      R2, 1 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__CalculChk87
	MOVF        R1, 0 
	XORWF       R4, 0 
L__CalculChk87:
	BTFSC       STATUS+0, 2 
	GOTO        L_CalculChk57
;GesMatrix.c,706 :: 		Somme = Somme + *(ptTab+i);
	MOVF        R4, 0 
	ADDWF       FARG_CalculChk_ptTab+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_CalculChk_ptTab+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       R3, 1 
;GesMatrix.c,704 :: 		for (i=0; i!=NbOctTab-1; i++)
	INCF        R4, 1 
;GesMatrix.c,707 :: 		}
	GOTO        L_CalculChk56
L_CalculChk57:
;GesMatrix.c,708 :: 		*(ptTab + NbOctTab -1) = Somme;
	MOVF        FARG_CalculChk_NbOctTab+0, 0 
	ADDWF       FARG_CalculChk_ptTab+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_CalculChk_ptTab+1, 0 
	MOVWF       R1 
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       FSR1H 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,710 :: 		}
L_end_CalculChk:
	RETURN      0
; end of _CalculChk

_LecConfigEEP:

;GesMatrix.c,726 :: 		void LecConfigEEP()
;GesMatrix.c,730 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        LecConfigEEP_i_L0+0 
L_LecConfigEEP59:
	MOVF        LecConfigEEP_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_LecConfigEEP60
;GesMatrix.c,731 :: 		ImgJeux[i] = EEPROM_Read(EEP_NUM_IMAG_PROC_L+i);
	MOVLW       _ImgJeux+0
	MOVWF       FLOC__LecConfigEEP+0 
	MOVLW       hi_addr(_ImgJeux+0)
	MOVWF       FLOC__LecConfigEEP+1 
	MOVF        LecConfigEEP_i_L0+0, 0 
	ADDWF       FLOC__LecConfigEEP+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FLOC__LecConfigEEP+1, 1 
	MOVF        LecConfigEEP_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__LecConfigEEP+0, FSR1
	MOVFF       FLOC__LecConfigEEP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,730 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        LecConfigEEP_i_L0+0, 1 
;GesMatrix.c,731 :: 		ImgJeux[i] = EEPROM_Read(EEP_NUM_IMAG_PROC_L+i);
	GOTO        L_LecConfigEEP59
L_LecConfigEEP60:
;GesMatrix.c,732 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        LecConfigEEP_i_L0+0 
L_LecConfigEEP62:
	MOVF        LecConfigEEP_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_LecConfigEEP63
;GesMatrix.c,733 :: 		ImgJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_IMAG_PROC_H+i);
	MOVLW       8
	ADDWF       LecConfigEEP_i_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _ImgJeux+0
	ADDWF       R0, 0 
	MOVWF       FLOC__LecConfigEEP+0 
	MOVLW       hi_addr(_ImgJeux+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__LecConfigEEP+1 
	MOVF        R0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__LecConfigEEP+0, FSR1
	MOVFF       FLOC__LecConfigEEP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,732 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        LecConfigEEP_i_L0+0, 1 
;GesMatrix.c,733 :: 		ImgJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_IMAG_PROC_H+i);
	GOTO        L_LecConfigEEP62
L_LecConfigEEP63:
;GesMatrix.c,734 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        LecConfigEEP_i_L0+0 
L_LecConfigEEP65:
	MOVF        LecConfigEEP_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_LecConfigEEP66
;GesMatrix.c,735 :: 		ImgTempoJeux[i] = EEPROM_Read(EEP_NUM_DURE_PROC_L+i);
	MOVLW       _ImgTempoJeux+0
	MOVWF       FLOC__LecConfigEEP+0 
	MOVLW       hi_addr(_ImgTempoJeux+0)
	MOVWF       FLOC__LecConfigEEP+1 
	MOVF        LecConfigEEP_i_L0+0, 0 
	ADDWF       FLOC__LecConfigEEP+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FLOC__LecConfigEEP+1, 1 
	MOVF        LecConfigEEP_i_L0+0, 0 
	ADDLW       16
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__LecConfigEEP+0, FSR1
	MOVFF       FLOC__LecConfigEEP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,734 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        LecConfigEEP_i_L0+0, 1 
;GesMatrix.c,735 :: 		ImgTempoJeux[i] = EEPROM_Read(EEP_NUM_DURE_PROC_L+i);
	GOTO        L_LecConfigEEP65
L_LecConfigEEP66:
;GesMatrix.c,736 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        LecConfigEEP_i_L0+0 
L_LecConfigEEP68:
	MOVF        LecConfigEEP_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_LecConfigEEP69
;GesMatrix.c,737 :: 		ImgTempoJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_DURE_PROC_H+i);
	MOVLW       8
	ADDWF       LecConfigEEP_i_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _ImgTempoJeux+0
	ADDWF       R0, 0 
	MOVWF       FLOC__LecConfigEEP+0 
	MOVLW       hi_addr(_ImgTempoJeux+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__LecConfigEEP+1 
	MOVF        LecConfigEEP_i_L0+0, 0 
	ADDLW       24
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__LecConfigEEP+0, FSR1
	MOVFF       FLOC__LecConfigEEP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,736 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        LecConfigEEP_i_L0+0, 1 
;GesMatrix.c,737 :: 		ImgTempoJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_DURE_PROC_H+i);
	GOTO        L_LecConfigEEP68
L_LecConfigEEP69:
;GesMatrix.c,739 :: 		}
L_end_LecConfigEEP:
	RETURN      0
; end of _LecConfigEEP

_InitVarGlobal:

;GesMatrix.c,754 :: 		void InitVarGlobal()
;GesMatrix.c,756 :: 		AppelImg.MajImg = FAUX;
	CLRF        _AppelImg+0 
;GesMatrix.c,757 :: 		AppelImg.ValPWM = 0;     //luminosité maxi
	CLRF        _AppelImg+5 
;GesMatrix.c,758 :: 		AppelImg.TempoCli = 0;
	CLRF        _AppelImg+6 
;GesMatrix.c,759 :: 		AppelImg.Tempo2Img = 0;
	CLRF        _AppelImg+7 
;GesMatrix.c,764 :: 		}
L_end_InitVarGlobal:
	RETURN      0
; end of _InitVarGlobal

_InitPeriphFond:

;GesMatrix.c,783 :: 		void InitPeriphFond()
;GesMatrix.c,789 :: 		trisa  = CONF_PORT_A;
	MOVLW       240
	MOVWF       TRISA+0 
;GesMatrix.c,790 :: 		adcon1 = CONF_ADCON1;
	MOVLW       6
	MOVWF       ADCON1+0 
;GesMatrix.c,792 :: 		trisb = CONF_PORT_B;
	MOVLW       136
	MOVWF       TRISB+0 
;GesMatrix.c,793 :: 		trisc = CONF_PORT_C;
	MOVLW       24
	MOVWF       TRISC+0 
;GesMatrix.c,794 :: 		cmcon = CONF_CMCON;
	MOVLW       7
	MOVWF       CMCON+0 
;GesMatrix.c,795 :: 		trisd = CONF_PORT_D_IN;
	MOVLW       255
	MOVWF       TRISD+0 
;GesMatrix.c,799 :: 		lata = 0;
	CLRF        LATA+0 
;GesMatrix.c,800 :: 		latc = 0;
	CLRF        LATC+0 
;GesMatrix.c,801 :: 		latb = 0;
	CLRF        LATB+0 
;GesMatrix.c,802 :: 		latd = 0;
	CLRF        LATD+0 
;GesMatrix.c,804 :: 		latb.BIT_WDOG = 1;
	BSF         LATB+0, 0 
;GesMatrix.c,808 :: 		eecon1.EEPGD = 0;
	BCF         EECON1+0, 7 
;GesMatrix.c,809 :: 		eecon1.CFGS = 0;
	BCF         EECON1+0, 6 
;GesMatrix.c,812 :: 		portc.BIT_RW_MEM = 1;
	BSF         PORTC+0, 5 
;GesMatrix.c,813 :: 		portc.BIT_OE_MEM = 0;
	BCF         PORTC+0, 6 
;GesMatrix.c,814 :: 		portb.BIT_PAGE_MEM = 0;
	BCF         PORTB+0, 4 
;GesMatrix.c,817 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;GesMatrix.c,818 :: 		portb.BIT_RAZ_CPT = 1;
	BSF         PORTB+0, 6 
;GesMatrix.c,819 :: 		delay_us(10);
	MOVLW       33
	MOVWF       R13, 0
L_InitPeriphFond71:
	DECFSZ      R13, 1, 1
	BRA         L_InitPeriphFond71
;GesMatrix.c,820 :: 		portb.BIT_RAZ_CPT = 0;
	BCF         PORTB+0, 6 
;GesMatrix.c,823 :: 		porta = 0;    //selection ligne 0
	CLRF        PORTA+0 
;GesMatrix.c,824 :: 		portc.BIT_LATCH_MTRX = 0;
	BCF         PORTC+0, 0 
;GesMatrix.c,825 :: 		portc.BIT_CLK_MTRX = 0;
	BCF         PORTC+0, 7 
;GesMatrix.c,829 :: 		pr2 = MAX_PERIODE;
	MOVLW       255
	MOVWF       PR2+0 
;GesMatrix.c,830 :: 		t2con = INIT_T2_CON;
	MOVLW       6
	MOVWF       T2CON+0 
;GesMatrix.c,831 :: 		ccp1con = INIT_CCP_CON;
	MOVLW       28
	MOVWF       CCP1CON+0 
;GesMatrix.c,832 :: 		ccpr1l = 0x00;
	CLRF        CCPR1L+0 
;GesMatrix.c,835 :: 		rcon.IPEN = 1;
	BSF         RCON+0, 7 
;GesMatrix.c,837 :: 		}
L_end_InitPeriphFond:
	RETURN      0
; end of _InitPeriphFond
