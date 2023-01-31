//
// Objet du programme : Gestion bandeau arcade (matrice de led)
//
// V1.1 par E.BURTZ le 07/01/20 : version initiale
// V1.2 par E.BURTZ le 09/01/20 : ajout teche d'it rapide pour la gestion de la matrice
// V1.3 par E.BURTZ le 18/01/20 : ajout reception bus CAN  (programmation image eep)
// V1.4 par E.BURTZ le 22/01/20 : ajout reception bus CAN  (commande de debug)
// V1.5 par E.BURTZ le 25/01/20 : ajout gestion des volets
// V1.6 par E.BURTZ le 26/01/20 : - volet au demarrage + gestion clignottement
//                                - deplacement tableau matrice 256 octets (bug ecrasement variable)
//                                - ajout commande appel cyclique page 1 et 2 + MST
// V1.7 par E.BURTZ le 26/01/20 : passage code en procédure
// V1.8 par E.BURTZ le 18/02/20 : - ajout affichage aleatoire à l'init
//                                - ajout reception CAN jeu en cours
// V1.9 par E.BURTZ le 23/02/20 : Attribution numero process raspberry avec image
// V2.0 par E.BURTZ ............
// V2.1 par E.BURTZ le 12/03/20 : Ajout commande CAN de mise a jour config eeprom PIC
// V2.2 par E.BURTZ le 24/03/20 : Modifcation pour traitement process = 255 (jeux par defaut)
// V2.3 par E.BURTZ le 26/03/20 : tentative correction bug aleatoire (config quartz)
//                                et correction memoristaion ModeEnCours

#include "commun.h"
#include "GesMatrix.h"
#include "built_in.h"


#include "Tache_emi_rec_I2C.h"
#include "Tache_ges_time_out.h"
#include "Tache_com_CAN.h"
#include "Tache_IT_Mtrx.h"

//--------------------- definition type application --------------------------//

/*#define V_AUCUN  0
#define V_GAUCHE 1
#define V_DROITE 2
#define V_CENTRE 3
typedef struct strAppImg
{
   unsigned short MajImg;        //[VRAI, FAUX]
   unsigned short PageHaut;      //[VRAI, FAUX]
   unsigned short NumImage;      //0..32
   unsigned short TypeVolet;     //[V_AUCUN, V_GAUCHE, V_DROITE, V_CENTRE]
   unsigned short TempoVolet;    //en n*10ms ???
   unsigned short ValPWM;        //[0 (maxi) .. FF (mini)]
} t_AppImg; */

typedef struct strCliImg
{
   unsigned short CliEnCours;        //[VRAI, FAUX]
   unsigned short AffCli;            //[VRAI, FAUX]
   unsigned short TempoCli;
} t_CliImg;

//------------- déclaration des entet de procédure ---------------------------//

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

//--------------------  Variables globales visibles --------------------------//

t_AppImg AppelImg;



//------------------------- constante EEPROM ---------------------------------//


//#define EEP_NUM_IMAG_PROC_L 0
//#define EEP_NUM_IMAG_PROC_H 8
//#define EEP_NUM_DURE_PROC_L 16
//#define EEP_NUM_DURE_PROC_H 24
//#define LG_EEP_CONFIG 8

//#define OFF_CHK_IMG 32
//#define LG_ZONE_CHK_IMG 32

//----------------------- définition des constantes --------------------------//

#define TEMPO_WDOG      1 //25         //Temporisation
#define TEMPO_WDOG_ERR  25             //Temporisation en cas d'erreur (debug)
#define TEMPO_SCRUT     10        // scrutation tache de fond en n*1ms    quartz 40mhz
#define TEMPO_ACCES     10        //duree mini affichage message utilisateur
#define T_0_5S          19
#define T_0_2S          8
#define T_0_1S          4
#define T_3S            114

#define INIT_CCP_CON  0b00011100    //mode PWM classique
#define EFF_IMG_H     0xFF          //arret PWM
#define EFF_IMG_L     0b00111100    //arret PWM

#define STOP_PWM      0b00000000

//--------------------------- Constante projet -------------------------------//

#define TAILLE_IMAGE 4096

#define VIT_OUV_VOLET_DEF 25       //vitesse ouverture volet en ms

//--------------------- définition des constantes romées  --------------------//






//
//----------------------------- définition des variables ---------------------//
//

unsigned short gTempoWDOG =TEMPO_WDOG;

unsigned short ImgJeux[2*LG_EEP_CONFIG]      = {8,6,12,6,6,2,6,10,4,0,0,0,0,0,0,0};       //liste image a afficher
unsigned short ImgTempoJeux[2*LG_EEP_CONFIG] = {5,30,10,30,30,8,30,15,10,0,0,0,0,0,0,0};  //durée entre 2 images


//
//------------------------ programme principal -------------------------------//
//

void main()
{
unsigned int i, k;
unsigned Cpt = 0;
unsigned short Res, j;
unsigned short TempoImg = 0;
unsigned short ModeEnCoursPrec = RETROPI;
unsigned short ModeEnCoursLoc = RETROPI;



//-------------------- Init périphérique -----------------//

  InitPeriphFond();
  InitPeriphEmiRecI2C();
  delay_ms(500);               //attente reset matrix
  InitPeriphComCAN();
  InitPeriphITMatrix();
  InitPeriphGesTimeOut();

//---------------- Init variable globale -----------------//

  IniTVarGlEmiRecI2C();
  IniTVarGlGesTimeOut();
  IniTVarGlComCAN();
  InitVarGlobal();

//----------------- debug init eeprom --------------------//

  LecConfigEEP();


//---------------- Initialisation premiere image ---------//

  /*ImageEEp2RAM(FAUX,0);  //init image defender
  ImageEEp2RAM(VRAI,1);
  AppelImg.Tempo2Img = 10;
  //-- init volet central
  AppelImg.TypeVolet  = V_CENTRE_O;
  AppelImg.TempoVolet = VIT_OUV_VOLET_DEF;
  pie1.TMR1IE = 1;      //It gestion volet   */

  
//---------- autorisation des interruptions --------------//

  intcon.PEIE = 1;
  intcon.GIE  = 1;           //autorisation globale des IT


  for(;;)
  {
       //
       //---------------------------- changement image ----------------------//
       //
       if (AppelImg.MajImg == VRAI)
       {
            AppImageFond(AppelImg.PageHaut, AppelImg.NumImage);
            AppelImg.MajImg = FAUX;
       }
       
       //
       //-------------------- gestion clignottement --------------------------//
       //
       GesCliBandeau (&AppelImg);

       //
       //------------------ gestion bandeau d'init ----------------------------//
       //
       ModeEnCoursLoc = ModeEnCours;
       if (ModeEnCoursLoc == RETROPI)
       {
            ModeEnCoursPrec = ModeEnCoursLoc;
            GesBandeauInit(&TempoImg, &AppelImg);
       }
       else if ((ModeEnCoursLoc != ModeEnCoursPrec) && (!pie1.TMR1IE))
       {
            //-- on affiche le nom du jeu uniquement
            //-- si un volet est complétement fermé ou ouvert
            ModeEnCoursPrec = ModeEnCoursLoc;
            GesBandeauJeu(&TempoImg, ModeEnCoursLoc, &AppelImg);
       }

       //
       //--------------- gestion affichage double vue ------------------------//
       //
       if (AppelImg.Tempo2Img != 0)
       {
           TempoImg++;
           if (TempoImg == AppelImg.Tempo2Img)
           {
               TempoImg = 0;
               portb.BIT_PAGE_MEM = !portb.BIT_PAGE_MEM;
           }
       }
       else
           TempoImg = 0;
       //
       //----------------------- gestion chien de garde ---------------------//
       //
       gTempoWDOG--;
       if (gTempoWDOG == 0)
       {
          if (RecOK == REC_OK)
             gTempoWDOG = TEMPO_WDOG;
          else
             gTempoWDOG = TEMPO_WDOG_ERR;
          gTempoWDOG = TEMPO_WDOG;
          portb.BIT_WDOG = !portb.BIT_WDOG;
       }
       Delay_ms(TEMPO_SCRUT);
    }
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ Appelle d'une nouvelle image -------------//
//
// Affichage de différentes image lors de la mise sous tension
// avec bandeau aleatoire.
//
//      PE : PageImg : Page haut [VRAI, FAUX]
//           NumImg  : numero image [0..31]
//      PS : N/A
//
#define NUM_MAX_IMG 32

void AppImageFond(unsigned short PageImg, unsigned short NumImg)
{
unsigned short SaveVD;
unsigned short SaveVG;

       if (NumImg < NUM_MAX_IMG)
       {
            //-- extinction image en cours
            //ccpr1l  = EFF_IMG_H;
            //ccp1con = EFF_IMG_L;
            ccp1con = STOP_PWM;
            portc.BIT_OE_MTRX = 1;
            //-- arret IT tache visu matrix --//
            pie2.TMR3IE = 0;
            //intcon.GIE = 0;
            SaveVD = VoletDroit;     //volet droit et gauche sont ecrasé lors du
            SaveVG = VoletGauche;    //chargement d'une image !!!!!!!!!!!
            //-- lecture eep et ecriture RAM --//
            ImageEEp2RAM(PageImg, NumImg);
            delay_us(20);
            //-- redemarrage IT tache visu matrix --//
            VoletDroit = SaveVD;
            VoletGauche = SaveVG;
            pie2.TMR3IE = 1;
            //intcon.GIE = 1;
            //-- commutation luminosité initiale --//
            ccp1con = INIT_CCP_CON;
            ccpr1l = AppelImg.ValPWM;
       }
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ Gestion du bandeau a l'init  -------------//
//
// Affichage de différentes image lors de la mise sous tension
// avec bandeau aleatoire.
//
//      PE : ptTempoImg : tempo basculement 2 images
//           ptAppelImg : pointeur sur la structure de gestion des images
//      PS :
//
#define NUM_LIST_IMG 8
const unsigned short ImgInit[NUM_LIST_IMG] = {6,12,6,2,6,4,6,8};  //liste image a afficher
const unsigned short ImgTempo[NUM_LIST_IMG] = {25,10,25,8,25,10,25,5};

#define VOLET_MINI_O 1
#define VOLET_MAXI_O 3
#define VOLET_MINI_F 4
#define VOLET_MAXI_F 6

void GesBandeauInit (unsigned short *ptTempoImg, t_AppImg *ptAppelImg)
{
static unsigned short NumImage_ = 0;
static unsigned short VoletOuvrant = VRAI;
#define TEMPO_AFF_IMG 200
static unsigned short TempoAffImg = 0;

unsigned short TypeVoletA;


    if (VoletOuvrant == VRAI)
    {  
       if (!pie1.TMR1IE)
       {
          //-- le volet precedant est fermé --//
          //-- appelle image  --//
          //ImageEEp2RAM(FAUX,ImgInit[NumImage]);  //init image defender
          AppImageFond(FAUX,ImgInit[NumImage_]);
          delay_us(20);
          //ImageEEp2RAM(VRAI,ImgInit[NumImage]+1);
          AppImageFond(VRAI,ImgInit[NumImage_]+1);
          delay_us(20);
          ptAppelImg->Tempo2Img = ImgTempo[NumImage_];
          *ptTempoImg = 0;
          //-- init volet central --//
          TypeVoletA = GeneNbAlea(VOLET_MINI_O, VOLET_MAXI_O);
          ptAppelImg->TypeVolet  = TypeVoletA;
          ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
          pie1.TMR1IE = 1;      //It gestion volet
          //-- image suivante --//
          VoletOuvrant = FAUX;
          NumImage_++;
          if (NumImage_ == NUM_LIST_IMG)
             NumImage_ = 0;
       }
    }
    else
    {
        TempoAffImg++;
        if (TempoAffImg == TEMPO_AFF_IMG)
        {
           TempoAffImg = 0;
           //-- Fin d'affichage --//
           TypeVoletA = GeneNbAlea(VOLET_MINI_F, VOLET_MAXI_F);
           ptAppelImg->TypeVolet  = TypeVoletA;
           ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
           pie1.TMR1IE = 1;      //It gestion volet
           VoletOuvrant = VRAI;
        }
    }
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//---------- Gestion du bandeau pour un jeu -------------//
//
// Affichage de l'image concernant le jeux en cour
//
//      PE : ptTempoImg : tempo basculement 2 images
//           JeuEnCours : jeu en cours [1..5]
//           ptAppelImg : pointeur sur la structure de gestion des images
//      PS : N/A
//
//      liste process raspberry: (si pas d'image, on visualise retropie)
//            1 : asteroïd
//            2 : centiped
//            3 : Defender
//            4 : Donkey kong
//            5 : Galaxian
//            6 : Pac-man
//            7 : Space invader
//            8 : Tempest
//            9 : xevious
//

#define NUM_LIST_JEUX 15
//const unsigned short ImgJeux[NUM_LIST_JEUX] = {8,6,12,6,6,2,6,10,4};  //liste image a afficher
//const unsigned short ImgTempoJeux[NUM_LIST_JEUX] = {5,30,10,30,30,8,30,15,10};
#define NUM_JEU_DEFAUT 14

void GesBandeauJeu (unsigned short *ptTempoImg, unsigned short JeuEnCours_, t_AppImg *ptAppelImg)
{
unsigned short TypeVoletA;

    JeuEnCours_--;
    if (JeuEnCours_ > NUM_LIST_JEUX)
       JeuEnCours_ = NUM_JEU_DEFAUT;
    //-- le volet precedant est fermé --//
    //-- appelle image  --//
    AppImageFond(FAUX,ImgJeux[JeuEnCours_]);
    AppImageFond(VRAI,ImgJeux[JeuEnCours_]+1);
    ptAppelImg->Tempo2Img = ImgTempoJeux[JeuEnCours_];
    *ptTempoImg = 0;
    //-- init volet central --//
    TypeVoletA = GeneNbAlea(VOLET_MINI_O, VOLET_MAXI_O);
    ptAppelImg->TypeVolet  = TypeVoletA;
    ptAppelImg->TempoVolet = VIT_OUV_VOLET_DEF;
    pie1.TMR1IE = 1;      //It gestion volet
}


//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ generation nombre aleatoire  -------------//
//
//      PE : NbMini : nombre minimum
//           NbMaxi : nombre maximum
//      PS : NbAlea : nombre aleatoire compris entre mini et maximum inclus
//
unsigned short GeneNbAlea(unsigned short NbMini, unsigned short NbMaxi)
{
unsigned short NbAlea;
unsigned int Temp;

   Temp = rand();
   NbAlea = lo(Temp) + hi(Temp);
   NbAlea = NbAlea % (NbMaxi - NbMini + 1);
   NbAlea = NbAlea + NbMini;
   
   return NbAlea;

}


//
//-----------------------------------------------------//
//                                                     //
// Sociéte :                            projet :       //
//                                                     //
// Modifié par (Date, Libellé):                        //
//                                                     //
//---------- gestion clignottement bandeau -----------//
//
//  PE : ptAppelImg : pointeur sur la structure de gestion des images
//
//  Variable globale: N/A
//
//
void GesCliBandeau (t_AppImg *ptAppelImg)
{
static t_CliImg CliImg = {FAUX, FAUX, 0};

       if (ptAppelImg->TempoCli == 0)
       {
          if (CliImg.CliEnCours == VRAI)
          {
             //-- pas de clignottement --//
             //-- commutation luminosité initiale --//
             ccp1con = INIT_CCP_CON;
             ccpr1l = ptAppelImg->ValPWM;
             CliImg.CliEnCours = FAUX;
             CliImg.TempoCli = 0;
          }
       }
       else
       {
           CliImg.CliEnCours = VRAI;
           CliImg.TempoCli++;
           if (CliImg.TempoCli == ptAppelImg->TempoCli)
           {
                CliImg.TempoCli = 0;
                if (CliImg.AffCli == FAUX)
                {
                     //-- extinction image en cours
                     //ccpr1l  = EFF_IMG_H;
                     //ccp1con = EFF_IMG_L;
                     ccp1con = STOP_PWM;
                     portc.BIT_OE_MTRX = 1;
                     CliImg.AffCli = VRAI;
                }
                else
                {
                     //-- commutation luminosité initiale --//
                     ccp1con = INIT_CCP_CON;
                     ccpr1l = AppelImg.ValPWM;
                     CliImg.AffCli = FAUX;
                }
           }
       }
}

//
//-----------------------------------------------------//
//                                                     //
// Sociéte :                            projet :       //
//                                                     //
// Modifié par (Date, Libellé):                        //
//                                                     //
//---- initialisation ecriture image en memoire -------//
//
//  PE : PageMemHaute : Page memoire haute [VRAI, FAUX]
//
//  Variable globale: N/A
//
//
void InitEcrMem(unsigned short PageMemHaute)
{
  //-- init compteur (RAZ) --//
  portc.BIT_CLK_MEM = 1;
  portb.BIT_RAZ_CPT = 1;
  delay_us(10);
  portb.BIT_RAZ_CPT = 0;
  
  //-- init memoire pour ecriture --//
  portc.BIT_OE_MEM = 0;
  if (PageMemHaute == VRAI)
     portb.BIT_PAGE_MEM = 1;
  else
     portb.BIT_PAGE_MEM = 0;
  portc.BIT_RW_MEM = 0;
  trisd = CONF_PORT_D_OUT;
}

//-----------------------------------------------------//
//                                                     //
// Sociéte :                            projet :       //
//                                                     //
// Modifié par (Date, Libellé):                        //
//                                                     //
//---- initialisation lecture image en memoire --------//
//
//  PE : PageMemHaute : Page memoire haute [VRAI, FAUX]
//
//  Variable globale: N/A
//
//
void InitLecMem(unsigned short PageMemHaute)
{
  //-- init memoire pour lecture --//
  trisd = CONF_PORT_D_IN;
  portc.BIT_RW_MEM = 1;
  portc.BIT_OE_MEM = 0;
  if (PageMemHaute == VRAI)
     portb.BIT_PAGE_MEM = 1;
  else
     portb.BIT_PAGE_MEM = 0;
     
  //-- init compteur (RAZ) --//
  portc.BIT_CLK_MEM = 1;
  portb.BIT_RAZ_CPT = 1;
  delay_us(10);
  portb.BIT_RAZ_CPT = 0;

}

//-----------------------------------------------------//
//                                                     //
// Sociéte :                            projet :       //
//                                                     //
// Modifié par (Date, Libellé):                        //
//                                                     //
//--------- transfert image eep en memoire RAM --------//
//
//  PE : PageRAMHaute : Page memoire haute [VRAI, FAUX]
//       NumImage     : numero d'image eeprom [0 .. 31]
//
//  Variable globale:
//       NumLigne   : numero de ligne (Tache_IT_Mtrx)
//       NumColonne : numero de colonne (Tache_IT_Mtrx)
//
void ImageEEp2RAM(unsigned short PageRAMHaute, unsigned short NumImgEEp)
{
unsigned int AdrIntEEp = 0;
unsigned short PageEEpHaute;

unsigned int i, k;
unsigned Cpt = 0;
unsigned short Res, j;

  //-- Raz numero de ligne et de colonne --//
  NumColonne = 0xff;
  NumLigne   = 0;

  //-- calcul adresse interne EEP --//
  if (NumImgEEp >= IMG_PAGE_BAS)
  {
    PageEEpHaute = VRAI;
    NumImgEEP = NumImgEEP - IMG_PAGE_BAS;
  }
  else
    PageEEpHaute = FAUX;
  Hi(AdrIntEEp) = (NumImgEEp << 4);

  //-- initialisation position lecture EEP --//
  Res = EcrAdrIntPoll(AdrintEEp, PageEEpHaute);
  //-- init memoire page basse ou haute --//
  InitEcrMem(PageRAMHaute);
  Cpt = 0;
  for (j=0 ; j != NB_PART_IMG ; j++)
  {
      //-- lecture 256 octet memoire eep --//
      LecI2CPoll(LG_TAB_MATRIX, TabMatrix);
      //-- ecriture 256 octets dans memoire --//
      for (k=0 ; k != LG_TAB_MATRIX ; k++)
      {
         latd = TabMatrix[k];
         portc.BIT_RW_MEM = 1;    //ack donnée
         portc.BIT_CLK_MEM = 0;   //adresse suivante
         delay_us(1);
         portc.BIT_CLK_MEM = 1;
         delay_us(1);

         Cpt++;
         if (Cpt != TAILLE_IMAGE-1)
            portc.BIT_RW_MEM = 0;
         delay_us(1);
      }
  }
  //-- init memoire pour lecture --//
  InitLecMem(PageRAMHaute);
  
}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                      projet :               //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------------ verification chk  ------------------//
//
// Calcul le checksum sur 8 bit jusqu'a la donnée n-2 est
// verifie avec la valeur n-1 (cheksum) et n (cheksum barre).
//
//      PE : - ptMsg    : pointeur sur le message à analyser
//           - NbOctet  : nbd'octet du message
//      PS : ResVerif   : resultat verification [VRAI, FAUX]
//
//
unsigned short VerifChkChkb (char *ptData, unsigned short NbOctet)
{
unsigned short i;
unsigned short Somme;
unsigned short ResVerif;

  ResVerif = FAUX;
  Somme = 0;
  for (i=0 ; i!= NbOctet-2 ; i++)
  {
     Somme = Somme + *(ptData + i);
  }
  if (Somme == *(ptData + NbOctet - 2))
  {
     Somme = ~Somme;
     if (Somme == *(ptData + NbOctet -1))
          ResVerif = VRAI;
  }

  return ResVerif;
}

//
//-----------------------------------------------------//
//                                                     //
// Sociéte :                            projet :       //
//                                                     //
// Modifié par (Date, Libellé):                        //
//                                                     //
//------------ spg de calcul d'un checksum ------------//
//
// Cette procédure permet le calcul du checksum d'un tableau
// Elle inscrit cette valeur sur la dernierer donnée.
//
//  PE : ptTab    : pointeur sur un tableau
//       NbOctTab : nombre d'octet du tableau
//
//  Variable globale: N/A
//
//
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

//-------------------------------------------------------//
//                                                       //
// Sociéte :                            projet :         //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//----------- initialisation image process --------------//
//           à partir des données EEPROM
//
//      PE : Aucun
//      PS : Aucun
//
//   Variable : ImgJeux, ImgTempoJeux
//
void LecConfigEEP()
{
unsigned short i;

    for(i=0 ; i!= LG_EEP_CONFIG ; i++)
        ImgJeux[i] = EEPROM_Read(EEP_NUM_IMAG_PROC_L+i);
    for(i=0 ; i!= LG_EEP_CONFIG ; i++)
        ImgJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_IMAG_PROC_H+i);
    for(i=0 ; i!= LG_EEP_CONFIG ; i++)
        ImgTempoJeux[i] = EEPROM_Read(EEP_NUM_DURE_PROC_L+i);
    for(i=0 ; i!= LG_EEP_CONFIG ; i++)
        ImgTempoJeux[i+LG_EEP_CONFIG] = EEPROM_Read(EEP_NUM_DURE_PROC_H+i);

}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                            projet :         //
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
void InitVarGlobal()
{
   AppelImg.MajImg = FAUX;
   AppelImg.ValPWM = 0;     //luminosité maxi
   AppelImg.TempoCli = 0;
   AppelImg.Tempo2Img = 0;


//  gTempoWDOG = TEMPO_WDOG;

}

//-------------------------------------------------------//
//                                                       //
// Sociéte :                           projet :          //
//                                                       //
// Modifié par (Date, Libellé):                          //
//                                                       //
//------------ initialisation périphérique --------------//
//
//      PE : Aucun
//      PS : Aucun
//
//   Variable : N/A
//
#define MAX_PERIODE   0xFF          //T = 408 µs
#define INIT_T2_CON   0b00000110    //prediv par 16, timer ON (tcyc = 1.6 µs avec quartz 40 Mhz)


void InitPeriphFond()
{

//------------- initialisation port ---------------------//


  trisa  = CONF_PORT_A;
  adcon1 = CONF_ADCON1;

  trisb = CONF_PORT_B;
  trisc = CONF_PORT_C;
  cmcon = CONF_CMCON;
  trisd = CONF_PORT_D_IN;
        
  //latd.BIT_RESET = 1;
  //trisd.BIT_RESET = 0;
  lata = 0;
  latc = 0;
  latb = 0;
  latd = 0;

  latb.BIT_WDOG = 1;
  
//---------------- init eeprom --------------------------//

  eecon1.EEPGD = 0;
  eecon1.CFGS = 0;
  
  //-- init memoire --//
  portc.BIT_RW_MEM = 1;
  portc.BIT_OE_MEM = 0;
  portb.BIT_PAGE_MEM = 0;
  
  //-- init compteur --//
  portc.BIT_CLK_MEM = 1;
  portb.BIT_RAZ_CPT = 1;
  delay_us(10);
  portb.BIT_RAZ_CPT = 0;
  
  //-- init bit de gestion matrice --//
  porta = 0;    //selection ligne 0
  portc.BIT_LATCH_MTRX = 0;
  portc.BIT_CLK_MTRX = 0;
  
  //------------- initialisation module PWM ---------------//
  
  pr2 = MAX_PERIODE;
  t2con = INIT_T2_CON;
  ccp1con = INIT_CCP_CON;
  ccpr1l = 0x00;
  
  //----------- validation priorité haute -----------------//
  rcon.IPEN = 1;

}