clear all
close all

%Include noise

fs = 16384; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 4096/fs;

model_frequency = 95;

N = fs * T;

board_N = 2048;

t = linspace(0, T, N);

f = (0:round((N-1)/2)-1) .* fs/N;

noise = normrnd(0, 0.1, N, 1);

x = zeros(N, 1);

model_x = zeros(N, 1);

frequency = 95;

filename = sprintf('t_%d_mma7361.csv', frequency);
x_mma = csvread(filename);
x_mma = (x_mma / 16384) * 3.3 / 0.206;
filename = sprintf('t_%d_adxl354.csv', frequency);
x_adxl = csvread(filename);
x_adxl = (x_adxl / 16384) * 3.3 / 0.1;
filename = sprintf('f_%d_mma7361.csv', frequency);
f_mma = csvread(filename);
f_mma = f_mma / 0.206;
filename = sprintf('f_%d_adxl354.csv', frequency);
f_adxl = csvread(filename);
f_adxl = f_adxl / 0.1;

figure;
subplot(2, 1, 1);
plot(t, x_mma);
hold on 
plot(t, x_adxl);
legend('MMA7361', 'ADXL354');
title_str = sprintf('%d Hz', frequency);
title(title_str);

subplot(2, 1, 2);
plot(f, f_mma);
hold on 
plot(f, f_adxl);
legend('MMA7361', 'ADXL354');

fs = 1e3;
t = 0:1/fs:1;
x = [1 2]*sin(2*pi*[50 250]'.*t) + randn(size(t))/10;
lowpass(x,150,fs)