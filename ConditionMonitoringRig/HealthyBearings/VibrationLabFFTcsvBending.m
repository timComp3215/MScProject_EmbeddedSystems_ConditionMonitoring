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

slices = 1;

x_00 = zeros(N, 3, slices);
x_02 = zeros(N, 3, slices);
x_04 = zeros(N, 3, slices);
x_06 = zeros(N, 3, slices);
x_08 = zeros(N, 3, slices);
x_10 = zeros(N, 3, slices);
x_12 = zeros(N, 3, slices);
x_14 = zeros(N, 3, slices);
x_16 = zeros(N, 3, slices);
x_18 = zeros(N, 3, slices);
x_20 = zeros(N, 3, slices);

D_00mm = csvread('Bending30.csv');
D_02mm = csvread('Bending21.csv');
D_04mm = csvread('Bending22.csv');
D_06mm = csvread('Bending23.csv');
D_08mm = csvread('Worn1.csv');
D_10mm = csvread('Worn2.csv');
D_12mm = csvread('Healthy1.csv');
D_14mm = csvread('Healthy2.csv');
D_16mm = csvread('Healthy3.csv');
D_18mm = csvread('Worn0.csv');
%D_20mm = csvread('Healthy0.csv');

for n = 1:N
    for i = 1:3
        for z = 1:slices
            x_00(n, i, z) = D_00mm(n + (z-1)*N, 3 + (i-1));
            x_02(n, i, z) = D_02mm(n + (z-1)*N, 3 + (i-1));
            x_04(n, i, z) = D_04mm(n + (z-1)*N, 3 + (i-1));
            x_06(n, i, z) = D_06mm(n + (z-1)*N, 3 + (i-1));
            x_08(n, i, z) = D_08mm(n + (z-1)*N, 3 + (i-1));
            x_10(n, i, z) = D_10mm(n + (z-1)*N, 3 + (i-1));
            x_12(n, i, z) = D_12mm(n + (z-1)*N, 3 + (i-1));
            x_14(n, i, z) = D_14mm(n + (z-1)*N, 3 + (i-1));
            x_16(n, i, z) = D_16mm(n + (z-1)*N, 3 + (i-1));
            x_18(n, i, z) = D_18mm(n + (z-1)*N, 3 + (i-1));
            %x_20(n, i, z) = D_20mm(n + (z-1)*N, 3 + (i-1));
        end
    end
end

%figure;
%plot(t, x)

freq = (0:N-1) .* fs/N;

F_00 = zeros(round(N/2), 3, slices);
F_02 = zeros(round(N/2), 3, slices);
F_04 = zeros(round(N/2), 3, slices);
F_06 = zeros(round(N/2), 3, slices);
F_08 = zeros(round(N/2), 3, slices);
F_10 = zeros(round(N/2), 3, slices);
F_12 = zeros(round(N/2), 3, slices);
F_14 = zeros(round(N/2), 3, slices);
F_16 = zeros(round(N/2), 3, slices);
F_18 = zeros(round(N/2), 3, slices);
%
for i = 1:3
    for z = 1:slices
        tempf = fft(x_00(:, i, z));
        tempf = abs(tempf/N);
        F_00(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(x_02(:, i, z));
        tempf = abs(tempf/N);
        F_02(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(x_04(:, i, z));
        tempf = abs(tempf/N);
        F_04(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(x_06(:, i, z));
        tempf = abs(tempf/N);
        F_06(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(x_08(:, i, z));
        tempf = abs(tempf/N);
        F_08(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(x_10(:, i, z));
        tempf = abs(tempf/N);
        F_10(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(x_12(:, i, z));
        tempf = abs(tempf/N);
        F_12(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(x_14(:, i, z));
        tempf = abs(tempf/N);
        F_14(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(x_16(:, i, z));
        tempf = abs(tempf/N);
        F_16(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(x_18(:, i, z));
        tempf = abs(tempf/N);
        F_18(:, i, z) = tempf(1:round(N/2), 1);
    end
end
% for i = 1:3
%     for z = 1:slices
%         tempf = fft(x_20(:, i, z));
%         tempf = abs(tempf/N);
%         F_20(:, i, z) = tempf(1:round(N/2), 1);
%     end
% end

FT = zeros(round(N/2), 1);

FT(:, 1) = freq(1:round(N/2));

%{
figure
for i = 1:3
    subplot(3, 1, i);
    plot(t, x(:, i));
    hold on 
    plot(t, y(:, i));
    legend('Healthy', 'Bent');
end
%}
% figure
for i = 1:3
    %subplot(3, 1, i);
    figure
    subplot(2, 1, 1)
    plot(FT(:), F_10(:, i, 1));
    hold on 
    subplot(2, 1, 2)
    plot(FT(:), F_18(:, i, 1));
    legend('Healthy', 'Healthy2');
end


F_stats_00 = zeros(3, 3, slices);
F_stats_02 = zeros(3, 3, slices);
F_stats_04 = zeros(3, 3, slices);
F_stats_06 = zeros(3, 3, slices);
F_stats_08 = zeros(3, 3, slices);
F_stats_10 = zeros(3, 3, slices);
F_stats_12 = zeros(3, 3, slices);
F_stats_14 = zeros(3, 3, slices);
F_stats_16 = zeros(3, 3, slices);
F_stats_18 = zeros(3, 3, slices);
%F_stats_20 = zeros(3, 3, slices);

for i = 1:3
    for z = 1:slices
        F_stats_00(1, i, z) = max(F_00(:, i, z));
        F_stats_00(2, i, z) = rms(F_00(:, i, z));
        F_stats_00(3, i, z) = std(F_00(:, i, z))^2;

        F_stats_02(1, i, z) = max(F_02(:, i, z));
        F_stats_02(2, i, z) = rms(F_02(:, i, z));
        F_stats_02(3, i, z) = std(F_02(:, i, z))^2;
        
        F_stats_04(1, i, z) = max(F_04(:, i, z));
        F_stats_04(2, i, z) = rms(F_04(:, i, z));
        F_stats_04(3, i, z) = std(F_04(:, i, z))^2;
        
        F_stats_06(1, i, z) = max(F_06(:, i, z));
        F_stats_06(2, i, z) = rms(F_06(:, i, z));
        F_stats_06(3, i, z) = std(F_06(:, i, z))^2;
        
        F_stats_08(1, i, z) = max(F_08(:, i, z));
        F_stats_08(2, i, z) = rms(F_08(:, i, z));
        F_stats_08(3, i, z) = std(F_08(:, i, z))^2;
        
        F_stats_10(1, i, z) = max(F_10(:, i, z));
        F_stats_10(2, i, z) = rms(F_10(:, i, z));
        F_stats_10(3, i, z) = std(F_10(:, i, z))^2;

        F_stats_12(1, i, z) = max(F_12(:, i, z));
        F_stats_12(2, i, z) = rms(F_12(:, i, z));
        F_stats_12(3, i, z) = std(F_12(:, i, z))^2;
        
        F_stats_14(1, i, z) = max(F_14(:, i, z));
        F_stats_14(2, i, z) = rms(F_14(:, i, z));
        F_stats_14(3, i, z) = std(F_14(:, i, z))^2;
        
        F_stats_16(1, i, z) = max(F_16(:, i, z));
        F_stats_16(2, i, z) = rms(F_16(:, i, z));
        F_stats_16(3, i, z) = std(F_16(:, i, z))^2;
        
        F_stats_18(1, i, z) = max(F_18(:, i, z));
        F_stats_18(2, i, z) = rms(F_18(:, i, z));
        F_stats_18(3, i, z) = std(F_18(:, i, z))^2;
        
%         F_stats_20(1, i, z) = max(F_20(:, i, z));
%         F_stats_20(2, i, z) = rms(F_20(:, i, z));
%         F_stats_20(3, i, z) = std(F_20(:, i, z))^2;
    end
end

for acc = 1:3
    figure
    for z = 1:slices
        scatter3(F_stats_00(1, acc, z), F_stats_00(2, acc, z), F_stats_00(3, acc, z), 'ro');
        hold on  
        scatter3(F_stats_02(1, acc, z), F_stats_02(2, acc, z), F_stats_02(3, acc, z), 'bo');
        scatter3(F_stats_04(1, acc, z), F_stats_04(2, acc, z), F_stats_04(3, acc, z), 'go');
        scatter3(F_stats_06(1, acc, z), F_stats_06(2, acc, z), F_stats_06(3, acc, z), 'mo');
        scatter3(F_stats_08(1, acc, z), F_stats_08(2, acc, z), F_stats_08(3, acc, z), 'k^');
        scatter3(F_stats_10(1, acc, z), F_stats_10(2, acc, z), F_stats_10(3, acc, z), 'r^');
        scatter3(F_stats_12(1, acc, z), F_stats_12(2, acc, z), F_stats_12(3, acc, z), 'bx');
        scatter3(F_stats_14(1, acc, z), F_stats_14(2, acc, z), F_stats_14(3, acc, z), 'gx');
        scatter3(F_stats_16(1, acc, z), F_stats_16(2, acc, z), F_stats_16(3, acc, z), 'mx');
        scatter3(F_stats_18(1, acc, z), F_stats_18(2, acc, z), F_stats_18(3, acc, z), 'k^');
%         scatter3(F_stats_20(1, acc, z), F_stats_20(2, acc, z), F_stats_20(3, acc, z), 'ro');
    end
    legend('0mm', '0.2 mm', '0.4mm', '0.6mm', '0.8mm', '1mm', '1.2mm', '1.4mm', '1.6mm', '1.8mm');
    xlabel('Maximum')
    ylabel('RMS')
    zlabel('Standard deviation')
end

%{figure
% for acc = 1:3
%     subplot(3, 1, acc);
%     for z = 1:slices
%         scatter3(F_stats_00(1, acc, z), F_stats_00(2, acc, z), F_stats_00(3, acc, z), 'r');
%         hold on  
%         scatter3(F_stats_02(1, acc, z), F_stats_02(2, acc, z), F_stats_02(3, acc, z), 'b');
%         scatter3(F_stats_04(1, acc, z), F_stats_04(2, acc, z), F_stats_04(3, acc, z), 'g');
%         scatter3(F_stats_06(1, acc, z), F_stats_06(2, acc, z), F_stats_06(3, acc, z), 'm');
%         scatter3(F_stats_08(1, acc, z), F_stats_08(2, acc, z), F_stats_08(3, acc, z), 'k');
%     end
%     legend('0mm', '0.2 mm', '0.4mm', '0.6mm', '0.8mm');
%     xlabel('Maximum')
%     ylabel('RMS')
%     zlabel('Standard deviation')
% end
%}

%Find maximum accelerometer values from raw data
max_acc_1 = zeros(11, 1);
max_acc_2 = zeros(11, 1);
max_acc_3 = zeros(11, 1);

max_acc_1(1) = max(abs(D_00mm(:, 3)));
max_acc_1(2) = max(abs(D_02mm(:, 3)));
max_acc_1(3) = max(abs(D_04mm(:, 3)));
max_acc_1(4) = max(abs(D_06mm(:, 3)));
max_acc_1(5) = max(abs(D_08mm(:, 3)));
max_acc_1(6) = max(abs(D_10mm(:, 3)));
max_acc_1(7) = max(abs(D_12mm(:, 3)));
max_acc_1(8) = max(abs(D_14mm(:, 3)));
max_acc_1(9) = max(abs(D_16mm(:, 3)));
max_acc_1(10) = max(abs(D_18mm(:, 3)));
% max_acc_1(11) = max(abs(D_20mm(:, 3)));

max_acc_2(1) = max(abs(D_00mm(:, 4)));
max_acc_2(2) = max(abs(D_02mm(:, 4)));
max_acc_2(3) = max(abs(D_04mm(:, 4)));
max_acc_2(4) = max(abs(D_06mm(:, 4)));
max_acc_2(5) = max(abs(D_08mm(:, 4)));
max_acc_2(6) = max(abs(D_10mm(:, 4)));
max_acc_2(7) = max(abs(D_12mm(:, 4)));
max_acc_2(8) = max(abs(D_14mm(:, 4)));
max_acc_2(9) = max(abs(D_16mm(:, 4)));
max_acc_2(10) = max(abs(D_18mm(:, 4)));
% max_acc_2(11) = max(abs(D_20mm(:, 4)));

max_acc_3(1) = max(abs(D_00mm(:, 5)));
max_acc_3(2) = max(abs(D_02mm(:, 5)));
max_acc_3(3) = max(abs(D_04mm(:, 5)));
max_acc_3(4) = max(abs(D_06mm(:, 5)));
max_acc_3(5) = max(abs(D_08mm(:, 5)));
max_acc_3(6) = max(abs(D_10mm(:, 5)));
max_acc_3(7) = max(abs(D_12mm(:, 5)));
max_acc_3(8) = max(abs(D_14mm(:, 5)));
max_acc_3(9) = max(abs(D_16mm(:, 5)));
max_acc_3(10) = max(abs(D_18mm(:, 5)));
% max_acc_3(11) = max(abs(D_20mm(:, 5)));

figure
subplot(3, 1, 1)
plot(linspace(0, 20, 11), max_acc_1);
xlabel('Bending (mm)')
ylabel('Acceleration (g)')
subplot(3, 1, 2)
plot(linspace(0, 20, 11), max_acc_2);
xlabel('Bending (mm)')
ylabel('Acceleration (g)')
subplot(3, 1, 3)
plot(linspace(0, 20, 11), max_acc_3);
xlabel('Bending (mm)')
ylabel('Acceleration (g)')