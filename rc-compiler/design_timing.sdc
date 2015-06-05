# ####################################################################

#  Created by Encounter(R) RTL Compiler v11.20-s017_1 on Thu May 01 10:07:06 +0100 2014

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design patternbuffer

create_clock -name "clk" -add -period 1.0 -waveform {0.0 0.5} [get_ports clk]
create_clock -name "sclk" -add -period 100.0 -waveform {0.0 50.0} [get_ports sclk]
set_clock_gating_check -setup 0.0 
set_wire_load_mode "enclosed"
set_wire_load_selection_group "sub_micron" -library "h18_CORELIB_HV_TYP"
set_dont_use [get_lib_cells h18_CORELIB_HV_TYP/BUSHDX1_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_TYP/FILLCELLX1_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_TYP/FILLCELLX2_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_TYP/FILLCELLX4_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_TYP/FILLCELLX8_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_TYP/FILLCELLX16_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_TYP/FILLCELLX32_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_TYP/TIE0_HV]
set_dont_use [get_lib_cells h18_CORELIB_HV_TYP/TIE1_HV]
set_dont_use [get_lib_cells h18_IOLIB_HV_TYP/IOPAD5V_20_HV]
set_dont_use [get_lib_cells h18_IOLIB_HV_TYP/IOPAD5V_3_HV]
set_dont_use [get_lib_cells h18_IOLIB_HV_TYP/IOPAD5V_8_HV]
set_dont_use [get_lib_cells h18_IOLIB_HV_TYP/IOPAD1V8_20_HV]
set_dont_use [get_lib_cells h18_IOLIB_HV_TYP/IOPAD1V8_3_HV]
set_dont_use [get_lib_cells h18_IOLIB_HV_TYP/IOPAD1V8_8_HV]
