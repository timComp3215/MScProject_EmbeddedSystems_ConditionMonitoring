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

x_healthy = zeros(N, 10, 3);

D_00mm = csvread('Ref/Healthy1.csv');
D_02mm = csvread('Ref/Healthy2.csv');
D_04mm = csvread('Ref/Healthy3.csv');
D_06mm = csvread('Ref/Healthy4.csv');
D_08mm = csvread('Ref/Healthy5.csv');
D_10mm = csvread('Ref/Healthy6.csv');
D_12mm = csvread('Ref/Healthy7.csv');
D_14mm = csvread('Ref/Healthy8.csv');
D_16mm = csvread('Ref/Healthy9.csv');
D_18mm = csvread('Ref/Bend1.csv');

for i = 1:3
        x_healthy(:, 1, i) = D_00mm(:, 2 + i);
        x_healthy(:, 2, i) = D_02mm(:, 2 + i);
        x_healthy(:, 3, i) = D_04mm(:, 2 + i);
        x_healthy(:, 4, i) = D_06mm(:, 2 + i);
        x_healthy(:, 5, i) = D_08mm(:, 2 + i);
        x_healthy(:, 6, i) = D_10mm(:, 2 + i);
        x_healthy(:, 7, i) = D_12mm(:, 2 + i);
        x_healthy(:, 8, i) = D_14mm(:, 2 + i);
        x_healthy(:, 9, i) = D_16mm(:, 2 + i);
        x_healthy(:, 10, i) = D_18mm(:, 2 + i);
end
%%
% x_bend = zeros(N, 10, 3);
% 
% D_00mm = csvread('Bending21.csv');
% D_02mm = csvread('Bending22.csv');
% D_04mm = csvread('Bending23.csv');
% D_06mm = csvread('Bending24.csv');
% D_08mm = csvread('Bending25.csv');
% D_10mm = csvread('Bending26.csv');
% D_12mm = csvread('Bending27.csv');
% D_14mm = csvread('Bending28.csv');
% D_16mm = csvread('Bending29.csv');
% D_18mm = csvread('Bending30.csv');
% 
% for i = 1:3
%         x_bend(:, 1, i) = D_00mm(:, 2 + i);
%         x_bend(:, 2, i) = D_02mm(:, 2 + i);
%         x_bend(:, 3, i) = D_04mm(:, 2 + i);
%         x_bend(:, 4, i) = D_06mm(:, 2 + i);
%         x_bend(:, 5, i) = D_08mm(:, 2 + i);
%         x_bend(:, 6, i) = D_10mm(:, 2 + i);
%         x_bend(:, 7, i) = D_12mm(:, 2 + i);
%         x_bend(:, 8, i) = D_14mm(:, 2 + i);
%         x_bend(:, 9, i) = D_16mm(:, 2 + i);
%         x_bend(:, 10, i) = D_18mm(:, 2 + i);
% end
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
x_healthy_mean = zeros(10, 3);
x_bend_mean = zeros(10, 3);
x_worn_mean = zeros(10, 3);

for z = 1:10
    for i = 1:3
        x_healthy_mean(z, i) = mean(x_healthy(:, z, i));
%         x_bend_mean(z, i) = mean(x_healthy(:, z, i));
%         x_worn_mean(z, i) = mean(x_healthy(:, z, i));
        for n = 1:N
            x_healthy(n, z, i) = x_healthy(n, z, i) - x_healthy_mean(z, i);
%             x_bend(n, z, i) = x_bend(n, z, i) - x_bend_mean(z, i);
%             x_worn(n, z, i) = x_worn(n, z, i) - x_worn_mean(z, i);
        end
    end
end

%%

x_A_healthy = zeros(N2, 5);

x_A_healthy(:, 1) = csvread('A/t_H_1.csv');
x_A_healthy(:, 2) = csvread('A/t_H_2.csv');
x_A_healthy(:, 3) = csvread('A/t_H_3.csv');
x_A_healthy(:, 4) = csvread('A/t_H_4.csv');
x_A_healthy(:, 5) = csvread('A/t_H_5.csv');

x_A_healthy = (x_A_healthy*3.3)/(16384*0.8);

x_B_healthy = zeros(N2, 5);

x_B_healthy(:, 1) = csvread('B/t_H_1.csv');
x_B_healthy(:, 2) = csvread('B/t_H_2.csv');
x_B_healthy(:, 3) = csvread('B/t_H_3.csv');
x_B_healthy(:, 4) = csvread('B/t_H_4.csv');
x_B_healthy(:, 5) = csvread('B/t_H_5.csv');

x_B_healthy = (x_B_healthy*3.3)/(16384*0.4);

x_C_healthy = zeros(N2, 5);

x_C_healthy(:, 1) = csvread('C/t_H_1.csv');
x_C_healthy(:, 2) = csvread('C/t_H_2.csv');
x_C_healthy(:, 3) = csvread('C/t_H_3.csv');
x_C_healthy(:, 4) = csvread('C/t_H_4.csv');
x_C_healthy(:, 5) = csvread('C/t_H_5.csv');

x_C_healthy = (x_C_healthy*3.3)/(16384*0.04);

%%

figure
subplot(2, 2, 1)
plot(t, x_healthy(:, 3, 2))
xlim([0 0.5])
subplot(2, 2, 2)
plot(t2, x_A_healthy(:, 3))
xlim([0 0.5])
subplot(2, 2, 3)
plot(t2, x_B_healthy(:, 3))
xlim([0 0.5])
subplot(2, 2, 4)
plot(t2, x_C_healthy(:, 3))
xlim([0 0.5])

%%
f_A_healthy = zeros(N2/2, 5);

f_A_healthy(:, 1) = csvread('A/f_H_1.csv');
f_A_healthy(:, 2) = csvread('A/f_H_2.csv');
f_A_healthy(:, 3) = csvread('A/f_H_3.csv');
f_A_healthy(:, 4) = csvread('A/f_H_4.csv');
f_A_healthy(:, 5) = csvread('A/f_H_5.csv');

f_A_healthy = (f_A_healthy*3.3)/(16384*0.8);

f_B_healthy = zeros(N2/2, 5);

f_B_healthy(:, 1) = csvread('B/f_H_1.csv');
f_B_healthy(:, 2) = csvread('B/f_H_2.csv');
f_B_healthy(:, 3) = csvread('B/f_H_3.csv');
f_B_healthy(:, 4) = csvread('B/f_H_4.csv');
f_B_healthy(:, 5) = csvread('B/f_H_5.csv');

f_B_healthy = (f_B_healthy*3.3)/(16384*0.4);

f_C_healthy = zeros(N2/2, 5);

f_C_healthy(:, 1) = csvread('C/f_H_1.csv');
f_C_healthy(:, 2) = csvread('C/f_H_2.csv');
f_C_healthy(:, 3) = csvread('C/f_H_3.csv');
f_C_healthy(:, 4) = csvread('C/f_H_4.csv');
f_C_healthy(:, 5) = csvread('C/f_H_5.csv');

f_C_healthy = (f_C_healthy*3.3)/(16384*0.04);

%%

F_healthy = zeros(round(N/2), 10, 3);

for z = 1:10
    for i = 1:3
        tempf = fft(x_healthy(:, z, i));
        tempf = abs(tempf/N);
        F_healthy(:, z, i) = tempf(1:round(N/2), 1);
    end
end

%%
F_healthy_average = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_healthy_average(n, 1) = mean(F_healthy(n, :, 2));
end

F_A_healthy_average = zeros(N2/2, 1);
for n = 1:round(N2/2)
    F_A_healthy_average(n, 1) = mean(f_A_healthy(n, :));
end

F_B_healthy_average = zeros(N2/2, 1);
for n = 1:round(N2/2)
    F_B_healthy_average(n, 1) = mean(f_B_healthy(n, :));
end

F_C_healthy_average = zeros(N2/2, 1);
for n = 1:round(N2/2)
    F_C_healthy_average(n, 1) = mean(f_C_healthy(n, :));
end

%%

figure
subplot(2, 2, 1)
plot(f_bins, F_healthy_average);
xlim([0 1500])
ylim([0 0.16])
subplot(2, 2, 2)
plot(f_bins2, F_A_healthy_average);
xlim([0 1500])
ylim([0 0.016])
subplot(2, 2, 3)
plot(f_bins2, F_B_healthy_average);
xlim([0 1500])
ylim([0 0.016])
subplot(2, 2, 4)
plot(f_bins2, F_C_healthy_average);
xlim([0 1500])
ylim([0 0.016])

%%

figure
plot(f_bins, F_healthy_average)
hold on
plot(f_bins2, F_A_healthy_average*10)
plot(f_bins2, F_B_healthy_average*10)
xlim([0 1500])
legend('Ref', 'A', 'B')

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

FT = zeros(round(N/2), 1);

FT(:, 1) = freq(1:round(N/2));

F_stats_healthy = zeros(10, 3, 3);

F_stats_bend = zeros(10, 3, 3);

F_stats_worn = zeros(10, 3, 3);

for z = 1:10
    for i = 1:3
        F_stats_healthy(z, i, 1) = max(F_healthy( :, z, i));
        F_stats_healthy(z, i, 2) = std(F_healthy( :, z, i));
        F_stats_healthy(z, i, 3) = rms(F_healthy( :, z, i));
        
        F_stats_bend(z, i, 1) = max(F_bend( :, z, i));
        F_stats_bend(z, i, 2) = std(F_bend( :, z, i));
        F_stats_bend(z, i, 3) = rms(F_bend( :, z, i));
        
        F_stats_worn(z, i, 1) = max(F_worn( :, z, i));
        F_stats_worn(z, i, 2) = std(F_worn( :, z, i));
        F_stats_worn(z, i, 3) = rms(F_worn( :, z, i));

    end
end

F_stats_healthy_avg = zeros(3, 3);
F_stats_bend_avg = zeros(3, 3);
F_stats_worn_avg = zeros(3, 3);

for i = 1:3
    F_stats_healthy_avg(i, 1) = mean(F_stats_healthy(:, 1, i));
    F_stats_healthy_avg(i, 2) = mean(F_stats_healthy(:, 2, i));
    F_stats_healthy_avg(i, 3) = mean(F_stats_healthy(:, 3, i));
    
    F_stats_bend_avg(i, 1) = mean(F_stats_bend(:, 1, i));
    F_stats_bend_avg(i, 2) = mean(F_stats_bend(:, 2, i));
    F_stats_bend_avg(i, 3) = mean(F_stats_bend(:, 3, i));
    
    F_stats_worn_avg(i, 1) = mean(F_stats_worn(:, 1, i));
    F_stats_worn_avg(i, 2) = mean(F_stats_worn(:, 2, i));
    F_stats_worn_avg(i, 3) = mean(F_stats_worn(:, 3, i));
end

figure('color', 'w', 'Position', [100, 800, 2000, 550])
ha = tight_subplot(1,3,[.075 .07],[.08 .075],[.04 .04]);
for i = 1:3
    axes(ha(i));
        
    scatter3(F_stats_healthy(1, i, 1), F_stats_healthy(1, i, 2), F_stats_healthy(1, i, 3), 'ro');
    hold on  
    scatter3(F_stats_healthy(2, i, 1), F_stats_healthy(2, i, 2), F_stats_healthy(2, i, 3), 'ro');
    scatter3(F_stats_healthy(3, i, 1), F_stats_healthy(3, i, 2), F_stats_healthy(3, i, 3), 'ro');
    scatter3(F_stats_healthy(4, i, 1), F_stats_healthy(4, i, 2), F_stats_healthy(4, i, 3), 'ro');
    scatter3(F_stats_healthy(5, i, 1), F_stats_healthy(5, i, 2), F_stats_healthy(5, i, 3), 'ro');
    scatter3(F_stats_healthy(6, i, 1), F_stats_healthy(6, i, 2), F_stats_healthy(6, i, 3), 'ro');
    scatter3(F_stats_healthy(7, i, 1), F_stats_healthy(7, i, 2), F_stats_healthy(7, i, 3), 'ro');
    scatter3(F_stats_healthy(8, i, 1), F_stats_healthy(8, i, 2), F_stats_healthy(8, i, 3), 'ro');
    scatter3(F_stats_healthy(9, i, 1), F_stats_healthy(9, i, 2), F_stats_healthy(9, i, 3), 'ro');
    scatter3(F_stats_healthy(10, i, 1), F_stats_healthy(10, i, 2), F_stats_healthy(10, i, 3), 'ro');
    
  
    scatter3(F_stats_bend(1, i, 1), F_stats_bend(1, i, 2), F_stats_bend(1, i, 3), 'bs');
    scatter3(F_stats_bend(2, i, 1), F_stats_bend(2, i, 2), F_stats_bend(2, i, 3), 'bs');
    scatter3(F_stats_bend(3, i, 1), F_stats_bend(3, i, 2), F_stats_bend(3, i, 3), 'bs');
    scatter3(F_stats_bend(4, i, 1), F_stats_bend(4, i, 2), F_stats_bend(4, i, 3), 'bs');
    scatter3(F_stats_bend(5, i, 1), F_stats_bend(5, i, 2), F_stats_bend(5, i, 3), 'bs');
    scatter3(F_stats_bend(6, i, 1), F_stats_bend(6, i, 2), F_stats_bend(6, i, 3), 'bs');
    scatter3(F_stats_bend(7, i, 1), F_stats_bend(7, i, 2), F_stats_bend(7, i, 3), 'bs');
    scatter3(F_stats_bend(8, i, 1), F_stats_bend(8, i, 2), F_stats_bend(8, i, 3), 'bs');
    scatter3(F_stats_bend(9, i, 1), F_stats_bend(9, i, 2), F_stats_bend(9, i, 3), 'bs');
    scatter3(F_stats_bend(10, i, 1), F_stats_bend(10, i, 2), F_stats_bend(10, i, 3), 'bs');
    
    scatter3(F_stats_worn(1, i, 1), F_stats_worn(1, i, 2), F_stats_worn(1, i, 3), 'g^');
    scatter3(F_stats_worn(2, i, 1), F_stats_worn(2, i, 2), F_stats_worn(2, i, 3), 'g^');
    scatter3(F_stats_worn(3, i, 1), F_stats_worn(3, i, 2), F_stats_worn(3, i, 3), 'g^');
    scatter3(F_stats_worn(4, i, 1), F_stats_worn(4, i, 2), F_stats_worn(4, i, 3), 'g^');
    scatter3(F_stats_worn(5, i, 1), F_stats_worn(5, i, 2), F_stats_worn(5, i, 3), 'g^');
    scatter3(F_stats_worn(6, i, 1), F_stats_worn(6, i, 2), F_stats_worn(6, i, 3), 'g^');
    scatter3(F_stats_worn(7, i, 1), F_stats_worn(7, i, 2), F_stats_worn(7, i, 3), 'g^');
    scatter3(F_stats_worn(8, i, 1), F_stats_worn(8, i, 2), F_stats_worn(8, i, 3), 'g^');
    scatter3(F_stats_worn(9, i, 1), F_stats_worn(9, i, 2), F_stats_worn(9, i, 3), 'g^');
    scatter3(F_stats_worn(10, i, 1), F_stats_worn(10, i, 2), F_stats_worn(10, i, 3), 'g^');
    
    h1 = scatter3(F_stats_healthy_avg(1, i), F_stats_healthy_avg(2, i), F_stats_healthy_avg(3, i), 'ro', 'MarkerFaceColor', 'r', 'LineWidth', 5);
    h2 = scatter3(F_stats_bend_avg(1, i), F_stats_bend_avg(2, i), F_stats_bend_avg(3, i), 'bs', 'MarkerFaceColor', 'b', 'LineWidth', 5);
    h3 = scatter3(F_stats_worn_avg(1, i), F_stats_worn_avg(2, i), F_stats_worn_avg(3, i), 'g^', 'LineWidth', 5);
    %legend('0mm', '0.2 mm', '0.4mm', '0.6mm', '0.8mm', '1mm', '1.2mm', '1.4mm', '1.6mm', '1.8mm', 'average');

    xlabel('Max')
    ylabel('Std')
    zlabel('RMS')
    
    text1 = sprintf('Bearing %d', i);
    title(text1);
    
end
%Legend on 3rd graph only
leg = legend([h1 h2 h3], 'Healthy', 'Bending', 'Bearing Fault', 'Location', 'northeast');
title(leg, 'Average')
set(findall(gcf,'-property','FontSize'),'FontSize',18)


%%
figure('color', 'w', 'Position', [100, 100, 2000, 550])
ha = tight_subplot(1,3,[.075 .07],[.15 .075],[.042 .02]);
for i = 1:3
    axes(ha(i));
        
    scatter3(F_stats_healthy(1, i, 1), F_stats_healthy(1, i, 2), F_stats_healthy(1, i, 3), 'ro');
    hold on  
    scatter3(F_stats_healthy(2, i, 1), F_stats_healthy(2, i, 2), F_stats_healthy(2, i, 3), 'ro');
    scatter3(F_stats_healthy(3, i, 1), F_stats_healthy(3, i, 2), F_stats_healthy(3, i, 3), 'ro');
    scatter3(F_stats_healthy(4, i, 1), F_stats_healthy(4, i, 2), F_stats_healthy(4, i, 3), 'ro');
    scatter3(F_stats_healthy(5, i, 1), F_stats_healthy(5, i, 2), F_stats_healthy(5, i, 3), 'ro');
    scatter3(F_stats_healthy(6, i, 1), F_stats_healthy(6, i, 2), F_stats_healthy(6, i, 3), 'ro');
    scatter3(F_stats_healthy(7, i, 1), F_stats_healthy(7, i, 2), F_stats_healthy(7, i, 3), 'ro');
    scatter3(F_stats_healthy(8, i, 1), F_stats_healthy(8, i, 2), F_stats_healthy(8, i, 3), 'ro');
    scatter3(F_stats_healthy(9, i, 1), F_stats_healthy(9, i, 2), F_stats_healthy(9, i, 3), 'ro');
    scatter3(F_stats_healthy(10, i, 1), F_stats_healthy(10, i, 2), F_stats_healthy(10, i, 3), 'ro');
    
  
    scatter3(F_stats_bend(1, i, 1), F_stats_bend(1, i, 2), F_stats_bend(1, i, 3), 'bs');
    scatter3(F_stats_bend(2, i, 1), F_stats_bend(2, i, 2), F_stats_bend(2, i, 3), 'bs');
    scatter3(F_stats_bend(3, i, 1), F_stats_bend(3, i, 2), F_stats_bend(3, i, 3), 'bs');
    scatter3(F_stats_bend(4, i, 1), F_stats_bend(4, i, 2), F_stats_bend(4, i, 3), 'bs');
    scatter3(F_stats_bend(5, i, 1), F_stats_bend(5, i, 2), F_stats_bend(5, i, 3), 'bs');
    scatter3(F_stats_bend(6, i, 1), F_stats_bend(6, i, 2), F_stats_bend(6, i, 3), 'bs');
    scatter3(F_stats_bend(7, i, 1), F_stats_bend(7, i, 2), F_stats_bend(7, i, 3), 'bs');
    scatter3(F_stats_bend(8, i, 1), F_stats_bend(8, i, 2), F_stats_bend(8, i, 3), 'bs');
    scatter3(F_stats_bend(9, i, 1), F_stats_bend(9, i, 2), F_stats_bend(9, i, 3), 'bs');
    scatter3(F_stats_bend(10, i, 1), F_stats_bend(10, i, 2), F_stats_bend(10, i, 3), 'bs');
    
    scatter3(F_stats_worn(1, i, 1), F_stats_worn(1, i, 2), F_stats_worn(1, i, 3), 'g^');
    scatter3(F_stats_worn(2, i, 1), F_stats_worn(2, i, 2), F_stats_worn(2, i, 3), 'g^');
    scatter3(F_stats_worn(3, i, 1), F_stats_worn(3, i, 2), F_stats_worn(3, i, 3), 'g^');
    scatter3(F_stats_worn(4, i, 1), F_stats_worn(4, i, 2), F_stats_worn(4, i, 3), 'g^');
    scatter3(F_stats_worn(5, i, 1), F_stats_worn(5, i, 2), F_stats_worn(5, i, 3), 'g^');
    scatter3(F_stats_worn(6, i, 1), F_stats_worn(6, i, 2), F_stats_worn(6, i, 3), 'g^');
    scatter3(F_stats_worn(7, i, 1), F_stats_worn(7, i, 2), F_stats_worn(7, i, 3), 'g^');
    scatter3(F_stats_worn(8, i, 1), F_stats_worn(8, i, 2), F_stats_worn(8, i, 3), 'g^');
    scatter3(F_stats_worn(9, i, 1), F_stats_worn(9, i, 2), F_stats_worn(9, i, 3), 'g^');
    scatter3(F_stats_worn(10, i, 1), F_stats_worn(10, i, 2), F_stats_worn(10, i, 3), 'g^');
    
    h1 = scatter3(F_stats_healthy_avg(1, i), F_stats_healthy_avg(2, i), F_stats_healthy_avg(3, i), 'ro', 'MarkerFaceColor', 'r', 'LineWidth', 5);
    h2 = scatter3(F_stats_bend_avg(1, i), F_stats_bend_avg(2, i), F_stats_bend_avg(3, i), 'bs', 'MarkerFaceColor', 'b', 'LineWidth', 5);
    h3 = scatter3(F_stats_worn_avg(1, i), F_stats_worn_avg(2, i), F_stats_worn_avg(3, i), 'g^', 'LineWidth', 5);
    %legend('0mm', '0.2 mm', '0.4mm', '0.6mm', '0.8mm', '1mm', '1.2mm', '1.4mm', '1.6mm', '1.8mm', 'average');
    
    xlabel('Max')
    ylabel('Std')
    zlabel('RMS')
    
    
    text1 = sprintf('Bearing %d', i);
    title(text1);
    
    view([0 90])
end
%Legend on 3rd graph only
leg = legend([h1 h2 h3], 'Healthy', 'Bending', 'Bearing Fault', 'Location', 'northeast');
title(leg, 'Average')
set(findall(gcf,'-property','FontSize'),'FontSize',18)
%%

F_healthy_average = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_healthy_average(n, 1) = mean(F_healthy(n, :, 2));
end


F_bend_average = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_bend_average(n, 1) = mean(F_bend(n, :, 2));
end


F_worn_average = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_worn_average(n, 1) = mean(F_worn(n, :, 2));
end


figure('color', 'w', 'Position', [100, 100, 2000, 1100])
ha = tight_subplot(3, 1,[.04 .05],[.075 .035],[.04 .02]);
axes(ha(1));
plot(f_bins, F_healthy_average, 'r', 'LineWidth', 1);
ylim([0 0.1])
xlim([0 1500])
ax = gca;
ax.YAxis.Exponent = -3;
yticks([0 0.025 0.05 0.075 0.1 0.125 0.15])
set(gca,'XTickLabel',[]);
legend('Healthy')
grid on
%xlabel('Frequency (Hz)')
ylabel('Magnitude (g)')

axes(ha(2));
plot(f_bins, F_bend_average, 'b', 'LineWidth', 1);
ylim([0 0.1])
xlim([0 1500])
ax = gca;
ax.YAxis.Exponent = -3;
yticks([0 0.025 0.05 0.075 0.1 0.125 0.15])
set(gca,'XTickLabel',[]);
grid on
legend('Bending')
%xlabel('Frequency (Hz)')
ylabel('Magnitude (g)')

axes(ha(3));
plot(f_bins, F_worn_average, 'g', 'LineWidth', 1);
ylim([0 0.15])
xlim([0 1500])
ax = gca;
ax.YAxis.Exponent = -3;
yticks([0 0.025 0.05 0.075 0.1 0.125 0.15])
grid on
legend('Faulty Bearing')
xlabel('Frequency (Hz)')
ylabel('Magnitude (g)')

set(findall(gcf,'-property','FontSize'),'FontSize',18)
%%

mean_values = mean(x_healthy(:, 1, 3));
x_mean = zeros(N, 1);

for n = 1:N
    x_mean(n) = x_healthy(n, 1, 3) - mean_values;
end

tempf = fft(x_mean);
tempf = abs(tempf/N);
F_mean = tempf(1:round(N/2), 1);

figure
subplot(2, 1, 1)
plot(f_bins, F_healthy(:, 1, 3))
subplot(2, 1, 2)
plot(f_bins, F_mean)

%%
figure
loglog(rms(x_healthy(:, :, 2))*9.81, max(abs(x_healthy(:, :, 2))*9.81), 'bs')
hold on
loglog(rms(x_bend(:, :, 2))*9.81, max(abs(x_bend(:, :, 2))*9.81), 'g^')
loglog(rms(x_worn(:, :, 2))*9.81, max(abs(x_worn(:, :, 2))*9.81), 'rx')
legend('Healthy', 'Bending', 'Worn')
xlim([1 100])
ylim([3 300])