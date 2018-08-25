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

current_max = MCSA.Max(:);
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

ha(2).Position
axes(ha(2))
scatter(t, current_s, 'r^', 'filled')
hold on
scatter(t, current_l, 'b^', 'filled')
scatter(t, current_r, 'g^', 'MarkerFaceColor', [0 0.85 0], 'MarkerEdgeColor', [0 0.85 0])
ylim([0.9 1.1])
yticks('')
legend('Stopped', 'Loading Up/Down', 'Running', 'Location', 'North')

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