
_InterruptSpgComCAN:

;Tache_com_can.c,65 :: 		void InterruptSpgComCAN()
;Tache_com_can.c,73 :: 		Res = CANRead(&id, DataRec , &Len, &StatusCAN);
	MOVLW       _id+0
	MOVWF       FARG_CANRead_id+0 
	MOVLW       hi_addr(_id+0)
	MOVWF       FARG_CANRead_id+1 
	MOVLW       _DataRec+0
	MOVWF       FARG_CANRead_data_+0 
	MOVLW       hi_addr(_DataRec+0)
	MOVWF       FARG_CANRead_data_+1 
	MOVLW       _Len+0
	MOVWF       FARG_CANRead_dataLen+0 
	MOVLW       hi_addr(_Len+0)
	MOVWF       FARG_CANRead_dataLen+1 
	MOVLW       _StatusCAN+0
	MOVWF       FARG_CANRead_CAN_RX_MSG_FLAGS+0 
	MOVLW       hi_addr(_StatusCAN+0)
	MOVWF       FARG_CANRead_CAN_RX_MSG_FLAGS+1 
	CALL        _CANRead+0, 0
;Tache_com_can.c,74 :: 		if (Res != 0)
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_InterruptSpgComCAN0
;Tache_com_can.c,79 :: 		if (id == ID_REC_IMG_BMP)
	MOVLW       0
	MOVWF       R0 
	XORWF       _id+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN63
	MOVF        R0, 0 
	XORWF       _id+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN63
	MOVF        R0, 0 
	XORWF       _id+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN63
	MOVF        _id+0, 0 
	XORLW       66
L__InterruptSpgComCAN63:
	BTFSS       STATUS+0, 2 
	GOTO        L_InterruptSpgComCAN1
;Tache_com_can.c,81 :: 		GesRecImage(DataRec);
	MOVLW       _DataRec+0
	MOVWF       FARG_GesRecImage_ptDataRec+0 
	MOVLW       hi_addr(_DataRec+0)
	MOVWF       FARG_GesRecImage_ptDataRec+1 
	CALL        _GesRecImage+0, 0
;Tache_com_can.c,82 :: 		}
L_InterruptSpgComCAN1:
;Tache_com_can.c,86 :: 		if (id == ID_REC_IMG_CMD)
	MOVLW       0
	MOVWF       R0 
	XORWF       _id+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN64
	MOVF        R0, 0 
	XORWF       _id+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN64
	MOVF        R0, 0 
	XORWF       _id+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN64
	MOVF        _id+0, 0 
	XORLW       65
L__InterruptSpgComCAN64:
	BTFSS       STATUS+0, 2 
	GOTO        L_InterruptSpgComCAN2
;Tache_com_can.c,88 :: 		GesCmdImage(DataRec, &AppelImg);
	MOVLW       _DataRec+0
	MOVWF       FARG_GesCmdImage_ptDataRec+0 
	MOVLW       hi_addr(_DataRec+0)
	MOVWF       FARG_GesCmdImage_ptDataRec+1 
	MOVLW       _AppelImg+0
	MOVWF       FARG_GesCmdImage_ptAppelImg+0 
	MOVLW       hi_addr(_AppelImg+0)
	MOVWF       FARG_GesCmdImage_ptAppelImg+1 
	CALL        _GesCmdImage+0, 0
;Tache_com_can.c,89 :: 		}
L_InterruptSpgComCAN2:
;Tache_com_can.c,93 :: 		if (id == ID_MSG_REC_ST_PAY)
	MOVLW       0
	MOVWF       R0 
	XORWF       _id+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN65
	MOVF        R0, 0 
	XORWF       _id+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN65
	MOVF        R0, 0 
	XORWF       _id+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN65
	MOVF        _id+0, 0 
	XORLW       64
L__InterruptSpgComCAN65:
	BTFSS       STATUS+0, 2 
	GOTO        L_InterruptSpgComCAN3
;Tache_com_can.c,95 :: 		ModeEnCours = DataRec[1];
	MOVF        _DataRec+1, 0 
	MOVWF       _ModeEnCours+0 
;Tache_com_can.c,96 :: 		}
L_InterruptSpgComCAN3:
;Tache_com_can.c,99 :: 		if ((id & MASK_ACCEPT_B2) == ID_MSG_CONFIG_EEP)
	MOVLW       252
	ANDWF       _id+0, 0 
	MOVWF       R1 
	MOVLW       255
	ANDWF       _id+1, 0 
	MOVWF       R2 
	MOVLW       255
	ANDWF       _id+2, 0 
	MOVWF       R3 
	MOVLW       255
	ANDWF       _id+3, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R0 
	XORWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN66
	MOVF        R0, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN66
	MOVF        R0, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptSpgComCAN66
	MOVF        R1, 0 
	XORLW       80
L__InterruptSpgComCAN66:
	BTFSS       STATUS+0, 2 
	GOTO        L_InterruptSpgComCAN4
;Tache_com_can.c,101 :: 		GesMajEEprom(id, DataRec);
	MOVF        _id+0, 0 
	MOVWF       FARG_GesMajEEprom_Id_+0 
	MOVF        _id+1, 0 
	MOVWF       FARG_GesMajEEprom_Id_+1 
	MOVF        _id+2, 0 
	MOVWF       FARG_GesMajEEprom_Id_+2 
	MOVF        _id+3, 0 
	MOVWF       FARG_GesMajEEprom_Id_+3 
	MOVLW       _DataRec+0
	MOVWF       FARG_GesMajEEprom_ptDataRec+0 
	MOVLW       hi_addr(_DataRec+0)
	MOVWF       FARG_GesMajEEprom_ptDataRec+1 
	CALL        _GesMajEEprom+0, 0
;Tache_com_can.c,102 :: 		}
L_InterruptSpgComCAN4:
;Tache_com_can.c,103 :: 		}
L_InterruptSpgComCAN0:
;Tache_com_can.c,105 :: 		}
L_end_InterruptSpgComCAN:
	RETURN      0
; end of _InterruptSpgComCAN

_GesRecImage:

;Tache_com_can.c,122 :: 		void GesRecImage(unsigned short *ptDataRec)
;Tache_com_can.c,143 :: 		if ((ptDataRec[0] == HEADER_1) && (ptDataRec[7] == HEADER_2))
	MOVFF       FARG_GesRecImage_ptDataRec+0, FSR0
	MOVFF       FARG_GesRecImage_ptDataRec+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage7
	MOVLW       7
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       170
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage7
L__GesRecImage61:
;Tache_com_can.c,147 :: 		HeaderOK = VRAI;
	MOVLW       1
	MOVWF       GesRecImage_HeaderOK_L0+0 
;Tache_com_can.c,148 :: 		NumImage = ptDataRec[1];
	MOVLW       1
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       GesRecImage_NumImage_L0+0 
;Tache_com_can.c,149 :: 		for (i=2 ; i!=7 ; i++)
	MOVLW       2
	MOVWF       GesRecImage_i_L0+0 
L_GesRecImage8:
	MOVF        GesRecImage_i_L0+0, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L_GesRecImage9
;Tache_com_can.c,150 :: 		if (ptDataRec[i] != 0) HeaderOK = FAUX;
	MOVF        GesRecImage_i_L0+0, 0 
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_GesRecImage11
	CLRF        GesRecImage_HeaderOK_L0+0 
L_GesRecImage11:
;Tache_com_can.c,149 :: 		for (i=2 ; i!=7 ; i++)
	INCF        GesRecImage_i_L0+0, 1 
;Tache_com_can.c,150 :: 		if (ptDataRec[i] != 0) HeaderOK = FAUX;
	GOTO        L_GesRecImage8
L_GesRecImage9:
;Tache_com_can.c,151 :: 		if (HeaderOK == VRAI)
	MOVF        GesRecImage_HeaderOK_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage12
;Tache_com_can.c,154 :: 		RecHeader = VRAI;
	MOVLW       1
	MOVWF       GesRecImage_RecHeader_L0+0 
;Tache_com_can.c,155 :: 		NumOctet   = 0;
	CLRF        GesRecImage_NumOctet_L0+0 
;Tache_com_can.c,156 :: 		NumPartImg = 0;
	CLRF        GesRecImage_NumPartImg_L0+0 
;Tache_com_can.c,157 :: 		ChkImg     = 0;
	CLRF        GesRecImage_ChkImg_L0+0 
;Tache_com_can.c,158 :: 		RecOK = REC_OK;
	CLRF        _RecOK+0 
;Tache_com_can.c,159 :: 		t3con = VAL_CONF_T3CON_LS;  //diminution vitesse affichage
	MOVLW       49
	MOVWF       T3CON+0 
;Tache_com_can.c,161 :: 		}
L_GesRecImage12:
;Tache_com_can.c,162 :: 		}
L_GesRecImage7:
;Tache_com_can.c,164 :: 		if (HeaderFin == VRAI)
	MOVF        GesRecImage_HeaderFin_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage13
;Tache_com_can.c,167 :: 		if ((ptDataRec[0] == HEADER_2) && (ptDataRec[7] == HEADER_1))
	MOVFF       FARG_GesRecImage_ptDataRec+0, FSR0
	MOVFF       FARG_GesRecImage_ptDataRec+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       170
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage16
	MOVLW       7
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage16
L__GesRecImage60:
;Tache_com_can.c,170 :: 		if (ChkImg == DataRec[2])
	MOVF        GesRecImage_ChkImg_L0+0, 0 
	XORWF       _DataRec+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage17
;Tache_com_can.c,173 :: 		EEPROM_Write(OFF_CHK_IMG+NumImage, ChkImg);
	MOVF        GesRecImage_NumImage_L0+0, 0 
	ADDLW       32
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        GesRecImage_ChkImg_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Tache_com_can.c,174 :: 		}
	GOTO        L_GesRecImage18
L_GesRecImage17:
;Tache_com_can.c,176 :: 		RecOK.BIT_ERR_CHK = 1;
	BSF         _RecOK+0, 1 
L_GesRecImage18:
;Tache_com_can.c,177 :: 		}
	GOTO        L_GesRecImage19
L_GesRecImage16:
;Tache_com_can.c,179 :: 		RecOK.BIT_ERR_HDF = 1;
	BSF         _RecOK+0, 2 
L_GesRecImage19:
;Tache_com_can.c,180 :: 		HeaderFin = FAUX;
	CLRF        GesRecImage_HeaderFin_L0+0 
;Tache_com_can.c,181 :: 		t3con = VAL_CONF_T3CON_HS;  //reinitialisation vitesse affichage
	MOVLW       1
	MOVWF       T3CON+0 
;Tache_com_can.c,184 :: 		}
L_GesRecImage13:
;Tache_com_can.c,186 :: 		if (HeaderOK == VRAI)
	MOVF        GesRecImage_HeaderOK_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage20
;Tache_com_can.c,188 :: 		if (RecHeader == VRAI)
	MOVF        GesRecImage_RecHeader_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage21
;Tache_com_can.c,189 :: 		RecHeader = FAUX;
	CLRF        GesRecImage_RecHeader_L0+0 
	GOTO        L_GesRecImage22
L_GesRecImage21:
;Tache_com_can.c,193 :: 		ChkImg = ChkImg + ptDataRec[0] + ptDataRec[1] + ptDataRec[2] + ptDataRec[3];
	MOVFF       FARG_GesRecImage_ptDataRec+0, FSR2
	MOVFF       FARG_GesRecImage_ptDataRec+1, FSR2H
	MOVF        POSTINC2+0, 0 
	ADDWF       GesRecImage_ChkImg_L0+0, 1 
	MOVLW       1
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       GesRecImage_ChkImg_L0+0, 1 
	MOVLW       2
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       GesRecImage_ChkImg_L0+0, 1 
	MOVLW       3
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       GesRecImage_ChkImg_L0+0, 1 
;Tache_com_can.c,194 :: 		ChkImg = ChkImg + ptDataRec[4] + ptDataRec[5] + ptDataRec[6] + ptDataRec[7];
	MOVLW       4
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       GesRecImage_ChkImg_L0+0, 1 
	MOVLW       5
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       GesRecImage_ChkImg_L0+0, 1 
	MOVLW       6
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       GesRecImage_ChkImg_L0+0, 1 
	MOVLW       7
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       GesRecImage_ChkImg_L0+0, 1 
;Tache_com_can.c,196 :: 		TabMatrix[NumOctet++] = ptDataRec[0];
	MOVLW       _TabMatrix+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FSR1H 
	MOVF        GesRecImage_NumOctet_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVFF       FARG_GesRecImage_ptDataRec+0, FSR0
	MOVFF       FARG_GesRecImage_ptDataRec+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        GesRecImage_NumOctet_L0+0, 1 
;Tache_com_can.c,197 :: 		TabMatrix[NumOctet++] = ptDataRec[1];
	MOVLW       _TabMatrix+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FSR1H 
	MOVF        GesRecImage_NumOctet_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        GesRecImage_NumOctet_L0+0, 1 
;Tache_com_can.c,198 :: 		TabMatrix[NumOctet++] = ptDataRec[2];
	MOVLW       _TabMatrix+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FSR1H 
	MOVF        GesRecImage_NumOctet_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       2
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        GesRecImage_NumOctet_L0+0, 1 
;Tache_com_can.c,199 :: 		TabMatrix[NumOctet++] = ptDataRec[3];
	MOVLW       _TabMatrix+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FSR1H 
	MOVF        GesRecImage_NumOctet_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       3
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        GesRecImage_NumOctet_L0+0, 1 
;Tache_com_can.c,200 :: 		TabMatrix[NumOctet++] = ptDataRec[4];
	MOVLW       _TabMatrix+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FSR1H 
	MOVF        GesRecImage_NumOctet_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       4
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        GesRecImage_NumOctet_L0+0, 1 
;Tache_com_can.c,201 :: 		TabMatrix[NumOctet++] = ptDataRec[5];
	MOVLW       _TabMatrix+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FSR1H 
	MOVF        GesRecImage_NumOctet_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       5
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        GesRecImage_NumOctet_L0+0, 1 
;Tache_com_can.c,202 :: 		TabMatrix[NumOctet++] = ptDataRec[6];
	MOVLW       _TabMatrix+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FSR1H 
	MOVF        GesRecImage_NumOctet_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       6
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        GesRecImage_NumOctet_L0+0, 1 
;Tache_com_can.c,203 :: 		TabMatrix[NumOctet++] = ptDataRec[7];
	MOVLW       _TabMatrix+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FSR1H 
	MOVF        GesRecImage_NumOctet_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       7
	ADDWF       FARG_GesRecImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesRecImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        GesRecImage_NumOctet_L0+0, 1 
;Tache_com_can.c,204 :: 		if (NumOctet == 0)
	MOVF        GesRecImage_NumOctet_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage23
;Tache_com_can.c,209 :: 		if (NumImage >= IMG_PAGE_BAS)
	MOVLW       16
	SUBWF       GesRecImage_NumImage_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_GesRecImage24
;Tache_com_can.c,211 :: 		PageHt = VRAI;
	MOVLW       1
	MOVWF       GesRecImage_PageHt_L0+0 
;Tache_com_can.c,213 :: 		AdrInt     = 0;
	CLRF        GesRecImage_AdrInt_L0+0 
	CLRF        GesRecImage_AdrInt_L0+1 
;Tache_com_can.c,214 :: 		Hi(AdrInt) = ((NumImage - IMG_PAGE_BAS) << 4) + NumPartImg;
	MOVLW       16
	SUBWF       GesRecImage_NumImage_L0+0, 0 
	MOVWF       GesRecImage_AdrInt_L0+1 
	RLCF        GesRecImage_AdrInt_L0+1, 1 
	BCF         GesRecImage_AdrInt_L0+1, 0 
	RLCF        GesRecImage_AdrInt_L0+1, 1 
	BCF         GesRecImage_AdrInt_L0+1, 0 
	RLCF        GesRecImage_AdrInt_L0+1, 1 
	BCF         GesRecImage_AdrInt_L0+1, 0 
	RLCF        GesRecImage_AdrInt_L0+1, 1 
	BCF         GesRecImage_AdrInt_L0+1, 0 
	MOVF        GesRecImage_NumPartImg_L0+0, 0 
	ADDWF       GesRecImage_AdrInt_L0+1, 1 
;Tache_com_can.c,215 :: 		}
	GOTO        L_GesRecImage25
L_GesRecImage24:
;Tache_com_can.c,218 :: 		PageHt = FAUX;
	CLRF        GesRecImage_PageHt_L0+0 
;Tache_com_can.c,220 :: 		AdrInt     = 0;
	CLRF        GesRecImage_AdrInt_L0+0 
	CLRF        GesRecImage_AdrInt_L0+1 
;Tache_com_can.c,221 :: 		Hi(AdrInt) = (NumImage << 4) + NumPartImg;
	MOVF        GesRecImage_NumImage_L0+0, 0 
	MOVWF       GesRecImage_AdrInt_L0+1 
	RLCF        GesRecImage_AdrInt_L0+1, 1 
	BCF         GesRecImage_AdrInt_L0+1, 0 
	RLCF        GesRecImage_AdrInt_L0+1, 1 
	BCF         GesRecImage_AdrInt_L0+1, 0 
	RLCF        GesRecImage_AdrInt_L0+1, 1 
	BCF         GesRecImage_AdrInt_L0+1, 0 
	RLCF        GesRecImage_AdrInt_L0+1, 1 
	BCF         GesRecImage_AdrInt_L0+1, 0 
	MOVF        GesRecImage_NumPartImg_L0+0, 0 
	ADDWF       GesRecImage_AdrInt_L0+1, 1 
;Tache_com_can.c,222 :: 		}
L_GesRecImage25:
;Tache_com_can.c,223 :: 		Res = EcrI2CPoll(AdrInt, PageHt, TabMatrix, LG_TAB_MATRIX);
	MOVF        GesRecImage_AdrInt_L0+0, 0 
	MOVWF       FARG_EcrI2CPoll_AdresseInt+0 
	MOVF        GesRecImage_AdrInt_L0+1, 0 
	MOVWF       FARG_EcrI2CPoll_AdresseInt+1 
	MOVF        GesRecImage_PageHt_L0+0, 0 
	MOVWF       FARG_EcrI2CPoll_PageHaute+0 
	MOVLW       _TabMatrix+0
	MOVWF       FARG_EcrI2CPoll_ptBuffEcr+0 
	MOVLW       hi_addr(_TabMatrix+0)
	MOVWF       FARG_EcrI2CPoll_ptBuffEcr+1 
	MOVLW       0
	MOVWF       FARG_EcrI2CPoll_NbData+0 
	MOVLW       1
	MOVWF       FARG_EcrI2CPoll_NbData+1 
	CALL        _EcrI2CPoll+0, 0
;Tache_com_can.c,224 :: 		if (Res == FAUX)
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage26
;Tache_com_can.c,225 :: 		RecOK.BIT_ERR_EEP = 1;
	BSF         _RecOK+0, 0 
L_GesRecImage26:
;Tache_com_can.c,226 :: 		NumPartImg++;
	INCF        GesRecImage_NumPartImg_L0+0, 1 
;Tache_com_can.c,227 :: 		}
L_GesRecImage23:
;Tache_com_can.c,228 :: 		if ( NumPartImg == NB_PART_IMG)
	MOVF        GesRecImage_NumPartImg_L0+0, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_GesRecImage27
;Tache_com_can.c,231 :: 		HeaderOK = FAUX;
	CLRF        GesRecImage_HeaderOK_L0+0 
;Tache_com_can.c,232 :: 		HeaderFin = VRAI;
	MOVLW       1
	MOVWF       GesRecImage_HeaderFin_L0+0 
;Tache_com_can.c,233 :: 		}
L_GesRecImage27:
;Tache_com_can.c,234 :: 		}
L_GesRecImage22:
;Tache_com_can.c,235 :: 		}
L_GesRecImage20:
;Tache_com_can.c,236 :: 		}
L_end_GesRecImage:
	RETURN      0
; end of _GesRecImage

_GesCmdImage:

;Tache_com_can.c,253 :: 		void GesCmdImage(unsigned short *ptDataRec, t_AppImg *ptAppelImg)
;Tache_com_can.c,258 :: 		switch  (ptDataRec[CMD_IMG])
	MOVF        FARG_GesCmdImage_ptDataRec+0, 0 
	MOVWF       R2 
	MOVF        FARG_GesCmdImage_ptDataRec+1, 0 
	MOVWF       R3 
	GOTO        L_GesCmdImage28
;Tache_com_can.c,260 :: 		case MAJ_LUMINOSITE:
L_GesCmdImage30:
;Tache_com_can.c,263 :: 		ccpr1l = ptDataRec[LUM_VAL_PWM];
	MOVLW       1
	ADDWF       FARG_GesCmdImage_ptDataRec+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptDataRec+1, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       CCPR1L+0 
;Tache_com_can.c,264 :: 		ptAppelImg->ValPWM = ptDataRec[LUM_VAL_PWM];
	MOVLW       5
	ADDWF       FARG_GesCmdImage_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       FSR0 
	MOVF        R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,265 :: 		break;
	GOTO        L_GesCmdImage29
;Tache_com_can.c,267 :: 		case APP_IMG_SIMPLE:
L_GesCmdImage31:
;Tache_com_can.c,269 :: 		Param = ptDataRec[IMG_NUM_IMG];
	MOVLW       1
	ADDWF       FARG_GesCmdImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
;Tache_com_can.c,270 :: 		ptAppelImg->MajImg = VRAI;
	MOVFF       FARG_GesCmdImage_ptAppelImg+0, FSR1
	MOVFF       FARG_GesCmdImage_ptAppelImg+1, FSR1H
	MOVLW       1
	MOVWF       POSTINC1+0 
;Tache_com_can.c,271 :: 		if (Param.BIT_PAGE_IMG)
	BTFSS       R4, 7 
	GOTO        L_GesCmdImage32
;Tache_com_can.c,272 :: 		ptAppelImg->PageHaut = VRAI;
	MOVLW       1
	ADDWF       FARG_GesCmdImage_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_GesCmdImage33
L_GesCmdImage32:
;Tache_com_can.c,274 :: 		ptAppelImg->PageHaut = FAUX;
	MOVLW       1
	ADDWF       FARG_GesCmdImage_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
L_GesCmdImage33:
;Tache_com_can.c,275 :: 		ptAppelImg->NumImage  = Param & MASQ_NUM_IMG;
	MOVLW       2
	ADDWF       FARG_GesCmdImage_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       31
	ANDWF       R4, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,277 :: 		break;
	GOTO        L_GesCmdImage29
;Tache_com_can.c,279 :: 		case APP_IMG_VOLET:
L_GesCmdImage34:
;Tache_com_can.c,283 :: 		ptAppelImg->TypeVolet  = ptDataRec[IMG_VOLET_TYP];
	MOVLW       3
	ADDWF       FARG_GesCmdImage_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	ADDWF       FARG_GesCmdImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,284 :: 		ptAppelImg->TempoVolet = ptDataRec[IMG_VOLET_PER];
	MOVLW       4
	ADDWF       FARG_GesCmdImage_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       2
	ADDWF       FARG_GesCmdImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,285 :: 		pie1.TMR1IE = 1;      //It gestion volet
	BSF         PIE1+0, 0 
;Tache_com_can.c,286 :: 		break;
	GOTO        L_GesCmdImage29
;Tache_com_can.c,288 :: 		case MAJ_CLIGNOTTE:
L_GesCmdImage35:
;Tache_com_can.c,290 :: 		ptAppelImg->TempoCli = ptDataRec[CLI_VITESSE];
	MOVLW       6
	ADDWF       FARG_GesCmdImage_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	ADDWF       FARG_GesCmdImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,291 :: 		break;
	GOTO        L_GesCmdImage29
;Tache_com_can.c,293 :: 		case APP_2_IMAGE:
L_GesCmdImage36:
;Tache_com_can.c,295 :: 		ptAppelImg->Tempo2Img = ptDataRec[APP_VITESSE];
	MOVLW       7
	ADDWF       FARG_GesCmdImage_ptAppelImg+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptAppelImg+1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	ADDWF       FARG_GesCmdImage_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesCmdImage_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,296 :: 		break;
	GOTO        L_GesCmdImage29
;Tache_com_can.c,298 :: 		}
L_GesCmdImage28:
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_GesCmdImage30
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_GesCmdImage31
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_GesCmdImage34
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_GesCmdImage35
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_GesCmdImage36
L_GesCmdImage29:
;Tache_com_can.c,299 :: 		}
L_end_GesCmdImage:
	RETURN      0
; end of _GesCmdImage

_GesMajEEprom:

;Tache_com_can.c,318 :: 		void GesMajEEprom(long Id_, unsigned short *ptDataRec)
;Tache_com_can.c,322 :: 		switch (Id_)
	GOTO        L_GesMajEEprom37
;Tache_com_can.c,324 :: 		case (ID_MSG_CONFIG_EEP+OFF_NUM_IMAG_PROC_L):
L_GesMajEEprom39:
;Tache_com_can.c,326 :: 		t3con = VAL_CONF_T3CON_LS;  //diminution vitesse affichage
	MOVLW       49
	MOVWF       T3CON+0 
;Tache_com_can.c,327 :: 		for (i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        GesMajEEprom_i_L0+0 
L_GesMajEEprom40:
	MOVF        GesMajEEprom_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_GesMajEEprom41
;Tache_com_can.c,332 :: 		DataEEp[i+EEP_NUM_IMAG_PROC_L] = ptDataRec[i];
	MOVF        GesMajEEprom_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       _DataEEp+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_DataEEp+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        GesMajEEprom_i_L0+0, 0 
	ADDWF       FARG_GesMajEEprom_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesMajEEprom_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,327 :: 		for (i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        GesMajEEprom_i_L0+0, 1 
;Tache_com_can.c,333 :: 		}
	GOTO        L_GesMajEEprom40
L_GesMajEEprom41:
;Tache_com_can.c,334 :: 		break;
	GOTO        L_GesMajEEprom38
;Tache_com_can.c,336 :: 		case (ID_MSG_CONFIG_EEP+OFF_NUM_IMAG_PROC_H):
L_GesMajEEprom43:
;Tache_com_can.c,338 :: 		for (i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        GesMajEEprom_i_L0+0 
L_GesMajEEprom44:
	MOVF        GesMajEEprom_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_GesMajEEprom45
;Tache_com_can.c,343 :: 		DataEEp[i+EEP_NUM_IMAG_PROC_H] = ptDataRec[i];
	MOVLW       8
	ADDWF       GesMajEEprom_i_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _DataEEp+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_DataEEp+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        GesMajEEprom_i_L0+0, 0 
	ADDWF       FARG_GesMajEEprom_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesMajEEprom_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,338 :: 		for (i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        GesMajEEprom_i_L0+0, 1 
;Tache_com_can.c,344 :: 		}
	GOTO        L_GesMajEEprom44
L_GesMajEEprom45:
;Tache_com_can.c,345 :: 		break;
	GOTO        L_GesMajEEprom38
;Tache_com_can.c,347 :: 		case (ID_MSG_CONFIG_EEP+OFF_NUM_DURE_PROC_L):
L_GesMajEEprom47:
;Tache_com_can.c,349 :: 		for (i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        GesMajEEprom_i_L0+0 
L_GesMajEEprom48:
	MOVF        GesMajEEprom_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_GesMajEEprom49
;Tache_com_can.c,354 :: 		DataEEp[i+EEP_NUM_DURE_PROC_L] = ptDataRec[i];
	MOVLW       16
	ADDWF       GesMajEEprom_i_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _DataEEp+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_DataEEp+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        GesMajEEprom_i_L0+0, 0 
	ADDWF       FARG_GesMajEEprom_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesMajEEprom_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,349 :: 		for (i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        GesMajEEprom_i_L0+0, 1 
;Tache_com_can.c,355 :: 		}
	GOTO        L_GesMajEEprom48
L_GesMajEEprom49:
;Tache_com_can.c,356 :: 		break;
	GOTO        L_GesMajEEprom38
;Tache_com_can.c,358 :: 		case (ID_MSG_CONFIG_EEP+OFF_NUM_DURE_PROC_H):
L_GesMajEEprom51:
;Tache_com_can.c,360 :: 		for (i=0 ; i!= LG_EEP_CONFIG ; i++)
	CLRF        GesMajEEprom_i_L0+0 
L_GesMajEEprom52:
	MOVF        GesMajEEprom_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_GesMajEEprom53
;Tache_com_can.c,365 :: 		DataEEp[i+EEP_NUM_DURE_PROC_H] = ptDataRec[i];
	MOVLW       24
	ADDWF       GesMajEEprom_i_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _DataEEp+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_DataEEp+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        GesMajEEprom_i_L0+0, 0 
	ADDWF       FARG_GesMajEEprom_ptDataRec+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_GesMajEEprom_ptDataRec+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Tache_com_can.c,360 :: 		for (i=0 ; i!= LG_EEP_CONFIG ; i++)
	INCF        GesMajEEprom_i_L0+0, 1 
;Tache_com_can.c,366 :: 		}
	GOTO        L_GesMajEEprom52
L_GesMajEEprom53:
;Tache_com_can.c,367 :: 		for (i=0 ; i!= (4*LG_EEP_CONFIG) ; i++)
	CLRF        GesMajEEprom_i_L0+0 
L_GesMajEEprom55:
	MOVF        GesMajEEprom_i_L0+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_GesMajEEprom56
;Tache_com_can.c,370 :: 		EEPROM_Write(EEP_NUM_IMAG_PROC_L+i, DataEEp[i]);
	MOVF        GesMajEEprom_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       _DataEEp+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_DataEEp+0)
	MOVWF       FSR0H 
	MOVF        GesMajEEprom_i_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Tache_com_can.c,371 :: 		delay_ms(10);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_GesMajEEprom58:
	DECFSZ      R13, 1, 1
	BRA         L_GesMajEEprom58
	DECFSZ      R12, 1, 1
	BRA         L_GesMajEEprom58
	NOP
	NOP
;Tache_com_can.c,367 :: 		for (i=0 ; i!= (4*LG_EEP_CONFIG) ; i++)
	INCF        GesMajEEprom_i_L0+0, 1 
;Tache_com_can.c,372 :: 		}
	GOTO        L_GesMajEEprom55
L_GesMajEEprom56:
;Tache_com_can.c,373 :: 		t3con = VAL_CONF_T3CON_HS;  //reinitialisation vitesse affichage
	MOVLW       1
	MOVWF       T3CON+0 
;Tache_com_can.c,374 :: 		delay_ms(ATT_ECR);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_GesMajEEprom59:
	DECFSZ      R13, 1, 1
	BRA         L_GesMajEEprom59
	DECFSZ      R12, 1, 1
	BRA         L_GesMajEEprom59
	DECFSZ      R11, 1, 1
	BRA         L_GesMajEEprom59
	NOP
	NOP
;Tache_com_can.c,376 :: 		reset
	RESET
;Tache_com_can.c,378 :: 		break;
	GOTO        L_GesMajEEprom38
;Tache_com_can.c,380 :: 		}
L_GesMajEEprom37:
	MOVLW       0
	MOVWF       R0 
	XORWF       FARG_GesMajEEprom_Id_+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom70
	MOVF        R0, 0 
	XORWF       FARG_GesMajEEprom_Id_+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom70
	MOVF        R0, 0 
	XORWF       FARG_GesMajEEprom_Id_+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom70
	MOVF        FARG_GesMajEEprom_Id_+0, 0 
	XORLW       80
L__GesMajEEprom70:
	BTFSC       STATUS+0, 2 
	GOTO        L_GesMajEEprom39
	MOVLW       0
	MOVWF       R0 
	XORWF       FARG_GesMajEEprom_Id_+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom71
	MOVF        R0, 0 
	XORWF       FARG_GesMajEEprom_Id_+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom71
	MOVF        R0, 0 
	XORWF       FARG_GesMajEEprom_Id_+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom71
	MOVF        FARG_GesMajEEprom_Id_+0, 0 
	XORLW       81
L__GesMajEEprom71:
	BTFSC       STATUS+0, 2 
	GOTO        L_GesMajEEprom43
	MOVLW       0
	MOVWF       R0 
	XORWF       FARG_GesMajEEprom_Id_+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom72
	MOVF        R0, 0 
	XORWF       FARG_GesMajEEprom_Id_+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom72
	MOVF        R0, 0 
	XORWF       FARG_GesMajEEprom_Id_+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom72
	MOVF        FARG_GesMajEEprom_Id_+0, 0 
	XORLW       82
L__GesMajEEprom72:
	BTFSC       STATUS+0, 2 
	GOTO        L_GesMajEEprom47
	MOVLW       0
	MOVWF       R0 
	XORWF       FARG_GesMajEEprom_Id_+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom73
	MOVF        R0, 0 
	XORWF       FARG_GesMajEEprom_Id_+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom73
	MOVF        R0, 0 
	XORWF       FARG_GesMajEEprom_Id_+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GesMajEEprom73
	MOVF        FARG_GesMajEEprom_Id_+0, 0 
	XORLW       83
L__GesMajEEprom73:
	BTFSC       STATUS+0, 2 
	GOTO        L_GesMajEEprom51
L_GesMajEEprom38:
;Tache_com_can.c,382 :: 		}
L_end_GesMajEEprom:
	RETURN      0
; end of _GesMajEEprom

_InitPeriphComCAN:

;Tache_com_can.c,397 :: 		void InitPeriphComCAN()
;Tache_com_can.c,399 :: 		InitComCAN();
	CALL        _InitComCAN+0, 0
;Tache_com_can.c,402 :: 		ipr3.RXB1IP = 0;     //passage basse priorité
	BCF         IPR3+0, 1 
;Tache_com_can.c,403 :: 		ipr3.RXB0IP = 0;
	BCF         IPR3+0, 0 
;Tache_com_can.c,404 :: 		pie3.RXB1IE = 1;
	BSF         PIE3+0, 1 
;Tache_com_can.c,405 :: 		pie3.RXB0IE = 1;
	BSF         PIE3+0, 0 
;Tache_com_can.c,407 :: 		}
L_end_InitPeriphComCAN:
	RETURN      0
; end of _InitPeriphComCAN

_InitComCAN:

;Tache_com_can.c,423 :: 		void InitComCAN()
;Tache_com_can.c,432 :: 		_CAN_TX_NO_RTR_FRAME;
	MOVLW       252
	MOVWF       _Config_can1+0 
;Tache_com_can.c,443 :: 		CANInitialize(1,4,8,8,8,Config_can2);
	MOVLW       1
	MOVWF       FARG_CANInitialize_SJW+0 
	MOVLW       4
	MOVWF       FARG_CANInitialize_BRP+0 
	MOVLW       8
	MOVWF       FARG_CANInitialize_PHSEG1+0 
	MOVLW       8
	MOVWF       FARG_CANInitialize_PHSEG2+0 
	MOVLW       8
	MOVWF       FARG_CANInitialize_PROPSEG+0 
	MOVLW       185
	MOVWF       FARG_CANInitialize_CAN_CONFIG_FLAGS+0 
	CALL        _CANInitialize+0, 0
;Tache_com_can.c,446 :: 		CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);
	MOVLW       128
	MOVWF       FARG_CANSetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSetOperationMode_WAIT+0 
	CALL        _CANSetOperationMode+0, 0
;Tache_com_can.c,450 :: 		CANSetMask(_CAN_MASK_B1,MASK_ACCEPT_B1,_CAN_CONFIG_STD_MSG);
	CLRF        FARG_CANSetMask_CAN_MASK+0 
	MOVLW       252
	MOVWF       FARG_CANSetMask_val+0 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+1 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+2 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+3 
	MOVLW       255
	MOVWF       FARG_CANSetMask_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetMask+0, 0
;Tache_com_can.c,451 :: 		CANSetFilter(_CAN_FILTER_B1_F1,ID_REC_IMG_BMP,_CAN_CONFIG_STD_MSG);
	CLRF        FARG_CANSetFilter_CAN_FILTER+0 
	MOVLW       66
	MOVWF       FARG_CANSetFilter_val+0 
	MOVLW       0
	MOVWF       FARG_CANSetFilter_val+1 
	MOVWF       FARG_CANSetFilter_val+2 
	MOVWF       FARG_CANSetFilter_val+3 
	MOVLW       255
	MOVWF       FARG_CANSetFilter_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetFilter+0, 0
;Tache_com_can.c,454 :: 		CANSetMask(_CAN_MASK_B2,MASK_ACCEPT_B2,_CAN_CONFIG_STD_MSG);
	MOVLW       1
	MOVWF       FARG_CANSetMask_CAN_MASK+0 
	MOVLW       252
	MOVWF       FARG_CANSetMask_val+0 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+1 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+2 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+3 
	MOVLW       255
	MOVWF       FARG_CANSetMask_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetMask+0, 0
;Tache_com_can.c,455 :: 		CANSetFilter(_CAN_FILTER_B2_F1,ID_MSG_CONFIG_EEP,_CAN_CONFIG_STD_MSG);
	MOVLW       2
	MOVWF       FARG_CANSetFilter_CAN_FILTER+0 
	MOVLW       80
	MOVWF       FARG_CANSetFilter_val+0 
	MOVLW       0
	MOVWF       FARG_CANSetFilter_val+1 
	MOVWF       FARG_CANSetFilter_val+2 
	MOVWF       FARG_CANSetFilter_val+3 
	MOVLW       255
	MOVWF       FARG_CANSetFilter_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetFilter+0, 0
;Tache_com_can.c,458 :: 		CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);
	CLRF        FARG_CANSetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSetOperationMode_WAIT+0 
	CALL        _CANSetOperationMode+0, 0
;Tache_com_can.c,460 :: 		}
L_end_InitComCAN:
	RETURN      0
; end of _InitComCAN

_IniTVarGlComCAN:

;Tache_com_can.c,476 :: 		void IniTVarGlComCAN()
;Tache_com_can.c,480 :: 		}
L_end_IniTVarGlComCAN:
	RETURN      0
; end of _IniTVarGlComCAN
