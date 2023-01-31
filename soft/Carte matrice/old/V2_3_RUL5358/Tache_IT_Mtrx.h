//----------------------------------------------------------------------------//
//                                                                            //
// Objet du programme : Gestion beep sonore                                   //
//                                                                            //
// par E. BURTZ                                                               //
// Commencé le 23/02/2007                                                     //
//                                                                            //
//----------------------------------------------------------------------------//
//

void InterruptSpgGesMatrix();
void InitPeriphITMatrix();


#define VAL_CONF_T3CON_HS 0b00000001        // préscaler = 1/1, fosc/4, timer3 on
#define VAL_CONF_T3CON_LS 0b00110001        // préscaler = 1/8, fosc/4, timer3 on

extern unsigned short NumColonne;
extern unsigned short NumLigne;

extern unsigned short VoletDroit;
extern unsigned short VoletGauche;