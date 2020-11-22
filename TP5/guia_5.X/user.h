/******************************************************************************/
/* User Level #define Macros                                                  */
/******************************************************************************/
/* TODO Application specific user parameters used in user.c may go here */
// Constantes para la configuracion de la UART
#define FP 40000000
#define BAUDRATE 9600
#define BRGVAL ((FP/BAUDRATE)/16) - 1

/******************************************************************************/
/* User Function Prototypes                                                   */
/******************************************************************************/
/* TODO User level functions prototypes (i.e. InitApp) go here */

void InitApp(void);         /* I/O and Peripheral Initialization */
void ConfigTimer(void);     /* Inicializa el timer para interrupciones */
void ConfigDACsinDMA(void); /* Configura el DAC sin DMA */
void ConfigDACconDMA(void); /* Configura el DAC con DMA */
void ConfigDMA0_DMA1(void); /* Configura el DMA0 y el DMA1 para DAC */
void ConfigDMA2(void);      /* Configura el DMA2 para ADC */
void ConfigADC(void);       /* Configura el ADC */
void ConfigTimer5(void);    /* Inicializa el timer5 */
void ConfigUART(void);      /* Configura la UART */