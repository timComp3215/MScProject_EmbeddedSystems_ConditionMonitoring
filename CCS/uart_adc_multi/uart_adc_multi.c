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
/******************************************************************************
This is intended to be a simple demonstration of the ADC using P6.0

Serial connection 9600 8N1

Should be able to set to a reference voltage of 3.3V

When M is sent via serial, return a value between 0 and 16383, giving the
ADC result directly (2^14-1)

I will leave in the RGB LED commands for easy debugging to check the serial
connection is not the problem

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
 *
 * Selecting 0, 1, 2, reconfigures the ADC to take measurements from a different ADC channel
 *******************************************************************************/
/* DriverLib Includes */
#include <ti/devices/msp432p4xx/driverlib/driverlib.h>

/* Standard Includes */
#include <stdint.h>
#include <stdbool.h>

volatile uint32_t cal30;
volatile uint32_t cal85;
volatile float calDifference;
volatile float tempC;
volatile float tempF;

void RGB(char color)
{
    if (color == 'R')
    {
        GPIO_setOutputHighOnPin(
                    GPIO_PORT_P2,
                    GPIO_PIN0
                    );
        GPIO_setOutputLowOnPin(
                    GPIO_PORT_P2,
                    GPIO_PIN1
                    );
        GPIO_setOutputLowOnPin(
                    GPIO_PORT_P2,
                    GPIO_PIN2
                    );
    }
    else if (color == 'G')
    {
        GPIO_setOutputLowOnPin(
                    GPIO_PORT_P2,
                    GPIO_PIN0
                    );
        GPIO_setOutputHighOnPin(
                    GPIO_PORT_P2,
                    GPIO_PIN1
                    );
        GPIO_setOutputLowOnPin(
                    GPIO_PORT_P2,
                    GPIO_PIN2
                    );
    }
    else if (color == 'B')
    {
        GPIO_setOutputLowOnPin(
                    GPIO_PORT_P2,
                    GPIO_PIN0
                    );
        GPIO_setOutputLowOnPin(
                    GPIO_PORT_P2,
                    GPIO_PIN1
                    );
        GPIO_setOutputHighOnPin(
                    GPIO_PORT_P2,
                    GPIO_PIN2
                    );
    }
}

void getVoltage(void)
{
    /*This module use the ADC to measure the voltage at P6.0
     * and send it in ASCII over serial port
     */

    uint8_t ascii_num[10] = {0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39};

    //Manually request conversion
    ADC14_toggleConversionTrigger();

    uint16_t Voltage;

    Voltage = ADC14_getResult(ADC_MEM0);

    UART_transmitData(EUSCI_A0_BASE, ascii_num[(Voltage / 10000)]);
    UART_transmitData(EUSCI_A0_BASE, ascii_num[((Voltage % 10000)/1000)]);
    UART_transmitData(EUSCI_A0_BASE, ascii_num[((Voltage % 1000)/100)]);
    UART_transmitData(EUSCI_A0_BASE, ascii_num[((Voltage % 100)/10)]);
    UART_transmitData(EUSCI_A0_BASE, ascii_num[(Voltage % 10)]);
    UART_transmitData(EUSCI_A0_BASE, '\n');

}

//![Simple UART Config]
/* UART Configuration Parameter. These are the configuration parameters to
 * make the eUSCI A UART module to operate with a 9600 baud rate. These
 * values were calculated using the online calculator that TI provides
 * at:
 *http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSP430BaudRateConverter/index.html
 */

//Configures to 9600 baud rate at this clock speed
const eUSCI_UART_Config uartConfig =
{
        EUSCI_A_UART_CLOCKSOURCE_SMCLK,          // SMCLK Clock Source
        78,                                     // BRDIV = 78
        2,                                       // UCxBRF = 2
        0,                                       // UCxBRS = 0
        EUSCI_A_UART_NO_PARITY,                  // No Parity
        EUSCI_A_UART_LSB_FIRST,                  // LSB First
        EUSCI_A_UART_ONE_STOP_BIT,               // One stop bit
        EUSCI_A_UART_MODE,                       // UART mode
        EUSCI_A_UART_OVERSAMPLING_BAUDRATE_GENERATION  // Oversampling
};
//![Simple UART Config]

//RGB select
volatile char color = 0;

void configure_analog(uint8_t channel)
{
    //Configure the ADC14 for either channel A0 or A1

    //Disable conversion
    ADC14_disableConversion();
    //Disable ADC module
    ADC14_disableModule();

    //Enable ADC module
    ADC14_enableModule();

    //Initialise with clock and suitable predivider
    ADC14_initModule(ADC_CLOCKSOURCE_MCLK, ADC_PREDIVIDER_1, ADC_DIVIDER_1,
            0);

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

    /* Tell ADC to wait for request on each sample - Conversion Trigger */
    ADC14_enableSampleTimer(ADC_MANUAL_ITERATION);

    /* Triggering the start of the sample */
    ADC14_enableConversion();
}

int main(void)
{
    /* Halting WDT  */
    MAP_WDT_A_holdTimer();

    /* Selecting P1.2 and P1.3 in UART mode */
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P1,
            GPIO_PIN2 | GPIO_PIN3, GPIO_PRIMARY_MODULE_FUNCTION);

    /* Setting DCO to 12MHz */
    CS_setDCOCenteredFrequency(CS_DCO_FREQUENCY_12);

    //![Simple UART Example]
    /* Configuring UART Module */
    MAP_UART_initModule(EUSCI_A0_BASE, &uartConfig);

    /* Enable UART module */
    MAP_UART_enableModule(EUSCI_A0_BASE);

    /* Enabling interrupts */
    MAP_UART_enableInterrupt(EUSCI_A0_BASE, EUSCI_A_UART_RECEIVE_INTERRUPT);
    MAP_Interrupt_enableInterrupt(INT_EUSCIA0);
    //MAP_Interrupt_enableSleepOnIsrExit();
    MAP_Interrupt_enableMaster();   
    //![Simple UART Example]

    volatile uint32_t i;

    // Stop watchdog timer
    WDT_A_hold(WDT_A_BASE);

    // Set P1.0 to output direction
    GPIO_setAsOutputPin(
        GPIO_PORT_P1,
        GPIO_PIN0
        );

    //RED LED
    GPIO_setAsOutputPin(
            GPIO_PORT_P2,
            GPIO_PIN0
            );

    //GREEN LED
    GPIO_setAsOutputPin(
            GPIO_PORT_P2,
            GPIO_PIN1
            );

    //BLUE LED
    GPIO_setAsOutputPin(
            GPIO_PORT_P2,
            GPIO_PIN2
            );

    //ADC STUFF
    /* Initializing ADC (MCLK/1/1) */

    //Set up GPIO Pin P5.5, P5.4 as Analogue Input
    GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P5,
            GPIO_PIN5 | GPIO_PIN4, GPIO_TERTIARY_MODULE_FUNCTION);
    //Set up GPIO Pin P6.0 as Analogue Input
    GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P6,
            GPIO_PIN0, GPIO_TERTIARY_MODULE_FUNCTION);

    //Enable ADC module
    //ADC14_enableModule();

    //Initialise with clock and suitable predivider
    //ADC14_initModule(ADC_CLOCKSOURCE_MCLK, ADC_PREDIVIDER_1, ADC_DIVIDER_1,
    //        0);

    /* Configuring ADC Memory (ADC_MEM0 A15 in single sample mode)  */
    //ADC14_configureSingleSampleMode(ADC_MEM0, true);

    /* Configure for input channel 15 (P6.0) and to use default Vref setting
     * which uses Vcc = 3.3V */
    //ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
    //        ADC_INPUT_A1, false);

    /* Tell ADC to wait for request on each sample - Conversion Trigger */
    //ADC14_enableSampleTimer(ADC_MANUAL_ITERATION);

    /* Triggering the start of the sample */
    //ADC14_enableConversion();

    configure_analog(2);

    while(1)
    {
        //Goes to low power mode !? If removed it doesn't return from interrupt properly
        //MAP_PCM_gotoLPM0(); //Exits the main loop to go to its own loop which is not well explained.


        // Toggle P1.0 output
        GPIO_toggleOutputOnPin(
            GPIO_PORT_P1,
            GPIO_PIN0
            );

        RGB(color);

        if (color == 'M')
        {
            getVoltage();
            color = 'm';//Prevents continuous reading
        }
        else if (color == '0')
        {
            configure_analog(0);
        }
        else if (color == '1')
        {
            configure_analog(1);
        }
        else if (color == '2')
        {
            configure_analog(2);
        }

        // Delay
        for(i=600000; i>0; i--);

    }
}

void EUSCIA0_IRQHandler(void)
{
   if (UCA0IFG & UCRXIFG)
    {
      while(!(UCA0IFG&UCTXIFG));
//      asm(" nop");
        //UCA0TXBUF = UCA0RXBUF;
        color = UCA0RXBUF;
        UART_transmitData(EUSCI_A0_BASE, color);
        UART_transmitData(EUSCI_A0_BASE, '\n');
//      __no_operation();
    }
}
