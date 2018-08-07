clear all
close all

subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.05], [0.1 0.1], [0.1 0.1]);

%Include noise

fs = 16384; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 4096/fs;

N = fs * T;

t = linspace(0, T, N);

f = (0:round((N-1)/2)-1) .* fs/N;

noise = normrnd(0, 0.1, N, 1);

x = zeros(N, 1);

model_x = zeros(N, 1);

frequency = 4053;

filename = sprintf('t_%d_mma7361.csv', frequency);
%filename = sprintf('t_random_mma7361.csv');
x_mma = csvread(filename);
x_mma = (x_mma / 16384) * 3.3 / 0.206;
F_mma = fft(x_mma);
filename = sprintf('t_%d_adxl354.csv', frequency);
%filename = sprintf('t_random_adxl354.csv');
x_adxl = csvread(filename);

x_adxl = (x_adxl / 16384) * 3.3 / 0.1;
F_adxl = fft(x_adxl);%Matlab fft
filename = sprintf('f_%d_mma7361.csv', frequency);
%filename = sprintf('f_random_mma7361.csv');
f_mma = csvread(filename);
f_mma = (f_mma / 16384) * 3.3 / 0.206;
filename = sprintf('f_%d_adxl354.csv', frequency);
%filename = sprintf('f_random_adxl354.csv');
f_adxl = csvread(filename);
f_adxl = (f_adxl / 16384) * 3.3 / 0.100;
%f_adxl = (f_adxl / 16384)*3.3 / 0.1;

max_acc = 1.5*max(max(abs(x_mma), abs(x_adxl)));

RMS_mma = rms(x_mma);
max_mma = max(f_mma);
RMS_adxl = rms(x_adxl);
max_adxl = max(f_adxl);



%%

figure('Color', 'w',  'Position', [500 800 1500 500]);
ha = tight_subplot(1,2,[.2 .07],[.15 .05],[.06 .02]);
%subplot(1, 2, 1);
axes(ha(1));
plot(t, x_mma);
ylabel('Acceleration (g)')
xlabel('Time (s)')
legend('MEMS (A)')
xlim([0 0.25])
%ylim([-max_acc max_acc])
%subplot(1, 2, 2);
axes(ha(2));
plot(t, x_adxl);
legend('MEMS (B)');
ylabel('Acceleration (g)')
xlim([0 0.25])
%ylim([-1.2 1.2])
xlabel('Time (s)')
set(findall(gcf,'-property','FontSize'),'FontSize',18)
%set(findall(gca, 'Type', 'Line'),'LineWidth',2);
%title_str = sprintf('%d Hz', frequency);
%title(title_str);

figure('Color', 'w', 'Position', [500 200 1500 500]) 
ha = tight_subplot(1,2,[.2 .07],[.15 .05],[.065 .02]);
axes(ha(1));
plot(f, f_mma);
ylabel('Magnitude (g^2/Hz)')
xlabel('Frequency (Hz)')
legend('MEMS (A)')
xlim([0 8192])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
axes(ha(2));
plot(f, f_adxl);
ylabel('Magnitude (g^2/Hz)')
xlabel('Frequency (Hz)')
legend('MEMS (B)')
xlim([0 8192])
set(findall(gcf,'-property','FontSize'),'FontSize',18)
set(findall(gca, 'Type', 'Line'),'LineWidth',2);

%F_adxl = fft(x_adxl);
F_adxl = abs(F_adxl/N);
F_adxl = F_adxl(1:round(N/2));

%F_mma = fft(x_mma);
F_mma = abs(F_mma/N);
F_mma = F_mma(1:round(N/2));

%{
figure('Color', 'w', 'Position', [800 200 1500 500]) ;
ha = tight_subplot(1,2,[.01 .03],[.1 .01],[.01 .01]);
%subplot(1, 2, 1);
axes(ha(1));
plot(f, F_mma);
ylabel('Magnitude (g^2/Hz)')
xlabel('Frequency (Hz)')
legend('MEMS (A)')
%subplot(1, 2, 2);
axes(ha(2));
plot(f, F_adxl);
ylabel('Magnitude (g^2/Hz)')
xlabel('Frequency (Hz)')
legend('MEMS (B)')
%}