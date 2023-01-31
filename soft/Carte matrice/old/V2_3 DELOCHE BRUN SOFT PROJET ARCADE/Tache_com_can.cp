#line 1 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_com_can.c"
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/commun.h"
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/gesmatrix.h"










typedef struct strAppImg
{
 unsigned short MajImg;
 unsigned short PageHaut;
 unsigned short NumImage;
 unsigned short TypeVolet;
 unsigned short TempoVolet;
 unsigned short ValPWM;
 unsigned short TempoCli;
 unsigned short Tempo2Img;
} t_AppImg;

extern t_AppImg AppelImg;
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/tache_it_mtrx.h"










void InterruptSpgGesMatrix();
void InitPeriphITMatrix();





extern unsigned short NumColonne;
extern unsigned short NumLigne;

extern unsigned short VoletDroit;
extern unsigned short VoletGauche;
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/tache_com_can.h"



void InterruptSpgComCAN();
void InitPeriphComCAN();
void IniTVarGlComCAN();


extern unsigned short Config_can1;





extern unsigned short RecOK;





extern unsigned short TabMatrix[ 256 ];



extern unsigned short ModeEnCours;
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/built_in.h"
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/tache_emi_rec_i2c.h"
#line 18 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/tache_emi_rec_i2c.h"
void InitPeriphEmiRecI2C();
void IniTVarGlEmiRecI2C();


unsigned short EcrI2CPoll(unsigned int AdresseInt, unsigned short PageHaute,
 unsigned short *ptBuffEcr, unsigned int NbData);
unsigned short EcrAdrIntPoll(unsigned int AdresseInt, unsigned short PageHaute);
void LecI2CPoll(unsigned int NbByte2Read, unsigned short *ptBufferRead);




extern unsigned short WordAdressI2C;
extern unsigned short NbOctetEcrI2C;
extern unsigned short AdresseI2C;
extern unsigned short *PtBuffEcrI2C;
extern unsigned short StatusI2C;





extern unsigned short NbOctetLecI2C;
extern unsigned short *PtBuffLecI2C;
#line 18 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_com_can.c"
void InitComCAN();
void GesRecImage(unsigned short *ptDataRec);
void GesCmdImage(unsigned short *ptDataRec, t_AppImg *ptAppelImg);
void GesMajEEprom(long Id_, unsigned short *ptDataRec);




long id;
unsigned short DataRec[8];
unsigned short Len;
unsigned short StatusCAN;

unsigned short Config_can1;
unsigned short DataEEp[32];








unsigned short RecOK =  0 ;
unsigned short ModeEnCours =  1 ;



unsigned short TabMatrix[512] absolute 0x100;
#line 65 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_com_can.c"
void InterruptSpgComCAN()
{
unsigned short Res, i, Param;





 Res = CANRead(&id, DataRec , &Len, &StatusCAN);
 if (Res != 0)
 {



 if (id ==  0x42 )
 {
 GesRecImage(DataRec);
 }



 if (id ==  0x41 )
 {
 GesCmdImage(DataRec, &AppelImg);
 }



 if (id ==  0x40 )
 {
 ModeEnCours = DataRec[1];
 }


 if ((id &  0xFFFFFFFC ) ==  0x50 )
 {
 GesMajEEprom(id, DataRec);
 }
 }

}
#line 122 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_com_can.c"
void GesRecImage(unsigned short *ptDataRec)
{
static unsigned short HeaderOK =  0 ;
static unsigned short RecHeader =  0 ;
static unsigned short HeaderFin =  0 ;

static unsigned short NumOctet = 0;

static unsigned short NumPartImg = 0;
static unsigned short NumImage = 0;
static unsigned short ChkImg = 0;




static unsigned short PageHt =  0 ;
static unsigned int AdrInt = 0;

unsigned short i, Res;


 if ((ptDataRec[0] ==  0x55 ) && (ptDataRec[7] ==  0xAA ))
 {


 HeaderOK =  1 ;
 NumImage = ptDataRec[1];
 for (i=2 ; i!=7 ; i++)
 if (ptDataRec[i] != 0) HeaderOK =  0 ;
 if (HeaderOK ==  1 )
 {

 RecHeader =  1 ;
 NumOctet = 0;
 NumPartImg = 0;
 ChkImg = 0;
 RecOK =  0 ;
 t3con =  0b00110001 ;

 }
 }

 if (HeaderFin ==  1 )
 {

 if ((ptDataRec[0] ==  0xAA ) && (ptDataRec[7] ==  0x55 ))
 {

 if (ChkImg == DataRec[2])
 {

 EEPROM_Write( 32 +NumImage, ChkImg);
 }
 else
 RecOK. F1  = 1;
 }
 else
 RecOK. F2  = 1;
 HeaderFin =  0 ;
 t3con =  0b00000001 ;


 }

 if (HeaderOK ==  1 )
 {
 if (RecHeader ==  1 )
 RecHeader =  0 ;
 else
 {

 ChkImg = ChkImg + ptDataRec[0] + ptDataRec[1] + ptDataRec[2] + ptDataRec[3];
 ChkImg = ChkImg + ptDataRec[4] + ptDataRec[5] + ptDataRec[6] + ptDataRec[7];

 TabMatrix[NumOctet++] = ptDataRec[0];
 TabMatrix[NumOctet++] = ptDataRec[1];
 TabMatrix[NumOctet++] = ptDataRec[2];
 TabMatrix[NumOctet++] = ptDataRec[3];
 TabMatrix[NumOctet++] = ptDataRec[4];
 TabMatrix[NumOctet++] = ptDataRec[5];
 TabMatrix[NumOctet++] = ptDataRec[6];
 TabMatrix[NumOctet++] = ptDataRec[7];
 if (NumOctet == 0)
 {



 if (NumImage >=  16 )
 {
 PageHt =  1 ;

 AdrInt = 0;
  ((char *)&AdrInt)[1]  = ((NumImage -  16 ) << 4) + NumPartImg;
 }
 else
 {
 PageHt =  0 ;

 AdrInt = 0;
  ((char *)&AdrInt)[1]  = (NumImage << 4) + NumPartImg;
 }
 Res = EcrI2CPoll(AdrInt, PageHt, TabMatrix,  256 );
 if (Res ==  0 )
 RecOK. F0  = 1;
 NumPartImg++;
 }
 if ( NumPartImg ==  16 )
 {

 HeaderOK =  0 ;
 HeaderFin =  1 ;
 }
 }
 }
}
#line 253 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_com_can.c"
void GesCmdImage(unsigned short *ptDataRec, t_AppImg *ptAppelImg)
{
unsigned short Param;


 switch (ptDataRec[ 0 ])
 {
 case  0 :
 {

 ccpr1l = ptDataRec[ 1 ];
 ptAppelImg->ValPWM = ptDataRec[ 1 ];
 break;
 }
 case  1 :
 {
 Param = ptDataRec[ 1 ];
 ptAppelImg->MajImg =  1 ;
 if (Param. F7 )
 ptAppelImg->PageHaut =  1 ;
 else
 ptAppelImg->PageHaut =  0 ;
 ptAppelImg->NumImage = Param &  0b00011111 ;

 break;
 }
 case  2 :
 {


 ptAppelImg->TypeVolet = ptDataRec[ 1 ];
 ptAppelImg->TempoVolet = ptDataRec[ 2 ];
 pie1.TMR1IE = 1;
 break;
 }
 case  5 :
 {
 ptAppelImg->TempoCli = ptDataRec[ 1 ];
 break;
 }
 case  6 :
 {
 ptAppelImg->Tempo2Img = ptDataRec[ 1 ];
 break;
 }
 }
}
#line 318 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_com_can.c"
void GesMajEEprom(long Id_, unsigned short *ptDataRec)
{
unsigned short i;

 switch (Id_)
 {
 case ( 0x50 + 0 ):
 {
 t3con =  0b00110001 ;
 for (i=0 ; i!=  8  ; i++)
 {



 DataEEp[i+ 0 ] = ptDataRec[i];
 }
 break;
 }
 case ( 0x50 + 1 ):
 {
 for (i=0 ; i!=  8  ; i++)
 {



 DataEEp[i+ 8 ] = ptDataRec[i];
 }
 break;
 }
 case ( 0x50 + 2 ):
 {
 for (i=0 ; i!=  8  ; i++)
 {



 DataEEp[i+ 16 ] = ptDataRec[i];
 }
 break;
 }
 case ( 0x50 + 3 ):
 {
 for (i=0 ; i!=  8  ; i++)
 {



 DataEEp[i+ 24 ] = ptDataRec[i];
 }
 for (i=0 ; i!= (4* 8 ) ; i++)
 {

 EEPROM_Write( 0 +i, DataEEp[i]);
 delay_ms(10);
 }
 t3con =  0b00000001 ;
 delay_ms( 25 );
 asm {
 reset
 }
 break;
 }
 }

}
#line 397 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_com_can.c"
void InitPeriphComCAN()
{
 InitComCAN();


 ipr3.RXB1IP = 0;
 ipr3.RXB0IP = 0;
 pie3.RXB1IE = 1;
 pie3.RXB0IE = 1;

}
#line 423 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_com_can.c"
void InitComCAN()
{

unsigned short Config_can2;
long id;


 Config_can1 = _CAN_TX_PRIORITY_0 &
 _CAN_TX_STD_FRAME &
 _CAN_TX_NO_RTR_FRAME;


 Config_can2 = _CAN_CONFIG_SAMPLE_THRICE &
 _CAN_CONFIG_PHSEG2_PRG_ON &
 _CAN_CONFIG_STD_MSG &
 _CAN_CONFIG_DBL_BUFFER_ON &
 _CAN_CONFIG_VALID_STD_MSG &
 _CAN_CONFIG_LINE_FILTER_OFF;


 CANInitialize(1,4,8,8,8,Config_can2);


 CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);



 CANSetMask(_CAN_MASK_B1, 0xFFFFFFFC ,_CAN_CONFIG_STD_MSG);
 CANSetFilter(_CAN_FILTER_B1_F1, 0x42 ,_CAN_CONFIG_STD_MSG);


 CANSetMask(_CAN_MASK_B2, 0xFFFFFFFC ,_CAN_CONFIG_STD_MSG);
 CANSetFilter(_CAN_FILTER_B2_F1, 0x50 ,_CAN_CONFIG_STD_MSG);


 CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);

}
#line 476 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_com_can.c"
void IniTVarGlComCAN()
{


}
