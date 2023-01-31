#line 1 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_IT_Mtrx.c"
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
#line 22 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_IT_Mtrx.c"
unsigned short NumColonne = 0xff;
unsigned short NumLigne = 0;


unsigned short VoletDroit = 0;
unsigned short VoletGauche = 127;
#line 83 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_IT_Mtrx.c"
void interrupt()
{
 tmr3h =  0b11111111 ;
 tmr3l =  0b11100010 ;
 if(NumLigne>=VoletGauche && NumLigne<=VoletDroit)
 {
 portc. F6  = 0;

 portc. F7  = 1;
 portc. F1  = 0;
 portc. F7  = 0;
 portc. F1  = 1;
 }
 else
 {
 portc. F6  = 1;
 portc. F7  = 1;
 portc. F1  = 0;
 portc. F7  = 0;
 portc. F1  = 1;
 }
 NumLigne = Numligne++;
 if(NumLigne > 127)
 {
 portc. F0  = 1;
 NumLigne = 0;
 NumColonne = NumColonne++;
 porta = NumColonne;
 portc. F0  = 0;
 }
 PIR2.TMR3IF = 0;
}
#line 139 "H:/1 TRAVAIL/Lycee_prof/3_Projet/Proj2021-22 Arcade/SPJ1_3/soft/Carte matrice/V2_3 DELOCHE BRUN SOFT PROJET ARCADE/Tache_IT_Mtrx.c"
void InitPeriphITMatrix()
{


 tmr3h =  0b11111111 ;
 tmr3l =  0b11100010 ;
 t3con =  0b00000001 ;


 ipr2.TMR3IP = 1;
 pie2.TMR3IE = 1;

}
