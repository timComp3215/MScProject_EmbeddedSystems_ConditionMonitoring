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

 *
 *                MSP432P401
 *             ------------------
 *         /|\|                  |
 *          | |                  |
 *          --|RST         P5.5  |<--- A0  (Analog Input)
 *            |            P5.4  |<--- A1  (Analog Input)
 *            |                  |
 *            |            P6.0  |<--- A15 (Analog Input)
 *            |                  |
 *            |                  |
 *
 * Edited version of example code to send ADC reading over serial in ASCII
 * 9600 baud rate
 *
 * Read SAMPLES no of ADC reading on push button 1.1 (S1)
 *
 * Remove averaging, add ability to read from one of 3 analog inputs
 * Adding configure_analog function to do this
 * Using this program as a testbed as it is more simple than FFT_uart program
 *
 ******************************************************************************/
/* DriverLib Includes */
#include <ti/devices/msp432p4xx/driverlib/driverlib.h>

/* Standard Includes */
#include <stdint.h>
#include <stdbool.h>

//Sample size
#define SAMPLES 16

//![Simple UART Config]
/* UART Configuration Parameter. These are the configuration parameters to
 * make the eUSCI A UART module to operate with a 9600 baud rate. These
 * values were calculated using the online calculator that TI provides
 * at:
 *http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSP430BaudRateConverter/index.html
 */

void sendReading(int16_t reading)
{
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

    mean /= SAMPLES;

    int16_t int_mean = (int16_t)(mean + 0.5);

    //Subtract
    for (i=0; i<SAMPLES; i++)
    {
        readings[i] -= int_mean;
    }
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
        TIMER_A_CLOCKSOURCE_DIVIDER_1,       // ACLK/1 = 32.768 kHz
        255,
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
        254                                       // 16000 Period
};

void configure_analog(uint8_t channel)
{
    //Configure the ADC14 for either channel A0 or A1

    //Disable interrupts
    ADC14_disableInterrupt(ADC_INT0);
    Interrupt_disableInterrupt(INT_ADC14);

    //Disable conversion
    ADC14_disableConversion();
    //Disable ADC module
    ADC14_disableModule();

    //Enable ADC module
    ADC14_enableModule();
    ADC14_initModule(ADC_CLOCKSOURCE_SMCLK, ADC_PREDIVIDER_1, ADC_DIVIDER_1,
            0);
    ADC14_setSampleHoldTime(ADC_PULSE_WIDTH_4, ADC_PULSE_WIDTH_4);
    ADC14_setResolution(ADC_14BIT);

    /* Configuring ADC Memory (ADC_MEM0 A15 in single sample mode)  */
    ADC14_configureSingleSampleMode(ADC_MEM0, true);

    /* Configure for input channel 15 (P6.0) and to use default Vref setting
     * which uses Vcc = 3.3V */
    if (channel == 0)
    {
        ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
            ADC_INPUT_A0, false);
    }
    else if (channel == 1)
    {
        ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
            ADC_INPUT_A1, false);
    }
    else if (channel == 2)
    {
        ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
            ADC_INPUT_A15, false);

    }

    ADC14_setSampleHoldTrigger(ADC_TRIGGER_SOURCE1, false);

    ADC14_enableInterrupt(ADC_INT0);
    //Interrupt_enableInterrupt(INT_ADC14);

    /* Tell ADC to wait for request on each sample - Conversion Trigger */
    //ADC14_enableSampleTimer(ADC_MANUAL_ITERATION);

    /* Triggering the start of the sample */
    ADC14_enableConversion();
}

/* Statics */
volatile int16_t resultsBuffer[SAMPLES];
volatile uint16_t resPos = 0;
volatile uint8_t stateCounter = 0;

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
    //MAP_ADC14_enableModule();
    //MAP_ADC14_initModule(ADC_CLOCKSOURCE_SMCLK, ADC_PREDIVIDER_1, ADC_DIVIDER_1,
    //        0);
    //MAP_ADC14_setSampleHoldTime(ADC_PULSE_WIDTH_4, ADC_PULSE_WIDTH_4);
    //MAP_ADC14_setResolution(ADC_14BIT);

    /* Configuring GPIOs (5.5 - A0, 5.4 - A1, 6.0 - A15) */
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P5, GPIO_PIN5,
    GPIO_TERTIARY_MODULE_FUNCTION);


    /* Configuring ADC Memory */
    //MAP_ADC14_configureSingleSampleMode(ADC_MEM0, true);
    //MAP_ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
    //ADC_INPUT_A0, false);

    /* Configuring Timer_A in continuous mode and sourced from ACLK */
    MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &upModeConfig);

    /* Configuring Timer_A0 in CCR1 to trigger at 16000 (0.5s) */
    MAP_Timer_A_initCompare(TIMER_A0_BASE, &compareConfig);

    /* Configuring the sample trigger to be sourced from Timer_A0  and setting it
     * to automatic iteration after it is triggered*/
    //MAP_ADC14_setSampleHoldTrigger(ADC_TRIGGER_SOURCE1, false);

    /* Enabling the interrupt when a conversion on channel 1 is complete and
     * enabling conversions */
    //MAP_ADC14_enableInterrupt(ADC_INT0);
    //MAP_ADC14_enableConversion();

    configure_analog(0);

    /* Enabling Interrupts */
    MAP_Interrupt_enableInterrupt(INT_ADC14);
    MAP_Interrupt_enableMaster();

    /* Starting the Timer */
    MAP_Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);

    int i;

    while (1)
    {
        //MAP_PCM_gotoLPM0();
        if (stateCounter == 1)
        {
            //average_preprocess(resultsBuffer, SAMPLES);

            for (i=0; i<SAMPLES; i++)
            {
                sendReading(resultsBuffer[i]);
            }
            resPos = 0;
            stateCounter = 0;
        }
    }
}

/* This interrupt is fired whenever a conversion is completed and placed in
 * ADC_MEM0 */
void ADC14_IRQHandler(void)
{
    if(resPos < SAMPLES)
    {
        resultsBuffer[resPos] = MAP_ADC14_getResult(ADC_MEM0);
        resPos++;
    }
    else
    {
        //Stop reading values
        MAP_Interrupt_disableInterrupt(INT_ADC14);
        //Send values
        stateCounter = 1;
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
