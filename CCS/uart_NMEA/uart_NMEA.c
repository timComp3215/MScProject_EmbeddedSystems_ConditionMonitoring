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

#include <assert.h>

struct NMEA_msg {
    RTC_C_Calendar dateTime;
    char type;
    char domain;
    uint16_t max;
    uint16_t RMS;
    uint16_t std;
};

/*
 * Initializing calendar to 11/19/2018 (Tuesday) 10:10:00
 */
const RTC_C_Calendar calendarTime =
{
    0,      /* Seconds */
    10,     /* Minutes */
    10,     /* Hour */
    2,      /* Day of Week */
    19,     /* Day */
    11,     /* Month */
    2018    /* Year */
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

volatile uint8_t timeSend = 1;//High from RTC interrupt to request sending time data

void sendASCII(uint8_t data)
{
    /* Send the byte as an ASCII number */

    uint8_t ascii_num[10] = {0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39};

    if (data <= 9)
    {
        UART_transmitData(EUSCI_A0_BASE, ascii_num[data]);
    }
    else
    {
        UART_transmitData(EUSCI_A0_BASE, '?');//Error symbol
    }

}

void sendNMEA(struct NMEA_msg msg)
{
    //Send an NMEA string

    //Check data types
    assert(msg.type == 'V' | msg.type == 'M');
    assert(msg.domain == 'T' | msg.domain == 'F');
    assert(msg.max > 0 && msg.max < 10000);
    assert(msg.RMS > 0 && msg.RMS < 10000);
    assert(msg.std > 0 && msg.std < 10000);


    //Format
    //$PCBM
    UART_transmitData(EUSCI_A0_BASE, '$');
    UART_transmitData(EUSCI_A0_BASE, 'P');
    UART_transmitData(EUSCI_A0_BASE, 'C');
    UART_transmitData(EUSCI_A0_BASE, 'B');
    UART_transmitData(EUSCI_A0_BASE, 'M');
    UART_transmitData(EUSCI_A0_BASE, ',');
    //YYMMDD
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.year%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.year%10));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.month%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.month%10));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.dayOfmonth%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.dayOfmonth%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //hhmm
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.hours%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.hours%10));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.minutes%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.minutes%10));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.seconds%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (char)(msg.dateTime.seconds%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //Letter 1 - V = Vibration, M = MCSA
    UART_transmitData(EUSCI_A0_BASE, msg.type);
    UART_transmitData(EUSCI_A0_BASE, ',');
    //Letter 2 - T - Time-based data, F = Frequency based data
    UART_transmitData(EUSCI_A0_BASE, msg.domain);
    UART_transmitData(EUSCI_A0_BASE, ',');
    //max
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max/1000));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max%1000)/100);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //RMS
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.RMS/1000));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.RMS%1000)/100);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.RMS%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.RMS%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //std
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.std/1000));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.std%1000)/100);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.std%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.std%10));
    //UART_transmitData(EUSCI_A0_BASE, ',');

    //<cr><lf>
    UART_transmitData(EUSCI_A0_BASE, 0x13);
    UART_transmitData(EUSCI_A0_BASE, 0x10);

}

int main(void)
{
    /* Halting the Watchdog */
    MAP_WDT_A_holdTimer();

    /* Configuring LFXTOUT and LFXTIN for XTAL operation and P1.0 for LED */
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_PJ,
            GPIO_PIN0 | GPIO_PIN1, GPIO_PRIMARY_MODULE_FUNCTION);

    /* Setting LFXT to lowest drive strength and current consumption */
    MAP_CS_startLFXT(CS_LFXT_DRIVE0);

    /* Initializing RTC time */ //Already initialised
    MAP_RTC_C_initCalendar(&calendarTime, RTC_C_FORMAT_BINARY);

    /* Setting event for every minute */
    //MAP_RTC_C_setCalendarAlarm(11,10,2,19);
    RTC_C_setCalendarEvent(RTC_C_CALENDAREVENT_MINUTECHANGE);

    /* Setting up interrupts for the RTC. Once we enable interrupts, if there
     * was a pending interrupt due to a wake-up from partial shutdown then the
     * ISR will immediately fire and blinkLED will be set to true.*/
    MAP_RTC_C_enableInterrupt(RTC_C_TIME_EVENT_INTERRUPT);
    MAP_Interrupt_enableInterrupt(INT_RTC_C);
    //MAP_Interrupt_enableMaster();

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
    //MAP_UART_enableInterrupt(EUSCI_A0_BASE, EUSCI_A_UART_RECEIVE_INTERRUPT);
    //MAP_Interrupt_enableInterrupt(INT_EUSCIA0);
    //MAP_Interrupt_enableSleepOnIsrExit();

    //Enable interrupts
    MAP_Interrupt_enableMaster();

    //RTC_C_Calendar currentTime;

    struct NMEA_msg msg1;

    while (1)
    {
        if (timeSend == 1)
        {
            msg1.dateTime = RTC_C_getCalendarTime();
            msg1.type = 'V';
            msg1.domain = 'T';
            msg1.max = 7654;
            msg1.RMS = 7890;
            msg1.std = 9999;

            sendNMEA(msg1);

            msg1.type = 'M';
            msg1.domain = 'F';
            msg1.max = 8394;
            msg1.RMS = 7777;
            msg1.std = 5897;

            sendNMEA(msg1);

            timeSend = 0;
        }
    }
}

/* RTC ISR */
void RTC_C_IRQHandler(void)
{
    MAP_RTC_C_clearInterruptFlag(MAP_RTC_C_getInterruptStatus());
    timeSend = 1;
}
