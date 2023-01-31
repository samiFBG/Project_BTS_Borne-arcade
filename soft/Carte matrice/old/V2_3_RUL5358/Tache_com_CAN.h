


void InterruptSpgComCAN();
void InitPeriphComCAN();
void IniTVarGlComCAN();
//void InitComCAN();

extern unsigned short Config_can1;

#define REC_OK  0
#define BIT_ERR_EEP F0
#define BIT_ERR_CHK F1
#define BIT_ERR_HDF F2
extern unsigned short RecOK;

#define NB_PART_IMG  16              //-- 1 image = 4096 Octets (16 pages de 256 octets)
#define IMG_PAGE_BAS 16             //limite num image pour stockage dans Page basse eep

#define LG_TAB_MATRIX 256
extern unsigned short TabMatrix[LG_TAB_MATRIX];

#define RETROPI  0
#define MODE_JEU 1
extern unsigned short ModeEnCours;

//---------------------- identificateur trame CAN ----------------------------//
#define MASK_ACCEPT_B1  0xFFFFFFFC       //id de 0x40 à 0x43
#define MASK_ACCEPT_B2  0xFFFFFFFC       //id de 0x50 à 0x53


#define ID_REC_IMG_BMP 0x42     //identificateur trame reception image bitmap
#define LG_REC_IMG_BMP 8

#define ID_REC_IMG_CMD 0x41
#define LG_REC_IMG_CMD 2

#define ID_MSG_REC_ST_PAY 0x40  //identificateur emission status paiement
#define LG_MSG_REC_ST_PAY 4     // seul l'octet 1 est utile (jeu en cours)


#define CMD_IMG 0    //Octet 0 : commandes possibles
#define MAJ_LUMINOSITE 0
#define APP_IMG_SIMPLE 1
#define APP_IMG_VOLET  2
#define AFF_PAGE_BASSE 3
#define AFF_PAGE_HAUTE 4
#define MAJ_CLIGNOTTE  5
#define APP_2_IMAGE    6

#define LUM_VAL_PWM   1     //Octet 1 : Luminosité: valeur PWM [0..255]  =[lum maxi .. lum mini]
#define IMG_NUM_IMG   1     //Octet 1 : Numero d'Image:  b7 : page, b4..B0 : numero [0..31]
#define IMG_VOLET_TYP 1     //Octet 1 : Type volet :
                            // [V_GAUCHE_O, V_DROITE_O, V_CENTRE_O
                            //      V_GAUCHE_F, V_DROITE_F, V_CENTRE_F] [1..6]
                            //
#define IMG_VOLET_PER 2     //Octet 2 : Vitesse volet [1..255] en n+1 * 1ms
#define CLI_VITESSE   1     //Octet 1 : vitesse de clignottement en n*35ms (si 0 arret clignottement)
#define APP_VITESSE   1     //Octet 1 : vitesse de chgt d'image en n*35ms (si 0 arret clignottement)

#define BIT_PAGE_IMG F7
#define MASQ_NUM_IMG 0b00011111

#define ID_MSG_CONFIG_EEP 0x50
#define LG_MSG_REC_CONFIG_EEP 8
#define OFF_NUM_IMAG_PROC_L 0
#define OFF_NUM_IMAG_PROC_H 1
#define OFF_NUM_DURE_PROC_L 2
#define OFF_NUM_DURE_PROC_H 3