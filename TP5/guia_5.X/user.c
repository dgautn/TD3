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
#include <stdbool.h>
#include <p33FJ128GP804.h>         /* For true/false definition                     */
#include "user.h"            /* variables/params used by user.c               */

/******************************************************************************/
/* Variables globales definidas en main.c                                                            */
/******************************************************************************/

/****************************** Ejercicio 3.1 *********************************/
/* Buffers de memoria DMA para almacenar la se�al senoidal a transmitir */
extern unsigned int RightBufferA[32]__attribute__((space(dma)));
extern unsigned int RightBufferB[32]__attribute__((space(dma)));
extern unsigned int LeftBufferA[32]__attribute__((space(dma)));
extern unsigned int LeftBufferB[32]__attribute__((space(dma)));


/******************************************************************************/
/* User Functions                                                             */
/******************************************************************************/

/* <Initialize variables in user.h and insert code for user algorithms.> */

void InitApp(void)
{
    /* TODO Initialize User Ports/Peripherals/Project here */

    /* Setup analog functionality and port direction */
    TRISBbits.TRISB2 = 0;   /* led1 */
    TRISBbits.TRISB3 = 0;   /* led2 */
    TRISBbits.TRISB7 = 1;   /* boton1 */
    TRISCbits.TRISC3 = 0;   /* para pruebas */
    /* Initialize peripherals */
    
    /***************************** Ejercicio 2 ********************************/
    /* Inicializa el temporizador del micro */
    ConfigTimer();
    
    /**************************** Ejercicio 3.1 *******************************/
    /* Configura el DAC sin DMA */
    /* se mantiene la configuracion del ej. 2.2 -> ConfigTimer(); */
    //ConfigDACsinDMA();

    /**************************** Ejercicio 3.2 *******************************/
    /* Configura el DAC con DMA */
    /* se mantiene la configuracion del ej. 2 -> ConfigTimer(); */
    //ConfigDMA0_DMA1();
    //ConfigDACconDMA();

    /***************************** Ejercicio 4 ********************************/
    /* Configura ADC con DMA2 y el timer5*/
    /* se mantiene la configuracion del ej. 2.2 -> ConfigTimer(); */
    /* se mabtiene la conf. del ej. 3.2 -> ConfigDMA0_DMA1() ConfigDACconDMA()*/
    //ConfigDMA2();
    //ConfigTimer5();
    //ConfigADC();
    
    /***************************** Ejercicio 5 ********************************/
    /* Configura la UART */
    /* se mantiene la configuracion del ej. 2.2 -> ConfigTimer(); 40MIPS */
    /* quitar instruccion que enciende led1 si se pulsa boton1 en main.c*/
    ConfigUART();
}

/* Funcion para inicializar el timer para generar interrupciones              */
/* El clock trabaja a 7,37MHz => 3,685x10^6 instrucciones por segundo         */
/* Para el ejercicio 2.1:                                                     */
/* En la guia recomienda usar 0x400000 que equivale a 4 194 304 instrucciones */
/* que es mas de 1s                                                           */
/* En el video de la clase en cambio:                                         */
/* Para que la interrupcion se ejecute cada 0,5s cuento 1 842 500             */
/* En hexadecimal -> 1C1D44                                                   */
/* Para el ejercicio 2.2:                                                     */
/* 40MIPS  cuento 40 000 000   ->   0x2625A00                                 */
void ConfigTimer(void)
{
    T3CONbits.TON = 0; 	// Detiene cualquier operaci�n del Timer3 de 16 bits
    T2CONbits.TON = 0; 	// Detiene cualquier operaci�n del Timer2 de 16/32 bits
    T2CONbits.T32 = 1; 	// Habilita el modo de temporizador de 32 bits
    T2CONbits.TCS = 0; 	// Selecciona el reloj de ciclo de instrucci�n interno
    T2CONbits.TGATE = 0; 	// Deshabilita el modo <Gated Timer> cronometrado?
    T2CONbits.TCKPS = 0b00; // Selecciona preescaler 1: 1
    TMR3 = 0x00; 		// Borra temporizador de 32 bits (msw)
    TMR2 = 0x00; 		// Borra temporizador de 32 bits (lsw)
/******************************************************************************/
    // ejercicio 2.1
    //PR3 = 0x0040;		// Carga el valor del per�odo de 32 bits (msw) 
    //PR2 = 0x0000;		// Carga el valor del per�odo de 32 bits (lsw)
    // ejercicio 2.2
    PR3 = 0x0262;		// Carga el valor del per�odo de 32 bits (msw)
    PR2 = 0x5A00;		// Carga el valor del per�odo de 32 bits (lsw)
/******************************************************************************/
    IPC2bits.T3IP = 0x01; 	// Establece el nivel de prioridad de la interrupci�n del Timer3
    IFS0bits.T3IF = 0; 	// Borra la bandera de la interrupci�n del Timer3
    IEC0bits.T3IE = 1; 	// Habilita la interrupci�n del Timer3

    T2CONbits.TON = 1; 	// Inicia el temporizador de 32 bits
}

/* Funcion para configurar el DAC sin DMA ( solo canal izquierdo ) */

void ConfigDACsinDMA(void)
{
    DAC1STATbits.ROEN = 1;   /* Salida de canal derecho del DAC habilitada */
    DAC1STATbits.LOEN = 1;   /* Salida de canal izquierdo del DAC habilitada */

    DAC1STATbits.RITYPE = 0; /* Interrupci�n del canal derecho si FIFO no est� llena */
    DAC1STATbits.LITYPE = 1; /* Interrupci�n del canal izquierdo si FIFO esta vacia */

    DAC1CONbits.AMPON = 0;   /* Amplificador desactivado durante los modos de suspensi�n e inactividad */
    DAC1CONbits.DACFDIV = 15;/* Dividir el reloj por 16 (f_vco=160MHz=> 160MHz/256/16 = 39062.5 Hz) */
    DAC1CONbits.FORM = 1;    /* Formato de datos con signo */
    
    ACLKCONbits.APSTSCLR = 0b111;/* bits del Clock auxiliar de salida = 0b111 -> divide por 1 */

    DAC1DFLT = 0;            /* Valor por defecto = 0 */

    IFS4bits.DAC1RIF = 0;    /* Borrar flag de interrupci�n del canal derecho */
    IFS4bits.DAC1LIF = 0;    /* Borrar flag de interrupci�n del canal izquierdo */

    IEC4bits.DAC1RIE = 0;    /* Interrupci�n de canal derecho deshabilitada */
    IEC4bits.DAC1LIE = 1;    /* Interrupci�n del canal izquierdo habilitada */

    DAC1CONbits.DACEN = 1;   /* M�dulo DAC1 habilitado */
}


/* Funcion para configurar el DMA canal 0 y 1*/

void ConfigDMA0_DMA1(void)
{
           /* DMA Canal 0 configurado para DAC1RDAT */
    DMA0CONbits.AMODE = 0;   /* Registro indirecto con incremento posterior */
    DMA0CONbits.MODE = 2;    /* Modo continuo con Ping-Pong habilitado */
    DMA0CONbits.DIR = 1;     /* Transferencia de datos de RAM a perif�ricos */

    DMA0PAD = (volatile unsigned int)&DAC1RDAT; /* Apunta DMA a DAC1RDAT */

    DMA0CNT = 31;            /* Solicitud de 32 DMA */
    DMA0REQ = 78;            /* Selecciona DAC1RDAT como fuente de solicitud DMA */

    DMA0STA = __builtin_dmaoffset(RightBufferA);                                                    
    DMA0STB = __builtin_dmaoffset(RightBufferB);                                                    

    IFS0bits.DMA0IF = 0;     /* Borra el flag de interrupci�n de DMA */
    IEC0bits.DMA0IE = 0;     /* Deshabilita el bit de interrupci�n de DMA */

    DMA0CONbits.CHEN = 1;    /* Habilita el canal DMA 0 */

       /* DMA Canal 1 configurado para DAC1LDAT */                                                          
    DMA1CONbits.AMODE = 0;   /* Registro indirecto con incremento posterior */
    DMA1CONbits.MODE = 2;    /* Modo continuo con Ping-Pong habilitado */
    DMA1CONbits.DIR = 1;     /* Transferencia de datos de RAM a perif�ricos */

    DMA1PAD = (volatile unsigned int)&DAC1LDAT; /* Apunta DMA a DAC1LDAT */

    DMA1CNT = 31;            /* Solicitud de 32 DMA */
    DMA1REQ = 79;            /* Selecciona DAC1LDAT como fuente de solicitud DMA */

    DMA1STA = __builtin_dmaoffset(LeftBufferA);                                                     
    DMA1STB = __builtin_dmaoffset(LeftBufferB);                                                     

    IFS0bits.DMA1IF = 0;     /* Borra el flag de interrupci�n de DMA */
    IEC0bits.DMA1IE = 0;     /* No Habilita el bit de interrupci�n de DMA */

    DMA1CONbits.CHEN = 1;    /* Habilita el canal DMA 1 */

}


/* Funcion para configurar el DAC con DMA */

void ConfigDACconDMA(void)
{
    /* DAC1 Code */                                                                         
    DAC1STATbits.ROEN = 1;   /* Salida DAC del canal derecho habilitada */
    DAC1STATbits.LOEN = 1;   /* Salida DAC del canal izquierdo habilitada */

    DAC1STATbits.RITYPE = 1; /* Interrupci�n del canal derecho si la FIFO est� vac�a */
    DAC1STATbits.LITYPE = 1; /* Interrupci�n del canal izquierdo si la FIFO est� vac�a */

    DAC1CONbits.AMPON = 0;   /* El amplificador est� desactivado durante los modos de suspensi�n/inactividad */
    DAC1CONbits.DACFDIV = 15;/* Dividir el reloj por 16 (f_vco=160MHz=> 160MHz/256/16 = 39062.5 Hz) */    
    DAC1CONbits.FORM = 1;    /* Formato de datos con signo */
    DAC1CONbits.DACEN = 1;   /* M�dulo DAC1 habilitado */    
    DAC1CONbits.FORM = 1;    /* Formato de datos con signo */

    ACLKCONbits.APSTSCLR = 0b111;/* bits del Clock auxiliar de salida = 0b111 -> divide por 1 */

    IEC4bits.DAC1RIE = 0;    /* Interrupci�n de canal derecho deshabilitada */
    IEC4bits.DAC1LIE = 0;    /* Interrupci�n del canal izquierdo deshabilitada */
}


/* Funcion para configurar el DMA 2 para ADC */

void ConfigDMA2(void)
{
       /* DMA Canal 2 configurado para ADC1 */
    DMA2CONbits.AMODE = 0;   /* Registro indirecto con incremento posterior */
    DMA2CONbits.MODE = 2;    /* Modo continuo con Ping-Pong habilitado */
    DMA2CONbits.DIR = 0;     /* Lee desde la direcci�n del perif�rico, escribe en la direcci�n DPSRAM */

    DMA2PAD = (volatile unsigned int)&ADC1BUF0; /* Apunta DMA a ADC1BUF0 */

    DMA2CNT = 31;            /* Solicitud de 32 DMA */
    DMA2REQ = 13;            /* Selecciona ADC1 */

    DMA2STA = __builtin_dmaoffset(RightBufferB);                                                    
    DMA2STB = __builtin_dmaoffset(RightBufferA);                                                    

    IFS1bits.DMA2IF = 0;     /* Borra el flag de interrupci�n de DMA */
    IEC1bits.DMA2IE = 0;     /* No Habilita el bit de interrupci�n de DMA */

    DMA2CONbits.CHEN = 1;    /* Habilita el canal DMA 2 */
  
}


/* Funcion para configurar el ADC */

void ConfigADC(void)
{
        AD1CON1bits.FORM = 3;   // Formato de salida de datos: fraccional con signo (formato Q15)
        AD1CON1bits.SSRC = 4;   // El temporizador GP (Timer5 para ADC1, Timer3 para ADC2) compara, finaliza 
                                // el muestreo e inicia la conversi�n
        AD1CON1bits.ASAM = 1;   // Control de muestras ADC: el muestreo comienza inmediatamente despu�s de la
                                // conversi�n
        AD1CON1bits.AD12B = 1;  // Operaci�n ADC de 12 bits

        AD1CON2bits.VCFG = 0;   // Referencia de voltaje del convertidor
                                // VREFH = AVDD,  VREFL = AVSS

        AD1CON2bits.CHPS = 0;   // Convierte canale CH0 solamente

        AD1CON3bits.ADRC = 0;   // ADC Clock se deriva de Systems Clock
        AD1CON3bits.SAMC = 5;   // Tiempo de muestreo autom�tico = 5 * TAD
        AD1CON3bits.ADCS = 9;   // Clock de conversi�n ADC: TAD = TCY * (ADCS + 1) = (1 / 40M) * 10 =
                                // 250 ns (4 MHz)
                                // Tiempo de conversi�n de ADC para Tconv de 12 bits = 14 * TAD = 3,5us (0,286 MHz)

        AD1CON2bits.SMPI = 0;         // SMPI debe ser 0 (un incremento por muestra ?)

        //AD1CHS0/AD1CHS123: Registro de selecci�n de entrada anal�gica-digital
        AD1CHS0bits.CH0SA = 0;        // Selecci�n de entrada MUXA +ve (AIN0) para CH0
        AD1CHS0bits.CH0NA = 0;        // Selecci�n de entrada MUXA -ve (VREF-) para CH0

        //AD1PCFGH/AD1PCFGL: Registro de configuraci�n de puerto
        AD1PCFGL = 0xFFFF;
        //AD1PCFGH = 0xFFFF;
        AD1PCFGLbits.PCFG0 = 0;   // AN0 como entrada anal�gica
        //IFS0bits.AD1IF = 0;       // Borra el bit del indicador de interrupci�n anal�gico-digital
        //IEC0bits.AD1IE = 0;       // No habilita la interrupci�n anal�gico-digital
        AD1CON1bits.ADON = 1;     // Enciende el ADC
}


/* Funcion para inicializar el Timer5 */

void ConfigTimer5(void)
{
    T5CONbits.TON = 0;      // Detiene cualquier operaci�n del Timer5
    T5CONbits.TCS = 0;      // Selecciona el reloj de ciclo de instrucci�n interno
    T5CONbits.TGATE = 0; 	// Deshabilita el modo <Gated Timer> cronometrado?
    T5CONbits.TCKPS = 0b00; // Selecciona preescaler 1: 1
    TMR5 = 0x00;            // Borra el registro del temporizador de 16 bits
    PR5 = 0x0400;           // Carga el valor del per�odo de 16 bits
 
    IPC7bits.T5IP = 0x01; 	// Establece el nivel de prioridad de la interrupci�n del Timer5
    IFS1bits.T5IF = 0;      // Borra la bandera de la interrupci�n del Timer5
    IEC1bits.T5IE = 0;      // No Habilita la interrupci�n del Timer5
    // Prueba de velocidad
    //IEC1bits.T5IE = 1;      // Habilita la interrupci�n del Timer5

    T5CONbits.TON = 1;      // Inicia el temporizador de 16 bits
}


/* Funci�n para inicializar el puerto serie */

void ConfigUART(void)
{
    U1MODEbits.STSEL = 0;       // 1 Bit de stop
    U1MODEbits.PDSEL = 0;       // Sin paridad, 8 bits de datos
    U1MODEbits.ABAUD = 0;       // Auto-Baud deshabilitado
    U1MODEbits.BRGH = 0;        // Modo de velocidad est�ndar

    U1BRG = BRGVAL;             // Velocidad en baudios de 9600

    U1STAbits.URXISEL = 0;      // Interrumpci�n despu�s de recibir un car�cter RX

    IEC0bits.U1RXIE = 1;        // Habilita la interrupci�n

    // Remapeo de pines
    RPINR18bits.U1RXR = 5;      // Mapea el pin RP5 al RX de la UART
    RPOR3bits.RP6R = 3;         // Mapea el pin RP6 al TX de la UART

    U1MODEbits.UARTEN = 1;      // Habilita UART
    U1STAbits.UTXEN = 1;        // Habilita la transmisi�n UART

}

