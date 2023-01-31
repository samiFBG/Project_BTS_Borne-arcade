#line 1 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Appli_hdl_it.c"
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
#line 41 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Appli_hdl_it.c"
void interrupt_low()
{
#line 85 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Appli_hdl_it.c"
 if ((PIE3.RXB0IE) && (PIR3.RXB0IF))
 {

 InterruptSpgComCAN();
 PIR3.RXB0IF = 0;
 }
 else if ((PIE3.RXB1IE) && (PIR3.RXB1IF))
 {

 InterruptSpgComCAN();
 PIR3.RXB1IF = 0;
 }
 else if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
 {

 InterruptSpgGesTimeOut();
 PIR1.TMR1IF = 0;

 }
}
