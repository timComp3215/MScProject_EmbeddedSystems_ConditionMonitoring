clear all
close all

%Include noise

fs = 16384; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 4096/fs;

N = fs * T;

t = linspace(0, T, N);

f_bins = (0:(N/2)-1) .* fs/N;

x_A_253 = zeros(N, 3);

x_A_253(:, 1) = csvread('A/t_253Hz_1.csv');
x_A_253(:, 2) = csvread('A/t_253Hz_2.csv');
x_A_253(:, 3) = csvread('A/t_253Hz_3.csv');

x_A_553 = zeros(N, 3);

x_A_553(:, 1) = csvread('A/t_553Hz_1.csv');
x_A_553(:, 2) = csvread('A/t_553Hz_2.csv');
x_A_553(:, 3) = csvread('A/t_553Hz_3.csv');

x_A_1053 = zeros(N, 3);

x_A_1053(:, 1) = csvread('A/t_1053Hz_1.csv');
x_A_1053(:, 2) = csvread('A/t_1053Hz_2.csv');
x_A_1053(:, 3) = csvread('A/t_1053Hz_3.csv');

x_A_1553 = zeros(N, 3);

x_A_1553(:, 1) = csvread('A/t_1553Hz_1.csv');
x_A_1553(:, 2) = csvread('A/t_1553Hz_2.csv');
x_A_1553(:, 3) = csvread('A/t_1553Hz_3.csv');

x_A_2053 = zeros(N, 3);

x_A_2053(:, 1) = csvread('A/t_2053Hz_1.csv');
x_A_2053(:, 2) = csvread('A/t_2053Hz_2.csv');
x_A_2053(:, 3) = csvread('A/t_2053Hz_3.csv');

x_A_2553 = zeros(N, 3);

x_A_2553(:, 1) = csvread('A/t_2553Hz_1.csv');
x_A_2553(:, 2) = csvread('A/t_2553Hz_2.csv');
x_A_2553(:, 3) = csvread('A/t_2553Hz_3.csv');

% x_A_3553 = zeros(N, 3);
% 
% x_A_3553(:, 1) = csvread('A/t_3553Hz_1.csv');
% x_A_3553(:, 2) = csvread('A/t_3553Hz_2.csv');
% x_A_3553(:, 3) = csvread('A/t_3553Hz_3.csv');

figure;
subplot(3, 1, 1)
plot(t, x_A_253(:, 1));
subplot(3, 1, 2)
plot(t, x_A_253(:, 2));
subplot(3, 1, 3)
plot(t, x_A_253(:, 3));

%%

x_B_253 = zeros(N, 3);

x_B_253(:, 1) = csvread('B/t_253Hz_1.csv');
x_B_253(:, 2) = csvread('B/t_253Hz_2.csv');
x_B_253(:, 3) = csvread('B/t_253Hz_3.csv');

x_B_553 = zeros(N, 3);

x_B_553(:, 1) = csvread('B/t_553Hz_1.csv');
x_B_553(:, 2) = csvread('B/t_553Hz_2.csv');
x_B_553(:, 3) = csvread('B/t_553Hz_3.csv');

x_B_1053 = zeros(N, 3);

x_B_1053(:, 1) = csvread('B/t_1053Hz_1.csv');
x_B_1053(:, 2) = csvread('B/t_1053Hz_2.csv');
x_B_1053(:, 3) = csvread('B/t_1053Hz_3.csv');

x_B_1553 = zeros(N, 3);

x_B_1553(:, 1) = csvread('B/t_1553Hz_1.csv');
x_B_1553(:, 2) = csvread('B/t_1553Hz_2.csv');
x_B_1553(:, 3) = csvread('B/t_1553Hz_3.csv');

x_B_2053 = zeros(N, 3);

x_B_2053(:, 1) = csvread('B/t_2053Hz_1.csv');
x_B_2053(:, 2) = csvread('B/t_2053Hz_2.csv');
x_B_2053(:, 3) = csvread('B/t_2053Hz_3.csv');

x_B_2553 = zeros(N, 3);

x_B_2553(:, 1) = csvread('B/t_2553Hz_1.csv');
x_B_2553(:, 2) = csvread('B/t_2553Hz_2.csv');
x_B_2553(:, 3) = csvread('B/t_2553Hz_3.csv');

% x_B_3553 = zeros(N, 3);
% 
% x_B_3553(:, 1) = csvread('B/t_3553Hz_1.csv');
% x_B_3553(:, 2) = csvread('B/t_3553Hz_2.csv');
% x_B_3553(:, 3) = csvread('B/t_3553Hz_3.csv');

figure;
subplot(3, 1, 1)
plot(t, x_B_253(:, 1));
subplot(3, 1, 2)
plot(t, x_B_253(:, 2));
subplot(3, 1, 3)
plot(t, x_B_253(:, 3));


%%

x_C_253 = zeros(N, 3);

x_C_253(:, 1) = csvread('C/t_253Hz_1.csv');
x_C_253(:, 2) = csvread('C/t_253Hz_2.csv');
x_C_253(:, 3) = csvread('C/t_253Hz_3.csv');

x_C_553 = zeros(N, 3);

x_C_553(:, 1) = csvread('C/t_553Hz_1.csv');
x_C_553(:, 2) = csvread('C/t_553Hz_2.csv');
x_C_553(:, 3) = csvread('C/t_553Hz_3.csv');

x_C_1053 = zeros(N, 3);

x_C_1053(:, 1) = csvread('C/t_1053Hz_1.csv');
x_C_1053(:, 2) = csvread('C/t_1053Hz_2.csv');
x_C_1053(:, 3) = csvread('C/t_1053Hz_3.csv');


x_C_1553 = zeros(N, 3);

x_C_1553(:, 1) = csvread('C/t_1553Hz_1.csv');
x_C_1553(:, 2) = csvread('C/t_1553Hz_2.csv');
x_C_1553(:, 3) = csvread('C/t_1553Hz_3.csv');

x_C_2053 = zeros(N, 3);

x_C_2053(:, 1) = csvread('C/t_2053Hz_1.csv');
x_C_2053(:, 2) = csvread('C/t_2053Hz_2.csv');
x_C_2053(:, 3) = csvread('C/t_2053Hz_3.csv');

x_C_2553 = zeros(N, 3);

x_C_2553(:, 1) = csvread('C/t_2553Hz_1.csv');
x_C_2553(:, 2) = csvread('C/t_2553Hz_2.csv');
x_C_2553(:, 3) = csvread('C/t_2553Hz_3.csv');

% x_C_3553 = zeros(N, 3);
% 
% x_C_3553(:, 1) = csvread('C/t_3553Hz_1.csv');
% x_C_3553(:, 2) = csvread('C/t_3553Hz_2.csv');
% x_C_3553(:, 3) = csvread('C/t_3553Hz_3.csv');

figure;
subplot(3, 1, 1)
plot(t, (x_C_253(:, 1)*3.3)/(16384*0.04));
subplot(3, 1, 2)
plot(t, x_C_253(:, 2));
subplot(3, 1, 3)
plot(t, x_C_253(:, 3));


%%

f_A_253 = zeros(N/2, 3);
f_A_253(:, 1) = csvread('A/f_253Hz_1.csv');
f_A_253(:, 2) = csvread('A/f_253Hz_2.csv');
f_A_253(:, 3) = csvread('A/f_253Hz_3.csv');

f_A_553 = zeros(N/2, 3);
f_A_553(:, 1) = csvread('A/f_553Hz_1.csv');
f_A_553(:, 2) = csvread('A/f_553Hz_2.csv');
f_A_553(:, 3) = csvread('A/f_553Hz_3.csv');

f_A_1053 = zeros(N/2, 3);
f_A_1053(:, 1) = csvread('A/f_1053Hz_1.csv');
f_A_1053(:, 2) = csvread('A/f_1053Hz_2.csv');
f_A_1053(:, 3) = csvread('A/f_1053Hz_3.csv');

f_A_1553 = zeros(N/2, 3);
f_A_1553(:, 1) = csvread('A/f_1553Hz_1.csv');
f_A_1553(:, 2) = csvread('A/f_1553Hz_2.csv');
f_A_1553(:, 3) = csvread('A/f_1553Hz_3.csv');

f_A_2053 = zeros(N/2, 3);
f_A_2053(:, 1) = csvread('A/f_2053Hz_1.csv');
f_A_2053(:, 2) = csvread('A/f_2053Hz_2.csv');
f_A_2053(:, 3) = csvread('A/f_2053Hz_3.csv');

f_A_2553 = zeros(N/2, 3);
f_A_2553(:, 1) = csvread('A/f_2553Hz_1.csv');
f_A_2553(:, 2) = csvread('A/f_2553Hz_2.csv');
f_A_2553(:, 3) = csvread('A/f_2553Hz_3.csv');

% f_A_3553 = zeros(N/2, 3);
% f_A_3553(:, 1) = csvread('A/f_3553Hz_1.csv');
% f_A_3553(:, 2) = csvread('A/f_3553Hz_2.csv');
% f_A_3553(:, 3) = csvread('A/f_3553Hz_3.csv');

figure;
subplot(3, 1, 1)
plot(f_bins, f_A_253(:, 1));
subplot(3, 1, 2)
plot(f_bins, f_A_253(:, 2));
subplot(3, 1, 3)
plot(f_bins, f_A_253(:, 3));

average_f_A = zeros(N/2, 6);

for n = 1:N/2
    average_f_A(n, 1) = mean(f_A_253(n, :));
    average_f_A(n, 2) = mean(f_A_553(n, :)); 
    average_f_A(n, 3) = mean(f_A_1053(n, :));
    average_f_A(n, 4) = mean(f_A_1553(n, :)); 
    average_f_A(n, 5) = mean(f_A_2053(n, :)); 
    average_f_A(n, 6) = mean(f_A_2553(n, :));   

end

frequencies_A = zeros(6, 1);
[M, I] = max(average_f_A(:, 1));
frequencies_A(1) = f_bins(I);
[M, I] = max(average_f_A(:, 2));
frequencies_A(2) = f_bins(I);
[M, I] = max(average_f_A(:, 3));
frequencies_A(3) = f_bins(I);
[M, I] = max(average_f_A(:, 4));
frequencies_A(4) = f_bins(I);
[M, I] = max(average_f_A(:, 5));
frequencies_A(5) = f_bins(I);
[M, I] = max(average_f_A(:, 6));
frequencies_A(6) = f_bins(I);

%%

f_B_253 = zeros(N/2, 3);
f_B_253(:, 1) = csvread('B/f_253Hz_1.csv');
f_B_253(:, 2) = csvread('B/f_253Hz_2.csv');
f_B_253(:, 3) = csvread('B/f_253Hz_3.csv');

f_B_553 = zeros(N/2, 3);
f_B_553(:, 1) = csvread('B/f_553Hz_1.csv');
f_B_553(:, 2) = csvread('B/f_553Hz_2.csv');
f_B_553(:, 3) = csvread('B/f_553Hz_3.csv');

f_B_1053 = zeros(N/2, 3);
f_B_1053(:, 1) = csvread('B/f_1053Hz_1.csv');
f_B_1053(:, 2) = csvread('B/f_1053Hz_2.csv');
f_B_1053(:, 3) = csvread('B/f_1053Hz_3.csv');

f_B_1553 = zeros(N/2, 3);
f_B_1553(:, 1) = csvread('B/f_1553Hz_1.csv');
f_B_1553(:, 2) = csvread('B/f_1553Hz_2.csv');
f_B_1553(:, 3) = csvread('B/f_1553Hz_3.csv');

f_B_2053 = zeros(N/2, 3);
f_B_2053(:, 1) = csvread('B/f_2053Hz_1.csv');
f_B_2053(:, 2) = csvread('B/f_2053Hz_2.csv');
f_B_2053(:, 3) = csvread('B/f_2053Hz_3.csv');

f_B_2553 = zeros(N/2, 3);
f_B_2553(:, 1) = csvread('B/f_2553Hz_1.csv');
f_B_2553(:, 2) = csvread('B/f_2553Hz_2.csv');
f_B_2553(:, 3) = csvread('B/f_2553Hz_3.csv');

% f_B_3553 = zeros(N/2, 3);
% f_B_3553(:, 1) = csvread('B/f_3553Hz_1.csv');
% f_B_3553(:, 2) = csvread('B/f_3553Hz_2.csv');
% f_B_3553(:, 3) = csvread('B/f_3553Hz_3.csv');

figure;
subplot(3, 1, 1)
plot(f_bins, f_B_253(:, 1));
subplot(3, 1, 2)
plot(f_bins, f_B_253(:, 2));
subplot(3, 1, 3)
plot(f_bins, f_B_253(:, 3));

average_f_B = zeros(N/2, 6);

for n = 1:N/2
    average_f_B(n, 1) = mean(f_B_253(n, :));
    average_f_B(n, 2) = mean(f_B_553(n, :));  
    average_f_B(n, 3) = mean(f_B_1053(n, :)); 
    average_f_B(n, 4) = mean(f_B_1553(n, :)); 
    average_f_B(n, 5) = mean(f_B_2053(n, :)); 
    average_f_B(n, 6) = mean(f_B_2553(n, :));   

end

frequencies_B = zeros(6, 1);
[M, I] = max(average_f_B(:, 1));
frequencies_B(1) = f_bins(I);
[M, I] = max(average_f_B(:, 2));
frequencies_B(2) = f_bins(I);
[M, I] = max(average_f_B(:, 3));
frequencies_B(3) = f_bins(I);
[M, I] = max(average_f_B(:, 4));
frequencies_B(4) = f_bins(I);
[M, I] = max(average_f_B(:, 5));
frequencies_B(5) = f_bins(I);
[M, I] = max(average_f_B(:, 6));
frequencies_B(6) = f_bins(I);

%%

f_C_253 = zeros(N/2, 3);
f_C_253(:, 1) = csvread('C/f_253Hz_1.csv');
f_C_253(:, 2) = csvread('C/f_253Hz_2.csv');
f_C_253(:, 3) = csvread('C/f_253Hz_3.csv');

f_C_553 = zeros(N/2, 3);
f_C_553(:, 1) = csvread('C/f_553Hz_1.csv');
f_C_553(:, 2) = csvread('C/f_553Hz_2.csv');
f_C_553(:, 3) = csvread('C/f_553Hz_3.csv');

f_C_1053 = zeros(N/2, 3);
f_C_1053(:, 1) = csvread('C/f_1053Hz_1.csv');
f_C_1053(:, 2) = csvread('C/f_1053Hz_2.csv');
f_C_1053(:, 3) = csvread('C/f_1053Hz_3.csv');

f_C_1553 = zeros(N/2, 3);
f_C_1553(:, 1) = csvread('C/f_1553Hz_1.csv');
f_C_1553(:, 2) = csvread('C/f_1553Hz_2.csv');
f_C_1553(:, 3) = csvread('C/f_1553Hz_3.csv');

f_C_2053 = zeros(N/2, 3);
f_C_2053(:, 1) = csvread('C/f_2053Hz_1.csv');
f_C_2053(:, 2) = csvread('C/f_2053Hz_2.csv');
f_C_2053(:, 3) = csvread('C/f_2053Hz_3.csv');

f_C_2553 = zeros(N/2, 3);
f_C_2553(:, 1) = csvread('C/f_2553Hz_1.csv');
f_C_2553(:, 2) = csvread('C/f_2553Hz_2.csv');
f_C_2553(:, 3) = csvread('C/f_2553Hz_3.csv');

% f_C_3553 = zeros(N/2, 3);
% f_C_3553(:, 1) = csvread('C/f_3553Hz_1.csv');
% f_C_3553(:, 2) = csvread('C/f_3553Hz_2.csv');
% f_C_3553(:, 3) = csvread('C/f_3553Hz_3.csv');

figure;
subplot(3, 1, 1)
plot(f_bins, f_C_253(:, 1));
subplot(3, 1, 2)
plot(f_bins, f_C_253(:, 2));
subplot(3, 1, 3)
plot(f_bins, f_C_253(:, 3));

average_f_C = zeros(N/2, 5);

for n = 1:N/2
    average_f_C(n, 1) = mean(f_C_253(n, :));
    average_f_C(n, 2) = mean(f_C_553(n, :));  
    average_f_C(n, 3) = mean(f_C_1053(n, :));
    average_f_C(n, 4) = mean(f_C_1553(n, :)); 
    average_f_C(n, 5) = mean(f_C_2053(n, :)); 
    average_f_C(n, 6) = mean(f_C_2553(n, :));   

end

frequencies_C = zeros(5, 1);
[M, I] = max(average_f_C(:, 1));
frequencies_C(1) = f_bins(I);
[M, I] = max(average_f_C(:, 2));
frequencies_C(2) = f_bins(I);
[M, I] = max(average_f_C(:, 3));
frequencies_C(3) = f_bins(I);
[M, I] = max(average_f_C(:, 4));
frequencies_C(4) = f_bins(I);
[M, I] = max(average_f_C(:, 5));
frequencies_C(5) = f_bins(I);
[M, I] = max(average_f_C(:, 6));
frequencies_C(6) = f_bins(I);
%%

rms_A = zeros(6, 1);
rms_A(1) = (mean(rms(x_A_253))*3.3)/(16384*0.8);
rms_A(2) = (mean(rms(x_A_553))*3.3)/(16384*0.8);
rms_A(3) = (mean(rms(x_A_1053))*3.3)/(16384*0.8);
rms_A(4) = (mean(rms(x_A_1553))*3.3)/(16384*0.8);
rms_A(5) = (mean(rms(x_A_2053))*3.3)/(16384*0.8);
rms_A(6) = (mean(rms(x_A_2553))*3.3)/(16384*0.8);

rms_B = zeros(5, 1);
rms_B(1) = (mean(rms(x_B_253))*3.3)/(16384*0.4);
rms_B(2) = (mean(rms(x_B_553))*3.3)/(16384*0.4);
rms_B(3) = (mean(rms(x_B_1053))*3.3)/(16384*0.4);
rms_B(4) = (mean(rms(x_B_1553))*3.3)/(16384*0.4);
rms_B(5) = (mean(rms(x_B_2053))*3.3)/(16384*0.4);
rms_B(6) = (mean(rms(x_B_2553))*3.3)/(16384*0.4);

rms_C = zeros(5, 1);
rms_C(1) = (mean(rms(x_C_253))*3.3)/(16384*0.04);
rms_C(2) = (mean(rms(x_C_553))*3.3)/(16384*0.04);
rms_C(3) = (mean(rms(x_C_1053))*3.3)/(16384*0.04);
rms_C(4) = (mean(rms(x_C_1553))*3.3)/(16384*0.04);
rms_C(5) = (mean(rms(x_C_2053))*3.3)/(16384*0.04);
rms_C(6) = (mean(rms(x_C_2553))*3.3)/(16384*0.04);

%%

figure('color', 'w', 'Position', [50, 50, 2000, 550])
ha = tight_subplot(1, 2, [.025 .07],[.14 .02],[.035 .014]);
axes(ha(1));

plot(frequencies_A, rms_A, 'm-s', 'LineWidth', 1.5, 'MarkerSize', 10)
hold on
plot(frequencies_B, rms_B, 'g-o', 'LineWidth', 1.5, 'MarkerSize', 10)
plot(frequencies_C, rms_C, 'k-^', 'LineWidth', 1.5, 'MarkerSize', 10)
xlabel('Vibration Frequency (Hz)')
ylabel('Acceleration RMS (g)')

axes(ha(2))
plot(frequencies_A, (max(average_f_A)*3.3)/(16384*0.8), 'm-s', 'LineWidth', 1.5, 'MarkerSize', 10)
hold on
plot(frequencies_B, (max(average_f_B)*3.3)/(16384*0.4), 'g-o', 'LineWidth', 1.5, 'MarkerSize', 10)
plot(frequencies_C, (max(average_f_C)*3.3)/(16384*0.04), 'k-^', 'LineWidth', 1.5, 'MarkerSize', 10)
xlabel('Vibration Frequency (Hz)')
ylabel('Maximum of Frequency Spectrum (g)')
legend('MEMS (A)', 'MEMS(B)', 'MEMS (C)')

set(findall(gcf,'-property','FontSize'),'FontSize',18)

%%

figure('color', 'w', 'Position', [50, 50, 2000, 1000])
ha = tight_subplot(3, 1, [.01 .05],[.075 .02],[.04 .012]);
axes(ha(1));
plot(t, (x_A_2553(:, 3)*3.3)/(16384*0.8), 'm', 'LineWidth', 1.5)
xlim([0 0.05])
ylim([-1.2 1.2])
set(gca,'XTickLabel',[]);
ylabel('Acceleration (g)')
legend('MEMS (A)')

axes(ha(2));
plot(t, (x_B_2553(:, 3)*3.3)/(16384*0.4), 'g', 'LineWidth', 1.5)
xlim([0 0.05])
ylim([-1.2 1.2])
set(gca,'XTickLabel',[]);
ylabel('Acceleration (g)')
legend('MEMS (B)')

axes(ha(3));
plot(t, (x_C_2553(:, 3)*3.3)/(16384*0.04), 'k', 'LineWidth', 1.5)
xlim([0 0.05])
ylim([-1.2 1.2])
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('MEMS (C)')


set(findall(gcf,'-property','FontSize'),'FontSize',18)
%%

figure('color', 'w', 'Position', [50, 50, 2000, 1000])
ha = tight_subplot(3, 1, [.025 .05],[.075 .02],[.042 .012]);
axes(ha(1));
plot(f_bins, (average_f_A(:, 6)*3.3)/(16384*0.8), 'm', 'LineWidth', 1.5)
xlim([0 8192])
ylim([0 0.35])
set(gca,'XTickLabel',[]);
yticks([0 0.05 0.1 0.15 0.2 0.25 0.3 0.35])
ylabel('Acceleration (g)')
legend('MEMS (A)')
grid on

axes(ha(2));
plot(f_bins, (average_f_B(:, 6)*3.3)/(16384*0.4), 'g', 'LineWidth', 1.5)
xlim([0 8192])
ylim([0 0.35])
set(gca,'XTickLabel',[]);
yticks([0 0.05 0.1 0.15 0.2 0.25 0.3 0.35])
ylabel('Acceleration (g)')
legend('MEMS (B)')
grid on

axes(ha(3));
plot(f_bins, (average_f_C(:, 6)*3.3)/(16384*0.04), 'k', 'LineWidth', 1.5)
xlim([0 8192])
ylim([0 0.35])
xlabel('Frequency (Hz)')
yticks([0 0.05 0.1 0.15 0.2 0.25 0.3 0.35])
ylabel('Acceleration (g)')
legend('MEMS (C)')
grid on


set(findall(gcf,'-property','FontSize'),'FontSize',18)
%%
model_frequency = [253, 553, 1053, 1553, 2053, 2553];

model_x = zeros(N, 6);

model_x(:, 1) = sin(model_frequency(1)*2*pi*t);
model_x(:, 2) = sin(model_frequency(1)*2*pi*t);
model_x(:, 3) = sin(model_frequency(1)*2*pi*t);
model_x(:, 4) = sin(model_frequency(1)*2*pi*t);
model_x(:, 5) = sin(model_frequency(1)*2*pi*t);
model_x(:, 6) = sin(model_frequency(6)*2*pi*t);

%%