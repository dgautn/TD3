/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

/* Device header file */
#if defined(__XC16__)
    #include <xc.h>
#elif defined(__C30__)
    #if defined(__dsPIC33E__)
    	#include <p33Exxxx.h>
    #elif defined(__dsPIC33F__)
    	#include <p33Fxxxx.h>
    #endif
#endif


#include <stdint.h>        /* Includes uint16_t definition                    */
#include <stdbool.h>       /* Includes true/false definition                  */

#include "system.h"        /* System funct/params, like osc/peripheral config */
#include "user.h"          /* User funct/params, such as InitApp              */
#include <dsp.h>           /* Libreria para DSP                               */

/******************************************************************************/
/* Global Variable Declaration                                                */
/******************************************************************************/

FIRStruct filtro;
fractional coeffs[TAPS]__attribute__((space(xmemory), far, aligned(ALIGNED))) = { 
   
};
fractional delay[TAPS]__attribute__((space(ymemory), far, aligned(ALIGNED)));
fractional temp[32];

fractional DAC_BufferA[32]__attribute__((space(dma))) = {0}; 
fractional DAC_BufferB[32]__attribute__((space(dma))) = {0};
fractional ADC_BufferA[32]__attribute__((space(dma)));
fractional ADC_BufferB[32]__attribute__((space(dma)));


/******************************************************************************/
/* Main Program                                                               */
/******************************************************************************/

int16_t main(void)
{

    /* Configure the oscillator for the device */
    ConfigureOscillator();

    /* Initialize IO ports and peripherals */
    InitApp();

    /* TODO <INSERT USER APPLICATION CODE HERE> */

    while(1)
    {
        LATBbits.LATB2 = PORTBbits.RB7; // Enciende led1 si se pulsa boton1
    }
}
