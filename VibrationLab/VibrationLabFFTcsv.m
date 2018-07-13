clear all
close all

%Include noise

fs = 5000; %Sample frequency
%T = 0.125/4; %Measurement time period
T = 1250/fs;

N = fs * T;

t = linspace(0, T, N);

slices = 20;

x = zeros(N, 3, slices);

y = zeros(N, 3, slices);

M = csvread('1500rpm.csv');

D = csvread('1500rpm_1mm_deflection.csv');

for n = 1:N
    for i = 1:3
        for z = 1:slices
            x(n, i, z) = M(n + (z-1)*N, 3 + (i-1));
            y(n, i, z) = D(n + (z-1)*N, 3 + (i-1));
        end
    end
end

%figure;
%plot(t, x)

freq = (0:N-1) .* fs/N;

F = zeros(round(N/2), 3, slices);
G = zeros(round(N/2), 3, slices);

for i = 1:3
    for z = 1:slices
        tempf = fft(x(:, i, z));
        tempf = abs(tempf/N);
        F(:, i, z) = tempf(1:round(N/2), 1);
    end
end

for i = 1:3
    for z = 1:slices
        tempf = fft(y(:, i, z));
        tempf = abs(tempf/N);
        G(:, i, z) = tempf(1:round(N/2), 1);
    end
end

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

figure
for i = 1:3
    subplot(3, 1, i);
    plot(FT, F(:, i));
    hold on 
    plot(FT, G(:, i));
    legend('Healthy', 'Bent');
end
%}

F_stats = zeros(3, 3, slices);
G_stats = zeros(3, 3, slices);

for i = 1:3
    for z = 1:slices
        F_stats(1, i, z) = max(F(:, i, z));
        F_stats(2, i, z) = rms(F(:, i, z));
        F_stats(3, i, z) = std(F(:, i, z))^2;

        G_stats(1, i, z) = max(G(:, i, z));
        G_stats(2, i, z) = rms(G(:, i, z));
        G_stats(3, i, z) = std(G(:, i, z))^2;
    end
end

for acc = 1:3
    figure
    for z = 1:slices
        scatter3(F_stats(1, acc, z), F_stats(2, acc, z), F_stats(3, acc, z), 'r');
        hold on  
        scatter3(G_stats(1, acc, z), G_stats(2, acc, z), G_stats(3, acc, z), 'b');
    end
    legend('Healthy', 'Bent');
    xlabel('Maximum')
    ylabel('RMS')
    zlabel('Standard deviation')
end

figure
for acc = 1:3
    subplot(3, 1, acc);
    for z = 1:slices
        scatter3(F_stats(1, acc, z), F_stats(2, acc, z), F_stats(3, acc, z), 'r');
        hold on  
        scatter3(G_stats(1, acc, z), G_stats(2, acc, z), G_stats(3, acc, z), 'b');
    end
    legend('Healthy', 'Bent');
    xlabel('Maximum')
    ylabel('RMS')
    zlabel('Standard deviation')
end
