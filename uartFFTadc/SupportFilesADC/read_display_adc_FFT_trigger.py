'''
Read ADC samples from board
Read FFT data from board
Convert to voltage
Display time series data
Diplay FFT data
Output data to csv file
'''

#Import libraries
import serial
import csv
import matplotlib.pyplot as plt

#Set length of signal
SAMPLES = 4096

#Sampling frequency - purely for graphs to be correctly scaled
fs = 16394

frequency = 4095

#set name of output file
output_file = 'adc_output.csv'
#output_file = 'MEMS/t_' + str(frequency) + '_adxl002.csv'
fft_output_file = 'fft_output.csv'
#fft_output_file = 'MEMS/f_' + str(frequency) + '_adxl002.csv'

#Connect to serial channel and send input
s = serial.Serial('COM4', 9600)

print "Sending measurement request"

s.write('M')

print "Reading data from board.."

#Read time data
values = []
float_values = []
    
n=0
##for n in range(SAMPLES):
##
##    if (n == (SAMPLES/4)):
##        print "25%..."
##    elif (n == (SAMPLES/2)):
##        print "50%..."
##    elif (n == (3*SAMPLES/4)):
##        print "75%..."
##    msg = s.read(2)
##
##    #Turn signed 16 bit number back into python integer
##    receivedMsg = int(msg[0].encode('hex'), 16) + 256*int(msg[1].encode('hex'), 16)
##
##    #Signed -> Normal
##    if (receivedMsg > (2**15)-1):
##        receivedMsg = receivedMsg - (2**16)
##
##    #print str(receivedMsg)
##
##    values.append(receivedMsg)
##
##
###Read frequency data
##magnitude = []
##    
##n=0
##
##print "Reading frequency data from board.."
##for n in range(SAMPLES/2):
##
##    if (n == (SAMPLES/8)):
##        print "25%..."
##    elif (n == (SAMPLES/4)):
##        print "50%..."
##    elif (n == (3*SAMPLES/8)):
##        print "75%..."
##    msg = s.read(2)
##
##    #Turn signed 16 bit number back into python integer
##    receivedMsg = int(msg[0].encode('hex'), 16) + 256*int(msg[1].encode('hex'), 16)
##
##    #Signed -> Normal
##    if (receivedMsg > (2**15)-1):
##        receivedMsg = receivedMsg - (2**16)
##
##    #print str(receivedMsg)
##
##    magnitude.append(receivedMsg)

#Get maximum
msg = s.read(2)
#Turn signed 16 bit number back into python integer
receivedMsg = int(msg[0].encode('hex'), 16) + 256*int(msg[1].encode('hex'), 16)
#Signed -> Normal
if (receivedMsg > (2**15)-1):
    receivedMsg = receivedMsg - (2**16)
fft_max = receivedMsg

print "Maximum: ", str(fft_max);

#Get RMSE
msg = s.read(2)
#Turn signed 16 bit number back into python integer
receivedMsg = int(msg[0].encode('hex'), 16) + 256*int(msg[1].encode('hex'), 16)
#Signed -> Normal
if (receivedMsg > (2**15)-1):
    receivedMsg = receivedMsg - (2**16)
fft_RMSE = receivedMsg

print "RMS: ", str(fft_RMSE);

#Get std
msg = s.read(2)
#Turn signed 16 bit number back into python integer
receivedMsg = int(msg[0].encode('hex'), 16) + 256*int(msg[1].encode('hex'), 16)
#Signed -> Normal
if (receivedMsg > (2**15)-1):
    receivedMsg = receivedMsg - (2**16)
fft_std = receivedMsg

print "Std: ", str(fft_std);

#Get index
msg = s.read(2)
#Turn signed 16 bit number back into python integer
receivedMsg = int(msg[0].encode('hex'), 16) + 256*int(msg[1].encode('hex'), 16)
#Signed -> Normal
if (receivedMsg > (2**15)-1):
    receivedMsg = receivedMsg - (2**16)
fft_index = receivedMsg

print "Index: ", str(fft_index);

msg = s.read(2)
print msg

#Close serial channel
s.close()
print "Reading finished"

