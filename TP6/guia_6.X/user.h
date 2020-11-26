/******************************************************************************/
/* User Level #define Macros                                                  */
/******************************************************************************/

/* TODO Application specific user parameters used in user.c may go here */
// Seleccion de filtro
#define F_FIR false
#define F_IIR true

// Constantes para el filtro FIR
#define ALIGNED 1024
#define TAPS     399

// Ganancias para el equalizador
#define GAN_MAX 0x7FFF
#define GAN_MIN 0x0000
#define GAN_INC 0x0CCD

// Constantes para la configuracion de la UART
#define FP 40000000
#define BAUDRATE 9600
#define BRGVAL ((FP/BAUDRATE)/16) - 1

/******************************************************************************/
/* User Function Prototypes                                                   */
/******************************************************************************/

/* TODO User level functions prototypes (i.e. InitApp) go here */

void InitApp(void);         /* I/O and Peripheral Initialization */
void Filtro_FIR(void);
void Filtro_IIR(void);
void ConfigTimer5(void);
void ConfigDAC(void);
void ConfigADC(void);
void ConfigDMA1(void);
void ConfigDMA2(void);
void ConfigUART(void);