clear all
close all

%Include noise

fs = 4096; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 4096/fs;

model_frequency = 7553;

N = fs * T;

board_N = 2048;

t = linspace(0, T, N);

x_small_1A = zeros(N, 3);
x_small_2A = zeros(N, 3);
x_small_3A = zeros(N, 3);

x_small_1A(:, 1) = csvread('Small/t_1A_1.csv');
x_small_1A(:, 2) = csvread('Small/t_1A_2.csv');
x_small_1A(:, 3) = csvread('Small/t_1A_3.csv');
x_small_2A(:, 1) = csvread('Small/t_2A_1.csv');
x_small_2A(:, 2) = csvread('Small/t_2A_2.csv');
x_small_2A(:, 3) = csvread('Small/t_2A_3.csv');
x_small_3A(:, 1) = csvread('Small/t_3A_1.csv');
x_small_3A(:, 2) = csvread('Small/t_3A_2.csv');
x_small_3A(:, 3) = csvread('Small/t_3A_3.csv');


figure
subplot(3, 1, 1)
plot(t, x_small_1A(:, 1));
subplot(3, 1, 2)
plot(t, x_small_1A(:, 2));
subplot(3, 1, 3)
plot(t, x_small_1A(:, 3));

rms_small = zeros(3, 1);
rms_small(1) = (mean(rms(x_small_1A))*3.3)/(16384*0.07667);
rms_small(2) = (mean(rms(x_small_2A))*3.3)/(16384*0.07667);
rms_small(3) = (mean(rms(x_small_3A))*3.3)/(16384*0.07667);


x_big_1A = zeros(N, 3);
x_big_2A = zeros(N, 3);
x_big_3A = zeros(N, 3);

x_big_1A(:, 1) = csvread('Big/t_1A_1.csv');
x_big_1A(:, 2) = csvread('Big/t_1A_2.csv');
x_big_1A(:, 3) = csvread('Big/t_1A_3.csv');
x_big_2A(:, 1) = csvread('Big/t_2A_1.csv');
x_big_2A(:, 2) = csvread('Big/t_2A_2.csv');
x_big_2A(:, 3) = csvread('Big/t_2A_3.csv');
x_big_3A(:, 1) = csvread('Big/t_3A_1.csv');
x_big_3A(:, 2) = csvread('Big/t_3A_2.csv');
x_big_3A(:, 3) = csvread('Big/t_3A_3.csv');


figure
subplot(3, 1, 1)
plot(t, x_big_3A(:, 1));
subplot(3, 1, 2)
plot(t, x_big_3A(:, 2));
subplot(3, 1, 3)
plot(t, x_big_3A(:, 3));

rms_big = zeros(3, 1);
rms_big(1) = (mean(rms(x_big_1A))*3.3)/(16384*0.013333);
rms_big(2) = (mean(rms(x_big_2A))*3.3)/(16384*0.013333);
rms_big(3) = (mean(rms(x_big_3A))*3.3)/(16384*0.013333);

sensitivity_small = zeros(3, 1);
sensitivity_small(1) = 1000*(mean(rms(x_small_1A))*3.3)/(16384*1);
sensitivity_small(2) = 1000*(mean(rms(x_small_2A))*3.3)/(16384*2);
sensitivity_small(3) = 1000*(mean(rms(x_small_3A))*3.3)/(16384*3);

sensitivity_big = zeros(3, 1);
sensitivity_big(1) = 1000*(mean(rms(x_big_1A))*3.3)/(16384*1);
sensitivity_big(2) = 1000*(mean(rms(x_big_2A))*3.3)/(16384*2);
sensitivity_big(3) = 1000*(mean(rms(x_big_3A))*3.3)/(16384*3);

%%

f_small_1A = zeros(N/2, 3);
f_small_2A = zeros(N/2, 3);
f_small_3A = zeros(N/2, 3);
f_big_1A = zeros(N/2, 3);
f_big_2A = zeros(N/2, 3);
f_big_3A = zeros(N/2, 3);

f_big_1A(:, 1) = csvread('Big/f_1A_1.csv');
f_big_1A(:, 2) = csvread('Big/f_1A_2.csv');
f_big_1A(:, 3) = csvread('Big/f_1A_3.csv');
f_big_2A(:, 1) = csvread('Big/f_2A_1.csv');
f_big_2A(:, 2) = csvread('Big/f_2A_2.csv');
f_big_2A(:, 3) = csvread('Big/f_2A_3.csv');
f_big_3A(:, 1) = csvread('Big/f_3A_1.csv');
f_big_3A(:, 2) = csvread('Big/f_3A_2.csv');
f_big_3A(:, 3) = csvread('Big/f_3A_3.csv');

f_small_1A(:, 1) = csvread('Small/f_1A_1.csv');
f_small_1A(:, 2) = csvread('Small/f_1A_2.csv');
f_small_1A(:, 3) = csvread('Small/f_1A_3.csv');
f_small_2A(:, 1) = csvread('Small/f_2A_1.csv');
f_small_2A(:, 2) = csvread('Small/f_2A_2.csv');
f_small_2A(:, 3) = csvread('Small/f_2A_3.csv');
f_small_3A(:, 1) = csvread('Small/f_3A_1.csv');
f_small_3A(:, 2) = csvread('Small/f_3A_2.csv');
f_small_3A(:, 3) = csvread('Small/f_3A_3.csv');

f_bins = (0:(N/2)-1) .* fs/N;

figure
subplot(3, 1, 1)
plot(f_bins, f_small_1A);
subplot(3, 1, 2)
plot(f_bins, f_small_2A);
subplot(3, 1, 3)
plot(f_bins, f_small_3A);

figure
subplot(3, 1, 1)
plot(f_bins, f_big_1A);
subplot(3, 1, 2)
plot(f_bins, f_big_2A);
subplot(3, 1, 3)
plot(f_bins, f_big_3A);

%%

figure('color', 'w', 'Position', [50, 700, 2000, 550])
ha = tight_subplot(1,2,[.05 .05],[.14 .02],[.03 .01]);
axes(ha(1));
plot(t(1:2048), (x_small_3A(1:2048)*3.3)/(16384*0.07667), 'b-', 'LineWidth', 2)
yticks([-5 -4 -3 -2 -1 0 1 2 3 4 5])
ylim([-4.5 4.5])
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Current (A)')
xlabel('Time (s)')
axes(ha(2));
plot(f_bins(1:200), (f_small_3A(1:200)*3.3)/(16384*0.07667), 'b-', 'LineWidth', 2)
ylabel('Magnitude (A)')
xlabel('Frequency (Hz)')
legend('CT1 @ 3A')

set(findall(gcf,'-property','FontSize'),'FontSize',18)
%%

figure('color', 'w', 'Position', [50, 100, 2000, 550])
ha = tight_subplot(1,2,[.05 .05],[.14 .02],[.03 .01]);
axes(ha(1));
plot(t(1:2048), (x_big_3A(1:2048)*3.3)/(16384*0.01333333), 'r-', 'LineWidth', 2)
yticks([-5 -4 -3 -2 -1 0 1 2 3 4 5])
ylim([-4.5 4.5])
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Current (A)')
xlabel('Time (s)')
axes(ha(2));
plot(f_bins(1:200), (f_big_3A(1:200)*3.3)/(16384*0.01333333), 'r-', 'LineWidth', 2)
ylabel('Magnitude (A)')
xlabel('Frequency (Hz)')
legend('CT2 @ 3A')

set(findall(gcf,'-property','FontSize'),'FontSize',18)

model_F = zeros(round(N/2), 9);




for z = 1:9
    tempF = fft(model_x(:, z));

    tempF = abs(tempF/N);

    model_F(:, z) = tempF(1:round(N/2));
end
%%
