#line 1 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_ges_time_out.c"
#line 1 "h:/1 travail/lycee_prof/3_projet/proj2021-22 arcade/spj1_3/soft/carte matrice/v2_3 deloche brun soft projet arcade/tache_ges_time_out.h"










void InterruptSpgGesTimeOut();
void InitPeriphGesTimeOut();
void IniTVarGlGesTimeOut();
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
#line 19 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_ges_time_out.c"
unsigned int TimeOut;




unsigned short TempoVolet = 0;
unsigned short DebutVolet =  1 ;
#line 69 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_ges_time_out.c"
void InterruptSpgGesTimeOut()
{

 tmr1h =  0xFB ;
 tmr1l =  0x1E ;

 TempoVolet++;
 if (TempoVolet == AppelImg.TempoVolet)
 {
 TempoVolet = 0;

 switch (AppelImg.TypeVolet)
 {

 case  1 :
 {
 if (DebutVolet ==  1 )
 {

 VoletGauche =  0x7F ;
 VoletDroit =  0x7E ;
 DebutVolet =  0 ;
 }
 else
 {

 VoletGauche--;
 if (VoletGauche ==  0 )
 {
 DebutVolet =  1 ;
 pie1.TMR1IE = 0;
 }
 }
 break;
 }

 case  4 :
 {
 if (DebutVolet ==  1 )
 {

 VoletGauche =  0 ;
 VoletDroit =  0x7E ;
 DebutVolet =  0 ;
 }
 else
 {

 VoletGauche++;
 if (VoletGauche ==  0x7F )
 {
 DebutVolet =  1 ;
 pie1.TMR1IE = 0;
 }
 }
 break;
 }

 case  2 :
 {
 if (DebutVolet ==  1 )
 {

 VoletGauche =  0x7F ;
 VoletDroit =  0 ;
 DebutVolet =  0 ;
 }
 else
 {

 if (VoletGauche ==  0x7F )
 VoletGauche =  0 ;
 else
 VoletDroit++;
 if (VoletDroit ==  0x7E )
 {
 DebutVolet =  1 ;
 pie1.TMR1IE = 0;
 }
 }
 break;
 }

 case  5 :
 {
 if (DebutVolet ==  1 )
 {

 VoletGauche =  0 ;
 VoletDroit =  0x7E ;
 DebutVolet =  0 ;
 }
 else
 {

 if (VoletGauche ==  0x7F )
 {
 DebutVolet =  1 ;
 pie1.TMR1IE = 0;
 }
 if (VoletDroit ==  0 )
 VoletGauche =  0x7F ;
 if (VoletGauche ==  0 )
 VoletDroit--;
 }
 break;
 }

 case  3 :
 {
 if (DebutVolet ==  1 )
 {

 VoletGauche =  0x40 ;
 VoletDroit =  0x3F ;
 DebutVolet =  0 ;
 }
 else
 {

 VoletGauche--;
 VoletDroit++;
 if (VoletGauche ==  0 )
 {
 DebutVolet =  1 ;
 pie1.TMR1IE = 0;
 }
 }
 break;
 }

 case  6 :
 {
 if (DebutVolet ==  1 )
 {

 VoletGauche =  0 ;
 VoletDroit =  0x7E ;
 DebutVolet =  0 ;
 }
 else
 {

 VoletGauche++;
 VoletDroit--;
 if (VoletGauche ==  0x40 )
 {
 DebutVolet =  1 ;
 pie1.TMR1IE = 0;
 }
 }
 break;
 }
 }
 }
}
#line 246 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_ges_time_out.c"
void InitPeriphGesTimeOut()
{


 tmr1h =  0xFB ;
 tmr1l =  0x1E ;
 t1con =  0b00110001 ;


 ipr1.TMR1IP = 0;
 pie1.TMR1IE = 0;

}
#line 273 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_ges_time_out.c"
void IniTVarGlGesTimeOut()
{


}
