clear all
close all

%Include noise

fs = 512; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 4096/fs;

model_frequency = 50;

N = fs * T;

board_N = 2048;

t = linspace(0, T, N);

noise = normrnd(0, 0.1, N, 1);

x = zeros(N, 1);

model_x = zeros(N, 1);

M = csvread('adc_output.csv');
%M = csvread('MEMS/t_95_adxl354.csv');
board_F = csvread('fft_output.csv');
%board_F = csvread('MEMS/f_95_adxl354.csv');

for n = 1:N
    %x(n) = 1.33*cos(128*2*pi*t(n) + pi*0.5) + 2*cos(512*2*pi*t(n)) + ...
    %    0.6*cos(2048*2*pi*t(n) - pi*0.5) + 5*noise(n) + ...
    %    0.8*cos(3500*2*pi*t(n) - pi*0.7) -0.8*cos(768*2*pi*t(n) + pi*0.3);
    %x(n) = 0.5*cos(16*2*pi*t(n));
    %x(n) = ((M(n)-mean(M))/16384.0)*3.3;
    %x(n) = (M(n)/16384.0)*3.3;
    x(n) = M(n);
    %model_x(n) = max(M)*sin(model_frequency*2*pi*t(n));
    model_x(n) = 2482.5*sin(model_frequency*2*pi*t(n));
    %x2(n) = int16(x(n)*(2^12));
end

%mean(M)

%figure;
%plot(t, x)

freq = (0:N-1) .* fs/N;
board_freq = ((0:board_N-1) .* fs/(board_N*2))';

F = fft(x);

F = abs(F/N);

F = F(1:round(N/2));

model_F = fft(model_x);

model_F = abs(model_F/N);

model_F = model_F(1:round(N/2));

%F2 = zeros(N/2, 1, 'int16');

%for n = 1:N/2
%    F2(n) = int16(F(n)*(2^12));
%end

FT = zeros(round(N/2), 3);

FT(:, 1) = freq(1:round(N/2));
FT(:, 2) = F;
FT(:, 3) = model_F;

figure
subplot(2, 1, 1);
plot(t, x);
%hold on
%plot(t, model_x);
subplot(2, 1, 2);
plot(board_freq, board_F);
hold on
plot(FT(:, 1), FT(:, 2), 'rx', 'MarkerSize', 2);

plot(FT(:, 1), FT(:, 3));
legend('Board', 'ADC', 'Model');

figure;
h1 = plot(board_freq, board_F);
hold on
%plot(FT(:, 1), FT(:, 2));
[Max_f, I_f] = max(FT(:, 3));
h2 = plot(FT(I_f, 1), FT(I_f, 3), 'rx');
legend([h1 h2], 'Board', 'Model');

disp('Max');
disp(max(board_F));

disp('RMS');
disp(rms(board_F));

disp('Std')
disp(std(board_F));