
//--------------------- definition type application --------------------------//

#define V_AUCUN  0
#define V_GAUCHE_O 1     //Volet ouvrant
#define V_DROITE_O 2
#define V_CENTRE_O 3
#define V_GAUCHE_F 4     //Volet fermant
#define V_DROITE_F 5
#define V_CENTRE_F 6
typedef struct strAppImg
{
   unsigned short MajImg;        //[VRAI, FAUX]
   unsigned short PageHaut;      //[VRAI, FAUX]
   unsigned short NumImage;      //0..32
   unsigned short TypeVolet;     //[V_GAUCHE_O, V_DROITE_O, V_CENTRE_O, V_GAUCHE_F, V_DROITE_F, V_CENTRE_F]
   unsigned short TempoVolet;    //en n*1ms ???
   unsigned short ValPWM;        //[0 (maxi) .. FF (mini)]
   unsigned short TempoCli;
   unsigned short Tempo2Img;
} t_AppImg;

extern t_AppImg AppelImg;

//-------------------------- configuration port A ----------------------------//


//#define BIT_LED_BI_H F3
//#define BIT_LED_BI_L F5

#define BIT_LG_A      F0             // High disables the antenna signal
#define BIT_LG_B      F1             // High does 100% modulation
#define BIT_LG_C      F2
#define BIT_LG_D      F3


#define CONF_ADCON1  0b00000110                //entrée logique sur port A

#define CONF_PORT_A  0b11110000

//-------------------------- configuration port B ----------------------------//

#define BIT_WDOG       F0

#define BIT_CAN_TX     F2
#define BIT_CAN_RX     F3
#define BIT_PAGE_MEM   F4
#define BIT_DEBUG_1    F5
#define BIT_RAZ_CPT    F6

#define CONF_PORT_B  0b10001000


//---------------------------- configuration port C --------------------------//

#define BIT_LATCH_MTRX F0
#define BIT_CLK_MEM    F1
#define BIT_OE_MTRX    F2
#define BIT_SCL        F3
#define BIT_SDA        F4
#define BIT_RW_MEM     F5
#define BIT_OE_MEM     F6
#define BIT_CLK_MTRX   F7


#define CONF_PORT_C   0b00011000

//---------------------------- configuration port D --------------------------//

#define BIT_R1       F0
#define BIT_G1       F1
#define BIT_B1       F2
#define BIT_R2       F3
#define BIT_G2       F4
#define BIT_B2       F5

#define CONF_CMCON    0b00000111
#define CONF_PORT_D_OUT   0b11000000
#define CONF_PORT_D_IN    0b11111111

//----------------------------------------------------------------------------//

//-------------------------- constante commune -------------------------------//

//------------------------- constante EEPROM ---------------------------------//

#define EEP_NUM_IMAG_PROC_L 0
#define EEP_NUM_IMAG_PROC_H 8
#define EEP_NUM_DURE_PROC_L 16
#define EEP_NUM_DURE_PROC_H 24
#define LG_EEP_CONFIG 8

#define OFF_CHK_IMG 32
#define LG_ZONE_CHK_IMG 32