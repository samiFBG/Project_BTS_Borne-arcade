//----------------------------------------------------------------------------//
//                                                                            //
// Objet du programme : Gestion bus et composant I2C                          //
//                                                                            //
// par E. BURTZ                                                               //
// Commencé le 30/11/2007                                                     //
//                                                                            //
// V1.0 : 30/11/07 : version initiale                                         //
//                                                                            //
//----------------------------------------------------------------------------//
//
//

#include "Tache_emi_rec_I2C.h"
#include "commun.h"
#include "built_in.h"

//----------------- definition des variable du SPG I2C ----------------------//

unsigned short RegistreEtat;

//------------------ definition variable globales visibles -------------------//

unsigned short WordAdressI2C;
unsigned short NbOctetEcrI2C;
unsigned short AdresseI2C;
unsigned short *PtBuffEcrI2C;
unsigned short StatusI2C;
//#define BIT_EMI_ADR_INT      F0
//#define BIT_START_EMI        F1
//#define BIT_REC_FIRST_BYTE   F5
//#define BIT_EMI_ACK          F6
//#define BIT_RECEPTION_I2C    F7
unsigned short NbOctetLecI2C;
unsigned short *PtBuffLecI2C;

char BufferEcrI2C[7];

//----------------- variables définie dans d'autre taches --------------------//


//---------------------------- constantes ------------------------------------//

//#define ADR_MEMORY           0b10100010   //adresse I2C HTR
//#define ADR_TEMP            0b10010000   //adresse I2C capteur temperature DS6121
//#define ACCESS_TEMP          0xAA         //registre DS6121
//#define ACCESS_CONFIG 0xAC
//#define START_CONVERT 0xEE
//#define INIT_MODE     0b00001000
#define ADR_CAT24M01  0b10100000
#define SET_PAGE_H    0b00000010

//----- definition bit WriteTabI2c
//char WriteTabI2c;
#define BIT_ECR_HEURE_RS232 F0
#define BIT_ECR_PLAGE       F1
#define BIT_ECR_HEURE_BP    F2
#define BIT_ECR_DATE_BP     F3
#define BIT_TRANSFERT_ENC   F4
#define BIT_ECR_CONFIG      F5


//-------------------------------------------------------//
//                                                       //
//          spg d'interruption emi/rec I2C               //
//                                                       //
//-------------------------------------------------------//
//
// Ce sous programme permet l'ecriture ou la lecture d'un
// composant I2C sous IT.
//
// Variable :
//    WordAdressI2C : adresse interne composant I2C
//                NbOctetEcrI2C : Nombre d'octet a ecrire
//                AdresseI2C    : adresse composant I2C
//                PtBuffEcrI2C  : pointeur sur les données a ecrire
//    PtBuffLecI2C  : pointeur sur les données lues
//
//void interrupt sspif : spgEmiRecI2C()
void InterruptSpgEmiRecI2C()
{

        if (!StatusI2C.BIT_RECEPTION_I2C)
        {
                //----------------------- mode ecriture -----------------------//
                if (!StatusI2C.BIT_START_EMI)
                {
                        //-- on envoie l'adresse I2C après le start --//
                        StatusI2C.BIT_START_EMI = 1;
                        AdresseI2C.F0 = 0;
                        sspbuf = AdresseI2C;
                }
                else
                {
                        if (!sspstat.P)
                        {
                                //--- emission I2C pas fini --//
                                if (!StatusI2C.BIT_EMI_ADR_INT)
                                {
                                        //-- on envoie l'adresse interne --//
                                        StatusI2C.BIT_EMI_ADR_INT = 1;
                                        sspbuf = WordAdressI2C;
                                }
                                else
                                {
                                        if (NbOctetEcrI2C != 0)
                                        {
                                                //-- on envoie les données --//
                                                NbOctetEcrI2C--;
                                                sspbuf = *PtBuffEcrI2C;
                                                PtBuffEcrI2C++;
                                        }
                                        else
                                        {
                                                //-- emission terminée ,emi bit stop --//
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
                //---------------------- mode lecture ----------------------//
                if (!StatusI2C.BIT_START_EMI)
                {
                        //-- on envoie l'adresse I2C après le start --//
                        StatusI2C.BIT_START_EMI = 1;
                        AdresseI2C.F0 = 1;
                        sspbuf = AdresseI2C;
                }
                else
                {
                        if (!StatusI2C.BIT_REC_FIRST_BYTE)
                        {
                                //-- reception acquittement slave --//
                                //-- on passe en mode reception --//
                                sspcon2.RCEN = 1;
                                StatusI2C.BIT_REC_FIRST_BYTE = 1;
                        }
                        else
                        {
                                //-- reception des données --//
                                if (!StatusI2C.BIT_EMI_ACK)
                                {
                                        //-- reception donnée esclave --//
                                        StatusI2C.BIT_EMI_ACK = 1;
                                        *PtBuffLecI2C = sspbuf;
                                        NbOctetLecI2C--;
                                        PtBuffLecI2C++;
                                        if (NbOctetLecI2C != 0)
                                        {
                                                //-- emission acquittement --//
                                                sspcon2.ACKDT = 0;
                                                sspcon2.ACKEN = 1;
                                        }
                                        else
                                        {
                                                //-- reception terminée : emission NACK --//
                                                sspcon2.ACKDT = 1;
                                                sspcon2.ACKEN = 1;
                                        }
                                }
                                else
                                {
                                        //-- fin d'acquittement maitre --//
                                        if (NbOctetLecI2C == 0)
                                        {
                                                //--  fin acquittement maitre  --//
                                                //-- plus de donnéesà recevoir --//
                                                if (!sspstat.P)
                                                {
                                                        //-- emission stop bit --//
                                            sspcon2.PEN = 1;
                                                }
                                                else
                                                        //-- fin bit de stop --//
                                                        StatusI2C = 0;
                                        }
                                        else
                                        {
                                                //--   fin acquittement maitre  --//
                                                //-- on recommence la reception --//
                                                sspcon2.RCEN = 1;
                                                StatusI2C.BIT_EMI_ACK = 0;
                                        }
                                }
                        }
                }
        }
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                           projet :          //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------- initialisation periphérique  ------------//
//
//      PE : Aucun
//      PS : Aucun
//
//   Variable : toutes les variables globales
//

#define CONF_SSPSTAT 0b10000000
#define CONF_SSPCON  0b00101000                //mode maitre Fi2c = Fosc/(4*(SSPAD+1))
#define CONF_SSPCON2 0b00000000
#define CONF_SSPADD         9                  //Fi2c = 1000 KHz  avec Q = 40 MHz
//#define CONF_SSPADD       24                 //400k
//#define CONF_SSPADD       99                 //Fi2c = 100 KHz  avec Q = 40 MHz      ##### debug #####

void InitPeriphEmiRecI2C()
{

        sspstat = CONF_SSPSTAT;
        sspcon1 = CONF_SSPCON;
        sspcon2 = CONF_SSPCON2;
        sspadd = CONF_SSPADD;
        
        //-- demasquage IT --//   //it interdite pour cette application
        pie1.SSPIE      = 0;      //gestion I2C
  
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                       projet :              //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//--------- initialisation variable globales ------------//
//
//      PE : Aucun
//      PS : Aucun
//
//   Variable : toutes les variables globales
//
void IniTVarGlEmiRecI2C()
{
     StatusI2C = 0;
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                       projet :              //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//-------------- spg d'écriture CAT24M01  ---------------//
//
//      PE : NbOctetEcr : Nb d'octet a ecrire (au moins 2)
//           AdresseInt : adresse haute composant I2C
//           ptBuffEcr  : Pointeur sur les donnée à ecrire
//                        !!!!!! le premier octet contient l'adresse basse de la memeoire !!!!!!
//
//      PS : EcrAdrI2C  : Etat Ecriture adresse I2C  [VRAI, FAUX]
//
//   Variable :
//           WordAdressI2C : adresse interne composant I2C
//           NbOctetEcrI2C : nombre d'octet à écrire
//           AdresseI2C    : adresse composant I2C
//           StatusI2C     : Etat comunication I2
//           NbOctetLecI2C : Nombre d'octet à lire
//           PtBuffEcrI2C  : Buffer d'écriture I2C
//           EcrAdrI2C_OK  : resulatat ecriture adresse I2C
//
void EcrCAT24M01 (char NbOctetEcr, char AdresseInt, char *ptBuffEcr)
{
unsigned short EcrAdrI2C;

      //-- positionnement adresse interne --//
//      EcrAdrI2C_OK = FAUX;
      WordAdressI2C = AdresseInt;                // adresse interne composant I2C
      NbOctetEcrI2C = NbOctetEcr;                // Nombre d'octet a ecrire
      AdresseI2C = ADR_CAT24M01;                 // adresse composant I2C
      PtBuffEcrI2C = ptBuffEcr;                  // pointeur sur les données a ecrire
      StatusI2C = 0;
      StatusI2C.BIT_RECEPTION_I2C = 0;

      sspcon2.SEN = 1;                           // lancement ecriture sous IT

//    //------- attente fin ecriture -----//
      delay_ms(5);

      //-- maj resultat --//
//    EcrAdrI2C = EcrAdrI2C_OK;
//    return EcrAdrI2C;
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                          projet :           //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//-------------- spg de lecture CAT24M01 ----------------//
//
//      PE : NbOctetLec  : Nb d'octet a lire
//           AdresseInt : adresse interne composant I2C
//           ptBuffLec  : Pointeur sur les donnée à lire
//
//      PS : Aucun
//
//   Variable :
//           WordAdressI2C : adresse interne composant I2C
//           NbOctetEcrI2C : nombre d'octet à écrire
//           AdresseI2C    : adresse composant I2C
//           StatusI2C     : Etat comunication I2
//           NbOctetLecI2C : Nombre d'octet à lire
//           PtBuffLecI2C  : Buffer de lecture I2C
//
void LecCAT24M01(char NbOctetLec, unsigned int AdresseInt, char *ptBuffLec)
{
static unsigned short AdrLo;

        //-- positionnement adresse interne --//
        WordAdressI2C = hi(AdresseInt);                // adresse interne composant I2C
        AdrLo = lo(AdresseInt);
        NbOctetEcrI2C = 1;                             // Nombre d'octet a ecrire
        AdresseI2C = ADR_CAT24M01;                     // adresse composant I2C
        PtBuffEcrI2C = &AdrLo;                         // pointeur sur les données a ecrire
        StatusI2C = 0;
        StatusI2C.BIT_RECEPTION_I2C = 0;
        sspcon2.SEN = 1;                               // lancement ecriture sous IT

        //------- attente fin ecriture adresse int -----//
        delay_us(60);

        //------ lecture I2C ---------//
        NbOctetLecI2C = NbOctetLec;
        AdresseI2C = ADR_CAT24M01;;
        PtBuffLecI2C = ptBuffLec;                      // tableau dans lequel stocké la donnée
        StatusI2C = 0;
        StatusI2C.BIT_RECEPTION_I2C = 1;

        sspcon2.SEN = 1;                               // lancement lecture sous IT

//      //------- attente fin lecture -----//
//      delay_ms(5);
}

#define ATTENTE_POLLING 15        // ne pas descendre en dessous (10 pose problème)
//#define ATTENTE_POLLING 120      //###### debug #######


//############################### BRUN #######################################//

//-------------------------------------------------------//
//                                                       //
// Sociéte :                           projet :          //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//---------- spg d'ecriture I2C (en polling) ------------//
//
//      PE : AdresseInt : adresse interne composant I2C (16 bits)
//           PageHaute  : page superieur [VRAI, FAUX]
//           ptBuffEcr  : pointeur sur les données a ecrire
//           NbData     : nombre de donnée à écrire
//      PS : EcrOK      EcrAdr: resultat positionnement [VRAI, FAUX]
//
//   Attention il faut positionner la page pour l'adresse du composant I2C en fonction
//   de la variable d'entrée "PageHaute"
//   on effecture le positionnement de l'adresse interne de la mémoire EEP, puis on effectue
//   l'ecriture des "NbData" octets à partir du buffer d'ecriture "ptBuffEcr"
//   (voir documentation technique de la mémoire 24FC1024 : chronogramme d'ecriture)
//   on attend la durée ATTENTE_POLLING (15µs) apres chaque instruction liée a l'I2C
//   En cas de non acquittement, on retourne EcrOK a faux
//
//   Variable globale :
//       sspcon2.SEN : permet le positionnement de la condition de debut d'echange
//       sspcon2.PEN : permet le positionnement de la condition de fin d'echange
//       sspbuf      : permet d'emettre des valeurs (8 bits) sur l'I2C
//       sspcon2.ACKSTAT : valeur de l'acquittement
//
//   Fonction utilisée : Delay_us(), hi(), lo()
//
unsigned short EcrI2CPoll(unsigned int AdresseInt, unsigned short PageHaute, 
                          unsigned short *ptBuffEcr, unsigned int NbData)
{
unsigned short Res = VRAI;
unsigned int i;
unsigned short AdrCAT = ADR_CAT24M01;















    return Res;
}

//############################################################################//

//############################### BRUN #######################################//

//-------------------------------------------------------//
//                                                       //
// Sociéte :                         projet :            //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//---- spg de positionnement de l'adresse interne -------//
//
//      PE : AdresseInt : adresse interne composant I2C (16 bits)
//           PageHaute  : page superieur [VRAI, FAUX]
//      PS : EcrOK      EcrAdr: resultat positionnement [VRAI, FAUX]
//
//   Attention il faut positionner la page pour l'adresse du composant I2C en fonction
//   de la variable d'entrée "PageHaute"
//   on effecture le positionnement de l'adresse interne de la mémoire EEP
//   (voir documentation technique de la mémoire 24FC1024 : chronogramme d'ecriture)
//   on attend la durée ATTENTE_POLLING (15µs) apres chaque instruction liée a l'I2C
//   En cas de non acquittement, on retourne EcrOK a faux
//
//   Variable globale :
//       sspcon2.SEN : permet le positionnement de la condition de debut d'echange
//       sspcon2.PEN : permet le positionnement de la condition de fin d'echange
//       sspbuf      : permet d'emettre des valeurs (8 bits) sur l'I2C
//       sspcon2.ACKSTAT : valeur de l'acquittement
//
//   Fonction utilisée : Delay_us(), hi(), lo()
//
unsigned short EcrAdrIntPoll(unsigned int AdresseInt, unsigned short PageHaute)
{
unsigned short Res = VRAI;
unsigned short AdrCAT = ADR_CAT24M01;













     
    return Res;
}

//############################################################################//

//############################### BRUN #######################################//

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//---- spg de positionnement de l'adresse interne -------//
//
//      PE : NbByte2Read : Nb d'octet a lire [1 à 256]
//           ptBuffread  : pointeur sur le buffer ou stocker les données lues
//      PS : N/A
//
//   L'adresse interne de lecture et la page a été positionnée précédement
//   (fonctione EcrAdrIntPoll())
//   on effecture la lecture de "NbByte2Read" depuis la mémoire vers le buffer de
//   lecture ptBuffRead (voir documentation technique de la mémoire 24FC1024 : 
//   chronogramme de lecture)
//   on attend la durée ATTENTE_POLLING (15µs) apres chaque instruction liée a l'I2C
//
//   Variable globale :
//       sspcon2.SEN : permet le positionnement de la condition de debut d'echange
//       sspcon2.PEN : permet le positionnement de la condition de fin d'echange
//       sspcon2.RCEN  : passage en mode reception (doit etre mis a 1 avant chaque lecture
//                       d'un octet sur le bus)
//       sspbuf        : permet d'emettre ou de lire des valeurs (8 bits) sur l'I2C
//       sspcon2.ACKDT : valeur de l'acquittement a émettre (0 : ACK , 1 : NACK)
//       sspcon2.ACKEN : permet l'emission de l'acquittement (a faire apres chaque lecture
//                       d'un octet sur le bus)
//
//   Fonction utilisée : Delay_us()
//
void LecI2CPoll(unsigned int NbByte2Read, unsigned short *ptBufferRead)
{


















    
}
//############################################################################//