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
SAMPLES = 256

#Sampling frequency - purely for graphs to be correctly scaled
fs = 128

#set name of output file
output_file = 'adc_output.csv'

#Connect to serial channel and send input
s = serial.Serial('COM4', 9600)

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


#Close serial channel
s.close()
print "Reading finished"

for n in range(0, SAMPLES):
    float_values.append(((float(values[n])/16384) * 3.3))

#Set up x axes variables for plotting
time = []

for n in range(0, SAMPLES):
    time.append(n*(1/float(fs)))
    
#Plot
fig = plt.figure(1)

#Time signal
#plt.subplot(211)
plt.plot(time, float_values, linewidth=0.5)
#plt.ylabel('Voltage')
plt.ylabel('Voltage (V)')
plt.xlabel('Time (s)')
plt.title('Time based data')
#Get rid of white space on x axis
plt.autoscale(enable=True, axis='x', tight=True)
#Put ticks on outside for bottom and left axes
ax = plt.gca()
ax.tick_params(direction='out')
ax.ticklabel_format(useOffset=False)
ax.tick_params(bottom=True, left=True, top=False, right=False)
ax.set_ylim([0,3.5])


#Display
print "Display graphs"
print "Please close graphs before continuing"
plt.show()

