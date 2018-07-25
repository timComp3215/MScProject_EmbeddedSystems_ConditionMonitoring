/* --COPYRIGHT--,BSD
 * Copyright (c) 2017, Texas Instruments Incorporated
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * *  Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * *  Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * *  Neither the name of Texas Instruments Incorporated nor the names of
 *    its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * --/COPYRIGHT--*/
/*******************************************************************************
 * MSP432 ADC14 - Single Channel Continuous Sample w/ Timer_A Trigger
 *
 * Description: In this ADC14 code example, a single input channel is sampled
 * using the standard 3.3v reference. The source of the sample trigger for this
 * example is Timer_A CCR1. The ADC is setup to continuously sample/convert
 * from A0 when the trigger starts and store the results in resultsBuffer (it
 * is setup to be a circular buffer where resPos overflows to 0). Timer_A is
 * setup in Up mode and a Compare value of 16384  is set as the compare trigger
 *  and reset trigger. Once the Timer_A is started, after 0.5s it will trigger
 * the ADC14 to start conversions. Essentially this example will use
 * the Timer_A module to trigger an ADC conversion every 0.5 seconds.
 *
 *                MSP432P401
 *             ------------------
 *         /|\|                  |
 *          | |                  |
 *          --|RST         P5.5  |<--- A0 (Analog Input)
 *            |                  |
 *            |                  |
 *            |                  |
 *            |                  |
 *            |                  |
 *
 *
 * Edited version of example code to send ADC reading over serial in ASCII
 * 9600 baud rate
 *
 * Read SAMPLES no of ADC reading on push button 1.1 (S1)
 *
 * Adding averaging function as preprocessing for FFT
 * Time data then centred around 0
 *
 * Calculate FFT using kissFFT
 *
 * Also send magnitudes via serial
 *
 ******************************************************************************/
/* DriverLib Includes */
#include <ti/devices/msp432p4xx/driverlib/driverlib.h>

/* Standard Includes */
#include <stdint.h>
#include <stdbool.h>

 /* Select the global Q value */
 #define GLOBAL_Q    12

/* Select FIXED point option for kissFFT */
#define FIXED_POINT 16

#include "kissFFT/kiss_fftr.h"
#include "kissFFT/kiss_fft_guts.h"

 /* Include the iqmathlib header files */
 #include <ti/iqmathlib/QmathLib.h>
 #include <ti/iqmathlib/IQmathLib.h>

//Sample size
#define SAMPLES 4096

//![Simple UART Config]
/* UART Configuration Parameter. These are the configuration parameters to
 * make the eUSCI A UART module to operate with a 9600 baud rate. These
 * values were calculated using the online calculator that TI provides
 * at:
 *http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSP430BaudRateConverter/index.html
 */

void sendReading(int16_t reading)
{
    //Sends readings as 2 8bit bytes (16 bit data)
    uint16_t reading_send;
    if (reading >= 0)
    {
        reading_send = reading;
    }
    else
    {
        reading_send = (reading + 65536);
    }
    UART_transmitData(EUSCI_A0_BASE, (reading_send%256));
    UART_transmitData(EUSCI_A0_BASE, (reading_send/256));
}

int16_t calc_mean(volatile int16_t *readings, uint16_t n)
{
    float mean = 0.0;
    int i=0;
    //Calculate mean
    for (i=0; i<n;i++)
    {
        mean += (float)(readings[i]);
    }

    mean /= n;

    return (int16_t)(mean + 0.5);
}

void average_preprocess(volatile int16_t *readings, uint16_t n)
{
    //This function calculates and then subtracts the mean value of the readings from
    //the values - this filters out the DC component
    float mean = 0.0;
    int i=0;

    //Calculate mean
    for (i=0; i<n;i++)
    {
        mean += (float)(readings[i]);
    }

    mean /= n;

    int16_t int_mean = (int16_t)(mean + 0.5);

    //Subtract
    for (i=0; i<n; i++)
    {
        readings[i] -= int_mean;
    }
}

int16_t max(volatile int16_t *readings, uint16_t n)
{
    //This function finds the maximum value in a range
    int16_t maximum = 0;
    int i;
    for (i=0; i<n; i++)
    {
        if (readings[i] > maximum)
        {
            maximum = readings[i];
        }
    }

    return maximum;
}

int16_t RMS(volatile int16_t *readings, uint16_t n)
{
    //Calculate the root mean square of a range
    int i;

    float RMS;

    for (i=0; i<n; i++)
    {
        //RMSE += (readings[i]-mean)*(readings[i]-mean)/n;
        RMS += ((float)readings[i])*((float)readings[i])/(float)n;
    }

    RMS = sqrt(RMS);

    return (int16_t)(RMS+0.5);
}

int16_t STD(volatile int16_t *readings, uint16_t n)
{
    int16_t mean = calc_mean(readings, n);

    float STD;

    int i;

    for (i=0; i<n; i++)
    {
        STD += ((float)readings[i]-mean)*((float)readings[i]-mean)/(float)n;
    }

    STD = sqrt(STD);

    return (int16_t)(STD+0.5);
}

//Configures to 9600 baud rate at this clock speed
const eUSCI_UART_Config uartConfig =
{
        EUSCI_A_UART_CLOCKSOURCE_SMCLK,          // SMCLK Clock Source
        78,                                      // BRDIV = 78
        2,                                       // UCxBRF = 2
        0,                                       // UCxBRS = 0
        EUSCI_A_UART_NO_PARITY,                  // No Parity
        EUSCI_A_UART_LSB_FIRST,                  // LSB First
        EUSCI_A_UART_ONE_STOP_BIT,               // One stop bit
        EUSCI_A_UART_MODE,                       // UART mode
        EUSCI_A_UART_OVERSAMPLING_BAUDRATE_GENERATION  // Oversampling
};

/* Timer_A Continuous Mode Configuration Parameter */
const Timer_A_UpModeConfig upModeConfig =
{
        TIMER_A_CLOCKSOURCE_ACLK,            // ACLK Clock Source
        TIMER_A_CLOCKSOURCE_DIVIDER_1,       // ACLK/1 = 128 kHz
        1,                                  // 32.768 kHz / 8 = 4096 Hz
        TIMER_A_TAIE_INTERRUPT_DISABLE,      // Disable Timer ISR
        TIMER_A_CCIE_CCR0_INTERRUPT_DISABLE, // Disable CCR0
        TIMER_A_DO_CLEAR                     // Clear Counter
};

/*const Timer_A_UpModeConfig upModeConfig =
{
        TIMER_A_CLOCKSOURCE_SMCLK,            // SMCLK Clock Source
        TIMER_A_CLOCKSOURCE_DIVIDER_1,       // SMCLK/1 = 12 MHz
        12000,                                // 12 Mhz / 12000 = 1 kHz
        TIMER_A_TAIE_INTERRUPT_DISABLE,      // Disable Timer ISR
        TIMER_A_CCIE_CCR0_INTERRUPT_DISABLE, // Disable CCR0
        TIMER_A_DO_CLEAR                     // Clear Counter
};*/

/* Timer_A Compare Configuration Parameter */
const Timer_A_CompareModeConfig compareConfig =
{
        TIMER_A_CAPTURECOMPARE_REGISTER_1,          // Use CCR1
        TIMER_A_CAPTURECOMPARE_INTERRUPT_DISABLE,   // Disable CCR interrupt
        TIMER_A_OUTPUTMODE_SET_RESET,               // Toggle output but
        1// 16000 Period
};

/* Statics */
//volatile int16_t resultsBuffer[SAMPLES];
int16_t *information_bytes;
volatile uint16_t resPos = 0;
volatile uint8_t sendValues = 0;

int main(void)
{
    /* Halting WDT  */
    MAP_WDT_A_holdTimer();

    /* Setting up clocks
     * MCLK = MCLK = 12MHz
     * ACLK = REFO = 32Khz */
    /* Setting DCO to 12MHz */
    CS_setDCOCenteredFrequency(CS_DCO_FREQUENCY_12);
    //Increase oscillator frequency to 128 kHz
    CS_setReferenceOscillatorFrequency(CS_REFO_32KHZ);
    MAP_CS_initClockSignal(CS_ACLK, CS_REFOCLK_SELECT, CS_CLOCK_DIVIDER_1);
    //MAP_CS_initClockSignal(CS_SMCLK, CS_DCOCLK_SELECT, CS_CLOCK_DIVIDER_1);

    //Set serial pins to serial mode
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P1,
                GPIO_PIN2 | GPIO_PIN3, GPIO_PRIMARY_MODULE_FUNCTION);

    /* Configuring UART Module */
    MAP_UART_initModule(EUSCI_A0_BASE, &uartConfig);

    /* Enable UART module */
    MAP_UART_enableModule(EUSCI_A0_BASE);

    /* Confinguring P1.1 as an input and enabling interrupts */
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN1);
    MAP_GPIO_clearInterruptFlag(GPIO_PORT_P1, GPIO_PIN1);
    MAP_GPIO_enableInterrupt(GPIO_PORT_P1, GPIO_PIN1);
    MAP_GPIO_interruptEdgeSelect(GPIO_PORT_P1, GPIO_PIN1, GPIO_HIGH_TO_LOW_TRANSITION);
    MAP_Interrupt_enableInterrupt(INT_PORT1);

    /* Enabling interrupts */
    //MAP_UART_enableInterrupt(EUSCI_A0_BASE, EUSCI_A_UART_RECEIVE_INTERRUPT);
    //MAP_Interrupt_enableInterrupt(INT_EUSCIA0);

    /* Initializing ADC (SMCLK/1/1) */
    MAP_ADC14_enableModule();
    MAP_ADC14_initModule(ADC_CLOCKSOURCE_SMCLK, ADC_PREDIVIDER_1, ADC_DIVIDER_1,
            0);
    MAP_ADC14_setSampleHoldTime(ADC_PULSE_WIDTH_4, ADC_PULSE_WIDTH_4);
    MAP_ADC14_setResolution(ADC_14BIT);

    /* Configuring GPIOs (5.5 A0) */
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P5, GPIO_PIN5,
    GPIO_TERTIARY_MODULE_FUNCTION);

    /* Configuring ADC Memory */
    MAP_ADC14_configureSingleSampleMode(ADC_MEM0, true);
    MAP_ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
    ADC_INPUT_A0, false);

    /* Configuring Timer_A in continuous mode and sourced from ACLK */
    MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &upModeConfig);

    /* Configuring Timer_A0 in CCR1 to trigger at 16000 (0.5s) */
    MAP_Timer_A_initCompare(TIMER_A0_BASE, &compareConfig);

    /* Configuring the sample trigger to be sourced from Timer_A0  and setting it
     * to automatic iteration after it is triggered*/
    MAP_ADC14_setSampleHoldTrigger(ADC_TRIGGER_SOURCE1, false);

    /* Enabling the interrupt when a conversion on channel 1 is complete and
     * enabling conversions */
    MAP_ADC14_enableInterrupt(ADC_INT0);
    MAP_ADC14_enableConversion();

    /* Starting the Timer */
    MAP_Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);

    //Set up variables for kissFFT
    int16_t resultsBuffer[SAMPLES];
    kiss_fft_cpx  fft_out[SAMPLES];
    kiss_fftr_cfg  kiss_fftr_state;
    kiss_fftr_state = kiss_fftr_alloc(SAMPLES,0,0,0);

    //Point information to input buffer
    information_bytes = resultsBuffer;

    /* Enabling Interrupts */
    MAP_Interrupt_enableInterrupt(INT_ADC14);
    MAP_Interrupt_enableMaster();

    int i;

    while (1)
    {
        //MAP_PCM_gotoLPM0();
        if (sendValues == 1)
        {
            //Preprocess data
            average_preprocess(resultsBuffer, SAMPLES);

            //Send time data
            for (i=0; i<SAMPLES; i++)
            {
                sendReading(resultsBuffer[i]);
            }

            //Perform FFT
            kiss_fftr(kiss_fftr_state,resultsBuffer,fft_out);

            /* Calculate the magnitude of the results. */
            for (i = 0; i < SAMPLES/2; i++) {
                resultsBuffer[i] = _Qmag(fft_out[i].r, fft_out[i].i);
            }

            //Send frequency data
            for (i=0; i<((SAMPLES/2)); i++)
            {
                sendReading(resultsBuffer[i]);
            }

            int16_t fft_max = max(resultsBuffer, (SAMPLES/2));
            sendReading(fft_max);

            int16_t fft_RMS = RMS(resultsBuffer, (SAMPLES/2));
            sendReading(fft_RMS);

            int16_t fft_std = STD(resultsBuffer, (SAMPLES/2));
            sendReading(fft_std);

            resPos = 0;
            sendValues = 0;
        }
    }
}

/* This interrupt is fired whenever a conversion is completed and placed in
 * ADC_MEM0 */
void ADC14_IRQHandler(void)
{
    if(resPos < SAMPLES)
    {
        //resultsBuffer[resPos++] = MAP_ADC14_getResult(ADC_MEM0);
        information_bytes[resPos++] = MAP_ADC14_getResult(ADC_MEM0);
        //resPos++;
    }
    else
    {
        //Stop reading values
        MAP_Interrupt_disableInterrupt(INT_ADC14);
        //Send values
        sendValues = 1;
    }
}

void PORT1_IRQHandler(void)
{
    uint32_t status = MAP_GPIO_getEnabledInterruptStatus(GPIO_PORT_P1);
    MAP_GPIO_clearInterruptFlag(GPIO_PORT_P1, status);

    /* Handles S1 button press */
    if (status & GPIO_PIN1)
    {
        //Enable ADC reads
        MAP_Interrupt_enableInterrupt(INT_ADC14);
    }
}

void EUSCIA0_IRQHandler(void)
{
   if (UCA0IFG & UCRXIFG)
    {
      while(!(UCA0IFG&UCTXIFG));
//      asm(" nop");
        //UCA0TXBUF = UCA0RXBUF;
        uint8_t color = UCA0RXBUF;
        UART_transmitData(EUSCI_A0_BASE, color);
        UART_transmitData(EUSCI_A0_BASE, '\n');
//      __no_operation();
    }
}
