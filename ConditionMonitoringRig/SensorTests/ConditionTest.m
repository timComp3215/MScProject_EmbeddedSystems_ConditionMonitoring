clear all
close all

%Initial program designed to analyse data in multiple slices at the
%actual sampling frequency given


%Include noise

fs = 5000; %Sample frequency
fs2 = 8192; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 25000/fs;
T2 = 4096/fs2;

N = fs * T;
N2 = fs2 * T2;

t = linspace(0, T, N);
t2 = linspace(0, T2, N2);

f_bins = (0:(N/2)-1) .* fs/N;
f_bins2 = (0:(N2/2)-1) .* fs2/N2;

x_healthy = zeros(N, 10);

D_00mm = csvread('Ref/Healthy20.csv');
D_02mm = csvread('Ref/Healthy21.csv');
D_04mm = csvread('Ref/Healthy22.csv');
D_06mm = csvread('Ref/Healthy23.csv');
D_08mm = csvread('Ref/Healthy24.csv');
D_10mm = csvread('Ref/Healthy25.csv');
D_12mm = csvread('Ref/Healthy26.csv');
D_14mm = csvread('Ref/Healthy27.csv');
D_16mm = csvread('Ref/Healthy28.csv');
D_18mm = csvread('Ref/Healthy29.csv');

i = 2; %Bearing 2 only

x_healthy(:, 1) = D_00mm(:, 2 + i);
x_healthy(:, 2) = D_02mm(:, 2 + i);
x_healthy(:, 3) = D_04mm(:, 2 + i);
x_healthy(:, 4) = D_06mm(:, 2 + i);
x_healthy(:, 5) = D_08mm(:, 2 + i);
x_healthy(:, 6) = D_10mm(:, 2 + i);
x_healthy(:, 7) = D_12mm(:, 2 + i);
x_healthy(:, 8) = D_14mm(:, 2 + i);
x_healthy(:, 9) = D_16mm(:, 2 + i);
x_healthy(:, 10) = D_18mm(:, 2 + i);

x_healthy = x_healthy / 10;
%%
x_bend = zeros(N, 5);

D_00mm = csvread('Ref/Bent1.csv');
D_02mm = csvread('Ref/Bent2.csv');
D_04mm = csvread('Ref/Bent3.csv');
D_06mm = csvread('Ref/Bent4.csv');
D_08mm = csvread('Ref/Bent5.csv');
% D_10mm = csvread('Bending26.csv');
% D_12mm = csvread('Bending27.csv');
% D_14mm = csvread('Bending28.csv');
% D_16mm = csvread('Bending29.csv');
% D_18mm = csvread('Bending30.csv');

i = 2; %Bearing 2 only
x_bend(:, 1) = D_00mm(:, 2 + i);
x_bend(:, 2) = D_02mm(:, 2 + i);
x_bend(:, 3) = D_04mm(:, 2 + i);
x_bend(:, 4) = D_06mm(:, 2 + i);
x_bend(:, 5) = D_08mm(:, 2 + i);
%         x_bend(:, 6, i) = D_10mm(:, 2 + i);
%         x_bend(:, 7, i) = D_12mm(:, 2 + i);
%         x_bend(:, 8, i) = D_14mm(:, 2 + i);
%         x_bend(:, 9, i) = D_16mm(:, 2 + i);
%         x_bend(:, 10, i) = D_18mm(:, 2 + i);
x_bend = x_bend / 10;
% 
 x_worn = zeros(N, 5);

D_00mm = csvread('Ref/Worn11.csv');
D_02mm = csvread('Ref/Worn12.csv');
D_04mm = csvread('Ref/Worn13.csv');
D_06mm = csvread('Ref/Worn14.csv');
D_08mm = csvread('Ref/Worn15.csv');

i = 2; %Bearing 2 only
x_worn(:, 1) = D_00mm(:, 2 + i);
x_worn(:, 2) = D_02mm(:, 2 + i);
x_worn(:, 3) = D_04mm(:, 2 + i);
x_worn(:, 4) = D_06mm(:, 2 + i);
x_worn(:, 5) = D_08mm(:, 2 + i);

x_worn = x_worn / 10;

%%
%Remove DC component
x_healthy_mean = zeros(10);
x_bend_mean = zeros(5);
x_worn_mean = zeros(5);

for z = 1:10
    x_healthy_mean(z) = mean(x_healthy(:, z));
%     x_bend_mean(z) = mean(x_healthy(:, z));
%         x_worn_mean(z, i) = mean(x_healthy(:, z, i));
    for n = 1:N
        x_healthy(n, z) = x_healthy(n, z) - x_healthy_mean(z);
%         x_bend(n, z) = x_bend(n, z) - x_bend_mean(z);
%             x_worn(n, z, i) = x_worn(n, z, i) - x_worn_mean(z, i);
    end
end

for z = 1:5
%     x_healthy_mean(z) = mean(x_healthy(:, z));
    x_bend_mean(z) = mean(x_healthy(:, z));
    x_worn_mean(z) = mean(x_healthy(:, z));
    
    for n = 1:N
%         x_healthy(n, z) = x_healthy(n, z) - x_healthy_mean(z);
        x_bend(n, z) = x_bend(n, z) - x_bend_mean(z);
        x_worn(n, z) = x_worn(n, z) - x_worn_mean(z);
    end
end

%%

x_A_healthy = zeros(N2, 5);

x_A_healthy(:, 1) = csvread('A/t_H_20.csv');
x_A_healthy(:, 2) = csvread('A/t_H_21.csv');
x_A_healthy(:, 3) = csvread('A/t_H_22.csv');
x_A_healthy(:, 4) = csvread('A/t_H_23.csv');
x_A_healthy(:, 5) = csvread('A/t_H_24.csv');

x_A_healthy = (x_A_healthy*3.3)/(16384*0.8);

x_A_bend = zeros(N2, 5);

x_A_bend(:, 1) = csvread('A/t_B_1.csv');
x_A_bend(:, 2) = csvread('A/t_B_2.csv');
x_A_bend(:, 3) = csvread('A/t_B_3.csv');
x_A_bend(:, 4) = csvread('A/t_B_4.csv');
x_A_bend(:, 5) = csvread('A/t_B_5.csv');

x_A_bend = (x_A_bend*3.3)/(16384*0.8);

x_A_worn = zeros(N2, 5);

x_A_worn(:, 1) = csvread('A/t_W_1.csv');
x_A_worn(:, 2) = csvread('A/t_W_2.csv');
x_A_worn(:, 3) = csvread('A/t_W_3.csv');
x_A_worn(:, 4) = csvread('A/t_W_4.csv');
x_A_worn(:, 5) = csvread('A/t_W_5.csv');

x_A_worn = (x_A_worn*3.3)/(16384*0.8);

%%



%%
f_A_healthy = zeros(N2/2, 5);

f_A_healthy(:, 1) = csvread('A/f_H_20.csv');
f_A_healthy(:, 2) = csvread('A/f_H_21.csv');
f_A_healthy(:, 3) = csvread('A/f_H_22.csv');
f_A_healthy(:, 4) = csvread('A/f_H_23.csv');
f_A_healthy(:, 5) = csvread('A/f_H_24.csv');

f_A_healthy = (f_A_healthy*3.3)/(16384*0.8);

f_A_bend = zeros(N2/2, 5);

f_A_bend(:, 1) = csvread('A/f_B_1.csv');
f_A_bend(:, 2) = csvread('A/f_B_2.csv');
f_A_bend(:, 3) = csvread('A/f_B_3.csv');
f_A_bend(:, 4) = csvread('A/f_B_4.csv');
f_A_bend(:, 5) = csvread('A/f_B_5.csv');

f_A_bend = (f_A_bend*3.3)/(16384*0.8);

f_A_worn = zeros(N2/2, 5);
f_A_worn(:, 1) = csvread('A/f_W_1.csv');
f_A_worn(:, 2) = csvread('A/f_W_2.csv');
f_A_worn(:, 3) = csvread('A/f_W_3.csv');
f_A_worn(:, 4) = csvread('A/f_W_4.csv');
f_A_worn(:, 5) = csvread('A/f_W_5.csv');

f_A_worn = (f_A_worn*3.3)/(16384*0.8);

%%

F_healthy = zeros(round(N/2), 10);

for z = 1:10
    tempf = fft(x_healthy(:, z));
    tempf = abs(tempf/N);
    F_healthy(:, z) = tempf(1:round(N/2), 1);
end

F_bend = zeros(round(N/2), 5);

for z = 1:5
    tempf = fft(x_bend(:, z));
    tempf = abs(tempf/N);
    F_bend(:, z) = tempf(1:round(N/2), 1);
end

F_worn = zeros(round(N/2), 5);

for z = 1:5
    tempf = fft(x_worn(:, z));
    tempf = abs(tempf/N);
    F_worn(:, z) = tempf(1:round(N/2), 1);
end

%%
F_healthy_average1 = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_healthy_average1(n, 1) = mean(F_healthy(n, 1:5));
end

F_healthy_average2 = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_healthy_average2(n, 1) = mean(F_healthy(n, 6:10));
end

F_bend_average = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_bend_average(n, 1) = mean(F_bend(n, :));
end

F_worn_average = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_worn_average(n, 1) = mean(F_worn(n, :));
end

F_A_healthy_average = zeros(N2/2, 1);
for n = 1:round(N2/2)
    F_A_healthy_average(n, 1) = mean(f_A_healthy(n, :));
end

F_A_bend_average = zeros(N2/2, 1);
for n = 1:round(N2/2)
    F_A_bend_average(n, 1) = mean(f_A_bend(n, :));
end

F_A_worn_average = zeros(N2/2, 1);
for n = 1:round(N2/2)
    F_A_worn_average(n, 1) = mean(f_A_worn(n, :));
end

%%

figure('color', 'w', 'Position', [100, 100, 1500, 1000])
ha = tight_subplot(2, 3,[.07 .03],[.075 .01],[.051 .011]);

axes(ha(1));
plot(t, x_healthy(:, 1), 'r');
legend('Healthy_{ref}')
ylim([-0.2 0.2])
xlim([0 0.5])
ylabel('Acceleration (g)')
xticklabels('')

axes(ha(2));
plot(t, x_bend(:, 1), 'b');
xlim([0 0.5])
ylim([-0.2 0.2])
legend('Bent_{ref}')
xticklabels('')
yticklabels('')

axes(ha(3));
plot(t, x_worn(:, 1), 'g');
xlim([0 0.5])
ylim([-0.2 0.2])
legend('BF_{ref}')
xticklabels('')
yticklabels('')

axes(ha(4));
plot(t2, x_A_healthy(:, 1), 'r');
xlim([0 0.5])
ylim([-0.2 0.2])
legend('Healthy_A')
ylabel('Acceleration (g)')
xlabel('Time (s)')

axes(ha(5));
plot(t2, x_A_bend(:, 1), 'b');
ylim([-0.2 0.2])
legend('Bent_A')
xlim([0 0.5])
yticklabels('')
xlabel('Time (s)')

axes(ha(6));
plot(t2, x_A_worn(:, 1), 'g');
legend('BF_A')
xlim([0 0.5])
ylim([-0.2 0.2])
yticklabels('')
xlabel('Time (s)')

set(findall(gcf,'-property','FontSize'),'FontSize',18)

%%

figure('color', 'w', 'Position', [100, 100, 1500, 1000])
ha = tight_subplot(2, 3,[.07 .02],[.075 .034],[.045 .005]);

axes(ha(1));
plot(f_bins, F_healthy_average1, 'r', 'LineWidth', 1);
xlim([0 3000])
ylim([0 0.018])
yticks([0 0.004 0.008 0.012 0.016])
ax = gca;
ax.YAxis.Exponent = -3;
xticklabels('')
ylabel('Magnitude (g)')
legend('Healthy_{ref}')

axes(ha(2));
plot(f_bins, F_bend_average, 'b', 'LineWidth', 1);
xlim([0 3000])
ylim([0 0.018])
yticks([0 0.004 0.008 0.012 0.016])
xticklabels('')
yticklabels('')
legend('Bent_{ref}')

axes(ha(3));
plot(f_bins, F_worn_average, 'g', 'LineWidth', 1);
xlim([0 3000])
ylim([0 0.018])
yticks([0 0.004 0.008 0.012 0.016])
xticklabels('')
yticklabels('')
legend('BF_{ref}')

axes(ha(4));
plot(f_bins2, F_A_healthy_average, 'r', 'LineWidth', 1);
xlim([0 3000])
ylim([0 0.018])
yticks([0 0.004 0.008 0.012 0.016])
ax = gca;
ax.YAxis.Exponent = -3;
xticks([0 1000 2000 3000])
xticklabels([0 1 2 3])
xlabel('Frequency (kHz)')
ylabel('Magnitude (g)')
legend('Healthy_A')

axes(ha(5));
plot(f_bins2, F_A_bend_average, 'b', 'LineWidth', 1);
xlim([0 3000])
ylim([0 0.018])
yticks([0 0.004 0.008 0.012 0.016])
yticklabels('')
xticks([0 1000 2000 3000])
xticklabels([0 1 2 3])
xlabel('Frequency (kHz)')
legend('Bent_A')

axes(ha(6));
plot(f_bins2, F_A_worn_average, 'g', 'LineWidth', 1);
xlim([0 3000])
ylim([0 0.018])
yticks([0 0.004 0.008 0.012 0.016])
yticklabels('')
xticks([0 1000 2000 3000])
xticklabels([0 1 2 3])
xlabel('Frequency (kHz)')
legend('BF_A')

set(findall(gcf,'-property','FontSize'),'FontSize',18)

%%

rms_healthy = zeros(5, 1);
rms_healthy2 = zeros(5, 1);
rms_bend = zeros(5, 1);
rms_worn = zeros(5, 1);
rms_A_healthy = zeros(5, 1);
rms_A_bend = zeros(5, 1);
rms_A_worn = zeros(5, 1);

for z = 1:5
    rms_healthy(z) = rms(F_healthy(:, z));
    rms_healthy2(z) = rms(F_healthy(:, 5+z));
    rms_bend(z) = rms(F_bend(:, z));
    rms_worn(z) = rms(F_worn(:, z));
    rms_A_healthy(z) = rms(f_A_healthy(:, z));
    rms_A_bend(z) = rms(f_A_bend(:, z));
    rms_A_worn(z) = rms(f_A_worn(:, z));
end

max_healthy = zeros(5, 1);
max_healthy2 = zeros(5, 1);
max_bend = zeros(5, 1);
max_worn = zeros(5, 1);
max_A_healthy = zeros(5, 1);
max_A_bend = zeros(5, 1);
max_A_worn = zeros(5, 1);

for z = 1:5
    max_healthy(z) = max(F_healthy(:, z));
    max_healthy2(z) = max(F_healthy(:, 5+z));
    max_bend(z) = max(F_bend(:, z));
    max_worn(z) = max(F_worn(:, z));
    max_A_healthy(z) = max(f_A_healthy(:, z));
    max_A_bend(z) = max(f_A_bend(:, z));
    max_A_worn(z) = max(f_A_worn(:, z));
end

std_healthy = zeros(5, 1);
std_healthy2 = zeros(5, 1);
std_bend = zeros(5, 1);
std_worn = zeros(5, 1);
std_A_healthy = zeros(5, 1);
std_A_bend = zeros(5, 1);
std_A_worn = zeros(5, 1);

for z = 1:5
    std_healthy(z) = std(F_healthy(:, z));
    std_healthy2(z) = std(F_healthy(:, 5+z));
    std_bend(z) = std(F_bend(:, z));
    std_worn(z) = std(F_worn(:, z));
    std_A_healthy(z) = std(f_A_healthy(:, z));
    std_A_bend(z) = std(f_A_bend(:, z));
    std_A_worn(z) = std(f_A_worn(:, z));
end

%%

max_healthy_avg = max(F_healthy_average1);
max_bend_avg = max(F_bend_average);
max_worn_avg = max(F_worn_average);
max_A_healthy_avg = max(F_A_healthy_average);
max_A_bend_avg = max(F_A_bend_average);
max_A_worn_avg = max(F_A_worn_average);

std_healthy_avg = std(F_healthy_average1);
std_bend_avg = std(F_bend_average);
std_worn_avg = std(F_worn_average);
std_A_healthy_avg = std(F_A_healthy_average);
std_A_bend_avg = std(F_A_bend_average);
std_A_worn_avg = std(F_A_worn_average);

rms_healthy_avg = rms(F_healthy_average1);
rms_bend_avg = rms(F_bend_average);
rms_worn_avg = rms(F_worn_average);
rms_A_healthy_avg = rms(F_A_healthy_average);
rms_A_bend_avg = rms(F_A_bend_average);
rms_A_worn_avg = rms(F_A_worn_average);

%%

figure
scatter(max_healthy, std_healthy);
hold on
scatter(max_healthy2, std_healthy2);
scatter(max_bend, std_bend);
scatter(max_worn, std_worn);
legend('H', 'H2', 'B', 'W')

%%

figure
scatter(max_A_healthy, std_A_healthy);
hold on
scatter(max_A_bend, std_A_bend);
scatter(max_A_worn, std_A_worn);
legend('H', 'B', 'W')

%%

figure
scatter(max_healthy, std_healthy);
hold on
scatter(max_healthy2, std_healthy2);
scatter(max_bend, std_bend);
scatter(max_A_healthy, std_A_healthy);
scatter(max_A_bend, std_A_bend);
legend('H', 'H2', 'B', 'H_A', 'B_A')
%legend('H', 'B', 'H_A', 'B_A')

%%

figure
scatter(max_healthy_avg, std_healthy_avg)
hold on
scatter(max_bend_avg, std_bend_avg);
scatter(max_A_healthy_avg, std_A_healthy_avg);
scatter(max_A_bend_avg, std_A_bend_avg);
legend('H', 'B', 'H_A', 'B_A')

%%

figure
h1 = scatter(max_healthy_avg, std_healthy_avg, 'ro', 'MarkerFaceColor', 'r');
hold on
h2 = scatter(max_bend_avg, std_bend_avg,  'bs', 'MarkerFaceColor', 'b');
h3 = scatter(max_worn_avg, std_worn_avg,  'g^', 'MarkerFaceColor', 'g');
h4 = scatter(max_A_healthy_avg, std_A_healthy_avg,  'mo', 'MarkerFaceColor', 'm');
h5 = scatter(max_A_bend_avg, std_A_bend_avg,  'cs', 'MarkerFaceColor', 'c');
h6 = scatter(max_A_worn_avg, std_A_worn_avg,  'k^', 'MarkerFaceColor', 'k');

scatter(max_healthy, std_healthy, 'ro');
scatter(max_bend, std_bend, 'bs');
scatter(max_worn, std_worn, 'g^');
scatter(max_A_healthy, std_A_healthy, 'mo');
scatter(max_A_bend, std_A_bend, 'cs');
scatter(max_A_worn, std_A_worn, 'k^');
legend([h1 h2 h3 h4 h5 h6], 'H_{ref}', 'B_{ref}', 'W_ref', 'H_A', 'B_A', 'W_A', 'Location', 'East')

%%

max_healthy_avg = mean(max_healthy);
max_bend_avg = mean(max_bend);
max_worn_avg = mean(max_worn);
max_A_healthy_avg = mean(max_A_healthy);
max_A_bend_avg = mean(max_A_bend);
max_A_worn_avg = mean(max_A_worn);

std_healthy_avg = mean(std_healthy);
std_bend_avg = mean(std_bend);
std_worn_avg = mean(std_worn);
std_A_healthy_avg = mean(std_A_healthy);
std_A_bend_avg = mean(std_A_bend);
std_A_worn_avg = mean(std_A_worn);

rms_healthy_avg = mean(rms_healthy);
rms_bend_avg = mean(rms_bend);
rms_worn_avg = mean(rms_worn);
rms_A_healthy_avg = mean(rms_A_healthy);
rms_A_bend_avg = mean(rms_A_bend);
rms_A_worn_avg = mean(rms_A_worn);

%%

figure('color', 'w', 'Position', [300, 300, 1400, 500])
ha = tight_subplot(1, 2 ,[.045 .07],[.15 .07],[.055 .01]);

axes(ha(1));
h1 = scatter(max_healthy_avg, std_healthy_avg, 'ro', 'MarkerFaceColor', 'r', 'LineWidth', 6);
hold on
h2 = scatter(max_bend_avg, std_bend_avg,  'bs', 'MarkerFaceColor', 'b', 'LineWidth', 6);
h3 = scatter(max_worn_avg, std_worn_avg,  'g^', 'MarkerFaceColor', 'g', 'LineWidth', 6);
scatter(max_healthy, std_healthy, 'ro', 'LineWidth', 1);
scatter(max_bend, std_bend, 'bs', 'LineWidth', 1);
scatter(max_worn, std_worn, 'g^', 'LineWidth', 1);
xlabel('Maximum (g)')
ylabel('std (g)')
xlim([0 0.02])
ylim([0.0001 0.0003])
grid on

leg = legend([h1 h2 h3], 'H_{ref}', 'B_{ref}', 'BF_{ref}', 'Location', 'EastOutside');
title(leg, 'Average')

axes(ha(2));
h4 = scatter(max_A_healthy_avg, std_A_healthy_avg,   'ro', 'MarkerFaceColor', 'r', 'LineWidth', 6);
hold on
h5 = scatter(max_A_bend_avg, std_A_bend_avg,  'bs', 'MarkerFaceColor', 'b', 'LineWidth', 6);
h6 = scatter(max_A_worn_avg, std_A_worn_avg,  'g^', 'MarkerFaceColor', 'g', 'LineWidth', 6);
scatter(max_A_healthy, std_A_healthy, 'ro', 'LineWidth', 1);
scatter(max_A_bend, std_A_bend, 'bs', 'LineWidth', 1);
scatter(max_A_worn, std_A_worn, 'g^', 'LineWidth', 1);

xlabel('Maximum (g)')
ylabel('std (g)')

xlim([0 0.02])
ylim([0.00025 0.0005])
grid on

leg = legend([h4 h5 h6], 'H_A', 'B_A', 'BF_A', 'Location', 'EastOutside')
title(leg, 'Average')

set(findall(gcf,'-property','FontSize'),'FontSize',18)
%%

figure
scatter3(max_healthy, std_healthy, rms_healthy);
hold on
scatter3(max_bend, std_bend, rms_bend);
scatter3(max_A_healthy, std_A_healthy, rms_A_healthy);
scatter3(max_A_bend, std_A_bend, rms_A_bend);
legend('H', 'B', 'H_A', 'H_B')

%%
figure('color', 'w', 'Position', [300, 300, 1200, 500])
ha = tight_subplot(1, 2 ,[.045 .07],[.17 .034],[.065 .013]);

axes(ha(1));
h1 = loglog(mean(rms(x_healthy(:, 1:5))*9.81), mean(max(abs(x_healthy(:, 1:5))*9.81)), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
hold on
loglog(rms(x_healthy(:, 1:5))*9.81, max(abs(x_healthy(:, 1:5))*9.81), 'ro', 'MarkerSize', 10);
h2 = loglog(mean(rms(x_bend(:, :))*9.81), mean(max(abs(x_bend(:, :))*9.81)), 'bs', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
loglog(rms(x_bend(:, :))*9.81, max(abs(x_bend(:, :))*9.81), 'bs', 'MarkerSize', 10);
h3 = loglog(mean(rms(x_worn(:, :))*9.81), mean(max(abs(x_worn(:, :))*9.81)), 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', 10);
loglog(rms(x_worn(:, :))*9.81, max(abs(x_worn(:, :))*9.81), 'g^', 'MarkerSize', 10);
plot([0.1 10], [.3 30], 'g', 'LineWidth', 1)
plot([0.1 10], [.6 60], 'Color', [1 0.8 0], 'LineWidth', 1)
plot([0.1 10], [1 100], 'r', 'LineWidth', 1)
leg = legend([h1 h2 h3], 'Healthy_{ref}', 'Bending_{ref}', 'BF_{ref}', 'Location', 'East');
title(leg, 'Average')
xlim([.1 1])
ylim([.3 4])
xticks([0.1 0.5 1])
xticklabels({'0.1', '0.5', '1.0'})
yticks([0.3 1 2 3 4])
ylabel('Maximum acceleration (ms^{-2})')
xlabel('RMS acceleration (ms^{-2})')
text(0.14,0.35,'Low');
text(0.14,0.7,'Normal');
text(0.14,1.3,'Alert');
text(0.14,2.5,'Alarm');


axes(ha(2));
h1 = loglog(mean(rms(x_A_healthy(:, 1:5))*9.81), mean(max(abs(x_A_healthy(:, 1:5))*9.81)), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
hold on
loglog(rms(x_A_healthy(:, 1:5))*9.81, max(abs(x_A_healthy(:, 1:5))*9.81), 'ro', 'MarkerSize', 10);
h2 = loglog(mean(rms(x_A_bend(:, :))*9.81), mean(max(abs(x_A_bend(:, :))*9.81)), 'bs', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
loglog(rms(x_A_bend(:, :))*9.81, max(abs(x_A_bend(:, :))*9.81), 'bs', 'MarkerSize', 10);
h3 = loglog(mean(rms(x_A_worn(:, :))*9.81), mean(max(abs(x_A_worn(:, :))*9.81)), 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', 10);
loglog(rms(x_A_worn(:, :))*9.81, max(abs(x_A_worn(:, :))*9.81), 'g^', 'MarkerSize', 10);
plot([0.1 10], [.3 30], 'g', 'LineWidth', 1)
plot([0.1 10], [.6 60], 'Color', [1 0.8 0], 'LineWidth', 1)
plot([0.1 10], [1 100], 'r', 'LineWidth', 1)
leg = legend([h1 h2 h3], 'Healthy_{A}', 'Bending_{A}', 'BF_{A}', 'Location', 'East');
title(leg, 'Average')
xlim([.1 1])
ylim([.3 4])
xticks([0.1 0.5 1])
xticklabels({'0.1', '0.5', '1.0'})
yticks([0.3 1 2 3 4])
xlabel('RMS acceleration (ms^{-2})')
text(0.14,0.35,'Low');
text(0.14,0.7,'Normal');
text(0.14,1.3,'Alert');
text(0.14,2.5,'Alarm');

set(findall(gcf,'-property','FontSize'),'FontSize',18)

%%
healthy_max = mean(max(abs(x_A_healthy(:, 1:5))*9.81));
healthy_rms = mean(rms(x_A_healthy(:, 1:5))*9.81);

figure('Color', 'w', 'Position', [100 100 1500 600])
ha = tight_subplot(1, 2 ,[.045 .07],[.15 .06],[.055 .02]);

axes(ha(1));
h1 = loglog(mean(rms(x_A_healthy(:, 1:5))*9.81), mean(max(abs(x_A_healthy(:, 1:5))*9.81)), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
hold on
h2 = loglog(mean(rms(x_A_bend(:, :))*9.81), mean(max(abs(x_A_bend(:, :))*9.81)), 'bs', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
h3 = loglog(mean(rms(x_A_worn(:, :))*9.81), mean(max(abs(x_A_worn(:, :))*9.81)), 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', 10);

plot([0.1 10], [.3 30], 'g', 'LineWidth', 1.5)
plot([0.1 10], [.6 60], 'Color', [1 0.8 0], 'LineWidth', 1.5)
plot([0.1 10], [1 100], 'r', 'LineWidth', 1.5)
plot([0.8*healthy_rms 0.8*healthy_rms], [.1 5*healthy_max], 'k', 'LineWidth', 2')
plot([1.2*healthy_rms 1.2*healthy_rms], [.1 5*healthy_max], 'k', 'LineWidth', 2')
plot([0.8*healthy_rms 1.2*healthy_rms], [1.5*healthy_max 1.5*healthy_max], 'k', 'LineWidth', 2')
xlim([.1 1])
ylim([.3 4])
grid on
text(0.5,2.7,'Unhealthy');
text(0.11,2.7,'Unhealthy');
text(0.28,2.6,'BF');
text(0.25,0.5,'Healthy');
ylabel('Maximum acceleration (ms^{-2})')
xlabel('RMS acceleration (ms^{-2})')
title('ISO bearing fault chart')

leg = legend([h1 h2 h3], 'Healthy_{A}', 'Bending_{A}', 'BF_{A}', 'Location', 'SouthEast');

axes(ha(2));

h4 = scatter(max_A_healthy_avg, std_A_healthy_avg,   'ro', 'MarkerFaceColor', 'r', 'LineWidth', 6);
hold on
h5 = scatter(max_A_bend_avg, std_A_bend_avg,  'bs', 'MarkerFaceColor', 'b', 'LineWidth', 6);
h6 = scatter(max_A_worn_avg, std_A_worn_avg,  'g^', 'MarkerFaceColor', 'g', 'LineWidth', 6);
plot([0.8*max_A_healthy_avg 0.8*max_A_healthy_avg], [0 1], 'k', 'LineWidth', 2')
plot([1.2*max_A_healthy_avg 1.2*max_A_healthy_avg], [0 1], 'k', 'LineWidth', 2')
plot([0 0.5*max_A_healthy_avg], [std_A_healthy_avg std_A_healthy_avg], 'k', 'LineWidth', 2')
plot([0.5*max_A_healthy_avg 0.5*max_A_healthy_avg], [0 std_A_healthy_avg], 'k', 'LineWidth', 2')

text(0.001,0.00038,'Bending');
text(0.012,0.00038,'Healthy');
text(0.001,0.00048,'Unhealthy');
ht = text(0.0187,0.00036,'Unhealthy');
set(ht,'Rotation',90)

xlabel('Maximum (g)')
ylabel('std (g)')

title('Fault classification chart')
leg = legend([h4 h5 h6], 'Healthy_{A}', 'Bending_{A}', 'BF_{A}', 'Location', 'SouthEast');

xlim([0 0.02])
ylim([0.00025 0.0005])
grid on

set(findall(gcf,'-property','FontSize'),'FontSize',18)