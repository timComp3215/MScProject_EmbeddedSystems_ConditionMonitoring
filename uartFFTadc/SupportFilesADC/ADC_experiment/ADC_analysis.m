clear all
close all

%Include noise

fs = 16384; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 4096/fs;

model_frequency = 7553;

N = fs * T;

board_N = 2048;

t = linspace(0, T, N);

noise = normrnd(0, 0.1, N, 1);

x = zeros(N, 1);

model_x = zeros(N, 9);

M = csvread('ADCt_7553.csv');
%M = csvread('MEMS/t_95_adxl354.csv');

board_F = zeros(round(N/2), 9);

board_F(:, 1) = csvread('ADCf_53.csv');
board_F(:, 2) = csvread('ADCf_553.csv');
board_F(:, 3) = csvread('ADCf_1553.csv');
board_F(:, 4) = csvread('ADCf_2553.csv');
board_F(:, 5) = csvread('ADCf_3553.csv');
board_F(:, 6) = csvread('ADCf_4553.csv');
board_F(:, 7) = csvread('ADCf_5553.csv');
board_F(:, 8) = csvread('ADCf_6553.csv');
board_F(:, 9) = csvread('ADCf_7553.csv');

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
    model_x(n, 1) = 2482.5*sin(53*2*pi*t(n));
    model_x(n, 2) = 2482.5*sin(553*2*pi*t(n));
    model_x(n, 3) = 2482.5*sin(1553*2*pi*t(n));
    model_x(n, 4) = 2482.5*sin(2553*2*pi*t(n));
    model_x(n, 5) = 2482.5*sin(3553*2*pi*t(n));
    model_x(n, 6) = 2482.5*sin(4553*2*pi*t(n));
    model_x(n, 7) = 2482.5*sin(5553*2*pi*t(n));
    model_x(n, 8) = 2482.5*sin(6553*2*pi*t(n));
    model_x(n, 9) = 2482.5*sin(7553*2*pi*t(n));
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
%%
model_F = zeros(round(N/2), 9);

for z = 1:9
    tempF = fft(model_x(:, z));

    tempF = abs(tempF/N);

    model_F(:, z) = tempF(1:round(N/2));
end
%%
%F2 = zeros(N/2, 1, 'int16');

%for n = 1:N/2
%    F2(n) = int16(F(n)*(2^12));
%end

FT = zeros(round(N/2), 3);

FT(:, 1) = freq(1:round(N/2));
% FT(:, 2) = F;
% FT(:, 3) = model_F;
% 
% figure
% subplot(2, 1, 1);
% plot(t, x);
% %hold on
% %plot(t, model_x);
% subplot(2, 1, 2);
% plot(board_freq, board_F);
% hold on
% plot(FT(:, 1), FT(:, 2), 'rx', 'MarkerSize', 2);

% plot(FT(:, 1), FT(:, 3));
% legend('Board', 'ADC', 'Model');

figure('color', 'w', 'Position', [50, 100, 2000, 550])
ha = tight_subplot(1,1,[.075 .07],[.125 .02],[.06 .03]);
axes(ha(1));
h1 = plot(board_freq, board_F(:, 1), 'b', 'LineWidth', 1);
hold on

plot(board_freq, board_F(:, 2), 'b', 'LineWidth', 1)
plot(board_freq, board_F(:, 3), 'b', 'LineWidth', 1)
plot(board_freq, board_F(:, 4), 'b', 'LineWidth', 1)
plot(board_freq, board_F(:, 5), 'b', 'LineWidth', 1)
plot(board_freq, board_F(:, 6), 'b', 'LineWidth', 1)
plot(board_freq, board_F(:, 7), 'b', 'LineWidth', 1)
plot(board_freq, board_F(:, 8), 'b', 'LineWidth', 1)
plot(board_freq, board_F(:, 9), 'b', 'LineWidth', 1)


[Max_f, I_f] = max(model_F(:, 1));
h2 = plot(FT(I_f, 1), model_F(I_f, 1), 'rd', 'LineWidth', 1);

%plot(FT(:, 1), FT(:, 2));
for z = 2:9
    [Max_f, I_f] = max(model_F(:, z));
    plot(FT(I_f, 1), model_F(I_f, z), 'rd', 'LineWidth', 1);
end
xlim([0 8192])
legend([h1 h2], 'Board', 'Model', 'Location', 'North');
xlabel('Frequency (Hz)')
ylabel('Magnitude')


set(findall(gcf,'-property','FontSize'),'FontSize',18)

% disp('Max');
% disp(max(board_F));
% 
% disp('RMS');
% disp(rms(board_F));
% 
% disp('Std')
% disp(std(board_F));