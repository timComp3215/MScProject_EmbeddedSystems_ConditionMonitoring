clear all
close all

%Initial program designed to analyse data in multiple slices at the
%actual sampling frequency given


%Include noise

fs = 5000; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 25000/fs;

N = fs * T;

t = linspace(0, T, N);

x_healthy = zeros(N, 10, 3);

D_00mm = csvread('Healthy0.csv');
D_02mm = csvread('Healthy1.csv');
D_04mm = csvread('Healthy2.csv');
D_06mm = csvread('Healthy3.csv');
D_08mm = csvread('Healthy4.csv');
D_10mm = csvread('Healthy5.csv');
D_12mm = csvread('Healthy6.csv');
D_14mm = csvread('Healthy7.csv');
D_16mm = csvread('Healthy8.csv');
D_18mm = csvread('Healthy9.csv');

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

x_bend = zeros(N, 10, 3);

D_00mm = csvread('Bending21.csv');
D_02mm = csvread('Bending22.csv');
D_04mm = csvread('Bending23.csv');
D_06mm = csvread('Bending24.csv');
D_08mm = csvread('Bending25.csv');
D_10mm = csvread('Bending26.csv');
D_12mm = csvread('Bending27.csv');
D_14mm = csvread('Bending28.csv');
D_16mm = csvread('Bending29.csv');
D_18mm = csvread('Bending30.csv');

for i = 1:3
        x_bend(:, 1, i) = D_00mm(:, 2 + i);
        x_bend(:, 2, i) = D_02mm(:, 2 + i);
        x_bend(:, 3, i) = D_04mm(:, 2 + i);
        x_bend(:, 4, i) = D_06mm(:, 2 + i);
        x_bend(:, 5, i) = D_08mm(:, 2 + i);
        x_bend(:, 6, i) = D_10mm(:, 2 + i);
        x_bend(:, 7, i) = D_12mm(:, 2 + i);
        x_bend(:, 8, i) = D_14mm(:, 2 + i);
        x_bend(:, 9, i) = D_16mm(:, 2 + i);
        x_bend(:, 10, i) = D_18mm(:, 2 + i);
end

x_worn = zeros(N, 10, 3);

D_00mm = csvread('Worn0.csv');
D_02mm = csvread('Worn1.csv');
D_04mm = csvread('Worn2.csv');
D_06mm = csvread('Worn3.csv');
D_08mm = csvread('Worn4.csv');
D_10mm = csvread('Worn5.csv');
D_12mm = csvread('Worn6.csv');
D_14mm = csvread('Worn7.csv');
D_16mm = csvread('Worn8.csv');
D_18mm = csvread('Worn9.csv');

for i = 1:3
        x_worn(:, 1, i) = D_00mm(:, 2 + i);
        x_worn(:, 2, i) = D_02mm(:, 2 + i);
        x_worn(:, 3, i) = D_04mm(:, 2 + i);
        x_worn(:, 4, i) = D_06mm(:, 2 + i);
        x_worn(:, 5, i) = D_08mm(:, 2 + i);
        x_worn(:, 6, i) = D_10mm(:, 2 + i);
        x_worn(:, 7, i) = D_12mm(:, 2 + i);
        x_worn(:, 8, i) = D_14mm(:, 2 + i);
        x_worn(:, 9, i) = D_16mm(:, 2 + i);
        x_worn(:, 10, i) = D_18mm(:, 2 + i);
end

x_worn = x_worn / 10;
x_bend = x_bend / 10;
x_healthy = x_healthy / 10;

%%
%Remove DC component
% x_healthy_mean = zeros(10, 3);
% x_bend_mean = zeros(10, 3);
% x_worn_mean = zeros(10, 3);
% 
% for z = 1:10
%     for i = 1:3
%         x_healthy_mean(z, i) = mean(x_healthy(:, z, i));
%         x_bend_mean(z, i) = mean(x_healthy(:, z, i));
%         x_worn_mean(z, i) = mean(x_healthy(:, z, i));
%         for n = 1:N
%             x_healthy(n, z, i) = x_healthy(n, z, i) - x_healthy_mean(z, i);
%             x_bend(n, z, i) = x_bend(n, z, i) - x_bend_mean(z, i);
%             x_worn(n, z, i) = x_worn(n, z, i) - x_worn_mean(z, i);
%         end
%     end
% end



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

f_bins = freq(1:round(N/2));

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
ha = tight_subplot(1,3,[.075 .07],[.09 .075],[.04 .04]);
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

    xlabel('Maximim (g)')
    ylabel('std (g)')
    zlabel('RMS (g)')
    
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
    
    xlabel('Maximum (g)')
    ylabel('std (g)')
    zlabel('RMS (g)')
    
    
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
ha = tight_subplot(3, 1,[.04 .05],[.075 .035],[.05 .02]);
axes(ha(1));
plot(f_bins, F_healthy_average, 'r', 'LineWidth', 1);
ylim([0 0.016])
xlim([0 1500])
ax = gca;
ax.YAxis.Exponent = -3;
yticks([0 0.0025 0.005 0.0075 0.01 0.0125 0.015])
set(gca,'XTickLabel',[]);
legend('Healthy')
grid on
%xlabel('Frequency (Hz)')
ylabel('Magnitude (g)')

axes(ha(2));
plot(f_bins, F_bend_average, 'b', 'LineWidth', 1);
ylim([0 0.0161])
xlim([0 1500])
ax = gca;
ax.YAxis.Exponent = -3;
yticks([0 0.0025 0.005 0.0075 0.01 0.0125 0.015])
set(gca,'XTickLabel',[]);
grid on
legend('Bending')
%xlabel('Frequency (Hz)')
ylabel('Magnitude (g)')

axes(ha(3));
plot(f_bins, F_worn_average, 'g', 'LineWidth', 1);
ylim([0 0.016])
xlim([0 1500])
ax = gca;
ax.YAxis.Exponent = -3;
yticks([0 0.0025 0.005 0.0075 0.01 0.0125 0.015])
grid on
legend('Bearing Fault')
xlabel('Frequency (Hz)')
ylabel('Magnitude (g)')

set(findall(gcf,'-property','FontSize'),'FontSize',18)
%%

figure
h1 = scatter3(max(F_healthy_average), std(F_healthy_average), rms(F_healthy_average), 'ro');
hold on
h2 = scatter3(max(F_bend_average), std(F_bend_average), rms(F_bend_average), 'bs');
h3 = scatter3(max(F_worn_average), std(F_worn_average), rms(F_worn_average), 'g^');

for z = 1:10
    scatter3(F_stats_healthy(z, 2, 1), F_stats_healthy(z, 2, 2), F_stats_healthy(z, 2, 3), 'ro');
    scatter3(F_stats_bend(z, 2, 1), F_stats_bend(z, 2, 2), F_stats_bend(z, 2, 3), 'bs');
    scatter3(F_stats_worn(z, 2, 1), F_stats_worn(z, 2, 2), F_stats_worn(z, 2, 3), 'g^');
end

legend([h1 h2 h3], 'Healthy', 'Bend', 'Worn')

xlabel('Max')
ylabel('std')
zlabel('rms')
view(2)

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
figure('color', 'w', 'Position', [200 200 1800 500])
ha = tight_subplot(1,3,[.075 .07],[.17 .08],[.045 .02]);

axes(ha(1));
h1 = loglog(rms(x_healthy(:, :, 2))*9.81, max(abs(x_healthy(:, :, 1))*9.81), 'ro');
hold on
h2 = loglog(rms(x_bend(:, :, 2))*9.81, max(abs(x_bend(:, :, 1))*9.81), 'bs');
h3 = loglog(rms(x_worn(:, :, 2))*9.81, max(abs(x_worn(:, :, 1))*9.81), 'g^');
plot([0.1 10], [.3 30], 'g', 'LineWidth', 1)
plot([0.1 10], [.6 60], 'Color', [1 0.8 0], 'LineWidth', 1)
plot([0.1 10], [1 100], 'r', 'LineWidth', 1)
legend([h1 h2 h3], 'Healthy', 'Bending', 'BF')
xlim([.1 1])
ylim([.3 3])
xticks([0.1 0.5 1])
xticklabels({'0.1', '0.5', '1.0'})
yticks([0.3 1 2 3])
ylabel('Maximum acceleration (ms^{-2})')
xlabel('RMS acceleration (ms^{-2})')
text(0.14,0.35,'Low');
text(0.14,0.7,'Normal');
text(0.14,1.2,'Alert');
text(0.14,2.2,'Alarm');
title('Bearing 1')

axes(ha(2));
h1 = loglog(rms(x_healthy(:, :, 2))*9.81, max(abs(x_healthy(:, :, 2))*9.81), 'ro');
hold on
h2 = loglog(rms(x_bend(:, :, 2))*9.81, max(abs(x_bend(:, :, 2))*9.81), 'bs');
h3 = loglog(rms(x_worn(:, :, 2))*9.81, max(abs(x_worn(:, :, 2))*9.81), 'g^');
plot([0.1 10], [.3 30], 'g', 'LineWidth', 1)
plot([0.1 10], [.6 60], 'Color', [1 0.8 0], 'LineWidth', 1)
plot([0.1 10], [1 100], 'r', 'LineWidth', 1)
legend([h1 h2 h3], 'Healthy', 'Bending', 'BF')
xlim([.1 1])
ylim([.3 3])
xticks([0.1 0.5 1])
xticklabels({'0.1', '0.5', '1.0'})
yticks([0.3 1 2 3])
ylabel('Maximum acceleration (ms^{-2})')
xlabel('RMS acceleration (ms^{-2})')
text(0.14,0.35,'Low');
text(0.14,0.7,'Normal');
text(0.14,1.2,'Alert');
text(0.14,2.2,'Alarm');
title('Bearing 2')

axes(ha(3));
h1 = loglog(rms(x_healthy(:, :, 2))*9.81, max(abs(x_healthy(:, :, 3))*9.81), 'ro');
hold on
h2 = loglog(rms(x_bend(:, :, 2))*9.81, max(abs(x_bend(:, :, 3))*9.81), 'bs');
h3 = loglog(rms(x_worn(:, :, 2))*9.81, max(abs(x_worn(:, :, 3))*9.81), 'g^');
plot([0.1 10], [.3 30], 'g', 'LineWidth', 1)
plot([0.1 10], [.6 60], 'Color', [1 0.8 0], 'LineWidth', 1)
plot([0.1 10], [1 100], 'r', 'LineWidth', 1)
legend([h1 h2 h3], 'Healthy', 'Bending', 'BF')
xlim([.1 1])
ylim([.3 3])
xticks([0.1 0.5 1])
xticklabels({'0.1', '0.5', '1.0'})
yticks([0.3 1 2 3])
ylabel('Maximum acceleration (ms^{-2})')
xlabel('RMS acceleration (ms^{-2})')
text(0.14,0.35,'Low');
text(0.14,0.7,'Normal');
text(0.14,1.2,'Alert');
text(0.14,2.2,'Alarm');
title('Bearing 3')


set(findall(gcf,'-property','FontSize'),'FontSize',18)