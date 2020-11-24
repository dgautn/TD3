/******************************************************************************/
/* User Level #define Macros                                                  */
/******************************************************************************/

/* TODO Application specific user parameters used in user.c may go here */

#define ALIGNED 1024
#define TAPS     400 

/******************************************************************************/
/* User Function Prototypes                                                   */
/******************************************************************************/

/* TODO User level functions prototypes (i.e. InitApp) go here */

void InitApp(void);         /* I/O and Peripheral Initialization */
void Filtro_FIR(void);
void ConfigTimer5(void);
void ConfigDAC(void);
void ConfigADC(void);
void ConfigDMA1(void);
void ConfigDMA2(void);