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

#include <stdint.h>          /* For uint16_t definition                       */
#include <stdbool.h>         /* For true/false definition                     */
#include "user.h"            /* variables/params used by user.c               */
#include <dsp.h>             /* Libreria para DSP                             */

/******************************************************************************/
/* Variables globales definidas en main.c                                                            */
/******************************************************************************/

extern FIRStruct filtro;
extern fractional coeffs[TAPS]__attribute__((space(xmemory), aligned(ALIGNED)));
extern fractional delay[TAPS]__attribute__((space(ymemory), aligned(ALIGNED)));

extern IIRTransposedStruct filtro_pb, filtro_pa, filtro_pband;
extern fractional coeffs_pb[20]__attribute__((space(xmemory)));
extern fractional coeffs_pa[20]__attribute__((space(xmemory)));
extern fractional coeffs_pband[40]__attribute__((space(xmemory)));
extern fractional delay1_pb[4]__attribute__((space(ymemory), far));
extern fractional delay2_pb[4]__attribute__((space(ymemory), far));
extern fractional delay1_pa[4]__attribute__((space(ymemory), far));
extern fractional delay2_pa[4]__attribute__((space(ymemory), far));
extern fractional delay1_pband[8]__attribute__((space(ymemory), far));
extern fractional delay2_pband[8]__attribute__((space(ymemory), far));

extern unsigned int DAC_BufferA[32]__attribute__((space(dma)));
extern unsigned int DAC_BufferB[32]__attribute__((space(dma)));
extern unsigned int ADC_BufferA[32]__attribute__((space(dma)));
extern unsigned int ADC_BufferB[32]__attribute__((space(dma)));


/******************************************************************************/
/* User Functions                                                             */
/******************************************************************************/

/* <Initialize variables in user.h and insert code for user algorithms.> */

void InitApp(void)
{
    /* TODO Initialize User Ports/Peripherals/Project here */

    /* Setup analog functionality and port direction */
    TRISBbits.TRISB2 = 0;   /* led1 */
    TRISBbits.TRISB7 = 1;   /* boton1 */

    /* Initialize peripherals */
    #if F_FIR 
        Filtro_FIR();
    #endif
    #if F_IIR
        Filtro_IIR();
        ConfigUART();
    #endif
    ConfigTimer5();
    ConfigDAC();
    ConfigADC();
    ConfigDMA1();
    ConfigDMA2();
}

/* Funcion para cargar el filtro FIR */
void Filtro_FIR(void)
{
    filtro.numCoeffs = TAPS;             // Número de coeficientes del filtro (M)
    filtro.coeffsBase = &coeffs[0];         // Dirección inicial del vector de coeficientes
    filtro.coeffsEnd = &((uint8_t *)coeffs)[TAPS*2-1];
                                         // Dirección final del vector de coeficientes
    filtro.coeffsPage = 0xFF00;          // Página de ubicación de coeficientes para RAM
    filtro.delayBase = &delay[0];           // Dirección inicial del vector de retardos
    filtro.delayEnd = &((uint8_t *)delay)[TAPS*2-1];
                                         // Dirección final del vector de retardos
    filtro.delay = &delay[0];               // Puntero a la dirección actual del vector de retardos
    FIRDelayInit(&filtro);    
}

/* Funcion para cargar los filtros IIR */
void Filtro_IIR(void)
{
    filtro_pb.numSectionsLess1 = 3;    // Número de secciones menos 1
    filtro_pb.coeffsBase = &coeffs_pb[0]; // Dirección de inicio del vector de coeficientes
    filtro_pb.coeffsPage = 0xFF00;     // Página del vector de coeficientes (0xFF00 para RAM)
    filtro_pb.delayBase1 = &delay1_pb[0]; // Dirección del vector de retardos 1
    filtro_pb.delayBase2 = &delay2_pb[0]; // Dirección del vector de retardos 2
    filtro_pb.finalShift = 0;          // Ganancia final del filtro, en potencia de 2, 2^0 = 1
    IIRTransposedInit(&filtro_pb);
    
    filtro_pa.numSectionsLess1 = 3;    // Número de secciones menos 1
    filtro_pa.coeffsBase = &coeffs_pa[0]; // Dirección de inicio del vector de coeficientes
    filtro_pa.coeffsPage = 0xFF00;     // Página del vector de coeficientes (0xFF00 para RAM)
    filtro_pa.delayBase1 = &delay1_pa[0]; // Dirección del vector de retardos 1
    filtro_pa.delayBase2 = &delay2_pa[0]; // Dirección del vector de retardos 2
    filtro_pa.finalShift = 0;          // Ganancia final del filtro, en potencia de 2, 2^0 = 1
    IIRTransposedInit(&filtro_pa);
   
    filtro_pband.numSectionsLess1 = 3;       // Número de secciones menos 1
    filtro_pband.coeffsBase = &coeffs_pband[0]; // Dirección de inicio del vector de coeficientes
    filtro_pband.coeffsPage = 0xFF00;        // Página del vector de coeficientes (0xFF00 para RAM)
    filtro_pband.delayBase1 = &delay1_pband[0]; // Dirección del vector de retardos 1
    filtro_pband.delayBase2 = &delay2_pband[0]; // Dirección del vector de retardos 2
    filtro_pband.finalShift = 0;             // Ganancia final del filtro, en potencia de 2, 2^0 = 1
    IIRTransposedInit(&filtro_pband);
}

/* Funcion para inicializar el Timer5 */
void ConfigTimer5(void)
{
    T5CONbits.TON = 0;      // Detiene cualquier operación del Timer5
    T5CONbits.TCS = 0;      // Selecciona el reloj de ciclo de instrucción interno
    T5CONbits.TGATE = 0; 	// Deshabilita el modo <Gated Timer> cronometrado?
    T5CONbits.TCKPS = 0b00; // Selecciona preescaler 1: 1
    TMR5 = 0x00;            // Borra el registro del temporizador de 16 bits
    PR5 = 0x0400;           // Carga el valor del período de 16 bits
 
    IPC7bits.T5IP = 0x01; 	// Establece el nivel de prioridad de la interrupción del Timer5
    IFS1bits.T5IF = 0;      // Borra la bandera de la interrupción del Timer5
    IEC1bits.T5IE = 0;      // No Habilita la interrupción del Timer5
    // Prueba de velocidad
    //IEC1bits.T5IE = 1;      // Habilita la interrupción del Timer5

    T5CONbits.TON = 1;      // Inicia el temporizador de 16 bits
}


/* Funcion para configurar el DAC con DMA */
void ConfigDAC(void)
{
    /* DAC1 Code */                                                                         
    //DAC1STATbits.ROEN = 1;   /* Salida DAC del canal derecho habilitada */
    DAC1STATbits.LOEN = 1;   /* Salida DAC del canal izquierdo habilitada */

    //DAC1STATbits.RITYPE = 1; /* Interrupción del canal derecho si la FIFO está vacía */
    DAC1STATbits.LITYPE = 1; /* Interrupción del canal izquierdo si la FIFO está vacía */

    DAC1CONbits.AMPON = 0;   /* El amplificador está desactivado durante los modos de suspensión/inactividad */
    DAC1CONbits.DACFDIV = 15;/* Dividir el reloj por 16 (f_vco=160MHz=> 160MHz/256/16 = 39062.5 Hz) */    
    DAC1CONbits.FORM = 1;    /* Formato de datos con signo */
    DAC1CONbits.DACEN = 1;   /* Módulo DAC1 habilitado */    
    DAC1CONbits.FORM = 1;    /* Formato de datos con signo */

    ACLKCONbits.APSTSCLR = 0b111;/* bits del Clock auxiliar de salida = 0b111 -> divide por 1 */

    //IEC4bits.DAC1RIE = 0;    /* Interrupción de canal derecho deshabilitada */
    //IEC4bits.DAC1LIE = 0;    /* Interrupción del canal izquierdo deshabilitada */
}


/* Funcion para configurar el ADC */
void ConfigADC(void)
{
    AD1CON1bits.FORM = 3;   // Formato de salida de datos: fraccional con signo (formato Q15)
    AD1CON1bits.SSRC = 4;   // El temporizador GP (Timer5 para ADC1, Timer3 para ADC2) compara, finaliza 
                            // el muestreo e inicia la conversión
    AD1CON1bits.ASAM = 1;   // Control de muestras ADC: el muestreo comienza inmediatamente después de la
                            // conversión
    AD1CON1bits.AD12B = 1;  // Operación ADC de 12 bits

    AD1CON2bits.VCFG = 0;   // Referencia de voltaje del convertidor
                            // VREFH = AVDD,  VREFL = AVSS

    AD1CON2bits.CHPS = 0;   // Convierte canale CH0 solamente

    AD1CON3bits.ADRC = 0;   // ADC Clock se deriva de Systems Clock
    AD1CON3bits.SAMC = 5;   // Tiempo de muestreo automático = 5 * TAD
    AD1CON3bits.ADCS = 9;   // Clock de conversión ADC: TAD = TCY * (ADCS + 1) = (1 / 40M) * 10 =
                            // 250 ns (4 MHz)
                            // Tiempo de conversión de ADC para Tconv de 12 bits = 14 * TAD = 3,5us (0,286 MHz)

    AD1CON2bits.SMPI = 0;         // SMPI debe ser 0 (un incremento por muestra ?)

    //AD1CHS0/AD1CHS123: Registro de selección de entrada analógica-digital
    AD1CHS0bits.CH0SA = 0;        // Selección de entrada MUXA +ve (AIN0) para CH0
    AD1CHS0bits.CH0NA = 0;        // Selección de entrada MUXA -ve (VREF-) para CH0

    //AD1PCFGH/AD1PCFGL: Registro de configuración de puerto
    AD1PCFGL = 0xFFFF;
    //AD1PCFGH = 0xFFFF;
    AD1PCFGLbits.PCFG0 = 0;   // AN0 como entrada analógica
    //IFS0bits.AD1IF = 0;       // Borra el bit del indicador de interrupción analógico-digital
    //IEC0bits.AD1IE = 0;       // No habilita la interrupción analógico-digital
    AD1CON1bits.ADON = 1;     // Enciende el ADC
}

/* Funcion para configurar el DMA canal 1 */
void ConfigDMA1(void)
{
        /* DMA Canal 1 configurado para DAC1LDAT */                                                          
    DMA1CONbits.AMODE = 0;   /* Registro indirecto con incremento posterior */
    DMA1CONbits.MODE = 2;    /* Modo continuo con Ping-Pong habilitado */
    DMA1CONbits.DIR = 1;     /* Transferencia de datos de RAM a periféricos */

    DMA1PAD = (volatile unsigned int)&DAC1LDAT; /* Apunta DMA a DAC1LDAT */

    DMA1CNT = 31;            /* Solicitud de 32 DMA */
    DMA1REQ = 79;            /* Selecciona DAC1LDAT como fuente de solicitud DMA */

    DMA1STA = __builtin_dmaoffset(DAC_BufferA);                                                     
    DMA1STB = __builtin_dmaoffset(DAC_BufferB);                                                     

    IFS0bits.DMA1IF = 0;     /* Borra el flag de interrupción de DMA */
    IEC0bits.DMA1IE = 0;     /* No Habilita el bit de interrupción de DMA */

    DMA1CONbits.CHEN = 1;    /* Habilita el canal DMA 1 */

}


/* Funcion para configurar el DMA 2 para ADC */
void ConfigDMA2(void)
{
       /* DMA Canal 2 configurado para ADC1 */
    DMA2CONbits.AMODE = 0;   /* Registro indirecto con incremento posterior */
    DMA2CONbits.MODE = 2;    /* Modo continuo con Ping-Pong habilitado */
    DMA2CONbits.DIR = 0;     /* Lee desde la dirección del periférico, escribe en la dirección DPSRAM */

    DMA2PAD = (volatile unsigned int)&ADC1BUF0; /* Apunta DMA a ADC1BUF0 */

    DMA2CNT = 31;            /* Solicitud de 32 DMA */
    DMA2REQ = 13;            /* Selecciona ADC1 */

    DMA2STA = __builtin_dmaoffset(ADC_BufferB);                                                    
    DMA2STB = __builtin_dmaoffset(ADC_BufferA);                                                    

    IFS1bits.DMA2IF = 0;     /* Borra el flag de interrupción de DMA */
    IEC1bits.DMA2IE = 0;     /* No Habilita el bit de interrupción de DMA */

    DMA2CONbits.CHEN = 1;    /* Habilita el canal DMA 2 */
  
}

/* Función para inicializar el puerto serie */

void ConfigUART(void)
{
    U1MODEbits.STSEL = 0;       // 1 Bit de stop
    U1MODEbits.PDSEL = 0;       // Sin paridad, 8 bits de datos
    U1MODEbits.ABAUD = 0;       // Auto-Baud deshabilitado
    U1MODEbits.BRGH = 0;        // Modo de velocidad estándar

    U1BRG = BRGVAL;             // Velocidad en baudios de 9600

    U1STAbits.URXISEL = 0;      // Interrumpción después de recibir un carácter RX

    IEC0bits.U1RXIE = 1;        // Habilita la interrupción

    // Remapeo de pines
    RPINR18bits.U1RXR = 5;      // Mapea el pin RP5 al RX de la UART
    RPOR3bits.RP6R = 3;         // Mapea el pin RP6 al TX de la UART

    U1MODEbits.UARTEN = 1;      // Habilita UART
    U1STAbits.UTXEN = 1;        // Habilita la transmisión UART

}
