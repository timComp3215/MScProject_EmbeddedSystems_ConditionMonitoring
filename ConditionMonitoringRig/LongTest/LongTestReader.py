'''
Read ADC samples from board
Read FFT data from board
Convert to voltage
Display time series data
Diplay FFT data
Output data to csv file
'''

##fields=(
##    ('Gap', 'gap'),
##    ('Type', 'type', str),
##    ('Domain', 'domain', str),
##    ('Hour', 'hour', int),
##    ('Min', 'min', int),
##    ('Max_freq', 'max_freq', int),
##    ('Max', 'max', int),
##    ('RMS', 'rms', int),
##    ('STD', 'std', int),
##    ('Condition', 'condition', str),
##    ('Runtime', 'runtime', int)
##    )


#Import libraries
import serial
import csv
import matplotlib.pyplot as plt
import pynmea2 as nmea
import datetime

#Set length of signal
SAMPLES = 4096

#Sampling frequency - purely for graphs to be correctly scaled
fs = 8192

condition = 'B'
test = 4

t1 = datetime.datetime.now()

#set name of output file
#output_file = 'adc_output.csv'
output_file = 'A/t_' + condition + '_' + str(test) + '.csv'
#fft_output_file = 'fft_output.csv'
fft_output_file = 'A/f_' + condition + '_' + str(test) + '.csv'
MCSA_file = 'MCSA'+ '_' + str(t1.hour) + str(t1.minute)+ '.csv'
Vib_t_file = 'Vib_t' + '_' + str(t1.hour) + str(t1.minute) + '.csv'
Vib_f_file = 'Vib_f' + '_' + str(t1.hour) + str(t1.minute) + '.csv'

#Connect to serial channel and send input
s = serial.Serial('COM4', 9600)

count = 1

#Initialise new files
with open(MCSA_file, 'wb') as fout:
    writer = csv.writer(fout)
    writer.writerow(['Hour', 'Min', 'Max freq', 'Max', 'RMS', 'std', 'Condition', 'Runtime'])
    fout.close()

with open(Vib_t_file, 'wb') as fout:
    writer = csv.writer(fout)
    writer.writerow(['Hour', 'Min', 'Max', 'RMS', 'std', 'Condition', 'Runtime'])
    fout.close()

with open(Vib_f_file, 'wb') as fout:
    writer = csv.writer(fout)
    writer.writerow(['Hour', 'Min', 'Max freq', 'Max', 'RMS', 'std', 'Condition', 'Runtime'])
    fout.close()

while (1):
    print "Waiting for reading " + str(count)

    data = s.readline()

    msg = nmea.parse(data,check=False)

    print msg

    if (msg.type == 'M'):
        with open(MCSA_file, 'ab') as fout:
            writer = csv.writer(fout)
            writer.writerow([msg.hour, msg.min, msg.max_freq, msg.max, msg.rms, msg.std, msg.condition, msg.runtime])
            fout.close()

    if (msg.type == 'V'):
        if (msg.domain == 'T'):
            with open(Vib_t_file, 'ab') as fout:
                writer = csv.writer(fout)
                writer.writerow([msg.hour, msg.min, msg.max, msg.rms, msg.std, msg.condition, msg.runtime])
                fout.close()
        elif (msg.domain == 'F'):
            with open(Vib_f_file, 'ab') as fout:
                writer = csv.writer(fout)
                writer.writerow([msg.hour, msg.min, msg.max_freq, msg.max, msg.rms, msg.std, msg.condition, msg.runtime])
                fout.close()
    
    count = count + 1
