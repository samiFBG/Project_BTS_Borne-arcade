

//------------------------- constante EEPROM ---------------------------------//

#define EEP_NUM_IMAG_PROC_L 0
#define EEP_NUM_IMAG_PROC_H 8
#define EEP_NUM_DURE_PROC_L 16
#define EEP_NUM_DURE_PROC_H 24
#define LG_EEP_CONFIG 8

#define OFF_CHK_IMG 32
#define LG_ZONE_CHK_IMG 32


extern uint8_t ImgJeux[2*LG_EEP_CONFIG];       //liste image a afficher
extern uint8_t ImgTempoJeux[2*LG_EEP_CONFIG];  //durée entre 2 images


void LecConfigEEP();
void EcrConfigEEPDebug();
void AppImageFond(uint8_t NumImg, uint8_t *ptImage);
void GesCliBandeau (t_AppImg *ptAppelImg);
void GesBandeauInit (uint8_t *ptTempoImg, t_AppImg *ptAppelImg, uint8_t *ptImgHte, uint8_t *ptImgBas);
void GesBandeauJeu (uint8_t *ptTempoImg, uint8_t JeuEnCours_, t_AppImg *ptAppelImg, uint8_t *ptImgHte, uint8_t *ptImgBas);



