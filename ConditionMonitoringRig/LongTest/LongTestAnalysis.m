clear all
close all

%Initial program designed to analyse data in multiple slices at the
%actual sampling frequency given

%%

MCSA = readtable('MCSA_166.csv');
Vib_t = readtable('Vib_t_166.csv');
Vib_f = readtable('Vib_f_166.csv');

%%

H = hours(MCSA.Hour(:));
M = minutes(MCSA.Min(:));

t = H+M;

current_max = (MCSA.Max(:)*3.3)/(16384*0.07667);
current_freq = MCSA.MaxFreq(:);

figure
subplot(2, 1, 1)
plot(t, current_max);
xtickformat('hh:mm')
subplot(2, 1, 2);
plot(t, current_freq);
ylim([0 100])

%%

current_condition = cell2mat(MCSA.Condition(:));
current_condition_num = zeros(length(current_condition), 1);

current_r = zeros(length(current_condition), 1);
current_l = zeros(length(current_condition), 1);
current_s = zeros(length(current_condition), 1);

for n = 1:length(current_condition_num)
    if (current_condition(n) == 'S')
        current_condition_num(n) = 1;
        current_s(n) = 1;
    elseif (current_condition(n) == 'L')
        current_condition_num(n) = 2;
        current_l(n) = 1;
    elseif(current_condition(n) == 'R')
        current_condition_num(n) = 3;
        current_r(n) = 1;
    end
end

%%

figure
scatter(t, current_s, 'r^', 'filled')
hold on
scatter(t, current_l, 'b^', 'filled')
scatter(t, current_r, 'g^', 'MarkerFaceColor', [0 0.85 0], 'MarkerEdgeColor', [0 0.85 0])
ylim([0.9 1.1])
yticks('')
legend('Stopped', 'Loading Up/Down', 'Running', 'Location', 'North')

%%

figure
plot(t, current_s, 'r', 'LineWidth', 4)
hold on
plot(t, current_l, 'b',  'LineWidth', 4)
plot(t, current_r, 'g',  'LineWidth', 4)
ylim([0.99 1.01])
yticks('')
legend('Stopped', 'Loading Up/Down', 'Running', 'Location', 'North')

%%

figure('color', 'w', 'Position', [50 50 1500 1000])

ha = tight_subplot(2, 1,[.07 .03],[.075 .01],[.035 .011]);

axes(ha(1));
plot(t, current_max, 'b', 'LineWidth', 5);
hold on
plot([hours(0) hours(4)], [15 15], 'r', 'LineWidth', 3)

axes(ha(2))
scatter(t, current_s, 'ro', 'filled')
hold on
scatter(t, current_l, 'bs', 'filled')
scatter(t, current_r, 'g^', 'MarkerFaceColor', [0 0.85 0], 'MarkerEdgeColor', [0 0.85 0])
ylim([0.9 1.1])
yticks('')
legend('Stopped', 'Loading Up/Down', 'Running', 'Location', 'North')


set(findall(gcf,'-property','FontSize'),'FontSize',18)


%%

figure('color', 'w', 'Position', [50 50 1700 1000])

ha = tight_subplot(3, 1,[.07 .03],[.075 .01],[.035 .011]);

axes(ha(1));
yyaxis left
h1 = plot(t, current_max, 'b', 'LineWidth', 5);
hold on
h2 = plot([hours(0) hours(4)], [15 15], 'r', 'LineWidth', 3);
xlim([hours(0) hours(4)])

yyaxis right
h3 = scatter(t, current_s, 'ro', 'filled');
hold on
h4 = scatter(t, current_l, 'ms', 'filled');
h5 = scatter(t, current_r, 'g^', 'MarkerFaceColor', [0 0.85 0], 'MarkerEdgeColor', [0 0.85 0]);
ylim([0.1 1.05])
yticks('')
legend([h3 h4 h5 h1 h2], 'Stopped', 'Loading Up/Down', 'Running', 'FFT Max', 'Threshold', 'Location', 'EastOutside')


set(findall(gcf,'-property','FontSize'),'FontSize',18)

%%

t_vib = hours(Vib_t.Hour(:)) + minutes(Vib_t.Min(:));

vib_t_max = (Vib_t.Max(:)*3.3)/(16384*0.8);
vib_t_rms = (Vib_t.RMS(:)*3.3)/(16384*0.8);

%%
vib_t_condition = cell2mat(Vib_t.Condition(:));

vib_t_healthy = zeros(length(t_vib), 1);
vib_t_bending = zeros(length(t_vib), 1);
vib_t_faulty = zeros(length(t_vib), 1);
vib_t_unhealthy = zeros(length(t_vib), 1);

for n = 1:length(t_vib)
    if (vib_t_condition(n) == 'H')
        vib_t_healthy(n) = 1;
    elseif (vib_t_condition(n) == 'B')
        vib_t_bending(n) = 1;
    elseif(vib_t_condition(n) == 'F')
        vib_t_faulty(n) = 1;
    elseif(vib_t_condition(n) == 'U')
        vib_t_unhealthy(n) = 1;
    end
end

%%

figure
scatter(t_vib, vib_t_healthy, 'g^', 'filled');
hold on
scatter(t_vib, vib_t_unhealthy, 'ro', 'filled');
ylim([0.5 1.5])

%%

figure
scatter(t_vib, vib_t_max);
hold on
scatter(t_vib, vib_t_rms);

%%

figure
yyaxis left
scatter(t_vib, vib_t_max);
hold on
scatter(t_vib, vib_t_rms);

yyaxis right
scatter(t_vib, vib_t_healthy, 'g^', 'filled');
hold on
scatter(t_vib, vib_t_unhealthy, 'ro', 'filled');
ylim([0.5 1.5])

%%

vib_f_max = (Vib_f.Max(:)*3.3)/(16384*0.8);
vib_f_std = (Vib_f.std(:)*3.3)/(16384*0.8);

%%
vib_f_condition = cell2mat(Vib_f.Condition(:));

vib_f_healthy = zeros(length(t_vib), 1);
vib_f_bending = zeros(length(t_vib), 1);
vib_f_faulty = zeros(length(t_vib), 1);
vib_f_unhealthy = zeros(length(t_vib), 1);

for n = 1:length(t_vib)
    if (vib_f_condition(n) == 'H')
        vib_f_healthy(n) = 1;
    elseif (vib_f_condition(n) == 'B')
        vib_f_bending(n) = 1;
    elseif(vib_f_condition(n) == 'F')
        vib_f_faulty(n) = 1;
    elseif(vib_f_condition(n) == 'U')
        vib_f_unhealthy(n) = 1;
    end
end

%%

figure

yyaxis left
scatter(t_vib, vib_f_max)

yyaxis right
scatter(t_vib, vib_f_healthy, 'g^', 'filled');
hold on
scatter(t_vib, vib_f_unhealthy, 'ro', 'filled');
scatter(t_vib, vib_f_bending, 'bs', 'filled');
scatter(t_vib, vib_f_faulty, 'mv', 'filled');
ylim([0.5 1.5])

%%

figure('color', 'w', 'Position', [50 50 2200 1300])

ha = tight_subplot(3, 1,[.06 .03],[.075 .03],[.04 .005]);

axes(ha(1));
yyaxis left
h1 = plot(t, current_max, 'b', 'LineWidth', 5);
hold on
h2 = plot([hours(0) hours(4)], [(15*3.3)/(16384*0.07667) (15*3.3)/(16384*0.07667)], 'r', 'LineWidth', 3);
xlim([hours(0) hours(4.5)])
ylim([0 0.25])
ylabel('Current (A)')

yyaxis right
h3 = scatter(t, current_s, 50, 'ro', 'filled');
hold on
h4 = scatter(t, current_l, 50, 'ms', 'filled');
h5 = scatter(t, current_r, 50, 'g^', 'MarkerFaceColor', [0 0.85 0], 'MarkerEdgeColor', [0 0.85 0]);
ylim([0.1 1.05])
yticks('')
legend([h3 h4 h5 h1 h2], 'Stopped', 'Loading', 'Running', 'FFT Max', 'Threshold', 'Location', 'East')

xticklabels('')

title('MCSA')


axes(ha(2));
yyaxis left
h1 = scatter(t_vib, vib_t_max, 50, 'kd');
hold on
h2 = scatter(t_vib, vib_t_rms, 50, 'mv');
ylim([0 2])
ylabel('Acceleration (g)')

yyaxis right
h3 = scatter(t_vib, vib_t_healthy, 50, 'g^', 'filled');
hold on
h4 = scatter(t_vib, vib_t_unhealthy, 50, 'ro', 'filled');
ylim([0.1 1.05])
yticks('')
xlim([hours(0) hours(4.5)])

legend([h3 h4 h1 h2], 'Healthy', 'Unhealthy', 'Maximum', 'RMS', 'Location', 'East')

xticklabels('')

title('Vibration - Time domain')


axes(ha(3))
yyaxis left
h1 = scatter(t_vib, vib_f_max, 50, 'kd');
hold on
h2 = scatter(t_vib, vib_f_std, 50, 'bp');
ylim([0 0.06])
ylabel('Acceleration (g)')

yyaxis right
h3 = scatter(t_vib, vib_f_healthy, 50, 'g^', 'filled');
hold on
h4 = scatter(t_vib, vib_f_unhealthy, 50, 'ro', 'filled');
h5 = scatter(t_vib, vib_f_bending, 50, 'bs', 'filled');
ylim([0.1 1.05])
yticks('')
xlim([hours(0) hours(4.5)])
xlabel('Time (Hours)')
xticks([hours(0) hours(0.5) hours(1) hours(1.5) hours(2) hours(2.5) hours(3) hours(3.5) hours(4) ])
legend([h3 h4 h5 h1 h2], 'Healthy', 'Unhealthy', 'Bending', 'FFT max', 'FFT std', 'Location', 'East')

title('Vibration - Frequency domain')

set(findall(gcf,'-property','FontSize'),'FontSize',18)

%%
figure('color', 'w', 'Position', [200 200 600 500])
    ha = tight_subplot(1, 1,[.06 .03],[.15 .03],[.13 .04]);

loglog(vib_t_rms*9.81, vib_t_max*9.81, 'bs')
hold on
plot([0.1 10], [.3 30], 'g', 'LineWidth', 1)
plot([0.1 10], [.6 60], 'Color', [1 0.8 0], 'LineWidth', 1)
plot([0.1 10], [1 100], 'r', 'LineWidth', 1)
xlim([.1 1])
ylim([.3 20])
xticks([0.1 0.5 1])
xticklabels({'0.1', '0.5', '1.0'})
yticks([0.3 1 5 10 20])
ylabel('Maximum acceleration (ms^{-2})')
xlabel('RMS acceleration (ms^{-2})')
text(0.14,0.35,'Low');
text(0.14,0.7,'Normal');
text(0.14,1.2,'Alert');
text(0.14,2.2,'Alarm');
set(findall(gcf,'-property','FontSize'),'FontSize',18)

%%

t = str2double(Base.Time_ns_(:))/1000000000;

current_base = str2double(Base.Current_nA_(:))/1000000;
current_LPM0 = str2double(LPM0.Current_nA_(:))/1000000;
current_Vib = str2double(Vib.Current_nA_(:))/1000000;
current_MCSA = str2double(MCSA.Current_nA_(:))/1000000;
current_Both = str2double(Both.Current_nA_(:))/1000000; 

%%

figure('color', 'w', 'Position', ([200 200 2000 1000]))
ha = tight_subplot(1, 1,[.07 .03],[.075 .01],[.035 .011]);
axes(ha(1));

plot(t+3.5, current_base, 'LineWidth', 1);
hold on
plot(t+1, current_LPM0, 'LineWidth', 1);
plot(t+6, current_Vib, 'LineWidth', 1);
plot(t+2.25, current_MCSA, 'LineWidth', 1);
plot(t+4.75, current_Both, 'LineWidth', 1);

legend('Base program', 'LPM0', 'Acceleromter only', 'Current Sensor only', 'Full system', 'Location', 'East')

ylabel('Current (mA)')
xlabel('Time (s)')
xlim([180 190])
set(findall(gcf,'-property','FontSize'),'FontSize',18)

%%

voltage_base = str2double(Base.Voltage_mV_(:))/1000;

%%
figure
plot(t, voltage_base)


%%

energy_base = str2double(Base.Energy_uJ_(:))/1000000;
energy_LPM0 = str2double(LPM0.Energy_uJ_(:))/1000000;
energy_Vib = str2double(Vib.Energy_uJ_(:))/1000000;
energy_MCSA = str2double(MCSA.Energy_uJ_(:))/1000000;
energy_Both = str2double(Both.Energy_uJ_(:))/1000000; 

%%