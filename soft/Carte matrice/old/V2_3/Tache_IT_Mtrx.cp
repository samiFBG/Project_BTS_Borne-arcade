#line 1 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3/Tache_IT_Mtrx.c"
#line 1 "h:/1 travail/lycee_ed/5_projets/31_arcade/soft/microcontroleur/ges_matrix/v2_3/commun.h"
#line 1 "h:/1 travail/lycee_ed/5_projets/31_arcade/soft/microcontroleur/ges_matrix/v2_3/gesmatrix.h"










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
#line 1 "h:/1 travail/lycee_ed/5_projets/31_arcade/soft/microcontroleur/ges_matrix/v2_3/tache_it_mtrx.h"










void InterruptSpgGesMatrix();
void InitPeriphITMatrix();





extern unsigned short NumColonne;
extern unsigned short NumLigne;

extern unsigned short VoletDroit;
extern unsigned short VoletGauche;
#line 22 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3/Tache_IT_Mtrx.c"
unsigned short NumColonne = 0xff;
unsigned short NumLigne = 0;


unsigned short VoletDroit = 0;
unsigned short VoletGauche = 127;
#line 56 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3/Tache_IT_Mtrx.c"
void interrupt()
{


 tmr3h =  0xFF ;
 tmr3l =  0xE2 ;


 if ((NumLigne >= VoletGauche) && (NumLigne <= VoletDroit))
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

 NumLigne++;
 if (NumLigne.F7)
 {
 portc. F0  = 1;
 NumLigne = 0;

 NumColonne++;
 porta = NumColonne;
 portc. F0  = 0;
 }

 PIR2.TMR3IF = 0;

}
#line 112 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3/Tache_IT_Mtrx.c"
void InitPeriphITMatrix()
{


 tmr3h =  0xFF ;
 tmr3l =  0xE2 ;
 t3con =  0b00000001 ;


 ipr2.TMR3IP = 1;
 pie2.TMR3IE = 1;

}
