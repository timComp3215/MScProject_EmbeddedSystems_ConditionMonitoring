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

x_small_healthy = zeros(N, 5);
x_small_bend = zeros(N, 5);
% x_big_Healhty = zeros(N, 5);

x_small_healthy(:, 1) = csvread('Small/t_H_1.csv');
x_small_healthy(:, 2) = csvread('Small/t_H_2.csv');
x_small_healthy(:, 3) = csvread('Small/t_H_3.csv');
x_small_healthy(:, 4) = csvread('Small/t_H_4.csv');
x_small_healthy(:, 5) = csvread('Small/t_H_5.csv');
x_small_bend(:, 1) = csvread('Small/t_B_1.csv');
x_small_bend(:, 2) = csvread('Small/t_B_2.csv');
x_small_bend(:, 3) = csvread('Small/t_B_3.csv');
x_small_bend(:, 4) = csvread('Small/t_B_4.csv');
x_small_bend(:, 5) = csvread('Small/t_B_5.csv');

x_small_healthy = (x_small_healthy*3.3)/(16384*0.07667);
x_small_bend = (x_small_bend*3.3)/(16384*0.07667);


% x_small_3(:, 1) = csvread('Small/t_Phase3_1.csv');
% x_small_3(:, 2) = csvread('Small/t_Phase3_2.csv');
% x_small_3(:, 3) = csvread('Small/t_Phase3_3.csv');
% x_small_3(:, 4) = csvread('Small/t_Phase3_0.csv');
% x_small_3(:, 5) = csvread('Small/t_Phase3_4.csv');


x_big_healthy = zeros(N, 5);
x_big_bend = zeros(N, 5);
% x_big_3 = zeros(N, 5);

x_big_healthy(:, 1) = csvread('Big/t_H_1.csv');
x_big_healthy(:, 2) = csvread('Big/t_H_2.csv');
x_big_healthy(:, 3) = csvread('Big/t_H_3.csv');
x_big_healthy(:, 4) = csvread('Big/t_H_4.csv');
x_big_healthy(:, 5) = csvread('Big/t_H_5.csv');
x_big_bend(:, 1) = csvread('Big/t_B_1.csv');
x_big_bend(:, 2) = csvread('Big/t_B_2.csv');
x_big_bend(:, 3) = csvread('Big/t_B_3.csv');
x_big_bend(:, 4) = csvread('Big/t_B_4.csv');
x_big_bend(:, 5) = csvread('Big/t_B_5.csv');
% x_big_3(:, 1) = csvread('Big/t_Phase3_1.csv');
% x_big_3(:, 2) = csvread('Big/t_Phase3_2.csv');
% x_big_3(:, 3) = csvread('Big/t_Phase3_3.csv');
% x_big_3(:, 4) = csvread('Big/t_Phase3_0.csv');
% x_big_3(:, 5) = csvread('Big/t_Phase3_4.csv');


x_big_healthy = (x_big_healthy*3.3)/(16384*0.013333);
x_big_bend = (x_big_bend*3.3)/(16384*0.013333);

 figure
 subplot(2, 1, 1)
 plot(t, x_small_healthy(:, 1));
 subplot(2, 1, 2)
 plot(t, x_big_healthy(:, 2));
% subplot(3, 1, 3)
% plot(t, x_big_3(:, 3));


 figure
 subplot(2, 1, 1)
 plot(t, x_small_bend(:, 1));
 subplot(2, 1, 2)
 plot(t, x_big_bend(:, 2));
%%

f_small_healthy = zeros(N/2, 5);
f_small_bend = zeros(N/2, 5);
% f_small_3A = zeros(N/2, 3);
f_big_healthy = zeros(N/2, 5);
f_big_bend = zeros(N/2, 5);
% f_big_3A = zeros(N/2, 3);

f_big_healthy(:, 1) = csvread('Big/f_H_1.csv');
f_big_healthy(:, 2) = csvread('Big/f_H_2.csv');
f_big_healthy(:, 3) = csvread('Big/f_H_3.csv');
f_big_healthy(:, 4) = csvread('Big/f_H_4.csv');
f_big_healthy(:, 5) = csvread('Big/f_H_5.csv');
f_big_bend(:, 1) = csvread('Big/f_B_1.csv');
f_big_bend(:, 2) = csvread('Big/f_B_2.csv');
f_big_bend(:, 3) = csvread('Big/f_B_3.csv');
f_big_bend(:, 4) = csvread('Big/f_B_4.csv');
f_big_bend(:, 5) = csvread('Big/f_B_5.csv');

f_big_healthy = (f_big_healthy*3.3)/(16384*0.013333);
f_big_bend = (f_big_bend*3.3)/(16384*0.013333);


f_small_healthy(:, 1) = csvread('Small/f_H_1.csv');
f_small_healthy(:, 2) = csvread('Small/f_H_2.csv');
f_small_healthy(:, 3) = csvread('Small/f_H_3.csv');
f_small_healthy(:, 4) = csvread('Small/f_H_4.csv');
f_small_healthy(:, 5) = csvread('Small/f_H_5.csv');
f_small_bend(:, 1) = csvread('Small/f_B_2.csv');
f_small_bend(:, 2) = csvread('Small/f_B_2.csv');
f_small_bend(:, 3) = csvread('Small/f_B_3.csv');
f_small_bend(:, 4) = csvread('Small/f_B_4.csv');
f_small_bend(:, 5) = csvread('Small/f_B_5.csv');


f_small_healthy = (f_small_healthy*3.3)/(16384*0.07667);
f_small_bend = (f_small_bend*3.3)/(16384*0.07667);

%%

f_bins = (0:(N/2)-1) .* fs/N;

figure
plot(f_bins, f_small_healthy(:, 1))
hold on
plot(f_bins, f_big_healthy(:, 1));

%%

f_small_healthy_mean = mean(f_small_healthy(:, :)');
f_small_bend_mean = mean(f_small_bend(:, :)');

f_big_healthy_mean = mean(f_big_healthy(:, :)');
f_big_bend_mean = mean(f_big_bend(:, :)');

%%

figure('color', 'w', 'Position', [50, 700, 2000, 550])
ha = tight_subplot(1,2,[.05 .05],[.14 .06],[.042 .01]);

axes(ha(1));
plot(f_bins, f_small_healthy_mean, 'r-o', 'LineWidth', 2, 'MarkerSize', 10)
hold on
plot(f_bins, f_small_bend_mean, 'b-s', 'LineWidth', 2, 'MarkerSize', 10)
% xlim([0 2048])
xlim([0 100])
xlabel('Frequency (Hz)')
ylabel('Magnitude (A)')
legend('Healthy', 'Bending')
title('CT1')

axes(ha(2));
plot(f_bins, f_big_healthy_mean, 'r-o', 'LineWidth', 2, 'MarkerSize', 10)
hold on
plot(f_bins, f_big_bend_mean, 'b-s', 'LineWidth', 2, 'MarkerSize', 10)
% xlim([0 2048])
xlim([0 100])
xlabel('Frequency (Hz)')
ylabel('Magnitude (A)')
legend('Healthy', 'Bending')
title('CT2')

set(findall(gcf,'-property','FontSize'),'FontSize',18)

%%

figure('color', 'w', 'Position', [50, 700, 2000, 550])
ha = tight_subplot(1,2,[.05 .05],[.14 .02],[.03 .01]);
axes(ha(1));
plot(t(1:2048), (x_small_3(1:2048)*3.3)/(16384*0.07667), 'b-', 'LineWidth', 2)
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
plot(t(1:2048), (x_big_3(1:2048)*3.3)/(16384*0.01333333), 'r-', 'LineWidth', 2)
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
