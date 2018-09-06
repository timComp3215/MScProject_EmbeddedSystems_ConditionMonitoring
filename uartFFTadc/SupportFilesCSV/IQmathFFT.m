clear all
close all

%Include noise

fs = 8192; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 4096/8192;

N = fs * T;

t = linspace(0, T, N);

noise = normrnd(0, 0.1, N, 1);

x = zeros(N, 1);

x2 = zeros(N, 1, 'int16');

for n = 1:N
    x(n) = 1.33*cos(128*2*pi*t(n) + pi*0.5) + 2*cos(512*2*pi*t(n)) + ...
        0.6*cos(2048*2*pi*t(n) - pi*0.5) + 5*noise(n) + ...
        0.8*cos(3500*2*pi*t(n) - pi*0.7) -0.8*cos(768*2*pi*t(n) + pi*0.3);
    %x(n) = 0.5*cos(16*2*pi*t(n));
    x2(n) = int16(x(n)*(2^12));
end

%Write to input file
csvwrite('fft_input.csv', x2);

%Read from board output
board_F = csvread('fft_output.csv');

figure;
plot(t, x2)

%{k = 0:N-1;
%F = zeros(length(k), 1);

%for K = 1:length(k)
%    for n = 1:N
%        F(K) = F(K) + x(n) * exp(-2*pi*j*n*k(K) / N);
%    end
%end

freq = (0:N-1) .* fs/N;

F = fft(double(x2));

F = abs(F/N);

F = F(1:round(N/2));

F2 = zeros(N/2, 1, 'int16');

for n = 1:N/2
    F2(n) = int16(F(n)*(2^12));
end

FT = zeros(round(N/2), 2);

FT(:, 1) = freq(1:round(N/2));
FT(:, 2) = F;

figure;
%plot(freq(1:round(N/2)), F(1:round(N/2)));
plot(FT(:, 1), FT(:, 2), 'r-', 'LineWidth', 0.75);
hold on
plot(FT(:, 1), board_F, 'b-', 'LineWidth', 0.25);
legend('Matlab', 'On-board')

disp('Max')
disp(max(FT(:, 2)))
disp(max(board_F))

disp('RMS')
disp(rms(FT(:, 2)))
disp(rms(board_F))

disp('std')
disp(std(FT(:, 2)))
disp(std(board_F))
%%
figure('Color', 'w', 'Position', [500 200 1500 1000]) 
ha = tight_subplot(2,1,[.09 .07],[.071 .032],[.06 .012]);
axes(ha(1));
plot(t, x2);
ylabel('Amplitude')
xlabel('Time (s)')
text(0.01,25000, 'a)', 'FontSize', 14, 'FontWeight', 'bold')
axes(ha(2));
plot(FT(:, 1), FT(:, 2), 'b-', 'LineWidth', 2);
hold on
plot(FT(:, 1), board_F, 'rx', 'LineWidth', 2, 'MarkerSize', 10);
xlim([0 4096])
legend('Matlab', 'Online')
ylabel('Magnitude')
xlabel('Frequency (Hz)')
text(75,4500, 'b)', 'FontSize', 14, 'FontWeight', 'bold')
set(findall(gcf,'-property','FontSize'),'FontSize', 18)

% Y = fft(x);
% Y = abs(Y/N);
% 
% figure;
% plot(freq(1:round(N/2)),Y(1:round(N/2)));