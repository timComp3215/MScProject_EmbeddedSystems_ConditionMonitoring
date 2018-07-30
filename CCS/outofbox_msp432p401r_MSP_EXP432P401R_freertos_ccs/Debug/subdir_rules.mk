################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
MSP_EXP432P401R.obj: ../MSP_EXP432P401R.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/outofbox_msp432p401r_MSP_EXP432P401R_freertos_ccs" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/third_party/CMSIS/Include" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/ti/posix/ccs" --include_path="/FreeRTOS/Source/include" --include_path="/FreeRTOS/Source/portable/CCS/ARM_CM4F" --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/freertos_builds_MSP_EXP432P401R_release_ccs" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/include" --advice:power=none --define=__MSP432P401R__ --define=DeviceFamily_MSP432P401x -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on --preproc_with_compile --preproc_dependency="MSP_EXP432P401R.d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

callbacks.obj: ../callbacks.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/outofbox_msp432p401r_MSP_EXP432P401R_freertos_ccs" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/third_party/CMSIS/Include" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/ti/posix/ccs" --include_path="/FreeRTOS/Source/include" --include_path="/FreeRTOS/Source/portable/CCS/ARM_CM4F" --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/freertos_builds_MSP_EXP432P401R_release_ccs" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/include" --advice:power=none --define=__MSP432P401R__ --define=DeviceFamily_MSP432P401x -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on --preproc_with_compile --preproc_dependency="callbacks.d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

led_thread.obj: ../led_thread.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/outofbox_msp432p401r_MSP_EXP432P401R_freertos_ccs" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/third_party/CMSIS/Include" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/ti/posix/ccs" --include_path="/FreeRTOS/Source/include" --include_path="/FreeRTOS/Source/portable/CCS/ARM_CM4F" --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/freertos_builds_MSP_EXP432P401R_release_ccs" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/include" --advice:power=none --define=__MSP432P401R__ --define=DeviceFamily_MSP432P401x -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on --preproc_with_compile --preproc_dependency="led_thread.d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

main_freertos.obj: ../main_freertos.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/outofbox_msp432p401r_MSP_EXP432P401R_freertos_ccs" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/third_party/CMSIS/Include" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/ti/posix/ccs" --include_path="/FreeRTOS/Source/include" --include_path="/FreeRTOS/Source/portable/CCS/ARM_CM4F" --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/freertos_builds_MSP_EXP432P401R_release_ccs" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/include" --advice:power=none --define=__MSP432P401R__ --define=DeviceFamily_MSP432P401x -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on --preproc_with_compile --preproc_dependency="main_freertos.d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

uart_thread.obj: ../uart_thread.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: ARM Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/outofbox_msp432p401r_MSP_EXP432P401R_freertos_ccs" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/third_party/CMSIS/Include" --include_path="C:/ti/simplelink_msp432p4_sdk_2_10_00_14/source/ti/posix/ccs" --include_path="/FreeRTOS/Source/include" --include_path="/FreeRTOS/Source/portable/CCS/ARM_CM4F" --include_path="D:/Tim/Documents/GitHub/MScProject_EmbeddedSystems_ConditionMonitoring/CCS/freertos_builds_MSP_EXP432P401R_release_ccs" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.1.LTS/include" --advice:power=none --define=__MSP432P401R__ --define=DeviceFamily_MSP432P401x -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on --preproc_with_compile --preproc_dependency="uart_thread.d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


