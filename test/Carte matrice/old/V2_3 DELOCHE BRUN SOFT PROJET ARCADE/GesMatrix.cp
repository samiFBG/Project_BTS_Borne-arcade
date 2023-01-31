#line 1 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
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
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/tache_ges_time_out.h"










void InterruptSpgGesTimeOut();
void InitPeriphGesTimeOut();
void IniTVarGlGesTimeOut();
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/tache_com_can.h"



void InterruptSpgComCAN();
void InitPeriphComCAN();
void IniTVarGlComCAN();


extern unsigned short Config_can1;





extern unsigned short RecOK;





extern unsigned short TabMatrix[ 256 ];



extern unsigned short ModeEnCours;
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/tache_it_mtrx.h"










void InterruptSpgGesMatrix();
void InitPeriphITMatrix();





extern unsigned short NumColonne;
extern unsigned short NumLigne;

extern unsigned short VoletDroit;
extern unsigned short VoletGauche;
#line 48 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
typedef struct strCliImg
{
 unsigned short CliEnCours;
 unsigned short AffCli;
 unsigned short TempoCli;
} t_CliImg;



void InitPeriphFond();
void InitVarGlobal();

unsigned short VerifChkChkb(char *ptData, unsigned short NbOctet);
void CalculChk(char *ptTab, unsigned short NbOctTab);
void InitEcrMem(unsigned short PageMemHaute);
void InitLecMem(unsigned short PageMemHaute);

void ImageEEp2RAM(unsigned short PageRAMHaute, unsigned short NumImgEEp);
void GesCliBandeau (t_AppImg *ptAppelImg);
unsigned short GeneNbAlea(unsigned short NbMini, unsigned short NbMaxi);
void GesBandeauInit (unsigned short *ptTempoImg, t_AppImg *ptAppelImg);
void GesBandeauJeu (unsigned short *ptTempoImg, unsigned short JeuEnCours_, t_AppImg *ptAppelImg);
void AppImageFond(unsigned short PageImg, unsigned short NumImg);

void LecConfigEEP();



t_AppImg AppelImg;
#line 126 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
unsigned short gTempoWDOG = 1 ;

unsigned short ImgJeux[2* 8 ] = {8,6,12,6,6,2,6,10,4,0,0,0,0,0,0,0};
unsigned short ImgTempoJeux[2* 8 ] = {5,30,10,30,30,8,30,15,10,0,0,0,0,0,0,0};






void main()
{
unsigned int i, k;
unsigned Cpt = 0;
unsigned short Res, j;
unsigned short TempoImg = 0;
unsigned short ModeEnCoursPrec =  0 ;
unsigned short ModeEnCoursLoc =  0 ;





 InitPeriphFond();
 InitPeriphEmiRecI2C();
 delay_ms(500);
 InitPeriphComCAN();
 InitPeriphITMatrix();
 InitPeriphGesTimeOut();



 IniTVarGlEmiRecI2C();
 IniTVarGlGesTimeOut();
 IniTVarGlComCAN();
 InitVarGlobal();



 LecConfigEEP();
#line 181 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
 intcon.PEIE = 1;
 intcon.GIE = 1;



 for(;;)
 {



 if (AppelImg.MajImg ==  1 )
 {
 AppImageFond(AppelImg.PageHaut, AppelImg.NumImage);
 AppelImg.MajImg =  0 ;
 }




 GesCliBandeau (&AppelImg);





 ModeEnCoursLoc = ModeEnCours;
 if (ModeEnCoursLoc ==  0 )
 {
 ModeEnCoursPrec = ModeEnCoursLoc;
 GesBandeauInit(&TempoImg, &AppelImg);
 }
 else if ((ModeEnCoursLoc != ModeEnCoursPrec) && (!pie1.TMR1IE))
 {


 ModeEnCoursPrec = ModeEnCoursLoc;
 GesBandeauJeu(&TempoImg, ModeEnCoursLoc, &AppelImg);
 }




 if (AppelImg.Tempo2Img != 0)
 {
 TempoImg++;
 if (TempoImg == AppelImg.Tempo2Img)
 {
 TempoImg = 0;
 portb. F4  = !portb. F4 ;
 }
 }
 else
 TempoImg = 0;



 gTempoWDOG--;
 if (gTempoWDOG == 0)
 {
 if (RecOK ==  0 )
 gTempoWDOG =  1 ;
 else
 gTempoWDOG =  25 ;
 gTempoWDOG =  1 ;
 portb. F0  = !portb. F0 ;
 }
 Delay_ms( 10 );
 }
}
#line 268 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void AppImageFond(unsigned short PageImg, unsigned short NumImg)
{
unsigned short SaveVD;
unsigned short SaveVG;

 if (NumImg <  32 )
 {



 ccp1con =  0b00000000 ;
 portc. F2  = 1;

 pie2.TMR3IE = 0;

 SaveVD = VoletDroit;
 SaveVG = VoletGauche;

 ImageEEp2RAM(PageImg, NumImg);
 delay_us(20);

 VoletDroit = SaveVD;
 VoletGauche = SaveVG;
 pie2.TMR3IE = 1;


 ccp1con =  0b00011100 ;
 ccpr1l = AppelImg.ValPWM;
 }
}
#line 315 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
const unsigned short ImgInit[ 8 ] = {6,12,6,2,6,4,6,8};
const unsigned short ImgTempo[ 8 ] = {25,10,25,8,25,10,25,5};






void GesBandeauInit (unsigned short *ptTempoImg, t_AppImg *ptAppelImg)
{
static unsigned short NumImage_ = 0;
static unsigned short VoletOuvrant =  1 ;

static unsigned short TempoAffImg = 0;

unsigned short TypeVoletA;


 if (VoletOuvrant ==  1 )
 {
 if (!pie1.TMR1IE)
 {



 AppImageFond( 0 ,ImgInit[NumImage_]);
 delay_us(20);

 AppImageFond( 1 ,ImgInit[NumImage_]+1);
 delay_us(20);
 ptAppelImg->Tempo2Img = ImgTempo[NumImage_];
 *ptTempoImg = 0;

 TypeVoletA = GeneNbAlea( 1 ,  3 );
 ptAppelImg->TypeVolet = TypeVoletA;
 ptAppelImg->TempoVolet =  25 ;
 pie1.TMR1IE = 1;

 VoletOuvrant =  0 ;
 NumImage_++;
 if (NumImage_ ==  8 )
 NumImage_ = 0;
 }
 }
 else
 {
 TempoAffImg++;
 if (TempoAffImg ==  200 )
 {
 TempoAffImg = 0;

 TypeVoletA = GeneNbAlea( 4 ,  6 );
 ptAppelImg->TypeVolet = TypeVoletA;
 ptAppelImg->TempoVolet =  25 ;
 pie1.TMR1IE = 1;
 VoletOuvrant =  1 ;
 }
 }
}
#line 407 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void GesBandeauJeu (unsigned short *ptTempoImg, unsigned short JeuEnCours_, t_AppImg *ptAppelImg)
{
unsigned short TypeVoletA;

 JeuEnCours_--;
 if (JeuEnCours_ >  15 )
 JeuEnCours_ =  14 ;


 AppImageFond( 0 ,ImgJeux[JeuEnCours_]);
 AppImageFond( 1 ,ImgJeux[JeuEnCours_]+1);
 ptAppelImg->Tempo2Img = ImgTempoJeux[JeuEnCours_];
 *ptTempoImg = 0;

 TypeVoletA = GeneNbAlea( 1 ,  3 );
 ptAppelImg->TypeVolet = TypeVoletA;
 ptAppelImg->TempoVolet =  25 ;
 pie1.TMR1IE = 1;
}
#line 440 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
unsigned short GeneNbAlea(unsigned short NbMini, unsigned short NbMaxi)
{
unsigned short NbAlea;
unsigned int Temp;

 Temp = rand();
 NbAlea =  ((char *)&Temp)[0]  +  ((char *)&Temp)[1] ;
 NbAlea = NbAlea % (NbMaxi - NbMini + 1);
 NbAlea = NbAlea + NbMini;

 return NbAlea;

}
#line 469 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void GesCliBandeau (t_AppImg *ptAppelImg)
{
static t_CliImg CliImg = { 0 ,  0 , 0};

 if (ptAppelImg->TempoCli == 0)
 {
 if (CliImg.CliEnCours ==  1 )
 {


 ccp1con =  0b00011100 ;
 ccpr1l = ptAppelImg->ValPWM;
 CliImg.CliEnCours =  0 ;
 CliImg.TempoCli = 0;
 }
 }
 else
 {
 CliImg.CliEnCours =  1 ;
 CliImg.TempoCli++;
 if (CliImg.TempoCli == ptAppelImg->TempoCli)
 {
 CliImg.TempoCli = 0;
 if (CliImg.AffCli ==  0 )
 {



 ccp1con =  0b00000000 ;
 portc. F2  = 1;
 CliImg.AffCli =  1 ;
 }
 else
 {

 ccp1con =  0b00011100 ;
 ccpr1l = AppelImg.ValPWM;
 CliImg.AffCli =  0 ;
 }
 }
 }
}
#line 526 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void InitEcrMem(unsigned short PageMemHaute)
{

 portc. F1  = 1;
 portb. F6  = 1;
 delay_us(10);
 portb. F6  = 0;


 portc. F6  = 0;
 if (PageMemHaute ==  1 )
 portb. F4  = 1;
 else
 portb. F4  = 0;
 portc. F5  = 0;
 trisd =  0b11000000 ;
}
#line 557 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void InitLecMem(unsigned short PageMemHaute)
{

 trisd =  0b11111111 ;
 portc. F5  = 1;
 portc. F6  = 0;
 if (PageMemHaute ==  1 )
 portb. F4  = 1;
 else
 portb. F4  = 0;


 portc. F1  = 1;
 portb. F6  = 1;
 delay_us(10);
 portb. F6  = 0;

}
#line 591 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void ImageEEp2RAM(unsigned short PageRAMHaute, unsigned short NumImgEEp)
{
unsigned int AdrIntEEp = 0;
unsigned short PageEEpHaute;

unsigned int i, k;
unsigned Cpt = 0;
unsigned short Res, j;


 NumColonne = 0xff;
 NumLigne = 0;


 if (NumImgEEp >=  16 )
 {
 PageEEpHaute =  1 ;
 NumImgEEP = NumImgEEP -  16 ;
 }
 else
 PageEEpHaute =  0 ;
  ((char *)&AdrIntEEp)[1]  = (NumImgEEp << 4);


 Res = EcrAdrIntPoll(AdrintEEp, PageEEpHaute);

 InitEcrMem(PageRAMHaute);
 Cpt = 0;
 for (j=0 ; j !=  16  ; j++)
 {

 LecI2CPoll( 256 , TabMatrix);

 for (k=0 ; k !=  256  ; k++)
 {
 latd = TabMatrix[k];
 portc. F5  = 1;
 portc. F1  = 0;
 delay_us(1);
 portc. F1  = 1;
 delay_us(1);

 Cpt++;
 if (Cpt !=  4096 -1)
 portc. F5  = 0;
 delay_us(1);
 }
 }

 InitLecMem(PageRAMHaute);

}
#line 660 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
unsigned short VerifChkChkb (char *ptData, unsigned short NbOctet)
{
unsigned short i;
unsigned short Somme;
unsigned short ResVerif;

 ResVerif =  0 ;
 Somme = 0;
 for (i=0 ; i!= NbOctet-2 ; i++)
 {
 Somme = Somme + *(ptData + i);
 }
 if (Somme == *(ptData + NbOctet - 2))
 {
 Somme = ~Somme;
 if (Somme == *(ptData + NbOctet -1))
 ResVerif =  1 ;
 }

 return ResVerif;
}
#line 700 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void CalculChk(char *ptTab, unsigned short NbOctTab)
{
unsigned short Somme;
unsigned short i;

 Somme = 0;
 for (i=0; i!=NbOctTab-1; i++)
 {
 Somme = Somme + *(ptTab+i);
 }
 *(ptTab + NbOctTab -1) = Somme;

}
#line 728 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void LecConfigEEP()
{
unsigned short i;

 for(i=0 ; i!=  8  ; i++)
 ImgJeux[i] = EEPROM_Read( 0 +i);
 for(i=0 ; i!=  8  ; i++)
 ImgJeux[i+ 8 ] = EEPROM_Read( 8 +i);
 for(i=0 ; i!=  8  ; i++)
 ImgTempoJeux[i] = EEPROM_Read( 16 +i);
 for(i=0 ; i!=  8  ; i++)
 ImgTempoJeux[i+ 8 ] = EEPROM_Read( 24 +i);

}
#line 756 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void InitVarGlobal()
{
 AppelImg.MajImg =  0 ;
 AppelImg.ValPWM = 0;
 AppelImg.TempoCli = 0;
 AppelImg.Tempo2Img = 0;




}
#line 785 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/GesMatrix.c"
void InitPeriphFond()
{




 trisa =  0b11110000 ;
 adcon1 =  0b00000110 ;

 trisb =  0b10001000 ;
 trisc =  0b00011000 ;
 cmcon =  0b00000111 ;
 trisd =  0b11111111 ;



 lata = 0;
 latc = 0;
 latb = 0;
 latd = 0;

 latb. F0  = 1;



 eecon1.EEPGD = 0;
 eecon1.CFGS = 0;


 portc. F5  = 1;
 portc. F6  = 0;
 portb. F4  = 0;


 portc. F1  = 1;
 portb. F6  = 1;
 delay_us(10);
 portb. F6  = 0;


 porta = 0;
 portc. F0  = 0;
 portc. F7  = 0;



 pr2 =  0xFF ;
 t2con =  0b00000110 ;
 ccp1con =  0b00011100 ;
 ccpr1l = 0x00;


 rcon.IPEN = 1;

}
