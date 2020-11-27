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

#include <stdint.h>        /* Includes uint16_t definition   */
#include <stdbool.h>       /* Includes true/false definition */
#include <dsp.h>           /* Libreria para DSP              */
#include "user.h"          /* User funct/params, such as InitApp */

/******************************************************************************/
/* Variables globales definidas en main.c                                                            */
/******************************************************************************/
extern FIRStruct filtro;
extern fractional temp[32];

extern IIRTransposedStruct filtro_pb, filtro_pa, filtro_pband;
extern fractional gan_bajo;
extern fractional gan_alto;
extern fractional gan_medio;
extern fractional temp_pb[32];
extern fractional temp_pa[32];
extern fractional temp_pband[32];
extern fractional temp_outiir[32];

extern fractcomplex origen[32]__attribute__((space(ymemory), aligned(128)));
extern fractcomplex destino[32]__attribute__((space(ymemory), aligned(128)));
extern fractcomplex giro[16]__attribute__((space(xmemory), aligned(64)));
extern fractional temp_fft[32];
extern fractional frame_tx[35];
extern int cnt;
extern int bit_tx;

extern fractional prueba[32];

extern unsigned int DAC_BufferA[32]__attribute__((space(dma)));
extern unsigned int DAC_BufferB[32]__attribute__((space(dma)));
extern unsigned int ADC_BufferA[32]__attribute__((space(dma)));
extern unsigned int ADC_BufferB[32]__attribute__((space(dma)));


/******************************************************************************/
/* Interrupt Vector Options                                                   */
/******************************************************************************/
/*                                                                            */
/* Refer to the C30 (MPLAB C Compiler for PIC24F MCUs and dsPIC33F DSCs) User */
/* Guide for an up to date list of the available interrupt options.           */
/* Alternately these names can be pulled from the device linker scripts.      */
/*                                                                            */
/* dsPIC33F Primary Interrupt Vector Names:                                   */
/*                                                                            */
/* _INT0Interrupt      _C1Interrupt                                           */
/* _IC1Interrupt       _DMA3Interrupt                                         */
/* _OC1Interrupt       _IC3Interrupt                                          */
/* _T1Interrupt        _IC4Interrupt                                          */
/* _DMA0Interrupt      _IC5Interrupt                                          */
/* _IC2Interrupt       _IC6Interrupt                                          */
/* _OC2Interrupt       _OC5Interrupt                                          */
/* _T2Interrupt        _OC6Interrupt                                          */
/* _T3Interrupt        _OC7Interrupt                                          */
/* _SPI1ErrInterrupt   _OC8Interrupt                                          */
/* _SPI1Interrupt      _DMA4Interrupt                                         */
/* _U1RXInterrupt      _T6Interrupt                                           */
/* _U1TXInterrupt      _T7Interrupt                                           */
/* _ADC1Interrupt      _SI2C2Interrupt                                        */
/* _DMA1Interrupt      _MI2C2Interrupt                                        */
/* _SI2C1Interrupt     _T8Interrupt                                           */
/* _MI2C1Interrupt     _T9Interrupt                                           */
/* _CNInterrupt        _INT3Interrupt                                         */
/* _INT1Interrupt      _INT4Interrupt                                         */
/* _ADC2Interrupt      _C2RxRdyInterrupt                                      */
/* _DMA2Interrupt      _C2Interrupt                                           */
/* _OC3Interrupt       _DCIErrInterrupt                                       */
/* _OC4Interrupt       _DCIInterrupt                                          */
/* _T4Interrupt        _DMA5Interrupt                                         */
/* _T5Interrupt        _U1ErrInterrupt                                        */
/* _INT2Interrupt      _U2ErrInterrupt                                        */
/* _U2RXInterrupt      _DMA6Interrupt                                         */
/* _U2TXInterrupt      _DMA7Interrupt                                         */
/* _SPI2ErrInterrupt   _C1TxReqInterrupt                                      */
/* _SPI2Interrupt      _C2TxReqInterrupt                                      */
/* _C1RxRdyInterrupt                                                          */
/*                                                                            */
/* dsPIC33E Primary Interrupt Vector Names:                                   */
/*                                                                            */
/* _INT0Interrupt     _IC4Interrupt      _U4TXInterrupt                       */
/* _IC1Interrupt      _IC5Interrupt      _SPI3ErrInterrupt                    */
/* _OC1Interrupt      _IC6Interrupt      _SPI3Interrupt                       */
/* _T1Interrupt       _OC5Interrupt      _OC9Interrupt                        */
/* _DMA0Interrupt     _OC6Interrupt      _IC9Interrupt                        */
/* _IC2Interrupt      _OC7Interrupt      _PWM1Interrupt                       */
/* _OC2Interrupt      _OC8Interrupt      _PWM2Interrupt                       */
/* _T2Interrupt       _PMPInterrupt      _PWM3Interrupt                       */
/* _T3Interrupt       _DMA4Interrupt     _PWM4Interrupt                       */
/* _SPI1ErrInterrupt  _T6Interrupt       _PWM5Interrupt                       */
/* _SPI1Interrupt     _T7Interrupt       _PWM6Interrupt                       */
/* _U1RXInterrupt     _SI2C2Interrupt    _PWM7Interrupt                       */
/* _U1TXInterrupt     _MI2C2Interrupt    _DMA8Interrupt                       */
/* _AD1Interrupt      _T8Interrupt       _DMA9Interrupt                       */
/* _DMA1Interrupt     _T9Interrupt       _DMA10Interrupt                      */
/* _NVMInterrupt      _INT3Interrupt     _DMA11Interrupt                      */
/* _SI2C1Interrupt    _INT4Interrupt     _SPI4ErrInterrupt                    */
/* _MI2C1Interrupt    _C2RxRdyInterrupt  _SPI4Interrupt                       */
/* _CM1Interrupt      _C2Interrupt       _OC10Interrupt                       */
/* _CNInterrupt       _QEI1Interrupt     _IC10Interrupt                       */
/* _INT1Interrupt     _DCIEInterrupt     _OC11Interrupt                       */
/* _AD2Interrupt      _DCIInterrupt      _IC11Interrupt                       */
/* _IC7Interrupt      _DMA5Interrupt     _OC12Interrupt                       */
/* _IC8Interrupt      _RTCCInterrupt     _IC12Interrupt                       */
/* _DMA2Interrupt     _U1ErrInterrupt    _DMA12Interrupt                      */
/* _OC3Interrupt      _U2ErrInterrupt    _DMA13Interrupt                      */
/* _OC4Interrupt      _CRCInterrupt      _DMA14Interrupt                      */
/* _T4Interrupt       _DMA6Interrupt     _OC13Interrupt                       */
/* _T5Interrupt       _DMA7Interrupt     _IC13Interrupt                       */
/* _INT2Interrupt     _C1TxReqInterrupt  _OC14Interrupt                       */
/* _U2RXInterrupt     _C2TxReqInterrupt  _IC14Interrupt                       */
/* _U2TXInterrupt     _QEI2Interrupt     _OC15Interrupt                       */
/* _SPI2ErrInterrupt  _U3ErrInterrupt    _IC15Interrupt                       */
/* _SPI2Interrupt     _U3RXInterrupt     _OC16Interrupt                       */
/* _C1RxRdyInterrupt  _U3TXInterrupt     _IC16Interrupt                       */
/* _C1Interrupt       _USB1Interrupt     _ICDInterrupt                        */
/* _DMA3Interrupt     _U4ErrInterrupt    _PWMSpEventMatchInterrupt            */
/* _IC3Interrupt      _U4RXInterrupt     _PWMSecSpEventMatchInterrupt         */
/*                                                                            */
/* For alternate interrupt vector naming, simply add 'Alt' between the prim.  */
/* interrupt vector name '_' and the first character of the primary interrupt */
/* vector name.  There is no Alternate Vector or 'AIVT' for the 33E family.   */
/*                                                                            */
/* For example, the vector name _ADC2Interrupt becomes _AltADC2Interrupt in   */
/* the alternate vector table.                                                */
/*                                                                            */
/* Example Syntax:                                                            */
/*                                                                            */
/* void __attribute__((interrupt,auto_psv)) <Vector Name>(void)               */
/* {                                                                          */
/*     <Clear Interrupt Flag>                                                 */
/* }                                                                          */
/*                                                                            */
/* For more comprehensive interrupt examples refer to the C30 (MPLAB C        */
/* Compiler for PIC24 MCUs and dsPIC DSCs) User Guide in the                  */
/* <C30 compiler instal directory>/doc directory for the latest compiler      */
/* release.  For XC16, refer to the MPLAB XC16 C Compiler User's Guide in the */
/* <XC16 compiler instal directory>/doc folder.                               */
/*                                                                            */
/******************************************************************************/
/* Interrupt Routines                                                         */
/******************************************************************************/

/* TODO Add interrupt routine code here. */

/* Codigo que se ejecuta con la interrupcion _DMA2Interrupt */
void __attribute__((interrupt, no_auto_psv))_DMA2Interrupt(void)
{
    IFS1bits.DMA2IF = 0; // Borra el Flag de interrupcion del DMA Canal 2 

    #if F_FIR
        // Verifica cual banco de memoria RAM esta empleando el DMA2, A -> 0 o el B -> 1
        if(DMACS1bits.PPST2)                                
            FIR(32, temp, (fractional *)ADC_BufferA, &filtro);
        else
            FIR(32, temp, (fractional *)ADC_BufferB, &filtro);
    #endif
    #if F_IIR
        // Verifica cual banco de memoria RAM esta empleando el DMA2, A -> 0 o el B -> 1
        if(DMACS1bits.PPST2) {                              
            IIRTransposed(32, temp_pb, (fractional *)ADC_BufferA, &filtro_pb);
            IIRTransposed(32, temp_pa, (fractional *)ADC_BufferA, &filtro_pa);
            IIRTransposed(32, temp_pband, (fractional *)ADC_BufferA, &filtro_pband);
        }
        else {
            IIRTransposed(32, temp_pb, (fractional *)ADC_BufferB, &filtro_pb);
            IIRTransposed(32, temp_pa, (fractional *)ADC_BufferB, &filtro_pa);
            IIRTransposed(32, temp_pband, (fractional *)ADC_BufferB, &filtro_pband);
        }
        
        VectorScale(32,temp_pb,temp_pb,gan_bajo); // aplica la ganancia a cada filtro
        VectorScale(32,temp_pa,temp_pa,gan_alto);
        VectorScale(32,temp_pband,temp_pband,gan_medio);
        
        VectorAdd(32,temp_outiir,temp_pb,temp_pband); // suma las tres bandas
        VectorAdd(32,temp_outiir,temp_outiir,temp_pa);
    #endif
    #if T_FFT
        int n = 0;
        if (cnt == F_MUEST) {
            // Verifica cual banco de memoria RAM esta empleando el DMA2, A -> 0 o el B -> 1
            if(DMACS1bits.PPST2) 
                VectorCopy(32, temp_fft, (fractional *) DAC_BufferA);
            else
                VectorCopy(32, temp_fft, (fractional *) DAC_BufferB);
            for (n=0;n<32;n++) {
                origen[n].real = temp_fft[n];
                origen[n].imag = 0;
            }
            FFTComplex(5, destino, origen, giro, 0xFF00);
            
            /************ Paquete para transmitir ****************/
            // Cabecera
            frame_tx[0] = 0xAA;
            // Parte Real
            for (n=0;n<16;n++) {
                frame_tx[n+1] = destino[n].real >> 8;
            }
            // Separador
            frame_tx[17] = 0x80;
            // Parte Imaginaria
            for (n=0;n<16;n++) {
                frame_tx[n+18] = destino[n].imag >> 8;
            }
            // Fin de paquete
            frame_tx[34] = 0x55;
            /*****************************************************/
            U1TXREG = frame_tx[0]; // Inicia la transmision por la UART
            cnt = 0;
        }
        else cnt ++;
    #endif
}

/* Codigo que se ejecuta con la interrupcion _DMA1Interrupt */
void __attribute__((interrupt, no_auto_psv))_DMA1Interrupt(void)
{
    IFS0bits.DMA1IF = 0; // Borra el Flag de interrupcion del DMA Canal 1

    #if F_FIR
        // Verifica cual banco de memoria RAM esta empleando el DMA1, A -> 0 o el B -> 1
        if(DMACS1bits.PPST1) 
            VectorCopy(32, (fractional *) DAC_BufferA, temp);
        else
            VectorCopy(32, (fractional *) DAC_BufferB, temp); 
    #endif
    #if F_IIR
        // Verifica cual banco de memoria RAM esta empleando el DMA1, A -> 0 o el B -> 1
        if(DMACS1bits.PPST1)
            VectorCopy(32, (fractional *) DAC_BufferA, temp_outiir);
        else
            VectorCopy(32, (fractional *) DAC_BufferB, temp_outiir); 
    #endif
}

/* Codigo que se ejecuta con la interrupcion _U1RXInterrupt (RX UART) */
void __attribute__((interrupt,auto_psv))_U1RXInterrupt(void)               
{
    char rxchar;
    IFS0bits.U1RXIF = 0;                // Clear U1RX Interrupt Flag
    #if F_IIR
        rxchar = U1RXREG;               // Recibe el caracter
        switch (rxchar)
    {
        case ('Q'):
            if (gan_bajo < GAN_MAX)
                gan_bajo = gan_bajo + GAN_INC;
            break;
        case ('A'):
            if (gan_bajo > GAN_MIN)
                gan_bajo = gan_bajo - GAN_INC;
            break;
        case ('W'):
            if (gan_medio < GAN_MAX)
                gan_medio = gan_medio + GAN_INC;
            break;
        case ('S'):
            if (gan_medio > GAN_MIN)
                gan_medio = gan_medio - GAN_INC;
            break;
        case ('E'):
            if (gan_alto < GAN_MAX)
                gan_alto = gan_alto + GAN_INC;
            break;
        case ('D'):
            if (gan_alto > GAN_MIN)
                gan_alto = gan_alto - GAN_INC;
            break;
        }
    #endif
}

/* Codigo que se ejecuta con la interrupcion _U1TXInterrupt (TX UART) */
void __attribute__((interrupt,auto_psv))_U1TXInterrupt(void)               
{
    IFS0bits.U1TXIF = 0;                // Clear TX Interrupt flag
    if (bit_tx < 35) {
        U1TXREG = frame_tx[bit_tx];
        bit_tx ++;
    }
        else bit_tx = 1;
}
