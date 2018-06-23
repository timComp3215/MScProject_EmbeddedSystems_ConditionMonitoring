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
 * MSP432 UART - PC Echo with 12MHz BRCLK
 *
 * Description: This demo echoes back characters received via a PC serial port.
 * SMCLK/DCO is used as a clock source and the device is put in LPM0
 * The auto-clock enable feature is used by the eUSCI and SMCLK is turned off
 * when the UART is idle and turned on when a receive edge is detected.
 * Note that level shifter hardware is needed to shift between RS232 and MSP
 * voltage levels.
 *
 *               MSP432P401
 *             -----------------
 *            |                 |
 *            |                 |
 *            |                 |
 *       RST -|     P1.3/UCA0TXD|----> PC (echo)
 *            |                 |
 *            |                 |
 *            |     P1.2/UCA0RXD|<---- PC
 *            |                 |
 *
 *
 *
 * This program implements an echo of a 16 bit integer as 2 8 bit bytes
 *
 *
 *******************************************************************************/
/* DriverLib Includes */
#include <ti/devices/msp432p4xx/driverlib/driverlib.h>

/* Standard Includes */
#include <stdint.h>
#include <stdbool.h>

/*void RGB(char color)
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
}*/

//![Simple UART Config]
/* UART Configuration Parameter. These are the configuration parameters to
 * make the eUSCI A UART module to operate with a 9600 baud rate. These
 * values were calculated using the online calculator that TI provides
 * at:
 *http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSP430BaudRateConverter/index.html
 */
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
//volatile char color = 0;
volatile int bytes = 0;
volatile char msg;
char *information_bytes;

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
    /*GPIO_setAsOutputPin(
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
    */

    const int rcvMessageSize = 1;//Size of received message array
    const int sndMessageSize = 1;//Size of sending message array

    uint16_t information[rcvMessageSize];
    //char *information_bytes;

    information_bytes = (char*)&information;

    while(1)
    {
        //Wait until two bytes have been read in
        //Then reply with echo message
        //if (bytes == 1)
        //{
        //    information_bytes[0] = msg;
        //}
        if (bytes == (rcvMessageSize*2))
        {
            //information_bytes[1] = msg;

            //Transmit
            int sendByteCount;
            for (sendByteCount = 0; sendByteCount < sndMessageSize; sendByteCount++)
            {
                UART_transmitData(EUSCI_A0_BASE, (information[sendByteCount]%256));
                UART_transmitData(EUSCI_A0_BASE, (information[sendByteCount]/256));
                UART_transmitData(EUSCI_A0_BASE, '\n');
            }

            bytes = 0;
        }

    }
}

/* EUSCI A0 UART ISR - Echoes data back to PC host */
/*void EUSCIA0_IRQHandler(void)
{
    uint32_t status = MAP_UART_getEnabledInterruptStatus(EUSCI_A0_BASE);

    MAP_UART_clearInterruptFlag(EUSCI_A0_BASE, status);

    if(status & EUSCI_A_UART_RECEIVE_INTERRUPT_FLAG)
    {
        MAP_UART_transmitData(EUSCI_A0_BASE, MAP_UART_receiveData(EUSCI_A0_BASE));
    }

}*/

void EUSCIA0_IRQHandler(void)
{
   if (UCA0IFG & UCRXIFG)
    {
      while(!(UCA0IFG&UCTXIFG));
//      asm(" nop");
        //UCA0TXBUF = UCA0RXBUF;
        msg = UCA0RXBUF;
        information_bytes[bytes] = msg;
        bytes++;

        //UART_transmitData(EUSCI_A0_BASE, color);
        //UART_transmitData(EUSCI_A0_BASE, '\n');
//      __no_operation();
    }
}
