clear all
close all

%Include noise

fs = 4096; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 4096/fs;

N = fs * T;

t = linspace(0, T, N);

f_bins = (0:(N/2)-1) .* fs/N;

x_Small_0 = zeros(N, 3);

x_Small_0(:, 1) = (csvread('Small/t_0_0.csv')*3.3)/(16384*0.07667);
x_Small_0(:, 2) = (csvread('Small/t_0_1.csv')*3.3)/(16384*0.07667);
x_Small_0(:, 3) = (csvread('Small/t_0_2.csv')*3.3)/(16384*0.07667);

x_Small_250 = zeros(N, 3);

x_Small_250(:, 1) = (csvread('Small/t_250_0.csv')*3.3)/(16384*0.07667);
x_Small_250(:, 2) = (csvread('Small/t_250_1.csv')*3.3)/(16384*0.07667);
x_Small_250(:, 3) = (csvread('Small/t_250_2.csv')*3.3)/(16384*0.07667);

x_Small_500 = zeros(N, 3);

x_Small_500(:, 1) = (csvread('Small/t_500_0.csv')*3.3)/(16384*0.07667);
x_Small_500(:, 2) = (csvread('Small/t_500_1.csv')*3.3)/(16384*0.07667);
x_Small_500(:, 3) = (csvread('Small/t_500_2.csv')*3.3)/(16384*0.07667);

x_Small_750 = zeros(N, 3);

x_Small_750(:, 1) = (csvread('Small/t_750_0.csv')*3.3)/(16384*0.07667);
x_Small_750(:, 2) = (csvread('Small/t_750_1.csv')*3.3)/(16384*0.07667);
x_Small_750(:, 3) = (csvread('Small/t_750_2.csv')*3.3)/(16384*0.07667);

x_Small_1000 = zeros(N, 3);

x_Small_1000(:, 1) = (csvread('Small/t_1000_0.csv')*3.3)/(16384*0.07667);
x_Small_1000(:, 2) = (csvread('Small/t_1000_1.csv')*3.3)/(16384*0.07667);
x_Small_1000(:, 3) = (csvread('Small/t_1000_2.csv')*3.3)/(16384*0.07667);

x_Small_1250 = zeros(N, 3);

x_Small_1250(:, 1) = (csvread('Small/t_1250_0.csv')*3.3)/(16384*0.07667);
x_Small_1250(:, 2) = (csvread('Small/t_1250_1.csv')*3.3)/(16384*0.07667);
x_Small_1250(:, 3) = (csvread('Small/t_1250_2.csv')*3.3)/(16384*0.07667);

x_Small_1500 = zeros(N, 3);

x_Small_1500(:, 1) = (csvread('Small/t_1500_0.csv')*3.3)/(16384*0.07667);
x_Small_1500(:, 2) = (csvread('Small/t_1500_1.csv')*3.3)/(16384*0.07667);
x_Small_1500(:, 3) = (csvread('Small/t_1500_2.csv')*3.3)/(16384*0.07667);

%%

figure;
subplot(3, 1, 1)
plot(t, x_Small_0(:, 1));
subplot(3, 1, 2)
plot(t, x_Small_0(:, 2));
subplot(3, 1, 3)
plot(t, x_Small_0(:, 3));

%%

figure
plot(t, x_Small_0(:, 1))
hold on
plot(t, x_Small_250(:, 1))
plot(t, x_Small_500(:, 1))
plot(t, x_Small_750(:, 1))
plot(t, x_Small_1000(:, 1))
plot(t, x_Small_1250(:, 1))
plot(t, x_Small_1500(:, 1))

%%

x_Big_0 = zeros(N, 3);

x_Big_0(:, 1) = (csvread('Big/t_0_0.csv')*3.3)/(16384*0.013333);
x_Big_0(:, 2) = (csvread('Big/t_0_1.csv')*3.3)/(16384*0.013333);
x_Big_0(:, 3) = (csvread('Big/t_0_2.csv')*3.3)/(16384*0.013333);

x_Big_250 = zeros(N, 3);

x_Big_250(:, 1) = (csvread('Big/t_250_0.csv')*3.3)/(16384*0.013333);
x_Big_250(:, 2) = (csvread('Big/t_250_1.csv')*3.3)/(16384*0.013333);
x_Big_250(:, 3) = (csvread('Big/t_250_2.csv')*3.3)/(16384*0.013333);

x_Big_500 = zeros(N, 3);

x_Big_500(:, 1) = (csvread('Big/t_500_0.csv')*3.3)/(16384*0.013333);
x_Big_500(:, 2) = (csvread('Big/t_500_1.csv')*3.3)/(16384*0.013333);
x_Big_500(:, 3) = (csvread('Big/t_500_2.csv')*3.3)/(16384*0.013333);

x_Big_750 = zeros(N, 3);

x_Big_750(:, 1) = (csvread('Big/t_750_0.csv')*3.3)/(16384*0.013333);
x_Big_750(:, 2) = (csvread('Big/t_750_1.csv')*3.3)/(16384*0.013333);
x_Big_750(:, 3) = (csvread('Big/t_750_2.csv')*3.3)/(16384*0.013333);

x_Big_1000 = zeros(N, 3);

x_Big_1000(:, 1) = (csvread('Big/t_1000_0.csv')*3.3)/(16384*0.013333);
x_Big_1000(:, 2) = (csvread('Big/t_1000_1.csv')*3.3)/(16384*0.013333);
x_Big_1000(:, 3) = (csvread('Big/t_1000_2.csv')*3.3)/(16384*0.013333);

x_Big_1250 = zeros(N, 3);

x_Big_1250(:, 1) = (csvread('Big/t_1250_0.csv')*3.3)/(16384*0.013333);
x_Big_1250(:, 2) = (csvread('Big/t_1250_1.csv')*3.3)/(16384*0.013333);
x_Big_1250(:, 3) = (csvread('Big/t_1250_2.csv')*3.3)/(16384*0.013333);

x_Big_1500 = zeros(N, 3);

x_Big_1500(:, 1) = (csvread('Big/t_1500_0.csv')*3.3)/(16384*0.013333);
x_Big_1500(:, 2) = (csvread('Big/t_1500_1.csv')*3.3)/(16384*0.013333);
x_Big_1500(:, 3) = (csvread('Big/t_1500_2.csv')*3.3)/(16384*0.013333);

%%

f_Small_0 = zeros(N/2, 3);

f_Small_0(:, 1) = (csvread('Small/f_0_0.csv')*3.3)/(16384*0.07667);
f_Small_0(:, 2) = (csvread('Small/f_0_1.csv')*3.3)/(16384*0.07667);
f_Small_0(:, 3) = (csvread('Small/f_0_2.csv')*3.3)/(16384*0.07667);

f_Small_250 = zeros(N/2, 3);

f_Small_250(:, 1) = (csvread('Small/f_250_0.csv')*3.3)/(16384*0.07667);
f_Small_250(:, 2) = (csvread('Small/f_250_1.csv')*3.3)/(16384*0.07667);
f_Small_250(:, 3) = (csvread('Small/f_250_2.csv')*3.3)/(16384*0.07667);

f_Small_500 = zeros(N/2, 3);

f_Small_500(:, 1) = (csvread('Small/f_500_0.csv')*3.3)/(16384*0.07667);
f_Small_500(:, 2) = (csvread('Small/f_500_1.csv')*3.3)/(16384*0.07667);
f_Small_500(:, 3) = (csvread('Small/f_500_2.csv')*3.3)/(16384*0.07667);

f_Small_750 = zeros(N/2, 3);

f_Small_750(:, 1) = (csvread('Small/f_750_0.csv')*3.3)/(16384*0.07667);
f_Small_750(:, 2) = (csvread('Small/f_750_1.csv')*3.3)/(16384*0.07667);
f_Small_750(:, 3) = (csvread('Small/f_750_2.csv')*3.3)/(16384*0.07667);

f_Small_1000 = zeros(N/2, 3);

f_Small_1000(:, 1) = (csvread('Small/f_1000_0.csv')*3.3)/(16384*0.07667);
f_Small_1000(:, 2) = (csvread('Small/f_1000_1.csv')*3.3)/(16384*0.07667);
f_Small_1000(:, 3) = (csvread('Small/f_1000_2.csv')*3.3)/(16384*0.07667);

f_Small_1250 = zeros(N/2, 3);

f_Small_1250(:, 1) = (csvread('Small/f_1250_0.csv')*3.3)/(16384*0.07667);
f_Small_1250(:, 2) = (csvread('Small/f_1250_1.csv')*3.3)/(16384*0.07667);
f_Small_1250(:, 3) = (csvread('Small/f_1250_2.csv')*3.3)/(16384*0.07667);

f_Small_1500 = zeros(N/2, 3);

f_Small_1500(:, 1) = (csvread('Small/f_1500_0.csv')*3.3)/(16384*0.07667);
f_Small_1500(:, 2) = (csvread('Small/f_1500_1.csv')*3.3)/(16384*0.07667);
f_Small_1500(:, 3) = (csvread('Small/f_1500_2.csv')*3.3)/(16384*0.07667);


%%

f_Big_0 = zeros(N/2, 3);

f_Big_0(:, 1) = (csvread('Big/f_0_0.csv')*3.3)/(16384*0.013333);
f_Big_0(:, 2) = (csvread('Big/f_0_1.csv')*3.3)/(16384*0.013333);
f_Big_0(:, 3) = (csvread('Big/f_0_2.csv')*3.3)/(16384*0.013333);

f_Big_250 = zeros(N/2, 3);

f_Big_250(:, 1) = (csvread('Big/f_250_0.csv')*3.3)/(16384*0.013333);
f_Big_250(:, 2) = (csvread('Big/f_250_1.csv')*3.3)/(16384*0.013333);
f_Big_250(:, 3) = (csvread('Big/f_250_2.csv')*3.3)/(16384*0.013333);

f_Big_500 = zeros(N/2, 3);

f_Big_500(:, 1) = (csvread('Big/f_500_0.csv')*3.3)/(16384*0.013333);
f_Big_500(:, 2) = (csvread('Big/f_500_1.csv')*3.3)/(16384*0.013333);
f_Big_500(:, 3) = (csvread('Big/f_500_2.csv')*3.3)/(16384*0.013333);

f_Big_750 = zeros(N/2, 3);

f_Big_750(:, 1) = (csvread('Big/f_750_0.csv')*3.3)/(16384*0.013333);
f_Big_750(:, 2) = (csvread('Big/f_750_1.csv')*3.3)/(16384*0.013333);
f_Big_750(:, 3) = (csvread('Big/f_750_2.csv')*3.3)/(16384*0.013333);

f_Big_1000 = zeros(N/2, 3);

f_Big_1000(:, 1) = (csvread('Big/f_1000_0.csv')*3.3)/(16384*0.013333);
f_Big_1000(:, 2) = (csvread('Big/f_1000_1.csv')*3.3)/(16384*0.013333);
f_Big_1000(:, 3) = (csvread('Big/f_1000_2.csv')*3.3)/(16384*0.013333);

f_Big_1250 = zeros(N/2, 3);

f_Big_1250(:, 1) = (csvread('Big/f_1250_0.csv')*3.3)/(16384*0.013333);
f_Big_1250(:, 2) = (csvread('Big/f_1250_1.csv')*3.3)/(16384*0.013333);
f_Big_1250(:, 3) = (csvread('Big/f_1250_2.csv')*3.3)/(16384*0.013333);

f_Big_1500 = zeros(N/2, 3);

f_Big_1500(:, 1) = (csvread('Big/f_1500_0.csv')*3.3)/(16384*0.013333);
f_Big_1500(:, 2) = (csvread('Big/f_1500_1.csv')*3.3)/(16384*0.013333);
f_Big_1500(:, 3) = (csvread('Big/f_1500_2.csv')*3.3)/(16384*0.013333);


%%

figure
subplot(2, 1, 1)
plot(f_bins, f_Small_0(:, 1));
hold on
plot(f_bins, f_Small_250(:, 1));
plot(f_bins, f_Small_500(:, 1));
plot(f_bins, f_Small_750(:, 1));
plot(f_bins, f_Small_1000(:, 1));
plot(f_bins, f_Small_1250(:, 1));
plot(f_bins, f_Small_1500(:, 1));
xlim([0 60])

subplot(2, 1, 2)
plot(f_bins, f_Big_0(:, 1));
hold on
plot(f_bins, f_Big_250(:, 1));
plot(f_bins, f_Big_500(:, 1));
plot(f_bins, f_Big_750(:, 1));
plot(f_bins, f_Big_1000(:, 1));
plot(f_bins, f_Big_1250(:, 1));
plot(f_bins, f_Big_1500(:, 1));
xlim([0 60])


%%

f_Small_0_mean = mean(f_Small_0(:, :)');
f_Small_250_mean = mean(f_Small_250(:, :)');
f_Small_500_mean = mean(f_Small_500(:, :)');
f_Small_750_mean = mean(f_Small_750(:, :)');
f_Small_1000_mean = mean(f_Small_1000(:, :)');
f_Small_1250_mean = mean(f_Small_1250(:, :)');
f_Small_1500_mean = mean(f_Small_1500(:, :)');

f_Big_0_mean = mean(f_Big_0(:, :)');
f_Big_250_mean = mean(f_Big_250(:, :)');
f_Big_500_mean = mean(f_Big_500(:, :)');
f_Big_750_mean = mean(f_Big_750(:, :)');
f_Big_1000_mean = mean(f_Big_1000(:, :)');
f_Big_1250_mean = mean(f_Big_1250(:, :)');
f_Big_1500_mean = mean(f_Big_1500(:, :)');

%%

figure('color', 'w', 'Position', [200 200 1800 600])
ha = tight_subplot(1, 2, [.025 .07],[.14 .06],[.05 .01]);

axes(ha(1));
plot(f_bins, f_Small_0_mean, 'r-x', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Small_250_mean, 'b-o', 'MarkerSize', 10, 'LineWidth', 1)
hold on
plot(f_bins, f_Small_250_mean, 'b-o', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Small_500_mean, 'g-d', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Small_750_mean, 'm-^', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Small_1000_mean, 'c-v', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Small_1250_mean, 'k-p', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Small_1500_mean, 'r-h', 'MarkerSize', 10, 'LineWidth', 1)
xlim([0 75])
ylabel('Magnitude (A)')
xlabel('Frequency (Hz)')
title('CT1')


axes(ha(2));
plot(f_bins, f_Big_0_mean, 'r-x', 'MarkerSize', 10, 'LineWidth', 1)
hold on
plot(f_bins, f_Big_250_mean, 'b-o', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Big_500_mean, 'g-d', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Big_750_mean, 'm-^', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Big_1000_mean, 'c-v', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Big_1250_mean, 'k-p', 'MarkerSize', 10, 'LineWidth', 1)
plot(f_bins, f_Big_1500_mean, 'r-h', 'MarkerSize', 10, 'LineWidth', 1)
xlim([0 75])
ylabel('Magnitude (A)')
xlabel('Frequency (Hz)')
title('CT2')
legend('0 RPM', '250 RPM', '500 RPM', '750 RPM', '1000 RPM', '1250 RPM', '1500 RPM', 'Location', 'East')

set(findall(gcf,'-property','FontSize'),'FontSize',18)
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
rms_A(1) = (mean(rms(x_Small_0))*3.3)/(16384*0.8);
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

figure('color', 'w', 'Position', [50, 50, 2000, 600])
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
legend('A', 'B', 'C')

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
legend('A')

axes(ha(2));
plot(t, (x_B_2553(:, 3)*3.3)/(16384*0.4), 'g', 'LineWidth', 1.5)
xlim([0 0.05])
ylim([-1.2 1.2])
set(gca,'XTickLabel',[]);
ylabel('Acceleration (g)')
legend('B')

axes(ha(3));
plot(t, (x_C_2553(:, 3)*3.3)/(16384*0.04), 'k', 'LineWidth', 1.5)
xlim([0 0.05])
ylim([-1.2 1.2])
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('C')


set(findall(gcf,'-property','FontSize'),'FontSize',18)
%%

figure('color', 'w', 'Position', [50, 50, 2000, 1000])
ha = tight_subplot(3, 1, [.025 .05],[.075 .02],[.042 .012]);
axes(ha(1));
plot(f_bins, (average_f_A(:, 6)*3.3)/(16384*0.8), 'm', 'LineWidth', 2)
xlim([0 8192])
ylim([0 0.35])
set(gca,'XTickLabel',[]);
yticks([0 0.05 0.1 0.15 0.2 0.25 0.3 0.35])
ylabel('Acceleration (g)')
legend('A')
grid on

axes(ha(2));
plot(f_bins, (average_f_B(:, 6)*3.3)/(16384*0.4), 'g', 'LineWidth', 2)
xlim([0 8192])
ylim([0 0.35])
set(gca,'XTickLabel',[]);
yticks([0 0.05 0.1 0.15 0.2 0.25 0.3 0.35])
ylabel('Acceleration (g)')
legend('B')
grid on

axes(ha(3));
plot(f_bins, (average_f_C(:, 6)*3.3)/(16384*0.04), 'k', 'LineWidth', 2)
xlim([0 8192])
ylim([0 0.35])
xlabel('Frequency (Hz)')
yticks([0 0.05 0.1 0.15 0.2 0.25 0.3 0.35])
ylabel('Acceleration (g)')
legend('C')
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