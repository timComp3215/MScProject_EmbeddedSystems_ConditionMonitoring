clear all
close all

%Initial program designed to analyse data in multiple slices at the
%actual sampling frequency given


%Include noise

fs = 8192; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 4096/fs;

N = fs * T;

t = linspace(0, T, N);

x_healthy_adxl = zeros(N, 10);

x_healthy_adxl(:, 1) = csvread('ADXL354/t_Healthy0.csv');
x_healthy_adxl(:, 2) = csvread('ADXL354/t_Healthy1.csv');
x_healthy_adxl(:, 3) = csvread('ADXL354/t_Healthy2.csv');
x_healthy_adxl(:, 4) = csvread('ADXL354/t_Healthy3.csv');
x_healthy_adxl(:, 5) = csvread('ADXL354/t_Healthy4.csv');
x_healthy_adxl(:, 6) = csvread('ADXL354/t_Healthy5.csv');
x_healthy_adxl(:, 7) = csvread('ADXL354/t_Healthy6.csv');
x_healthy_adxl(:, 8) = csvread('ADXL354/t_Healthy7.csv');
x_healthy_adxl(:, 9) = csvread('ADXL354/t_Healthy8.csv');
x_healthy_adxl(:, 10) = csvread('ADXL354/t_Healthy9.csv');

figure
subplot(2, 1, 1)
plot(t, x_healthy_adxl(:, 1));
%%
x_bend_adxl = zeros(N, 10);

x_bend_adxl(:, 1) = csvread('ADXL354/t_Bend0.csv');
x_bend_adxl(:, 2) = csvread('ADXL354/t_Bend1.csv');
x_bend_adxl(:, 3) = csvread('ADXL354/t_Bend2.csv');
x_bend_adxl(:, 4) = csvread('ADXL354/t_Bend3.csv');
x_bend_adxl(:, 5) = csvread('ADXL354/t_Bend4.csv');
x_bend_adxl(:, 6) = csvread('ADXL354/t_Bend5.csv');
x_bend_adxl(:, 7) = csvread('ADXL354/t_Bend6.csv');
x_bend_adxl(:, 8) = csvread('ADXL354/t_Bend7.csv');
x_bend_adxl(:, 9) = csvread('ADXL354/t_Bend8.csv');
x_bend_adxl(:, 10) = csvread('ADXL354/t_Bend9.csv');


subplot(2, 1, 2)
plot(t, x_bend_adxl(:, 1));

%%

freq = (0:N-1) .* fs/N;

f_bins = freq(1:round(N/2));

F_healthy_adxl = zeros(round(N/2), 10);

for z = 1:10
    tempf = fft(x_healthy_adxl(:, z));
    tempf = abs(tempf/N);
    F_healthy_adxl(:, z) = tempf(1:round(N/2), 1);
end

F_bend_adxl = zeros(round(N/2), 10);

for z = 1:10
    tempf = fft(x_bend_adxl(:, z));
    tempf = abs(tempf/N);
    F_bend_adxl(:, z) = tempf(1:round(N/2), 1);
end

f_healthy_adxl = zeros(round(N/2), 10);

f_healthy_adxl(:, 1) = csvread('ADXL354/f_Healthy0.csv');
f_healthy_adxl(:, 2) = csvread('ADXL354/f_Healthy1.csv');
f_healthy_adxl(:, 3) = csvread('ADXL354/f_Healthy2.csv');
f_healthy_adxl(:, 4) = csvread('ADXL354/f_Healthy3.csv');
f_healthy_adxl(:, 5) = csvread('ADXL354/f_Healthy4.csv');
f_healthy_adxl(:, 6) = csvread('ADXL354/f_Healthy5.csv');
f_healthy_adxl(:, 7) = csvread('ADXL354/f_Healthy6.csv');
f_healthy_adxl(:, 8) = csvread('ADXL354/f_Healthy7.csv');
f_healthy_adxl(:, 9) = csvread('ADXL354/f_Healthy8.csv');
f_healthy_adxl(:, 10) = csvread('ADXL354/f_Healthy9.csv');

f_bend_adxl = zeros(round(N/2), 10);

f_bend_adxl(:, 1) = csvread('ADXL354/f_Bend0.csv');
f_bend_adxl(:, 2) = csvread('ADXL354/f_Bend1.csv');
f_bend_adxl(:, 3) = csvread('ADXL354/f_Bend2.csv');
f_bend_adxl(:, 4) = csvread('ADXL354/f_Bend3.csv');
f_bend_adxl(:, 5) = csvread('ADXL354/f_Bend4.csv');
f_bend_adxl(:, 6) = csvread('ADXL354/f_Bend5.csv');
f_bend_adxl(:, 7) = csvread('ADXL354/f_Bend6.csv');
f_bend_adxl(:, 8) = csvread('ADXL354/f_Bend7.csv');
f_bend_adxl(:, 9) = csvread('ADXL354/f_Bend8.csv');
f_bend_adxl(:, 10) = csvread('ADXL354/f_Bend9.csv');

F_healthy_average_adxl = zeros(round(N/2), 1);
f_healthy_average_adxl = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_healthy_average_adxl(n, 1) = mean(F_healthy_adxl(n, :));
    f_healthy_average_adxl(n, 1) = mean(f_healthy_adxl(n, :));
end

F_bend_average_adxl = zeros(round(N/2), 1);
f_bend_average_adxl = zeros(round(N/2), 1);
for n = 1:round(N/2)
    F_bend_average_adxl(n, 1) = mean(F_bend_adxl(n, :));
    f_bend_average_adxl(n, 1) = mean(f_bend_adxl(n, :));
end

figure
subplot(2, 1, 1)
plot(f_bins(1:750), F_healthy_average_adxl(1:750, 1));
hold on
plot(f_bins(1:750), f_healthy_average_adxl(1:750, 1));
subplot(2, 1, 2)
plot(f_bins(1:750), F_bend_average_adxl(1:750, 1));
hold on
plot(f_bins(1:750), f_bend_average_adxl(1:750, 1));
title('Average')

figure
plot(f_bins, F_healthy_adxl(:, 1));
hold on
plot(f_bins, f_healthy_adxl(:, 1));

disp(std(F_healthy_adxl(:, 1)));
disp(std(f_healthy_adxl(:, 1)));


%%
F_stats_healthy_adxl = zeros(10, 3);
F_stats_bend_adxl = zeros(10, 3);

for z = 1:10
    for i = 1:3
        F_stats_healthy_adxl(z, 1) = max(F_healthy_adxl( :, z));
        F_stats_healthy_adxl(z, 2) = std(F_healthy_adxl( :, z));
        F_stats_healthy_adxl(z, 3) = rms(F_healthy_adxl( :, z));
        
        F_stats_bend_adxl(z, 1) = max(F_bend_adxl( :, z));
        F_stats_bend_adxl(z, 2) = std(F_bend_adxl( :, z));
        F_stats_bend_adxl(z, 3) = rms(F_bend_adxl( :, z));
        
%         F_stats_worn(z, i, 1) = max(F_worn( :, z, i));
%         F_stats_worn(z, i, 2) = std(F_worn( :, z, i));
%         F_stats_worn(z, i, 3) = rms(F_worn( :, z, i));

    end
end
f_stats_healthy_adxl = [53, 3, 4;
                       56, 3, 4;
                       57, 3, 4;
                       56, 3, 4;
                       56, 3, 4;
                       56, 3, 4;
                       55, 3, 4;
                       54, 3, 4;
                       54, 3, 4;
                       55, 3, 4];


f_stats_bend_adxl = [28, 3, 4;
                   27, 3, 3;
                   28, 3, 3;
                   23, 3, 3;
                   21, 3, 4;
                   23, 3, 4;
                   25, 3, 4;
                   29, 3, 4;
                   36, 3, 4;
                   25, 3, 4];
%%
% F_stats_worn = zeros(10, 3, 3);

% for z = 1:10
%     for i = 1:3
%         F_stats_healthy(z, i, 1) = max(F_healthy_mma( :, z, i));
%         F_stats_healthy(z, i, 2) = std(F_healthy_mma( :, z, i));
%         F_stats_healthy(z, i, 3) = rms(F_healthy_mma( :, z, i));
%         
%         F_stats_bend(z, i, 1) = max(F_bend( :, z, i));
%         F_stats_bend(z, i, 2) = std(F_bend( :, z, i));
%         F_stats_bend(z, i, 3) = rms(F_bend( :, z, i));
%         
%         F_stats_worn(z, i, 1) = max(F_worn( :, z, i));
%         F_stats_worn(z, i, 2) = std(F_worn( :, z, i));
%         F_stats_worn(z, i, 3) = rms(F_worn( :, z, i));
% 
%     end
% end
% 
% F_stats_healthy_avg = zeros(3, 3);
% F_stats_bend_avg = zeros(3, 3);
% F_stats_worn_avg = zeros(3, 3);
% 
% for i = 1:3
%     F_stats_healthy_avg(i, 1) = mean(F_stats_healthy(:, 1, i));
%     F_stats_healthy_avg(i, 2) = mean(F_stats_healthy(:, 2, i));
%     F_stats_healthy_avg(i, 3) = mean(F_stats_healthy(:, 3, i));
%     
%     F_stats_bend_avg(i, 1) = mean(F_stats_bend(:, 1, i));
%     F_stats_bend_avg(i, 2) = mean(F_stats_bend(:, 2, i));
%     F_stats_bend_avg(i, 3) = mean(F_stats_bend(:, 3, i));
%     
%     F_stats_worn_avg(i, 1) = mean(F_stats_worn(:, 1, i));
%     F_stats_worn_avg(i, 2) = mean(F_stats_worn(:, 2, i));
%     F_stats_worn_avg(i, 3) = mean(F_stats_worn(:, 3, i));
% end


figure
% figure('color', 'w', 'Position', [100, 800, 2000, 550])
% ha = tight_subplot(1,3,[.075 .07],[.08 .075],[.04 .04]);
% axes(ha(i));

scatter3(f_stats_healthy_adxl(1, 1), f_stats_healthy_adxl(1, 2), f_stats_healthy_adxl(1, 3), 'ro');
hold on  
scatter3(f_stats_healthy_adxl(2, 1), f_stats_healthy_adxl(2, 2), f_stats_healthy_adxl(2, 3), 'ro');
scatter3(f_stats_healthy_adxl(3, 1), f_stats_healthy_adxl(3, 2), f_stats_healthy_adxl(3, 3), 'ro');
scatter3(f_stats_healthy_adxl(4, 1), f_stats_healthy_adxl(4, 2), f_stats_healthy_adxl(4, 3), 'ro');
scatter3(f_stats_healthy_adxl(5, 1), f_stats_healthy_adxl(5, 2), f_stats_healthy_adxl(5, 3), 'ro');
scatter3(f_stats_healthy_adxl(6, 1), f_stats_healthy_adxl(6, 2), f_stats_healthy_adxl(6, 3), 'ro');
scatter3(f_stats_healthy_adxl(7, 1), f_stats_healthy_adxl(7, 2), f_stats_healthy_adxl(7, 3), 'ro');
scatter3(f_stats_healthy_adxl(8, 1), f_stats_healthy_adxl(8, 2), f_stats_healthy_adxl(8, 3), 'ro');
scatter3(f_stats_healthy_adxl(9, 1), f_stats_healthy_adxl(9, 2), f_stats_healthy_adxl(9, 3), 'ro');
scatter3(f_stats_healthy_adxl(10, 1), f_stats_healthy_adxl(10, 2), f_stats_healthy_adxl(10, 3), 'ro');

scatter3(F_stats_healthy_adxl(1, 1), F_stats_healthy_adxl(1, 2), F_stats_healthy_adxl(1, 3), 'ro');
scatter3(F_stats_healthy_adxl(2, 1), F_stats_healthy_adxl(2, 2), F_stats_healthy_adxl(2, 3), 'ro');
scatter3(F_stats_healthy_adxl(3, 1), F_stats_healthy_adxl(3, 2), F_stats_healthy_adxl(3, 3), 'ro');
scatter3(F_stats_healthy_adxl(4, 1), F_stats_healthy_adxl(4, 2), F_stats_healthy_adxl(4, 3), 'ro');
scatter3(F_stats_healthy_adxl(5, 1), F_stats_healthy_adxl(5, 2), F_stats_healthy_adxl(5, 3), 'ro');
scatter3(F_stats_healthy_adxl(6, 1), F_stats_healthy_adxl(6, 2), F_stats_healthy_adxl(6, 3), 'ro');
scatter3(F_stats_healthy_adxl(7, 1), F_stats_healthy_adxl(7, 2), F_stats_healthy_adxl(7, 3), 'ro');
scatter3(F_stats_healthy_adxl(8, 1), F_stats_healthy_adxl(8, 2), F_stats_healthy_adxl(8, 3), 'ro');
scatter3(F_stats_healthy_adxl(9, 1), F_stats_healthy_adxl(9, 2), F_stats_healthy_adxl(10, 3), 'ro');


scatter3(f_stats_bend_adxl(1, 1), f_stats_bend_adxl(1, 2), f_stats_bend_adxl(1, 3), 'bs');
scatter3(f_stats_bend_adxl(2, 1), f_stats_bend_adxl(2, 2), f_stats_bend_adxl(2, 3), 'bs');
scatter3(f_stats_bend_adxl(3, 1), f_stats_bend_adxl(3, 2), f_stats_bend_adxl(3, 3), 'bs');
scatter3(f_stats_bend_adxl(4, 1), f_stats_bend_adxl(4, 2), f_stats_bend_adxl(4, 3), 'bs');
scatter3(f_stats_bend_adxl(5, 1), f_stats_bend_adxl(5, 2), f_stats_bend_adxl(5, 3), 'bs');
scatter3(f_stats_bend_adxl(6, 1), f_stats_bend_adxl(6, 2), f_stats_bend_adxl(6, 3), 'bs');
scatter3(f_stats_bend_adxl(7, 1), f_stats_bend_adxl(7, 2), f_stats_bend_adxl(7, 3), 'bs');
scatter3(f_stats_bend_adxl(8, 1), f_stats_bend_adxl(8, 2), f_stats_bend_adxl(8, 3), 'bs');
scatter3(f_stats_bend_adxl(9, 1), f_stats_bend_adxl(9, 2), f_stats_bend_adxl(9, 3), 'bs');
scatter3(f_stats_bend_adxl(10, 1), f_stats_bend_adxl(10, 2), f_stats_bend_adxl(10, 3), 'bs');

scatter3(F_stats_bend_adxl(1, 1), F_stats_bend_adxl(1, 2), F_stats_bend_adxl(1, 3), 'bs');
scatter3(F_stats_bend_adxl(2, 1), F_stats_bend_adxl(2, 2), F_stats_bend_adxl(2, 3), 'bs');
scatter3(F_stats_bend_adxl(3, 1), F_stats_bend_adxl(3, 2), F_stats_bend_adxl(3, 3), 'bs');
scatter3(F_stats_bend_adxl(4, 1), F_stats_bend_adxl(4, 2), F_stats_bend_adxl(4, 3), 'bs');
scatter3(F_stats_bend_adxl(5, 1), F_stats_bend_adxl(5, 2), F_stats_bend_adxl(5, 3), 'bs');
scatter3(F_stats_bend_adxl(6, 1), F_stats_bend_adxl(6, 2), F_stats_bend_adxl(6, 3), 'bs');
scatter3(F_stats_bend_adxl(7, 1), F_stats_bend_adxl(7, 2), F_stats_bend_adxl(7, 3), 'bs');
scatter3(F_stats_bend_adxl(8, 1), F_stats_bend_adxl(8, 2), F_stats_bend_adxl(8, 3), 'bs');
scatter3(F_stats_bend_adxl(9, 1), F_stats_bend_adxl(9, 2), F_stats_bend_adxl(9, 3), 'bs');
scatter3(F_stats_bend_adxl(10, 1), F_stats_bend_adxl(10, 2), F_stats_bend_adxl(10, 3), 'bs');

%     scatter3(F_stats_worn(1, i, 1), F_stats_worn(1, i, 2), F_stats_worn(1, i, 3), 'g^');
%     scatter3(F_stats_worn(2, i, 1), F_stats_worn(2, i, 2), F_stats_worn(2, i, 3), 'g^');
%     scatter3(F_stats_worn(3, i, 1), F_stats_worn(3, i, 2), F_stats_worn(3, i, 3), 'g^');
%     scatter3(F_stats_worn(4, i, 1), F_stats_worn(4, i, 2), F_stats_worn(4, i, 3), 'g^');
%     scatter3(F_stats_worn(5, i, 1), F_stats_worn(5, i, 2), F_stats_worn(5, i, 3), 'g^');
%     scatter3(F_stats_worn(6, i, 1), F_stats_worn(6, i, 2), F_stats_worn(6, i, 3), 'g^');
%     scatter3(F_stats_worn(7, i, 1), F_stats_worn(7, i, 2), F_stats_worn(7, i, 3), 'g^');
%     scatter3(F_stats_worn(8, i, 1), F_stats_worn(8, i, 2), F_stats_worn(8, i, 3), 'g^');
%     scatter3(F_stats_worn(9, i, 1), F_stats_worn(9, i, 2), F_stats_worn(9, i, 3), 'g^');
%     scatter3(F_stats_worn(10, i, 1), F_stats_worn(10, i, 2), F_stats_worn(10, i, 3), 'g^');

% h1 = scatter3(F_stats_healthy_avg(1, i), F_stats_healthy_avg(2, i), F_stats_healthy_avg(3, i), 'ro', 'MarkerFaceColor', 'r', 'LineWidth', 5);
% h2 = scatter3(F_stats_bend_avg(1, i), F_stats_bend_avg(2, i), F_stats_bend_avg(3, i), 'bs', 'MarkerFaceColor', 'b', 'LineWidth', 5);
%     h3 = scatter3(F_stats_worn_avg(1, i), F_stats_worn_avg(2, i), F_stats_worn_avg(3, i), 'g^', 'LineWidth', 5);
%legend('0mm', '0.2 mm', '0.4mm', '0.6mm', '0.8mm', '1mm', '1.2mm', '1.4mm', '1.6mm', '1.8mm', 'average');

xlabel('Max')
ylabel('Std')
zlabel('RMS')

%     text1 = sprintf('Bearing %d', i);
% title(text1);

% %Legend on 3rd graph only
% leg = legend([h1 h2 h3], 'Healthy', 'Bending', 'Bearing Fault', 'Location', 'northeast');

% title(leg, 'Average')
set(findall(gcf,'-property','FontSize'),'FontSize',18)

view(2)
%%
%Compare with original data plot
F_healthy_average = csvread('F_healthy_average.csv');

f_bins2 = (0:12500-1) .* 5000/25000;

figure
subplot(2, 1, 1)
plot(f_bins2, F_healthy_average);
xlim([0 1500])
subplot(2, 1, 2)
plot(f_bins, f_healthy_average_adxl);
xlim([0 1500])

F_bend_average = csvread('F_bend_average.csv');

f_bins2 = (0:12500-1) .* 5000/25000;

figure
subplot(2, 1, 1)
plot(f_bins2, F_bend_average);
xlim([0 1500])
subplot(2, 1, 2)
plot(f_bins, f_bend_average_adxl);
xlim([0 1500])