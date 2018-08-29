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
fs = 4096

test = 5
condition = 'B'

#set name of output file
#output_file = 'adc_output.csv'
output_file = 'Big/t_' + condition + '_' + str(test) + '.csv'
#fft_output_file = 'fft_output.csv'
fft_output_file = 'Big/f_' + condition + '_' + str(test) + '.csv'

#Connect to serial channel and send input
s = serial.Serial('COM4', 9600)

print "Sending measurement request"

s.write('M')

print "Reading time data from board.."

#Read time data
values = []
float_values = []
    
n=0
for n in range(SAMPLES):

    if (n == (SAMPLES/4)):
        print "25%..."
    elif (n == (SAMPLES/2)):
        print "50%..."
    elif (n == (3*SAMPLES/4)):
        print "75%..."
    msg = s.read(2)

    #Turn signed 16 bit number back into python integer
    receivedMsg = int(msg[0].encode('hex'), 16) + 256*int(msg[1].encode('hex'), 16)

    #Signed -> Normal
    if (receivedMsg > (2**15)-1):
        receivedMsg = receivedMsg - (2**16)

    #print str(receivedMsg)

    values.append(receivedMsg)


#Read frequency data
magnitude = []
    
n=0

print "Reading frequency data from board.."
for n in range(SAMPLES/2):

    if (n == (SAMPLES/8)):
        print "25%..."
    elif (n == (SAMPLES/4)):
        print "50%..."
    elif (n == (3*SAMPLES/8)):
        print "75%..."
    msg = s.read(2)

    #Turn signed 16 bit number back into python integer
    receivedMsg = int(msg[0].encode('hex'), 16) + 256*int(msg[1].encode('hex'), 16)

    #Signed -> Normal
    if (receivedMsg > (2**15)-1):
        receivedMsg = receivedMsg - (2**16)

    #print str(receivedMsg)

    magnitude.append(receivedMsg)

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

#Close serial channel
s.close()
print "Reading finished"

for n in range(0, SAMPLES):
    #Convert to g
    #float_values.append(((float(values[n])/16384) * 3.3)/0.8)
    float_values.append(float(values[n]))

#print values
#Store readings in csv
print "Write output to " + output_file
with open(output_file, 'wb') as fout:
    writer = csv.writer(fout)
    for n in range(0, SAMPLES):
        #Integer must be inside [] brackets
        writer.writerow([values[n]])

    fout.close()

#Store FFT in csv
print "Write FFT data to " + fft_output_file
with open(fft_output_file, 'wb') as fout:
    writer = csv.writer(fout)
    for n in range(0, SAMPLES/2):
        #Integer must be inside [] brackets
        writer.writerow([magnitude[n]])

    fout.close()


#Set up x axes variables for plotting
time = []

for n in range(0, SAMPLES):
    time.append(n*(1/float(fs)))

fbins = []

for n in range(0, SAMPLES/2):
    fbins.append(n*(float(fs)/SAMPLES))

#Plot
fig = plt.figure(1)

#Time signal
plt.subplot(211)
plt.plot(time, float_values, linewidth=0.5)
#plt.ylabel('Voltage')
plt.ylabel('Acceleration (g)')
plt.xlabel('Time (s)')
plt.title('Time based data')
#Get rid of white space on x axis
plt.autoscale(enable=True, axis='x', tight=True)
#Put ticks on outside for bottom and left axes
ax = plt.gca()
ax.tick_params(direction='out')
ax.tick_params(bottom=True, left=True, top=False, right=False)
#ax.set_ylim([-3.5,3.5])

#Frequency signal
plt.subplot(212)
plt.plot(fbins, magnitude, linewidth=0.5)
plt.ylabel('Magnitude')
plt.xlabel('Frequency (Hz)')
plt.title('FFT spectrum')
#Get rid of white space on x axis
plt.autoscale(enable=True, axis='x', tight=True)
#Put ticks on outside for bottom and left axes
ax = plt.gca()
ax.tick_params(direction='out')
ax.tick_params(bottom=True, left=True, top=False, right=False)
ax.grid(color='b', linestyle='-', linewidth=0.1, axis='x')

#Background colour
fig.patch.set_facecolor('white')

#Space subplots properly
plt.tight_layout()

#Display
print "Display graphs"
print "Please close graphs before continuing"
plt.show()

