# ####################################################################

#  Created by Encounter(R) RTL Compiler v11.10-p005_1 on Sun Mar 01 12:27:09 +0000 2015

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design pads

create_clock -name "clock_pat" -add -period 2.0 -waveform {0.0 1.0} [get_ports pad_clock_in]
set_false_path -from [list \
  [get_ports pad_imem_write]  \
  [get_ports pad_reset] ]
set_multicycle_path -from [list \
  [get_cells {theCore/thePAT/thePC/pc_out_reg[0]}]  \
  [get_cells {theCore/thePAT/thePC/pc_out_reg[1]}]  \
  [get_cells {theCore/thePAT/thePC/pc_out_reg[2]}]  \
  [get_cells {theCore/thePAT/thePC/pc_out_reg[3]}]  \
  [get_cells {theCore/thePAT/thePC/pc_out_reg[4]}]  \
  [get_cells {theCore/thePAT/thePC/pc_out_reg[5]}]  \
  [get_cells {theCore/thePAT/thePC/pc_out_reg[6]}]  \
  [get_cells {theCore/thePAT/thePC/pc_out_reg[7]}] ] -to [list \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][0]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][10]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][11]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][12]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][13]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][14]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][1]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][20]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][21]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][22]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][2]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][3]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][4]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][5]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][6]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][7]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][8]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[0][9]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][0]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][10]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][11]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][12]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][13]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][14]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][1]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][20]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][21]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][22]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][2]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][3]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][4]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][5]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][6]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][7]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][8]}]  \
  [get_cells {theCore/iBuffer_i_buffer_reg[1][9]}] ] -setup -end 2
set_clock_gating_check -setup 0.0 
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -pin "Q" [get_ports pad_vdd_1v8_all]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -pin "Q" [get_ports pad_gnd_all]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -pin "Q" [get_ports pad_clock_in]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -pin "Q" [get_ports pad_scan_enable]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -pin "Q" [get_ports pad_imem_write]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -pin "Q" [get_ports pad_reset]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -pin "Q" [get_ports pad_inputs]
set_ideal_network [get_ports pad_scan_enable]
set_ideal_network [get_pins iopad_scan_enable/Y]
set_wire_load_mode "enclosed"
set_wire_load_selection_group "sub_micron" -library "h18_CORELIB_TYP"
set_dont_use [get_lib_cells h18_CORELIB_TYP/ANTENNA]
set_dont_use [get_lib_cells h18_CORELIB_TYP/BUSHDX1]
set_dont_use [get_lib_cells h18_CORELIB_TYP/FILLCELLX1]
set_dont_use [get_lib_cells h18_CORELIB_TYP/FILLCELLX2]
set_dont_use [get_lib_cells h18_CORELIB_TYP/FILLCELLX4]
set_dont_use [get_lib_cells h18_CORELIB_TYP/FILLCELLX8]
set_dont_use [get_lib_cells h18_CORELIB_TYP/FILLCELLX16]
set_dont_use [get_lib_cells h18_CORELIB_TYP/FILLCELLX32]
set_dont_use [get_lib_cells h18_CORELIB_TYP/TIE0]
set_dont_use [get_lib_cells h18_CORELIB_TYP/TIE1]
set_dont_use [get_lib_cells h18_IOLIB_TYP/IOPAD5V_20]
set_dont_use [get_lib_cells h18_IOLIB_TYP/IOPAD5V_3]
set_dont_use [get_lib_cells h18_IOLIB_TYP/IOPAD5V_8]
set_dont_use [get_lib_cells h18_IOLIB_TYP/IOPAD1V8_20]
set_dont_use [get_lib_cells h18_IOLIB_TYP/IOPAD1V8_3]
set_dont_use [get_lib_cells h18_IOLIB_TYP/IOPAD1V8_40]
set_dont_use [get_lib_cells h18_IOLIB_TYP/IOPAD1V8_8]
set_dont_use [get_lib_cells h18_IOLIB_TYP/GNDPAD1V8ALL]
set_dont_use [get_lib_cells h18_IOLIB_TYP/GNDPAD1V8_CORE]
set_dont_use [get_lib_cells h18_IOLIB_TYP/GNDPAD5VALL]
set_dont_use [get_lib_cells h18_IOLIB_TYP/GNDPAD5V_CORE]
set_dont_use [get_lib_cells h18_IOLIB_TYP/VDDPAD1V8]
set_dont_use [get_lib_cells h18_IOLIB_TYP/VDDPAD1V8ALL]
set_dont_use [get_lib_cells h18_IOLIB_TYP/VDDPAD5V]
set_dont_use [get_lib_cells h18_IOLIB_TYP/VDDPAD5VALL]
set_dont_use [get_lib_cells h18_IOLIB_TYP/VDDPAD5VL]
set_dont_use [get_lib_cells h18_IOLIB_TYP/VDDPAD5V_CORE]
set_dont_use [get_lib_cells h18_IOLIB_TYP/VDDPAD1V8_CORE]
set_dont_use [get_lib_cells h18_IOLIB_TYP/VDDPAD1V8L]
