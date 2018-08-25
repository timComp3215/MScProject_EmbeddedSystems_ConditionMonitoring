clear all
close all

%Initial program designed to analyse data in multiple slices at the
%actual sampling frequency given

%%

Base = readtable('EnergyTrace_NoSensors.csv');
LPM0 = readtable('EnergyTrace_LPM0.csv');
Vib = readtable('EnergyTrace_Vib.csv');
MCSA = readtable('EnergyTrace_Current.csv');
Both = readtable('EnergyTrace_Both.csv');

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