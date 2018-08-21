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
% x_worn = zeros(N, 10, 3);
% 
% D_00mm = csvread('Worn0.csv');
% D_02mm = csvread('Worn1.csv');
% D_04mm = csvread('Worn2.csv');
% D_06mm = csvread('Worn3.csv');
% D_08mm = csvread('Worn4.csv');
% D_10mm = csvread('Worn5.csv');
% D_12mm = csvread('Worn6.csv');
% D_14mm = csvread('Worn7.csv');
% D_16mm = csvread('Worn8.csv');
% D_18mm = csvread('Worn9.csv');
% 
% for i = 1:3
%         x_worn(:, 1, i) = D_00mm(:, 2 + i);
%         x_worn(:, 2, i) = D_02mm(:, 2 + i);
%         x_worn(:, 3, i) = D_04mm(:, 2 + i);
%         x_worn(:, 4, i) = D_06mm(:, 2 + i);
%         x_worn(:, 5, i) = D_08mm(:, 2 + i);
%         x_worn(:, 6, i) = D_10mm(:, 2 + i);
%         x_worn(:, 7, i) = D_12mm(:, 2 + i);
%         x_worn(:, 8, i) = D_14mm(:, 2 + i);
%         x_worn(:, 9, i) = D_16mm(:, 2 + i);
%         x_worn(:, 10, i) = D_18mm(:, 2 + i);
% end
%%
%Remove DC component
x_healthy_mean = zeros(10);
x_bend_mean = zeros(10);
x_worn_mean = zeros(10, 3);

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
%         x_worn_mean(z, i) = mean(x_healthy(:, z, i));
    for n = 1:N
%         x_healthy(n, z) = x_healthy(n, z) - x_healthy_mean(z);
        x_bend(n, z) = x_bend(n, z) - x_bend_mean(z);
%             x_worn(n, z, i) = x_worn(n, z, i) - x_worn_mean(z, i);
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


%%

F_healthy = zeros(round(N/2), 10);

for z = 1:10
    tempf = fft(x_healthy(:, z));
    tempf = abs(tempf/N);
    F_healthy(:, z) = tempf(1:round(N/2), 1);
end

F_bend = zeros(round(N/2), 10);

for z = 1:5
    tempf = fft(x_bend(:, z));
    tempf = abs(tempf/N);
    F_bend(:, z) = tempf(1:round(N/2), 1);
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

F_A_healthy_average = zeros(N2/2, 1);
for n = 1:round(N2/2)
    F_A_healthy_average(n, 1) = mean(f_A_healthy(n, :));
end

F_A_bend_average = zeros(N2/2, 1);
for n = 1:round(N2/2)
    F_A_bend_average(n, 1) = mean(f_A_bend(n, :));
end

%%

figure
subplot(2, 2, 1)
plot(t, x_healthy(:, 1));
legend('Healthy')
xlim([0 0.5])
subplot(2, 2, 2)
plot(t, x_bend(:, 1));
xlim([0 0.5])
legend('Bent')
subplot(2, 2, 3)
plot(t2, x_A_healthy(:, 1));
xlim([0 0.5])
legend('Healthy_sensor')
subplot(2, 2, 4)
plot(t2, x_A_bend(:, 1));
legend('Bent_sensor')
xlim([0 0.5])

%%

figure
subplot(2, 2, 1)
plot(f_bins, F_healthy_average1);
xlim([0 4096])
legend('Healthy')
subplot(2, 2, 2)
plot(f_bins, F_bend_average);
xlim([0 4096])
legend('Bent')
subplot(2, 2, 3)
plot(f_bins2, F_A_healthy_average);
xlim([0 4096])
legend('Healthy_sensor')
subplot(2, 2, 4)
plot(f_bins2, F_A_bend_average);
xlim([0 4096])
legend('Bent_sensor')

%%

rms_healthy = zeros(5, 1);
rms_bend = zeros(5, 1);
rms_A_healthy = zeros(5, 1);
rms_A_bend = zeros(5, 1);

for z = 1:5
    rms_healthy(z) = rms(F_healthy(:, z));
    rms_bend(z) = rms(F_bend(:, z));
    rms_A_healthy(z) = rms(f_A_healthy(:, z));
    rms_A_bend(z) = rms(f_A_bend(:, z));
end

max_healthy = zeros(5, 1);
max_bend = zeros(5, 1);
max_A_healthy = zeros(5, 1);
max_A_bend = zeros(5, 1);

for z = 1:5
    max_healthy(z) = max(F_healthy(:, z));
    max_bend(z) = max(F_bend(:, z));
    max_A_healthy(z) = max(f_A_healthy(:, z));
    max_A_bend(z) = max(f_A_bend(:, z));
end

std_healthy = zeros(5, 1);
std_bend = zeros(5, 1);
std_A_healthy = zeros(5, 1);
std_A_bend = zeros(5, 1);

for z = 1:5
    std_healthy(z) = std(F_healthy(:, z));
    std_bend(z) = std(F_bend(:, z));
    std_A_healthy(z) = std(f_A_healthy(:, z));
    std_A_bend(z) = std(f_A_bend(:, z));
end
%%

figure
scatter(max_healthy, std_healthy);
hold on
scatter(max_bend, std_bend);
legend('H', 'B')

%%

figure
scatter(max_A_healthy, std_A_healthy);
hold on
scatter(max_A_bend, std_A_bend);
legend('H', 'B')

%%

figure
scatter(max_healthy, std_healthy);
hold on
scatter(max_bend, std_bend);
scatter(max_A_healthy, std_A_healthy);
scatter(max_A_bend, std_A_bend);
legend('H', 'B', 'H_A', 'H_B')

%%

figure
scatter3(max_healthy, std_healthy, rms_healthy);
hold on
scatter3(max_bend, std_bend, rms_bend);
scatter3(max_A_healthy, std_A_healthy, rms_A_healthy);
scatter3(max_A_bend, std_A_bend, rms_A_bend);
legend('H', 'B', 'H_A', 'H_B')

%%
y = zeros(N2, 5);

for z = 1:5
    y(:, z) = lowpass(x_B_healthy(:, z), 1500, 8192);
end

F_y = zeros(round(N2/2), 5);

for z = 1:5

    tempf = fft(y(:, z));
    tempf = abs(tempf/N2);
    F_y(:, z) = tempf(1:round(N2/2), 1);

end

F_y_average = zeros(N2/2, 1);
for n = 1:round(N2/2)
    F_y_average(n, 1) = mean(F_y(n, :));
end

figure
subplot(3, 1, 3)
plot(f_bins2, F_y_average)
xlim([0 4096])
subplot(3, 1, 1)
plot(f_bins, F_healthy_average)
xlim([0 4096])
subplot(3, 1, 2)
plot(f_bins2, F_A_healthy_average)
xlim([0 4096])

%%

figure
plot(f_bins, F_healthy_average)
hold on
plot(f_bins2, F_A_healthy_average)
plot(f_bins2, F_y_average)
xlim([0 1500])
legend('Ref', 'A', 'Bavg')


%%
max_healthy = max(F_healthy(:, :, 2));
max_A_healthy = max(f_A_healthy);
max_y = max(F_y);

max_healthy_avg = max(F_healthy_average);
max_A_healthy_avg = max(F_A_healthy_average);
max_y_avg = max(F_y_average);

std_healthy = std(F_healthy(:, :, 2));
std_A_healthy = std(f_A_healthy);
std_y = std(F_y);

std_healthy_avg = std(F_healthy_average);
std_A_healthy_avg = std(F_A_healthy_average);
std_y_avg = std(F_y_average);

figure
scatter(max_healthy_avg, std_healthy_avg);
hold on
scatter(max_A_healthy_avg, std_A_healthy_avg);
scatter(max_y_avg, std_y_avg);

scatter(max_healthy, std_healthy);
scatter(max_A_healthy, std_A_healthy);
scatter(max_y, std_y);
legend('Ref', 'A', 'Y')

%%

figure
subplot(3, 1, 1)
plot(t, x_healthy(:, 1, 1))
ylim([-1 1])
subplot(3, 1, 2)
plot(t, x_bend(:, 1, 1))
ylim([-1 1])
subplot(3, 1, 3)
plot(t, x_worn(:, 1, 1))
ylim([-1 1])
%%

freq = (0:N-1) .* fs/N;

F_healthy = zeros(round(N/2), 10, 3);

for z = 1:10
    for i = 1:3
        tempf = fft(x_healthy(:, z, i));
        tempf = abs(tempf/N);
        F_healthy(:, z, i) = tempf(1:round(N/2), 1);
    end
end
%%
F_bend = zeros(round(N/2), 10, 3);

for z = 1:10
    for i = 1:3
        tempf = fft(x_bend(:, z, i));
        tempf = abs(tempf/N);
        F_bend(:, z, i) = tempf(1:round(N/2), 1);
    end
end

F_worn = zeros(round(N/2), 10, 3);

for z = 1:10
    for i = 1:3
        tempf = fft(x_worn(:, z, i));
        tempf = abs(tempf/N);
        F_worn(:, z, i) = tempf(1:round(N/2), 1);
    end
end
%%
f_bins = freq(1:round(N/2));
%%
figure
subplot(3, 1, 1)
plot(f_bins, F_healthy(:, 1, 1))
subplot(3, 1, 2)
plot(f_bins, F_healthy(:, 1, 2))
subplot(3, 1, 3)
plot(f_bins, F_healthy(:, 1, 3))

for i = 1:3
    figure
    subplot(3, 1, 1)
    plot(f_bins, F_healthy(:, 1, i))
    subplot(3, 1, 2)
    plot(f_bins, F_bend(:, 1, i))
    subplot(3, 1, 3)
    plot(f_bins, F_worn(:, 1, i))
end

%%
figure
loglog(rms(x_healthy(:, 1:5))*9.81, max(abs(x_healthy(:, 1:5))*9.81), 'bs')
hold on
loglog(rms(x_bend(:, :))*9.81, max(abs(x_bend(:, :))*9.81), 'g^')
% loglog(rms(x_worn(:, :, 2))*9.81, max(abs(x_worn(:, :, 2))*9.81), 'rx')
plot([0.1 10], [.3 30])
plot([0.1 10], [.6 60])
plot([0.1 10], [1 100])
legend('Healthy', 'Bending', 'Zone2', 'Zone3', 'Zone4')
xlim([.1 10])
ylim([.3 30])

%%

figure
loglog(rms(x_A_healthy(:, 1:5))*9.81, max(abs(x_A_healthy(:, 1:5))*9.81), 'bs')
hold on
loglog(rms(x_A_bend(:, :))*9.81, max(abs(x_A_bend(:, :))*9.81), 'g^')
% loglog(rms(x_worn(:, :, 2))*9.81, max(abs(x_worn(:, :, 2))*9.81), 'rx')
plot([0.1 10], [.3 30])
plot([0.1 10], [.6 60])
plot([0.1 10], [1 100])
legend('Healthy', 'Bending', 'Zone2', 'Zone3', 'Zone4')
xlim([.1 1])
ylim([.3 3])