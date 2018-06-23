/*******************************************************************************
 * MSP432 PCM - LPM3.5 with RTC Wake-Up
 *
 * Description: In this example, the use of LPM3.5 is shown with the
 * use of an RTC interrupt to "revive" the device. The RTC module is setup and
 * an alarm is set to fire an interrupt event one minute after the timer is
 * started. After the timer is started, the device is put into LPM3.5
 * by use of the PCM_shutdownDevice API. When the minute passes, an interrupt
 * is fired on the RTC which causes the device to reset. After the device is
 * reset, the IFG for the alarm is still pending ion the RTC controller. When
 * interrupts are enabled after the reset, this pending IFG will cause the
 * RTC ISR to fire and a flag is set. This flag will be caught by the main
 * execution of the program and an LED will be set indefinitely.
 *
 *                MSP432P401
 *             ------------------
 *         /|\|                  |
 *          | |                  |
 *          --|RST         P1.0  |---> P1.0 LED
 *            |                  |
 *            |                  |
 *            |                  |
 *            |                  |
 *
  *******************************************************************************/
/* DriverLib Includes */
#include <ti/devices/msp432p4xx/driverlib/driverlib.h>

/* Standard Includes */
#include <stdint.h>
#include <stdbool.h>

/*
 * Initializing calendar to 11/19/2013 (Tuesday) 10:10:00
 */
const RTC_C_Calendar calendarTime =
{
    0,      /* Seconds */
    10,     /* Minutes */
    10,     /* Hour */
    2,      /* Day of Week */
    19,     /* Day */
    11,     /* Month */
    2013    /* Year */
};

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

int main(void)
{
    /* Halting the Watchdog */
    MAP_WDT_A_holdTimer();

    /* If this flag has been set, it means that the device has already
     * been into LPM3.5 mode before. In this case, we want to blink
     * an LED to signal the reset.
     */
    if (MAP_ResetCtl_getPCMSource() & RESET_LPM35)
    {
        /* Clearing the PCM Reset flags */
        MAP_ResetCtl_clearPCMFlags();

        /* Unlocking the latched GPIO/LPM configuration flag */
        PCM->CTL1 = PCM_CTL1_KEY_VAL;

        /* Putting P1.0 high to signal reset */
        MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);
        MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P1, GPIO_PIN0);
        while(1);
    }

    /* Terminating all remaining pins to minimize power consumption. This is
        done by register accesses for simplicity and to minimize branching API
        calls */
    MAP_GPIO_setAsOutputPin(GPIO_PORT_PA, PIN_ALL16);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_PB, PIN_ALL16);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_PC, PIN_ALL16);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_PD, PIN_ALL16);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_PE, PIN_ALL16);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_PJ, PIN_ALL16);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_PA, PIN_ALL16);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_PB, PIN_ALL16);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_PC, PIN_ALL16);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_PD, PIN_ALL16);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_PE, PIN_ALL16);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_PJ, PIN_ALL16);

    /* Configuring LFXTOUT and LFXTIN for XTAL operation and P1.0 for LED */
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_PJ,
            GPIO_PIN0 | GPIO_PIN1, GPIO_PRIMARY_MODULE_FUNCTION);

    /* Setting LFXT to lowest drive strength and current consumption */
    MAP_CS_startLFXT(CS_LFXT_DRIVE0);

    /* Disabling high side voltage monitor/supervisor */
    MAP_PSS_disableHighSide();

    /* Initializing RTC to 11/19/2013 10:10:00 */
    MAP_RTC_C_initCalendar(&calendarTime, RTC_C_FORMAT_BINARY);

    /* Setting alarm for one minute later */
    MAP_RTC_C_setCalendarAlarm(11,10,2,19);

    /* Setting up interrupts for the RTC. Once we enable interrupts, if there
     * was a pending interrupt due to a wake-up from partial shutdown then the
     * ISR will immediately fire and blinkLED will be set to true.*/
    MAP_RTC_C_enableInterrupt(RTC_C_CLOCK_ALARM_INTERRUPT);
    MAP_Interrupt_enableInterrupt(INT_RTC_C);
    MAP_Interrupt_enableMaster();

    /* Starting the RTC and going into LP3.5 */
    MAP_RTC_C_startClock();

    /* Selecting P1.2 and P1.3 in UART mode */
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P1,
    GPIO_PIN2 | GPIO_PIN3, GPIO_PRIMARY_MODULE_FUNCTION);
    //MAP_PCM_shutdownDevice(PCM_LPM35_VCORE0);

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

    while (1)
    {

    }
}

/* RTC ISR */
void RTC_C_IRQHandler(void)
{
    MAP_RTC_C_clearInterruptFlag(MAP_RTC_C_getInterruptStatus());
    UART_transmitData(EUSCI_A0_BASE, 't');
    UART_transmitData(EUSCI_A0_BASE, '\n');
}
