
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
;GesMatrix.c,186 :: 		for(;;)
L_main1:
;GesMatrix.c,191 :: 		if (AppelImg.MajImg == VRAI)
	MOVF        _AppelImg+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
;GesMatrix.c,193 :: 		AppImageFond(AppelImg.PageHaut, AppelImg.NumImage);
	MOVF        _AppelImg+1, 0 
	MOVWF       FARG_AppImageFond_PageImg+0 
	MOVF        _AppelImg+2, 0 
	MOVWF       FARG_AppImageFond_NumImg+0 
	CALL        _AppImageFond+0, 0
;GesMatrix.c,194 :: 		AppelImg.MajImg = FAUX;
	CLRF        _AppelImg+0 
;GesMatrix.c,195 :: 		}
L_main4:
;GesMatrix.c,200 :: 		GesCliBandeau (&AppelImg);
	MOVLW       _AppelImg+0
	MOVWF       FARG_GesCliBandeau_ptAppelImg+0 
	MOVLW       hi_addr(_AppelImg+0)
	MOVWF       FARG_GesCliBandeau_ptAppelImg+1 
	CALL        _GesCliBandeau+0, 0
;GesMatrix.c,206 :: 		ModeEnCoursLoc = ModeEnCours;
	MOVF        _ModeEnCours+0, 0 
	MOVWF       main_ModeEnCoursLoc_L0+0 
;GesMatrix.c,207 :: 		if (ModeEnCoursLoc == RETROPI)
	MOVF        _ModeEnCours+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;GesMatrix.c,209 :: 		ModeEnCoursPrec = ModeEnCoursLoc;
	MOVF        main_ModeEnCoursLoc_L0+0, 0 
	MOVWF       main_ModeEnCoursPrec_L0+0 
;GesMatrix.c,210 :: 		GesBandeauInit(&TempoImg, &AppelImg);
	MOVLW       main_TempoImg_L0+0
	MOVWF       FARG_GesBandeauInit_ptTempoImg+0 
	MOVLW       hi_addr(main_TempoImg_L0+0)
	MOVWF       FARG_GesBandeauInit_ptTempoImg+1 
	MOVLW       _AppelImg+0
	MOVWF       FARG_GesBandeauInit_ptAppelImg+0 
	MOVLW       hi_addr(_AppelImg+0)
	MOVWF       FARG_GesBandeauInit_ptAppelImg+1 
	CALL        _GesBandeauInit+0, 0
;GesMatrix.c,211 :: 		}
	GOTO        L_main6
L_main5:
;GesMatrix.c,212 :: 		else if ((ModeEnCoursLoc != ModeEnCoursPrec) && (!pie1.TMR1IE))
	MOVF        main_ModeEnCoursLoc_L0+0, 0 
	XORWF       main_ModeEnCoursPrec_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
	BTFSC       PIE1+0, 0 
	GOTO        L_main9
L__main72:
;GesMatrix.c,216 :: 		ModeEnCoursPrec = ModeEnCoursLoc;
	MOVF        main_ModeEnCoursLoc_L0+0, 0 
	MOVWF       main_ModeEnCoursPrec_L0+0 
;GesMatrix.c,217 :: 		GesBandeauJeu(&TempoImg, ModeEnCoursLoc, &AppelImg);
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
;GesMatrix.c,218 :: 		}
L_main9:
L_main6:
;GesMatrix.c,223 :: 		if (AppelImg.Tempo2Img != 0)
	MOVF        _AppelImg+7, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
;GesMatrix.c,225 :: 		TempoImg++;
	INCF        main_TempoImg_L0+0, 1 
;GesMatrix.c,226 :: 		if (TempoImg == AppelImg.Tempo2Img)
	MOVF        main_TempoImg_L0+0, 0 
	XORWF       _AppelImg+7, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main11
;GesMatrix.c,228 :: 		TempoImg = 0;
	CLRF        main_TempoImg_L0+0 
;GesMatrix.c,229 :: 		portb.BIT_PAGE_MEM = !portb.BIT_PAGE_MEM;
	BTG         PORTB+0, 4 
;GesMatrix.c,230 :: 		}
L_main11:
;GesMatrix.c,231 :: 		}
	GOTO        L_main12
L_main10:
;GesMatrix.c,233 :: 		TempoImg = 0;
	CLRF        main_TempoImg_L0+0 
L_main12:
;GesMatrix.c,237 :: 		gTempoWDOG--;
	DECF        _gTempoWDOG+0, 1 
;GesMatrix.c,238 :: 		if (gTempoWDOG == 0)
	MOVF        _gTempoWDOG+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
;GesMatrix.c,240 :: 		if (RecOK == REC_OK)
	MOVF        _RecOK+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main14
;GesMatrix.c,241 :: 		gTempoWDOG = TEMPO_WDOG;
	MOVLW       1
	MOVWF       _gTempoWDOG+0 
	GOTO        L_main15
L_main14:
;GesMatrix.c,243 :: 		gTempoWDOG = TEMPO_WDOG_ERR;
	MOVLW       25
	MOVWF       _gTempoWDOG+0 
L_main15:
;GesMatrix.c,244 :: 		gTempoWDOG = TEMPO_WDOG;
	MOVLW       1
	MOVWF       _gTempoWDOG+0 
;GesMatrix.c,245 :: 		portb.BIT_WDOG = !portb.BIT_WDOG;
	BTG         PORTB+0, 0 
;GesMatrix.c,246 :: 		}
L_main13:
;GesMatrix.c,247 :: 		Delay_ms(TEMPO_SCRUT);
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
;GesMatrix.c,248 :: 		}
	GOTO        L_main1
;GesMatrix.c,249 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_AppImageFond:

;GesMatrix.c,268 :: 		void AppImageFond(unsigned short PageImg, unsigned short NumImg)
;GesMatrix.c,273 :: 		if (NumImg < NUM_MAX_IMG)
	MOVLW       32
	SUBWF       FARG_AppImageFond_NumImg+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_AppImageFond17
;GesMatrix.c,278 :: 		ccp1con = STOP_PWM;
	CLRF        CCP1CON+0 
;GesMatrix.c,279 :: 		portc.BIT_OE_MTRX = 1;
	BSF         PORTC+0, 2 
;GesMatrix.c,281 :: 		pie2.TMR3IE = 0;
	BCF         PIE2+0, 1 
;GesMatrix.c,283 :: 		SaveVD = VoletDroit;     //volet droit et gauche sont ecras? lors du
	MOVF        _VoletDroit+0, 0 
	MOVWF       AppImageFond_SaveVD_L0+0 
;GesMatrix.c,284 :: 		SaveVG = VoletGauche;    //chargement d'une image !!!!!!!!!!!
	MOVF        _VoletGauche+0, 0 
	MOVWF       AppImageFond_SaveVG_L0+0 
;GesMatrix.c,286 :: 		ImageEEp2RAM(PageImg, NumImg);
	MOVF        FARG_AppImageFond_PageImg+0, 0 
	MOVWF       FARG_ImageEEp2RAM_PageRAMHaute+0 
	MOVF        FARG_AppImageFond_NumImg+0, 0 
	MOVWF       FARG_ImageEEp2RAM_NumImgEEp+0 
	CALL        _ImageEEp2RAM+0, 0
;GesMatrix.c,287 :: 		delay_us(20);
	MOVLW       66
	MOVWF       R13, 0
L_AppImageFond18:
	DECFSZ      R13, 1, 1
	BRA         L_AppImageFond18
	NOP
;GesMatrix.c,289 :: 		VoletDroit = SaveVD;
	MOVF        AppImageFond_SaveVD_L0+0, 0 
	MOVWF       _VoletDroit+0 
;GesMatrix.c,290 :: 		VoletGauche = SaveVG;
	MOVF        AppImageFond_SaveVG_L0+0, 0 
	MOVWF       _VoletGauche+0 
;GesMatrix.c,291 :: 		pie2.TMR3IE = 1;
	BSF         PIE2+0, 1 
;GesMatrix.c,294 :: 		ccp1con = INIT_CCP_CON;
	MOVLW       28
	MOVWF       CCP1CON+0 
;GesMatrix.c,295 :: 		ccpr1l = AppelImg.ValPWM;
	MOVF        _AppelImg+5, 0 
	MOVWF       CCPR1L+0 
;GesMatrix.c,296 :: 		}
L_AppImageFond17:
;GesMatrix.c,297 :: 		}
L_end_AppImageFond:
	RETURN      0
; end of _AppImageFond

_GesBandeauInit:

;GesMatrix.c,323 :: 		void GesBandeauInit (unsigned short *ptTempoImg, t_AppImg *ptAppelImg)
;GesMatrix.c,333 :: 		if (VoletOuvrant == VRAI)
	MOVF        GesBandeauInit_VoletOuvrant_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_GesBandeauInit19
;GesMatrix.c,335 :: 		if (!pie1.TMR1IE)
	BTFSC       PIE1+0, 0 
	GOTO        L_GesBandeauInit20
;GesMatrix.c,340 :: 		AppImageFond(FAUX,ImgInit[NumImage_]);
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
;GesMatrix.c,341 :: 		delay_us(20);
	MOVLW       66
	MOVWF       R13, 0
L_GesBandeauInit21:
	DECFSZ      R13, 1, 1
	BRA         L_GesBandeauInit21
	NOP
;GesMatrix.c,343 :: 		AppImageFond(VRAI,ImgInit[NumImage_]+1);
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
;GesMatrix.c,344 :: 		delay_us(20);
	MOVLW       66
	MOVWF       R13, 0
L_GesBandeauInit22:
	DECFSZ      R13, 1, 1
	BRA         L_GesBandeauInit22
	NOP
;GesMatrix.c,345 :: 		ptAppelImg->Tempo2Img = ImgTempo[NumImage_];
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
;GesMatrix.c,346 :: 		*ptTempoImg = 0;
	MOVFF       FARG_GesBandeauInit_ptTempoImg+0, FSR1
	MOVFF       FARG_GesBandeauInit_ptTempoImg+1, FSR1H
	CLRF        POSTINC1+0 
;GesMatrix.c,348 :: 		TypeVoletA = GeneNbAlea(VOLET_MINI_O, VOLET_MAXI_O);
	MOVLW       1
	MOVWF       FARG_GeneNbAlea_NbMini+0 
	MOVLW       3
	MOVWF       FARG_GeneNbAlea_NbMaxi+0 
	CALL        _GeneNbAlea+0, 0
;GesMatrix.c,349 :: 		ptAppelImg->TypeVolet  = TypeVoletA;
	MOVLW       3
	ADDWF       FARG_GesBandeauInit_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauInit_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,350 :: 		ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
	MOVLW       4
	ADDWF       FARG_GesBandeauInit_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauInit_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       25
	MOVWF       POSTINC1+0 
;GesMatrix.c,351 :: 		pie1.TMR1IE = 1;      //It gestion volet
	BSF         PIE1+0, 0 
;GesMatrix.c,353 :: 		VoletOuvrant = FAUX;
	CLRF        GesBandeauInit_VoletOuvrant_L0+0 
;GesMatrix.c,354 :: 		NumImage_++;
	INCF        GesBandeauInit_NumImage__L0+0, 1 
;GesMatrix.c,355 :: 		if (NumImage_ == NUM_LIST_IMG)
	MOVF        GesBandeauInit_NumImage__L0+0, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_GesBandeauInit23
;GesMatrix.c,356 :: 		NumImage_ = 0;
	CLRF        GesBandeauInit_NumImage__L0+0 
L_GesBandeauInit23:
;GesMatrix.c,357 :: 		}
L_GesBandeauInit20:
;GesMatrix.c,358 :: 		}
	GOTO        L_GesBandeauInit24
L_GesBandeauInit19:
;GesMatrix.c,361 :: 		TempoAffImg++;
	INCF        GesBandeauInit_TempoAffImg_L0+0, 1 
;GesMatrix.c,362 :: 		if (TempoAffImg == TEMPO_AFF_IMG)
	MOVF        GesBandeauInit_TempoAffImg_L0+0, 0 
	XORLW       200
	BTFSS       STATUS+0, 2 
	GOTO        L_GesBandeauInit25
;GesMatrix.c,364 :: 		TempoAffImg = 0;
	CLRF        GesBandeauInit_TempoAffImg_L0+0 
;GesMatrix.c,366 :: 		TypeVoletA = GeneNbAlea(VOLET_MINI_F, VOLET_MAXI_F);
	MOVLW       4
	MOVWF       FARG_GeneNbAlea_NbMini+0 
	MOVLW       6
	MOVWF       FARG_GeneNbAlea_NbMaxi+0 
	CALL        _GeneNbAlea+0, 0
;GesMatrix.c,367 :: 		ptAppelImg->TypeVolet  = TypeVoletA;
	MOVLW       3
	ADDWF       FARG_GesBandeauInit_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauInit_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,368 :: 		ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
	MOVLW       4
	ADDWF       FARG_GesBandeauInit_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauInit_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       25
	MOVWF       POSTINC1+0 
;GesMatrix.c,369 :: 		pie1.TMR1IE = 1;      //It gestion volet
	BSF         PIE1+0, 0 
;GesMatrix.c,370 :: 		VoletOuvrant = VRAI;
	MOVLW       1
	MOVWF       GesBandeauInit_VoletOuvrant_L0+0 
;GesMatrix.c,371 :: 		}
L_GesBandeauInit25:
;GesMatrix.c,372 :: 		}
L_GesBandeauInit24:
;GesMatrix.c,373 :: 		}
L_end_GesBandeauInit:
	RETURN      0
; end of _GesBandeauInit

_GesBandeauJeu:

;GesMatrix.c,407 :: 		void GesBandeauJeu (unsigned short *ptTempoImg, unsigned short JeuEnCours_, t_AppImg *ptAppelImg)
;GesMatrix.c,411 :: 		JeuEnCours_--;
	DECF        FARG_GesBandeauJeu_JeuEnCours_+0, 1 
;GesMatrix.c,412 :: 		if (JeuEnCours_ > NUM_LIST_JEUX)
	MOVF        FARG_GesBandeauJeu_JeuEnCours_+0, 0 
	SUBLW       15
	BTFSC       STATUS+0, 0 
	GOTO        L_GesBandeauJeu26
;GesMatrix.c,413 :: 		JeuEnCours_ = NUM_JEU_DEFAUT;
	MOVLW       14
	MOVWF       FARG_GesBandeauJeu_JeuEnCours_+0 
L_GesBandeauJeu26:
;GesMatrix.c,416 :: 		AppImageFond(FAUX,ImgJeux[JeuEnCours_]);
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
;GesMatrix.c,417 :: 		AppImageFond(VRAI,ImgJeux[JeuEnCours_]+1);
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
;GesMatrix.c,418 :: 		ptAppelImg->Tempo2Img = ImgTempoJeux[JeuEnCours_];
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
;GesMatrix.c,419 :: 		*ptTempoImg = 0;
	MOVFF       FARG_GesBandeauJeu_ptTempoImg+0, FSR1
	MOVFF       FARG_GesBandeauJeu_ptTempoImg+1, FSR1H
	CLRF        POSTINC1+0 
;GesMatrix.c,421 :: 		TypeVoletA = GeneNbAlea(VOLET_MINI_O, VOLET_MAXI_O);
	MOVLW       1
	MOVWF       FARG_GeneNbAlea_NbMini+0 
	MOVLW       3
	MOVWF       FARG_GeneNbAlea_NbMaxi+0 
	CALL        _GeneNbAlea+0, 0
;GesMatrix.c,422 :: 		ptAppelImg->TypeVolet  = TypeVoletA;
	MOVLW       3
	ADDWF       FARG_GesBandeauJeu_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauJeu_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;GesMatrix.c,423 :: 		ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
	MOVLW       4
	ADDWF       FARG_GesBandeauJeu_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesBandeauJeu_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       25
	MOVWF       POSTINC1+0 
;GesMatrix.c,424 :: 		pie1.TMR1IE = 1;      //It gestion volet
	BSF         PIE1+0, 0 
;GesMatrix.c,425 :: 		}
L_end_GesBandeauJeu:
	RETURN      0
; end of _GesBandeauJeu

_GeneNbAlea:

;GesMatrix.c,440 :: 		unsigned short GeneNbAlea(unsigned short NbMini, unsigned short NbMaxi)
;GesMatrix.c,445 :: 		Temp = rand();
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       GeneNbAlea_Temp_L0+0 
	MOVF        R1, 0 
	MOVWF       GeneNbAlea_Temp_L0+1 
;GesMatrix.c,446 :: 		NbAlea = lo(Temp) + hi(Temp);
	MOVF        GeneNbAlea_Temp_L0+1, 0 
	ADDWF       GeneNbAlea_Temp_L0+0, 0 
	MOVWF       R2 
;GesMatrix.c,447 :: 		NbAlea = NbAlea % (NbMaxi - NbMini + 1);
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
;GesMatrix.c,448 :: 		NbAlea = NbAlea + NbMini;
	MOVF        FARG_GeneNbAlea_NbMini+0, 0 
	ADDWF       R0, 1 
;GesMatrix.c,450 :: 		return NbAlea;
;GesMatrix.c,452 :: 		}
L_end_GeneNbAlea:
	RETURN      0
; end of _GeneNbAlea

_GesCliBandeau:

;GesMatrix.c,469 :: 		void GesCliBandeau (t_AppImg *ptAppelImg)
;GesMatrix.c,473 :: 		if (ptAppelImg->TempoCli == 0)
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
;GesMatrix.c,475 :: 		if (CliImg.CliEnCours == VRAI)
	MOVF        GesCliBandeau_CliImg_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_GesCliBandeau28
;GesMatrix.c,479 :: 		ccp1con = INIT_CCP_CON;
	MOVLW       28
	MOVWF       CCP1CON+0 
;GesMatrix.c,480 :: 		ccpr1l = ptAppelImg->ValPWM;
	MOVLW       5
	ADDWF       FARG_GesCliBandeau_ptAppelImg+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesCliBandeau_ptAppelImg+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       CCPR1L+0 
;GesMatrix.c,481 :: 		CliImg.CliEnCours = FAUX;
	CLRF        GesCliBandeau_CliImg_L0+0 
;GesMatrix.c,482 :: 		CliImg.TempoCli = 0;
	CLRF        GesCliBandeau_CliImg_L0+2 
;GesMatrix.c,483 :: 		}
L_GesCliBandeau28:
;GesMatrix.c,484 :: 		}
	GOTO        L_GesCliBandeau29
L_GesCliBandeau27:
;GesMatrix.c,487 :: 		CliImg.CliEnCours = VRAI;
	MOVLW       1
	MOVWF       GesCliBandeau_CliImg_L0+0 
;GesMatrix.c,488 :: 		CliImg.TempoCli++;
	MOVF        GesCliBandeau_CliImg_L0+2, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       GesCliBandeau_CliImg_L0+2 
;GesMatrix.c,489 :: 		if (CliImg.TempoCli == ptAppelImg->TempoCli)
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
;GesMatrix.c,491 :: 		CliImg.TempoCli = 0;
	CLRF        GesCliBandeau_CliImg_L0+2 
;GesMatrix.c,492 :: 		if (CliImg.AffCli == FAUX)
	MOVF        GesCliBandeau_CliImg_L0+1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_GesCliBandeau31
;GesMatrix.c,497 :: 		ccp1con = STOP_PWM;
	CLRF        CCP1CON+0 
;GesMatrix.c,498 :: 		portc.BIT_OE_MTRX = 1;
	BSF         PORTC+0, 2 
;GesMatrix.c,499 :: 		CliImg.AffCli = VRAI;
	MOVLW       1
	MOVWF       GesCliBandeau_CliImg_L0+1 
;GesMatrix.c,500 :: 		}
	GOTO        L_GesCliBandeau32
L_GesCliBandeau31:
;GesMatrix.c,504 :: 		ccp1con = INIT_CCP_CON;
	MOVLW       28
	MOVWF       CCP1CON+0 
;GesMatrix.c,505 :: 		ccpr1l = AppelImg.ValPWM;
	MOVF        _AppelImg+5, 0 
	MOVWF       CCPR1L+0 
;GesMatrix.c,506 :: 		CliImg.AffCli = FAUX;
	CLRF        GesCliBandeau_CliImg_L0+1 
;GesMatrix.c,507 :: 		}
L_GesCliBandeau32:
;GesMatrix.c,508 :: 		}
L_GesCliBandeau30:
;GesMatrix.c,509 :: 		}
L_GesCliBandeau29:
;GesMatrix.c,510 :: 		}
L_end_GesCliBandeau:
	RETURN      0
; end of _GesCliBandeau

_InitEcrMem:

;GesMatrix.c,526 :: 		void InitEcrMem(unsigned short PageMemHaute)
;GesMatrix.c,529 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;GesMatrix.c,530 :: 		portb.BIT_RAZ_CPT = 1;
	BSF         PORTB+0, 6 
;GesMatrix.c,531 :: 		delay_us(10);
	MOVLW       33
	MOVWF       R13, 0
L_InitEcrMem33:
	DECFSZ      R13, 1, 1
	BRA         L_InitEcrMem33
;GesMatrix.c,532 :: 		portb.BIT_RAZ_CPT = 0;
	BCF         PORTB+0, 6 
;GesMatrix.c,535 :: 		portc.BIT_OE_MEM = 0;
	BCF         PORTC+0, 6 
;GesMatrix.c,536 :: 		if (PageMemHaute == VRAI)
	MOVF        FARG_InitEcrMem_PageMemHaute+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_InitEcrMem34
;GesMatrix.c,537 :: 		portb.BIT_PAGE_MEM = 1;
	BSF         PORTB+0, 4 
	GOTO        L_InitEcrMem35
L_InitEcrMem34:
;GesMatrix.c,539 :: 		portb.BIT_PAGE_MEM = 0;
	BCF         PORTB+0, 4 
L_InitEcrMem35:
;GesMatrix.c,540 :: 		portc.BIT_RW_MEM = 0;
	BCF         PORTC+0, 5 
;GesMatrix.c,541 :: 		trisd = CONF_PORT_D_OUT;
	MOVLW       192
	MOVWF       TRISD+0 
;GesMatrix.c,542 :: 		}
L_end_InitEcrMem:
	RETURN      0
; end of _InitEcrMem

_InitLecMem:

;GesMatrix.c,557 :: 		void InitLecMem(unsigned short PageMemHaute)
;GesMatrix.c,560 :: 		trisd = CONF_PORT_D_IN;
	MOVLW       255
	MOVWF       TRISD+0 
;GesMatrix.c,561 :: 		portc.BIT_RW_MEM = 1;
	BSF         PORTC+0, 5 
;GesMatrix.c,562 :: 		portc.BIT_OE_MEM = 0;
	BCF         PORTC+0, 6 
;GesMatrix.c,563 :: 		if (PageMemHaute == VRAI)
	MOVF        FARG_InitLecMem_PageMemHaute+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_InitLecMem36
;GesMatrix.c,564 :: 		portb.BIT_PAGE_MEM = 1;
	BSF         PORTB+0, 4 
	GOTO        L_InitLecMem37
L_InitLecMem36:
;GesMatrix.c,566 :: 		portb.BIT_PAGE_MEM = 0;
	BCF         PORTB+0, 4 
L_InitLecMem37:
;GesMatrix.c,569 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;GesMatrix.c,570 :: 		portb.BIT_RAZ_CPT = 1;
	BSF         PORTB+0, 6 
;GesMatrix.c,571 :: 		delay_us(10);
	MOVLW       33
	MOVWF       R13, 0
L_InitLecMem38:
	DECFSZ      R13, 1, 1
	BRA         L_InitLecMem38
;GesMatrix.c,572 :: 		portb.BIT_RAZ_CPT = 0;
	BCF         PORTB+0, 6 
;GesMatrix.c,574 :: 		}
L_end_InitLecMem:
	RETURN      0
; end of _InitLecMem

_ImageEEp2RAM:

;GesMatrix.c,591 :: 		void ImageEEp2RAM(unsigned short PageRAMHaute, unsigned short NumImgEEp)
;GesMatrix.c,593 :: 		unsigned int AdrIntEEp = 0;
	CLRF        ImageEEp2RAM_AdrIntEEp_L0+0 
	CLRF        ImageEEp2RAM_AdrIntEEp_L0+1 
	CLRF        ImageEEp2RAM_Cpt_L0+0 
	CLRF        ImageEEp2RAM_Cpt_L0+1 
;GesMatrix.c,601 :: 		NumColonne = 0xff;
	MOVLW       255
	MOVWF       _NumColonne+0 
;GesMatrix.c,602 :: 		NumLigne   = 0;
	CLRF        _NumLigne+0 
;GesMatrix.c,605 :: 		if (NumImgEEp >= IMG_PAGE_BAS)
	MOVLW       16
	SUBWF       FARG_ImageEEp2RAM_NumImgEEp+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_ImageEEp2RAM39
;GesMatrix.c,607 :: 		PageEEpHaute = VRAI;
	MOVLW       1
	MOVWF       ImageEEp2RAM_PageEEpHaute_L0+0 
;GesMatrix.c,608 :: 		NumImgEEP = NumImgEEP - IMG_PAGE_BAS;
	MOVLW       16
	SUBWF       FARG_ImageEEp2RAM_NumImgEEp+0, 1 
;GesMatrix.c,609 :: 		}
	GOTO        L_ImageEEp2RAM40
L_ImageEEp2RAM39:
;GesMatrix.c,611 :: 		PageEEpHaute = FAUX;
	CLRF        ImageEEp2RAM_PageEEpHaute_L0+0 
L_ImageEEp2RAM40:
;GesMatrix.c,612 :: 		Hi(AdrIntEEp) = (NumImgEEp << 4);
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
;GesMatrix.c,615 :: 		Res = EcrAdrIntPoll(AdrintEEp, PageEEpHaute);
	MOVF        ImageEEp2RAM_AdrIntEEp_L0+0, 0 
	MOVWF       FARG_EcrAdrIntPoll_AdresseInt+0 
	MOVF        ImageEEp2RAM_AdrIntEEp_L0+1, 0 
	MOVWF       FARG_EcrAdrIntPoll_AdresseInt+1 
	MOVF        ImageEEp2RAM_PageEEpHaute_L0+0, 0 
	MOVWF       FARG_EcrAdrIntPoll_PageHaute+0 
	CALL        _EcrAdrIntPoll+0, 0
;GesMatrix.c,617 :: 		InitEcrMem(PageRAMHaute);
	MOVF        FARG_ImageEEp2RAM_PageRAMHaute+0, 0 
	MOVWF       FARG_InitEcrMem_PageMemHaute+0 
	CALL        _InitEcrMem+0, 0
;GesMatrix.c,618 :: 		Cpt = 0;
	CLRF        ImageEEp2RAM_Cpt_L0+0 
	CLRF        ImageEEp2RAM_Cpt_L0+1 
;GesMatrix.c,619 :: 		for (j=0 ; j != NB_PART_IMG ; j++)
	CLRF        ImageEEp2RAM_j_L0+0 
L_ImageEEp2RAM41:
	MOVF        ImageEEp2RAM_j_L0+0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_ImageEEp2RAM42
;GesMatrix.c,622 :: 		LecI2CPoll(LG_TAB_MATRIX, TabMatrix);
	MOVLW       0
	MOVWF       FARG_LecI2CPoll_NbByte2Read+0 
	MOVLW       1
	MOVWF       FARG_LecI2CPoll_NbByte2Read+1 
	MOVLW       _TabMatrix+0
	MOVWF       FARG_LecI2CPoll_ptBufferRead+0 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FARG_LecI2CPoll_ptBufferRead+1 
	CALL        _LecI2CPoll+0, 0
;GesMatrix.c,624 :: 		for (k=0 ; k != LG_TAB_MATRIX ; k++)
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
;GesMatrix.c,626 :: 		latd = TabMatrix[k];
	MOVLW       _TabMatrix+0
	ADDWF       ImageEEp2RAM_k_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_TabMatrix+0)
	ADDWFC      ImageEEp2RAM_k_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       LATD+0 
;GesMatrix.c,627 :: 		portc.BIT_RW_MEM = 1;    //ack donn?e
	BSF         PORTC+0, 5 
;GesMatrix.c,628 :: 		portc.BIT_CLK_MEM = 0;   //adresse suivante
	BCF         PORTC+0, 1 
;GesMatrix.c,629 :: 		delay_us(1);
	MOVLW       3
	MOVWF       R13, 0
L_ImageEEp2RAM47:
	DECFSZ      R13, 1, 1
	BRA         L_ImageEEp2RAM47
;GesMatrix.c,630 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;GesMatrix.c,631 :: 		delay_us(1);
	MOVLW       3
	MOVWF       R13, 0
L_ImageEEp2RAM48:
	DECFSZ      R13, 1, 1
	BRA         L_ImageEEp2RAM48
;GesMatrix.c,633 :: 		Cpt++;
	INFSNZ      ImageEEp2RAM_Cpt_L0+0, 1 
	INCF        ImageEEp2RAM_Cpt_L0+1, 1 
;GesMatrix.c,634 :: 		if (Cpt != TAILLE_IMAGE-1)
	MOVF        ImageEEp2RAM_Cpt_L0+1, 0 
	XORLW       15
	BTFSS       STATUS+0, 2 
	GOTO        L__ImageEEp2RAM83
	MOVLW       255
	XORWF       ImageEEp2RAM_Cpt_L0+0, 0 
L__ImageEEp2RAM83:
	BTFSC       STATUS+0, 2 
	GOTO        L_ImageEEp2RAM49
;GesMatrix.c,635 :: 		portc.BIT_RW_MEM = 0;
	BCF         PORTC+0, 5 
L_ImageEEp2RAM49:
;GesMatrix.c,636 :: 		delay_us(1);
	MOVLW       3
	MOVWF       R13, 0
L_ImageEEp2RAM50:
	DECFSZ      R13, 1, 1
	BRA         L_ImageEEp2RAM50
;GesMatrix.c,624 :: 		for (k=0 ; k != LG_TAB_MATRIX ; k++)
	INFSNZ      ImageEEp2RAM_k_L0+0, 1 
	INCF        ImageEEp2RAM_k_L0+1, 1 
;GesMatrix.c,637 :: 		}
	GOTO        L_ImageEEp2RAM44
L_ImageEEp2RAM45:
;GesMatrix.c,619 :: 		for (j=0 ; j != NB_PART_IMG ; j++)
	INCF        ImageEEp2RAM_j_L0+0, 1 
;GesMatrix.c,638 :: 		}
	GOTO        L_ImageEEp2RAM41
L_ImageEEp2RAM42:
;GesMatrix.c,640 :: 		InitLecMem(PageRAMHaute);
	MOVF        FARG_ImageEEp2RAM_PageRAMHaute+0, 0 
	MOVWF       FARG_InitLecMem_PageMemHaute+0 
	CALL        _InitLecMem+0, 0
;GesMatrix.c,642 :: 		}
L_end_ImageEEp2RAM:
	RETURN      0
; end of _ImageEEp2RAM

_VerifChkChkb:

;GesMatrix.c,660 :: 		unsigned short VerifChkChkb (char *ptData, unsigned short NbOctet)
;GesMatrix.c,666 :: 		ResVerif = FAUX;
	CLRF        R5 
;GesMatrix.c,667 :: 		Somme = 0;
	CLRF        R4 
;GesMatrix.c,668 :: 		for (i=0 ; i!= NbOctet-2 ; i++)
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
;GesMatrix.c,670 :: 		Somme = Somme + *(ptData + i);
	MOVF        R3, 0 
	ADDWF       FARG_VerifChkChkb_ptData+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_VerifChkChkb_ptData+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       R4, 1 
;GesMatrix.c,668 :: 		for (i=0 ; i!= NbOctet-2 ; i++)
	INCF        R3, 1 
;GesMatrix.c,671 :: 		}
	GOTO        L_VerifChkChkb51
L_VerifChkChkb52:
;GesMatrix.c,672 :: 		if (Somme == *(ptData + NbOctet - 2))
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
;GesMatrix.c,674 :: 		Somme = ~Somme;
	COMF        R4, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R4 
;GesMatrix.c,675 :: 		if (Somme == *(ptData + NbOctet -1))
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
;GesMatrix.c,676 :: 		ResVerif = VRAI;
	MOVLW       1
	MOVWF       R5 
L_VerifChkChkb55:
;GesMatrix.c,677 :: 		}
L_VerifChkChkb54:
;GesMatrix.c,679 :: 		return ResVerif;
	MOVF        R5, 0 
	MOVWF       R0 
;GesMatrix.c,680 :: 		}
L_end_VerifChkChkb:
	RETURN      0
; end of _VerifChkChkb

_CalculChk:

;GesMatrix.c,700 :: 		void CalculChk(char *ptTab, unsigned short NbOctTab)
;GesMatrix.c,705 :: 		Somme = 0;
	CLRF        R3 
;GesMatrix.c,706 :: 		for (i=0; i!=NbOctTab-1; i++)
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
;GesMatrix.c,708 :: 		Somme = Somme + *(ptTab+i);
	MOVF        R4, 0 
	ADDWF       FARG_CalculChk_ptTab+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_CalculChk_ptTab+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       R3, 1 
;GesMatrix.c,706 :: 		for (i=0; i!=NbOctTab-1; i++)
	INCF        R4, 1 
;GesMatrix.c,709 :: 		}
	GOTO        L_CalculChk56
L_CalculChk57:
;GesMatrix.c,710 :: 		*(ptTab + NbOctTab -1) = Somme;
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
;GesMatrix.c,712 :: 		}
L_end_CalculChk:
	RETURN      0
; end of _CalculChk

_LecConfigEEP:

;GesMatrix.c,728 :: 		void LecConfigEEP()
;GesMatrix.c,732 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        LecConfigEEP_i_L0+0 
L_LecConfigEEP59:
	MOVF        LecConfigEEP_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_LecConfigEEP60
;GesMatrix.c,733 :: 		ImgJeux[i] = EEPROM_Read(EEP_NUM_IMAG_PROC_L+i);
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
;GesMatrix.c,732 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        LecConfigEEP_i_L0+0, 1 
;GesMatrix.c,733 :: 		ImgJeux[i] = EEPROM_Read(EEP_NUM_IMAG_PROC_L+i);
	GOTO        L_LecConfigEEP59
L_LecConfigEEP60:
;GesMatrix.c,734 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        LecConfigEEP_i_L0+0 
L_LecConfigEEP62:
	MOVF        LecConfigEEP_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_LecConfigEEP63
;GesMatrix.c,735 :: 		ImgJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_IMAG_PROC_H+i);
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
;GesMatrix.c,734 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        LecConfigEEP_i_L0+0, 1 
;GesMatrix.c,735 :: 		ImgJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_IMAG_PROC_H+i);
	GOTO        L_LecConfigEEP62
L_LecConfigEEP63:
;GesMatrix.c,736 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        LecConfigEEP_i_L0+0 
L_LecConfigEEP65:
	MOVF        LecConfigEEP_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_LecConfigEEP66
;GesMatrix.c,737 :: 		ImgTempoJeux[i] = EEPROM_Read(EEP_NUM_DURE_PROC_L+i);
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
;GesMatrix.c,736 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        LecConfigEEP_i_L0+0, 1 
;GesMatrix.c,737 :: 		ImgTempoJeux[i] = EEPROM_Read(EEP_NUM_DURE_PROC_L+i);
	GOTO        L_LecConfigEEP65
L_LecConfigEEP66:
;GesMatrix.c,738 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        LecConfigEEP_i_L0+0 
L_LecConfigEEP68:
	MOVF        LecConfigEEP_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_LecConfigEEP69
;GesMatrix.c,739 :: 		ImgTempoJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_DURE_PROC_H+i);
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
;GesMatrix.c,738 :: 		for(i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        LecConfigEEP_i_L0+0, 1 
;GesMatrix.c,739 :: 		ImgTempoJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_DURE_PROC_H+i);
	GOTO        L_LecConfigEEP68
L_LecConfigEEP69:
;GesMatrix.c,741 :: 		}
L_end_LecConfigEEP:
	RETURN      0
; end of _LecConfigEEP

_InitVarGlobal:

;GesMatrix.c,756 :: 		void InitVarGlobal()
;GesMatrix.c,758 :: 		AppelImg.MajImg = FAUX;
	CLRF        _AppelImg+0 
;GesMatrix.c,759 :: 		AppelImg.ValPWM = 0;     //luminosit? maxi
	CLRF        _AppelImg+5 
;GesMatrix.c,760 :: 		AppelImg.TempoCli = 0;
	CLRF        _AppelImg+6 
;GesMatrix.c,761 :: 		AppelImg.Tempo2Img = 0;
	CLRF        _AppelImg+7 
;GesMatrix.c,766 :: 		}
L_end_InitVarGlobal:
	RETURN      0
; end of _InitVarGlobal

_InitPeriphFond:

;GesMatrix.c,785 :: 		void InitPeriphFond()
;GesMatrix.c,791 :: 		trisa  = CONF_PORT_A;
	MOVLW       240
	MOVWF       TRISA+0 
;GesMatrix.c,792 :: 		adcon1 = CONF_ADCON1;
	MOVLW       6
	MOVWF       ADCON1+0 
;GesMatrix.c,794 :: 		trisb = CONF_PORT_B;
	MOVLW       136
	MOVWF       TRISB+0 
;GesMatrix.c,795 :: 		trisc = CONF_PORT_C;
	MOVLW       24
	MOVWF       TRISC+0 
;GesMatrix.c,796 :: 		cmcon = CONF_CMCON;
	MOVLW       7
	MOVWF       CMCON+0 
;GesMatrix.c,797 :: 		trisd = CONF_PORT_D_IN;
	MOVLW       255
	MOVWF       TRISD+0 
;GesMatrix.c,801 :: 		lata = 0;
	CLRF        LATA+0 
;GesMatrix.c,802 :: 		latc = 0;
	CLRF        LATC+0 
;GesMatrix.c,803 :: 		latb = 0;
	CLRF        LATB+0 
;GesMatrix.c,804 :: 		latd = 0;
	CLRF        LATD+0 
;GesMatrix.c,806 :: 		latb.BIT_WDOG = 1;
	BSF         LATB+0, 0 
;GesMatrix.c,810 :: 		eecon1.EEPGD = 0;
	BCF         EECON1+0, 7 
;GesMatrix.c,811 :: 		eecon1.CFGS = 0;
	BCF         EECON1+0, 6 
;GesMatrix.c,814 :: 		portc.BIT_RW_MEM = 1;
	BSF         PORTC+0, 5 
;GesMatrix.c,815 :: 		portc.BIT_OE_MEM = 0;
	BCF         PORTC+0, 6 
;GesMatrix.c,816 :: 		portb.BIT_PAGE_MEM = 0;
	BCF         PORTB+0, 4 
;GesMatrix.c,819 :: 		portc.BIT_CLK_MEM = 1;
	BSF         PORTC+0, 1 
;GesMatrix.c,820 :: 		portb.BIT_RAZ_CPT = 1;
	BSF         PORTB+0, 6 
;GesMatrix.c,821 :: 		delay_us(10);
	MOVLW       33
	MOVWF       R13, 0
L_InitPeriphFond71:
	DECFSZ      R13, 1, 1
	BRA         L_InitPeriphFond71
;GesMatrix.c,822 :: 		portb.BIT_RAZ_CPT = 0;
	BCF         PORTB+0, 6 
;GesMatrix.c,825 :: 		porta = 0;    //selection ligne 0
	CLRF        PORTA+0 
;GesMatrix.c,826 :: 		portc.BIT_LATCH_MTRX = 0;
	BCF         PORTC+0, 0 
;GesMatrix.c,827 :: 		portc.BIT_CLK_MTRX = 0;
	BCF         PORTC+0, 7 
;GesMatrix.c,831 :: 		pr2 = MAX_PERIODE;
	MOVLW       255
	MOVWF       PR2+0 
;GesMatrix.c,832 :: 		t2con = INIT_T2_CON;
	MOVLW       6
	MOVWF       T2CON+0 
;GesMatrix.c,833 :: 		ccp1con = INIT_CCP_CON;
	MOVLW       28
	MOVWF       CCP1CON+0 
;GesMatrix.c,834 :: 		ccpr1l = 0x00;
	CLRF        CCPR1L+0 
;GesMatrix.c,837 :: 		rcon.IPEN = 1;
	BSF         RCON+0, 7 
;GesMatrix.c,839 :: 		}
L_end_InitPeriphFond:
	RETURN      0
; end of _InitPeriphFond
