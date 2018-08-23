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
 *
 *                MSP432P401
 *             ------------------
 *         /|\|                  |
 *          | |                  |
 *          --|RST         P5.5  |<--- A0 (Analog Input)
 *            |            P5.4  |<--- A1 (Analog Input)
 *            |                  |
 *            |                  |
 *            |                  |
 *            |                  |
 *
 *
 * Testing reading of multiple channels via reading one channel, performing processing and
 * thereby triggering reading of another channel
 *
 * Send readings out as NMEA message
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
//Sampling rate (Hz)
#define FSV 16384 //Vibration
#define FSM 4096 //MCSA

//![Simple UART Config]
/* UART Configuration Parameter. These are the configuration parameters to
 * make the eUSCI A UART module to operate with a 9600 baud rate. These
 * values were calculated using the online calculator that TI provides
 * at:
 *http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSP430BaudRateConverter/index.html
 */

//Define structure of NMEA message
struct NMEA_msg {
    char type;
    char domain;
    uint8_t hour;
    uint8_t min;
    uint16_t max_freq;
    uint16_t max;
    uint16_t RMS;
    uint16_t std;
    char condition;
    uint16_t runTime;
};

//Initialize RTC to 00:00:00, to record time from start of test
const RTC_C_Calendar calendarTime =
{
    0,      /* Seconds */
    0,     /* Minutes */
    0,     /* Hour */
    0,      /* Day of Week */
    1,     /* Day */
    1,     /* Month */
    2018    /* Year */
};

void configure_analog(uint8_t channel)
{
    //Configure the ADC14

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

    /* Configuring ADC Memory */
    ADC14_configureSingleSampleMode(ADC_MEM0, true);

    /* Configure for input channel 15 (P6.0) and to use default Vref setting
     * which uses Vcc = 3.3V */
    if (channel == 0)
    {
        //P5.5
        ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
            ADC_INPUT_A0, false);
    }
    else if (channel == 1)
    {
        //P5.4
        ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
            ADC_INPUT_A1, false);
    }
    else if (channel == 2)
    {
        //P6.0
        ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
            ADC_INPUT_A15, false);
    }

    ADC14_setSampleHoldTrigger(ADC_TRIGGER_SOURCE1, false);

    /* Triggering the start of the sample */
    ADC14_enableConversion();
}

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

    //Format
    //$PCBM
    UART_transmitData(EUSCI_A0_BASE, '$');
    UART_transmitData(EUSCI_A0_BASE, 'P');
    UART_transmitData(EUSCI_A0_BASE, 'C');
    UART_transmitData(EUSCI_A0_BASE, 'B');
    UART_transmitData(EUSCI_A0_BASE, 'M');
    UART_transmitData(EUSCI_A0_BASE, ',');

    //Letter 1 - V = Vibration, M = MCSA
    UART_transmitData(EUSCI_A0_BASE, msg.type);
    UART_transmitData(EUSCI_A0_BASE, ',');
    //Letter 2 - T = Time-based data, F = Frequency based data
    UART_transmitData(EUSCI_A0_BASE, msg.domain);
    UART_transmitData(EUSCI_A0_BASE, ',');
    //Hour
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.hour/10));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.hour%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //Minute
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.min/10));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.min%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //max frequency
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max_freq/10000));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max_freq%10000)/1000);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max_freq%1000)/100);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max_freq%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max_freq%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //max
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max/10000));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max%10000)/1000);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max%1000)/100);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.max%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //RMS
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.RMS/10000));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.RMS%10000)/1000);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.RMS%1000)/100);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.RMS%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.RMS%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //std
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.std/10000));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.std%10000)/1000);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.std%1000)/100);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.std%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.std%10));
    UART_transmitData(EUSCI_A0_BASE, ',');
    //Condition
    UART_transmitData(EUSCI_A0_BASE, msg.condition);
    UART_transmitData(EUSCI_A0_BASE, ',');
    //Runtime
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.runTime/10000));
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.runTime%10000)/1000);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.runTime%1000)/100);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.runTime%100)/10);
    UART_transmitData(EUSCI_A0_BASE, 0x30 + (msg.runTime%10));
    UART_transmitData(EUSCI_A0_BASE, ',');

    //<cr><lf>
    UART_transmitData(EUSCI_A0_BASE, 0x0d);
    UART_transmitData(EUSCI_A0_BASE, 0x0a);

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

uint16_t max_index(volatile int16_t *readings, uint16_t n)
{
    //This function finds the maximum value in a range
    uint16_t index = 0;
    int16_t maximum = 0;
    int i;
    for (i=0; i<n; i++)
    {
        if (readings[i] > maximum)
        {
            index = i;
            maximum = readings[i];
        }
    }

    return index;
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
const Timer_A_UpModeConfig upModeConfig_V =
{
        TIMER_A_CLOCKSOURCE_ACLK,            // ACLK Clock Source
        TIMER_A_CLOCKSOURCE_DIVIDER_1,       // ACLK/1 = 128 kHz
        1,                                  // 32.768 kHz / 2 = 16384 Hz
        TIMER_A_TAIE_INTERRUPT_DISABLE,      // Disable Timer ISR
        TIMER_A_CCIE_CCR0_INTERRUPT_DISABLE, // Disable CCR0
        TIMER_A_DO_CLEAR                     // Clear Counter
};

/* Timer_A Compare Configuration Parameter */
const Timer_A_CompareModeConfig compareConfig_V =
{
        TIMER_A_CAPTURECOMPARE_REGISTER_1,          // Use CCR1
        TIMER_A_CAPTURECOMPARE_INTERRUPT_DISABLE,   // Disable CCR interrupt
        TIMER_A_OUTPUTMODE_SET_RESET,               // Toggle output but
        1// 16000 Period
};

const Timer_A_UpModeConfig upModeConfig_M =
{
        TIMER_A_CLOCKSOURCE_ACLK,            // ACLK Clock Source
        TIMER_A_CLOCKSOURCE_DIVIDER_1,       // ACLK/1 = 128 kHz
        7,                                  // 32.768 kHz / 8 = 4096 Hz
        TIMER_A_TAIE_INTERRUPT_DISABLE,      // Disable Timer ISR
        TIMER_A_CCIE_CCR0_INTERRUPT_DISABLE, // Disable CCR0
        TIMER_A_DO_CLEAR                     // Clear Counter
};

/* Timer_A Compare Configuration Parameter */
const Timer_A_CompareModeConfig compareConfig_M =
{
        TIMER_A_CAPTURECOMPARE_REGISTER_1,          // Use CCR1
        TIMER_A_CAPTURECOMPARE_INTERRUPT_DISABLE,   // Disable CCR interrupt
        TIMER_A_OUTPUTMODE_SET_RESET,               // Toggle output but
        7// 16000 Period
};

/* Statics */
//volatile int16_t resultsBuffer[SAMPLES];
int16_t *information_bytes;
volatile uint16_t resPos = 0;
volatile uint8_t stateCounter = 0;
volatile uint8_t enableReads = 0;
volatile uint16_t runTime = 0;//Count total runtime at full speed
volatile uint8_t RTC_trigger = 0;//Treat RTC trigger differently than other triggers
volatile uint8_t setHealthyState = 1;//Save a set of variables as the healthy state

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
    MAP_UART_enableInterrupt(EUSCI_A0_BASE, EUSCI_A_UART_RECEIVE_INTERRUPT);
    MAP_Interrupt_enableInterrupt(INT_EUSCIA0);

    /* Configuring GPIOs (5.5 A0, 5.4 A1, 6.0 A15) */
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P5, GPIO_PIN5,
                   GPIO_TERTIARY_MODULE_FUNCTION);
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P6, GPIO_PIN0,
                   GPIO_TERTIARY_MODULE_FUNCTION);

    /* Configuring Timer_A in continuous mode and sourced from ACLK */
    MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &upModeConfig_M);

    /* Configuring Timer_A0 in CCR1 to trigger at 16000 (0.5s) */
    MAP_Timer_A_initCompare(TIMER_A0_BASE, &compareConfig_M);

    //Configure Analog - A0
    configure_analog(1);

    /* Starting the Timer */
    MAP_Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);

    /* Setting LFXT to lowest drive strength and current consumption */
    MAP_CS_startLFXT(CS_LFXT_DRIVE0);

    /* Initializing RTC time */
    MAP_RTC_C_initCalendar(&calendarTime, RTC_C_FORMAT_BINARY);

    /* Setting event for every minute */
    RTC_C_setCalendarEvent(RTC_C_CALENDAREVENT_MINUTECHANGE);

    //RTC interrupt
    MAP_RTC_C_enableInterrupt(RTC_C_TIME_EVENT_INTERRUPT);
    MAP_Interrupt_enableInterrupt(INT_RTC_C);
    //MAP_Interrupt_enableMaster();

    /* Starting the RTC */
    MAP_RTC_C_startClock();

    //Set up variables for kissFFT
    int16_t resultsBuffer[SAMPLES];
    kiss_fft_cpx  fft_out[SAMPLES];
    kiss_fftr_cfg  kiss_fftr_state;
    kiss_fftr_state = kiss_fftr_alloc(SAMPLES,0,0,0);

    //Point information to input buffer
    information_bytes = resultsBuffer;

    //BLUE LED
    GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN2);

    /* Enabling Interrupts */
    MAP_Interrupt_enableMaster();

    int i;
    enum analogPin {Pin_MCSA = 1, Pin_Vib = 0};
    uint8_t analogPin = Pin_MCSA;

    struct NMEA_msg message;

    RTC_C_Calendar currentTime;

    uint16_t fft_max_freq;
    uint16_t fft_max;
    uint16_t fft_RMS;
    uint16_t fft_std;

    uint8_t setHealthyCount = 0;
    float fft_max_freq_healthy;
    float fft_max_healthy;
    float fft_RMS_healthy;
    float fft_std_healthy;

    PCM_gotoLPM0();

    while (1)
    {
        if (stateCounter == 1)
        {
            //Reset results counter
            resPos = 0;

            MAP_Timer_A_stopTimer(TIMER_A0_BASE);

            //Blue LED on
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);

            currentTime = RTC_C_getCalendarTime();

            message.hour = currentTime.hours;
            message.min = currentTime.minutes;

            //Preprocess data
            average_preprocess(resultsBuffer, SAMPLES);

            //If vibration, also transmit data about the time domain of the signal
            if (analogPin == Pin_Vib)
            {
                message.type = 'V';
                message.domain = 'T';

                message.max_freq = 0;
                fft_max = max(resultsBuffer, SAMPLES);
                message.max = fft_max;

                fft_RMS = RMS(resultsBuffer, SAMPLES);
                message.RMS = fft_RMS;

                fft_std = STD(resultsBuffer, SAMPLES);
                message.std = fft_std;

                sendNMEA(message);
            }

            //Perform FFT
            kiss_fftr(kiss_fftr_state,resultsBuffer,fft_out);

            /* Calculate the magnitude of the results. */
            for (i = 0; i < SAMPLES/2; i++) {
                resultsBuffer[i] = _Qmag(fft_out[i].r, fft_out[i].i);
            }

            //Frequency domain
            message.domain = 'F';

            fft_max_freq = max_index(resultsBuffer, (SAMPLES/2));
            //sendReading(fft_max_freq);
            //message.max_freq = fft_max_freq;

            fft_max = max(resultsBuffer, (SAMPLES/2));
            //sendReading(fft_max);
            message.max = fft_max;

            fft_RMS = RMS(resultsBuffer, (SAMPLES/2));
            //sendReading(fft_RMS);
            message.RMS = fft_RMS;

            fft_std = STD(resultsBuffer, (SAMPLES/2));
            //sendReading(fft_std);
            message.std = fft_std;


            //Configure analog channel
            if (analogPin == Pin_MCSA)
            {
                //MCSA
                message.type = 'M';
                message.condition = 'H';
                message.max_freq = fft_max_freq*(FSM/SAMPLES);
                //Is frequency high enough?
                if (fft_max_freq < 1500)
                {
                    if (RTC_trigger == 1)
                    {
                        RTC_trigger = 0;
                        runTime++;
                    }

                    analogPin = 0;
                    configure_analog(analogPin);
                    enableReads = 1;
                    /* Configuring Timer_A in continuous mode and sourced from ACLK */
                    MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &upModeConfig_V);
                    /* Configuring Timer_A0 in CCR1 to trigger at 16000 (0.5s) */
                    MAP_Timer_A_initCompare(TIMER_A0_BASE, &compareConfig_V);
                }
            }
            else if(analogPin == Pin_Vib)
            {

                //Save stats as healthy state
                if (setHealthyState == 1)
                {
                    setHealthyCount++;
                    fft_max_freq_healthy = fft_max_freq;
                    fft_max_healthy = fft_max;
                    fft_RMS_healthy = fft_RMS;
                    fft_std_healthy = fft_std;

                    if (setHealthyCount == 1)
                    {
                        setHealthyCount = 0;
                        setHealthyState = 0;
                    }
                    else
                    {
                        enableReads = 1;
                    }
                }

                message.type = 'V';

                //Evaluate healthy state
                if ((fft_max_freq > (0.9*fft_max_freq_healthy)) && (fft_max_freq < (1.1*fft_max_freq_healthy)))
                {
                    message.condition = 'H';//Healthy
                }
                else
                {
                    message.condition = 'U';//Unhealthy
                }

                message.max_freq = fft_max_freq*(FSV/SAMPLES);
                analogPin = 1;
                configure_analog(analogPin);
                /* Configuring Timer_A in continuous mode and sourced from ACLK */
                MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &upModeConfig_M);
                /* Configuring Timer_A0 in CCR1 to trigger at 16000 (0.5s) */
                MAP_Timer_A_initCompare(TIMER_A0_BASE, &compareConfig_M);
            }

            message.runTime = runTime;

            sendNMEA(message);

            MAP_Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);

            stateCounter = 0;

            //Blue LED off
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);

            //Enable Push Button
            MAP_Interrupt_enableInterrupt(INT_PORT1);

            //If there is no more reading to do, go to low power mode
            if (enableReads == 0)
            {
                PCM_gotoLPM0();
            }
        }

        //Enable ADC interrupts
        if (enableReads == 1)
        {
            enableReads = 0;
            ADC14_enableInterrupt(ADC_INT0);
            Interrupt_enableInterrupt(INT_ADC14);
        }
    }
}

/* This interrupt is fired whenever a conversion is completed and placed in
 * ADC_MEM0 */
void ADC14_IRQHandler(void)
{
    if(resPos < SAMPLES)
    {
        information_bytes[resPos++] = MAP_ADC14_getResult(ADC_MEM0);
    }
    else
    {
        //Disable ADC interrupts
        Interrupt_disableInterrupt(INT_ADC14);
        ADC14_disableInterrupt(ADC_INT0);

        //Disable Push Button
        MAP_Interrupt_disableInterrupt(INT_PORT1);

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
        //Enable ADC interrupts in main
        enableReads = 1;
        setHealthyState = 1;
    }
}

void EUSCIA0_IRQHandler(void)
{
   if (UCA0IFG & UCRXIFG)
    {
      while(!(UCA0IFG&UCTXIFG));
//      asm(" nop");
        //UCA0TXBUF = UCA0RXBUF;
        uint8_t msg = UCA0RXBUF;

        if (msg == 'M')//M for measurement
        {
            //Enable ADC interrupts in main
            enableReads = 1;
        }
    }
}

void RTC_C_IRQHandler(void)
{
    MAP_RTC_C_clearInterruptFlag(MAP_RTC_C_getInterruptStatus());
    //Enable ADC interrupts in main
    enableReads = 1;
    RTC_trigger = 1;
}
