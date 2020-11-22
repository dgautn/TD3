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

/******************************************************************************/
/* Global Variable Declaration                                                */
/******************************************************************************/

/* i.e. uint16_t <variable_name>; */
/****************************** Ejercicio 3.1 *********************************/
/* Variable para dar los valores máximos y mínimos de excursión del DAC */
uint16_t out_DAC = 0x8000;

/****************************** Ejercicio 3.2 *********************************/
/* Buffers de memoria DMA con la señal senoidal a transmitir */
unsigned int RightBufferA[32]__attribute__((space(dma))) = {0};
unsigned int RightBufferB[32]__attribute__((space(dma))) = {0};
unsigned int LeftBufferA[32]__attribute__((space(dma))) = {0x0000,0x18F8,0x30FB,0x471C,0x5A81,0x6A6C,0x7640,0x7D89,0x7FFF,0x7D89,0x7640,0x6A6C,0x5A81,0x471C,0x30FB,0x18F8,0x0000,0xE706,0xCF03,0xB8E2,0xA57D,0x9592,0x89BE,0x8275,0x8000,0x8275,0x89BE,0x9592,0xA57D,0xB8E2,0xCF03,0xE706};
unsigned int LeftBufferB[32]__attribute__((space(dma))) = {0x0000,0x18F8,0x30FB,0x471C,0x5A81,0x6A6C,0x7640,0x7D89,0x7FFF,0x7D89,0x7640,0x6A6C,0x5A81,0x471C,0x30FB,0x18F8,0x0000,0xE706,0xCF03,0xB8E2,0xA57D,0x9592,0x89BE,0x8275,0x8000,0x8275,0x89BE,0x9592,0xA57D,0xB8E2,0xCF03,0xE706};


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
    
    /****************************** Ejercicio 1 *******************************/
    int32_t i; 
    while(1)
    {
        // ejercicio 1.2    
        //LATBbits.LATB3 = ~LATBbits.LATB3; // Cambia el estado del led2
        for(i=0;i<155000;i=i+1) // bucle de 155 mil ciclos -> aprox 1s
        {
            // ejercicio 1.1
            //LATBbits.LATB2 = PORTBbits.RB7; // Enciende led1 si se pulsa boton1
        }
    }
    /**************************************************************************/
}
