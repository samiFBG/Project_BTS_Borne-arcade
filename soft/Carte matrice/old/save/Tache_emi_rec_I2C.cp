#line 1 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
#line 1 "h:/1 travail/lycee_ed/5_projets/31_arcade/soft/microcontroleur/ges_matrix/v2_3_rul5358/tache_emi_rec_i2c.h"
#line 18 "h:/1 travail/lycee_ed/5_projets/31_arcade/soft/microcontroleur/ges_matrix/v2_3_rul5358/tache_emi_rec_i2c.h"
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
#line 1 "h:/1 travail/lycee_ed/5_projets/31_arcade/soft/microcontroleur/ges_matrix/v2_3_rul5358/commun.h"
#line 1 "h:/1 travail/lycee_ed/5_projets/31_arcade/soft/microcontroleur/ges_matrix/v2_3_rul5358/built_in.h"
#line 20 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
unsigned short RegistreEtat;



unsigned short WordAdressI2C;
unsigned short NbOctetEcrI2C;
unsigned short AdresseI2C;
unsigned short *PtBuffEcrI2C;
unsigned short StatusI2C;





unsigned short NbOctetLecI2C;
unsigned short *PtBuffLecI2C;

char BufferEcrI2C[7];
#line 80 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
void InterruptSpgEmiRecI2C()
{

 if (!StatusI2C. F7 )
 {

 if (!StatusI2C. F1 )
 {

 StatusI2C. F1  = 1;
 AdresseI2C.F0 = 0;
 sspbuf = AdresseI2C;
 }
 else
 {
 if (!sspstat.P)
 {

 if (!StatusI2C. F0 )
 {

 StatusI2C. F0  = 1;
 sspbuf = WordAdressI2C;
 }
 else
 {
 if (NbOctetEcrI2C != 0)
 {

 NbOctetEcrI2C--;
 sspbuf = *PtBuffEcrI2C;
 PtBuffEcrI2C++;
 }
 else
 {

 sspcon2.PEN = 1;
 }
 }
 }
 else
 {
 StatusI2C = 0;
 }
 }
 }
 else
 {

 if (!StatusI2C. F1 )
 {

 StatusI2C. F1  = 1;
 AdresseI2C.F0 = 1;
 sspbuf = AdresseI2C;
 }
 else
 {
 if (!StatusI2C. F5 )
 {


 sspcon2.RCEN = 1;
 StatusI2C. F5  = 1;
 }
 else
 {

 if (!StatusI2C. F6 )
 {

 StatusI2C. F6  = 1;
 *PtBuffLecI2C = sspbuf;
 NbOctetLecI2C--;
 PtBuffLecI2C++;
 if (NbOctetLecI2C != 0)
 {

 sspcon2.ACKDT = 0;
 sspcon2.ACKEN = 1;
 }
 else
 {

 sspcon2.ACKDT = 1;
 sspcon2.ACKEN = 1;
 }
 }
 else
 {

 if (NbOctetLecI2C == 0)
 {


 if (!sspstat.P)
 {

 sspcon2.PEN = 1;
 }
 else

 StatusI2C = 0;
 }
 else
 {


 sspcon2.RCEN = 1;
 StatusI2C. F6  = 0;
 }
 }
 }
 }
 }
}
#line 218 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
void InitPeriphEmiRecI2C()
{

 sspstat =  0b10000000 ;
 sspcon1 =  0b00101000 ;
 sspcon2 =  0b00000000 ;
 sspadd =  9 ;


 pie1.SSPIE = 0;

}
#line 244 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
void IniTVarGlEmiRecI2C()
{
 StatusI2C = 0;
}
#line 273 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
void EcrCAT24M01 (char NbOctetEcr, char AdresseInt, char *ptBuffEcr)
{
unsigned short EcrAdrI2C;



 WordAdressI2C = AdresseInt;
 NbOctetEcrI2C = NbOctetEcr;
 AdresseI2C =  0b10100000 ;
 PtBuffEcrI2C = ptBuffEcr;
 StatusI2C = 0;
 StatusI2C. F7  = 0;

 sspcon2.SEN = 1;


 delay_ms(5);




}
#line 318 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
void LecCAT24M01(char NbOctetLec, unsigned int AdresseInt, char *ptBuffLec)
{
static unsigned short AdrLo;


 WordAdressI2C =  ((char *)&AdresseInt)[1] ;
 AdrLo =  ((char *)&AdresseInt)[0] ;
 NbOctetEcrI2C = 1;
 AdresseI2C =  0b10100000 ;
 PtBuffEcrI2C = &AdrLo;
 StatusI2C = 0;
 StatusI2C. F7  = 0;
 sspcon2.SEN = 1;


 delay_us(60);


 NbOctetLecI2C = NbOctetLec;
 AdresseI2C =  0b10100000 ;;
 PtBuffLecI2C = ptBuffLec;
 StatusI2C = 0;
 StatusI2C. F7  = 1;

 sspcon2.SEN = 1;



}
#line 367 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
unsigned short EcrI2CPoll(unsigned int AdresseInt, unsigned short PageHaute,
 unsigned short *ptBuffEcr, unsigned int NbData)
{
unsigned short Res =  1 ;
unsigned int i;
unsigned short AdrCAT =  0b10100000 ;

 if (PageHaute ==  1 )
 AdrCAT = AdrCAT |  0b00000010 ;

 sspcon2.SEN = 1;
 delay_us( 15 );
 sspbuf = AdrCAT;
 delay_us( 15 );
 sspbuf =  ((char *)&AdresseInt)[1] ;
 delay_us( 15 );
 sspbuf =  ((char *)&AdresseInt)[0] ;
 delay_us( 15 );
 for (i=0 ; i!=NbData ; i++)
 {
 sspbuf = ptBuffEcr[i];
 delay_us( 15 );
 }
 if (sspcon2.ACKSTAT)
 Res =  0 ;
 sspcon2.PEN = 1;


 return Res;
}
#line 412 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
unsigned short EcrAdrIntPoll(unsigned int AdresseInt, unsigned short PageHaute)
{
unsigned short Res =  1 ;
unsigned short AdrCAT =  0b10100000 ;

 if (PageHaute ==  1 )
 AdrCAT = AdrCAT |  0b00000010 ;

 sspcon2.SEN = 1;
 delay_us( 15 );
 sspbuf = AdrCAT;
 delay_us( 15 );
 sspbuf =  ((char *)&AdresseInt)[1] ;
 delay_us( 15 );
 sspbuf =  ((char *)&AdresseInt)[0] ;
 delay_us( 15 );
 if (sspcon2.ACKSTAT)
 Res =  0 ;
 sspcon2.PEN = 1;
 delay_us( 15 );

 return Res;
}
#line 450 "H:/1 TRAVAIL/Lycee_ed/5_PROJETS/31_arcade/soft/MicroControleur/Ges_Matrix/V2_3_RUL5358/Tache_emi_rec_I2C.c"
void LecI2CPoll(unsigned int NbByte2Read, unsigned short *ptBufferRead)
{
unsigned short Res =  1 ;

 sspcon2.SEN = 1;
 delay_us( 15 );
 sspbuf =  0b10100000 +1;
 delay_us( 15 );

 while (NbByte2Read != 1)
 {
 sspcon2.RCEN = 1;
 delay_us( 15 );
 *ptBufferRead = sspbuf;
 sspcon2.ACKDT = 0;
 sspcon2.ACKEN = 1;
 delay_us( 15 );
 NbByte2Read--;
 ptBufferRead++;
 }
 sspcon2.RCEN = 1;
 delay_us( 15 );
 *ptBufferRead = sspbuf;
 sspcon2.ACKDT = 1;
 sspcon2.ACKEN = 1;
 delay_us( 15 );
 sspcon2.PEN = 1;
 delay_us(10);

}
