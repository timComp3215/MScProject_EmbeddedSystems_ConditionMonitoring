################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
adc_FFT_Multi_Trigger_NMEA_rtc.obj: ../adc_FFT_Multi_Trigger_NMEA_rtc.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.2.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me -O1 --opt_for_speed=0 --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/adc_FFT_Multi_Trigger_NMEA_rtc" --include_path="C:/ti/simplelink_msp432p4_sdk_2_20_00_12/source" --include_path="C:/ti/simplelink_msp432p4_sdk_2_20_00_12/source/third_party/CMSIS/Include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.2.LTS/include" --advice:power=none --define=__MSP432P401R__ --define=DeviceFamily_MSP432P401x -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on --preproc_with_compile --preproc_dependency="adc_FFT_Multi_Trigger_NMEA_rtc.d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

system_msp432p401r.obj: ../system_msp432p401r.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.2.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me -O1 --opt_for_speed=0 --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/adc_FFT_Multi_Trigger_NMEA_rtc" --include_path="C:/ti/simplelink_msp432p4_sdk_2_20_00_12/source" --include_path="C:/ti/simplelink_msp432p4_sdk_2_20_00_12/source/third_party/CMSIS/Include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.2.LTS/include" --advice:power=none --define=__MSP432P401R__ --define=DeviceFamily_MSP432P401x -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on --preproc_with_compile --preproc_dependency="system_msp432p401r.d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


