###############################################################
#  Generated by:      Cadence Encounter 11.10-p003_1
#  OS:                Linux x86_64(Host ID IT059116)
#  Generated on:      Sun Mar  1 12:51:12 2015
#  Design:            pads
#  Command:           saveDesign -cellview {PAT32-20150301 pads layout}
###############################################################
set sdc_version 1.4
current_design pads
set_clock_gating_check -rise -setup 0 
set_clock_gating_check -fall -setup 0 
create_clock [get_ports {pad_clock_in}]  -name clock_pat -period 2 -waveform {0 1}
set_propagated_clock  [get_ports {pad_clock_in}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -min -pin Q [get_ports {pad_vdd_1v8_all}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -min -pin Q [get_ports {pad_vdd_1v8_all}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -max -pin Q [get_ports {pad_vdd_1v8_all}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -max -pin Q [get_ports {pad_vdd_1v8_all}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -min -pin Q [get_ports {pad_gnd_all}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -min -pin Q [get_ports {pad_gnd_all}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -max -pin Q [get_ports {pad_gnd_all}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -max -pin Q [get_ports {pad_gnd_all}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -min -pin Q [get_ports {pad_clock_in}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -min -pin Q [get_ports {pad_clock_in}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -max -pin Q [get_ports {pad_clock_in}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -max -pin Q [get_ports {pad_clock_in}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -min -pin Q [get_ports {pad_scan_enable}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -min -pin Q [get_ports {pad_scan_enable}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -max -pin Q [get_ports {pad_scan_enable}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -max -pin Q [get_ports {pad_scan_enable}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -min -pin Q [get_ports {pad_imem_write}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -min -pin Q [get_ports {pad_imem_write}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -max -pin Q [get_ports {pad_imem_write}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -max -pin Q [get_ports {pad_imem_write}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -min -pin Q [get_ports {pad_reset}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -min -pin Q [get_ports {pad_reset}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -max -pin Q [get_ports {pad_reset}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -max -pin Q [get_ports {pad_reset}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -min -pin Q [get_ports {pad_inputs}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -min -pin Q [get_ports {pad_inputs}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -rise -max -pin Q [get_ports {pad_inputs}]
set_driving_cell -lib_cell CLKBUFX32 -library h18_CORELIB_TYP -fall -max -pin Q [get_ports {pad_inputs}]
set_wire_load_mode enclosed
set_false_path  -from [get_ports {pad_reset pad_imem_write}] 
set_multicycle_path 2 -setup  -from [get_pins {{theCore/thePAT/thePC/pc_out_reg[7]/CP} {theCore/thePAT/thePC/pc_out_reg[6]/CP} {theCore/thePAT/thePC/pc_out_reg[5]/CP} {theCore/thePAT/thePC/pc_out_reg[4]/CP} {theCore/thePAT/thePC/pc_out_reg[3]/CP} {theCore/thePAT/thePC/pc_out_reg[2]/CP} {theCore/thePAT/thePC/pc_out_reg[1]/CP} {theCore/thePAT/thePC/pc_out_reg[0]/CP}}]  -to [get_pins {{theCore/iBuffer_i_buffer_reg[1][9]/D} {theCore/iBuffer_i_buffer_reg[1][9]/SE} {theCore/iBuffer_i_buffer_reg[1][9]/SI} {theCore/iBuffer_i_buffer_reg[1][8]/D} {theCore/iBuffer_i_buffer_reg[1][8]/SE} {theCore/iBuffer_i_buffer_reg[1][8]/SI} {theCore/iBuffer_i_buffer_reg[1][7]/D} {theCore/iBuffer_i_buffer_reg[1][7]/SE} {theCore/iBuffer_i_buffer_reg[1][7]/SI} {theCore/iBuffer_i_buffer_reg[1][6]/D} {theCore/iBuffer_i_buffer_reg[1][6]/SE} {theCore/iBuffer_i_buffer_reg[1][6]/SI} {theCore/iBuffer_i_buffer_reg[1][5]/D} {theCore/iBuffer_i_buffer_reg[1][5]/SE} {theCore/iBuffer_i_buffer_reg[1][5]/SI} {theCore/iBuffer_i_buffer_reg[1][4]/D} {theCore/iBuffer_i_buffer_reg[1][4]/SE} {theCore/iBuffer_i_buffer_reg[1][4]/SI} {theCore/iBuffer_i_buffer_reg[1][3]/D} {theCore/iBuffer_i_buffer_reg[1][3]/SE} {theCore/iBuffer_i_buffer_reg[1][3]/SI} {theCore/iBuffer_i_buffer_reg[1][2]/D} {theCore/iBuffer_i_buffer_reg[1][2]/SE} {theCore/iBuffer_i_buffer_reg[1][2]/SI} {theCore/iBuffer_i_buffer_reg[1][22]/D} {theCore/iBuffer_i_buffer_reg[1][22]/SE} {theCore/iBuffer_i_buffer_reg[1][22]/SI} {theCore/iBuffer_i_buffer_reg[1][21]/D} {theCore/iBuffer_i_buffer_reg[1][21]/SE} {theCore/iBuffer_i_buffer_reg[1][21]/SI} {theCore/iBuffer_i_buffer_reg[1][20]/D} {theCore/iBuffer_i_buffer_reg[1][20]/SE} {theCore/iBuffer_i_buffer_reg[1][20]/SI} {theCore/iBuffer_i_buffer_reg[1][1]/D} {theCore/iBuffer_i_buffer_reg[1][1]/SE} {theCore/iBuffer_i_buffer_reg[1][1]/SI} {theCore/iBuffer_i_buffer_reg[1][14]/D} {theCore/iBuffer_i_buffer_reg[1][14]/SE} {theCore/iBuffer_i_buffer_reg[1][14]/SI} {theCore/iBuffer_i_buffer_reg[1][13]/D} {theCore/iBuffer_i_buffer_reg[1][13]/SE} {theCore/iBuffer_i_buffer_reg[1][13]/SI} {theCore/iBuffer_i_buffer_reg[1][12]/D} {theCore/iBuffer_i_buffer_reg[1][12]/SE} {theCore/iBuffer_i_buffer_reg[1][12]/SI} {theCore/iBuffer_i_buffer_reg[1][11]/D} {theCore/iBuffer_i_buffer_reg[1][11]/SE} {theCore/iBuffer_i_buffer_reg[1][11]/SI} {theCore/iBuffer_i_buffer_reg[1][10]/D} {theCore/iBuffer_i_buffer_reg[1][10]/SE} {theCore/iBuffer_i_buffer_reg[1][10]/SI} {theCore/iBuffer_i_buffer_reg[1][0]/D} {theCore/iBuffer_i_buffer_reg[1][0]/SE} {theCore/iBuffer_i_buffer_reg[1][0]/SI} {theCore/iBuffer_i_buffer_reg[0][9]/D} {theCore/iBuffer_i_buffer_reg[0][9]/SE} {theCore/iBuffer_i_buffer_reg[0][9]/SI} {theCore/iBuffer_i_buffer_reg[0][8]/D} {theCore/iBuffer_i_buffer_reg[0][8]/SE} {theCore/iBuffer_i_buffer_reg[0][8]/SI} {theCore/iBuffer_i_buffer_reg[0][7]/D} {theCore/iBuffer_i_buffer_reg[0][7]/SE} {theCore/iBuffer_i_buffer_reg[0][7]/SI} {theCore/iBuffer_i_buffer_reg[0][6]/D} {theCore/iBuffer_i_buffer_reg[0][6]/SE} {theCore/iBuffer_i_buffer_reg[0][6]/SI} {theCore/iBuffer_i_buffer_reg[0][5]/D} {theCore/iBuffer_i_buffer_reg[0][5]/SE} {theCore/iBuffer_i_buffer_reg[0][5]/SI} {theCore/iBuffer_i_buffer_reg[0][4]/D} {theCore/iBuffer_i_buffer_reg[0][4]/SE} {theCore/iBuffer_i_buffer_reg[0][4]/SI} {theCore/iBuffer_i_buffer_reg[0][3]/D} {theCore/iBuffer_i_buffer_reg[0][3]/SE} {theCore/iBuffer_i_buffer_reg[0][3]/SI} {theCore/iBuffer_i_buffer_reg[0][2]/D} {theCore/iBuffer_i_buffer_reg[0][2]/SE} {theCore/iBuffer_i_buffer_reg[0][2]/SI} {theCore/iBuffer_i_buffer_reg[0][22]/D} {theCore/iBuffer_i_buffer_reg[0][22]/SE} {theCore/iBuffer_i_buffer_reg[0][22]/SI} {theCore/iBuffer_i_buffer_reg[0][21]/D} {theCore/iBuffer_i_buffer_reg[0][21]/SE} {theCore/iBuffer_i_buffer_reg[0][21]/SI} {theCore/iBuffer_i_buffer_reg[0][20]/D} {theCore/iBuffer_i_buffer_reg[0][20]/SE} {theCore/iBuffer_i_buffer_reg[0][20]/SI} {theCore/iBuffer_i_buffer_reg[0][1]/D} {theCore/iBuffer_i_buffer_reg[0][1]/SE} {theCore/iBuffer_i_buffer_reg[0][1]/SI} {theCore/iBuffer_i_buffer_reg[0][14]/D} {theCore/iBuffer_i_buffer_reg[0][14]/SE} {theCore/iBuffer_i_buffer_reg[0][14]/SI} {theCore/iBuffer_i_buffer_reg[0][13]/D} {theCore/iBuffer_i_buffer_reg[0][13]/SE} {theCore/iBuffer_i_buffer_reg[0][13]/SI} {theCore/iBuffer_i_buffer_reg[0][12]/D} {theCore/iBuffer_i_buffer_reg[0][12]/SE} {theCore/iBuffer_i_buffer_reg[0][12]/SI} {theCore/iBuffer_i_buffer_reg[0][11]/D} {theCore/iBuffer_i_buffer_reg[0][11]/SE} {theCore/iBuffer_i_buffer_reg[0][11]/SI} {theCore/iBuffer_i_buffer_reg[0][10]/D} {theCore/iBuffer_i_buffer_reg[0][10]/SE} {theCore/iBuffer_i_buffer_reg[0][10]/SI} {theCore/iBuffer_i_buffer_reg[0][0]/D} {theCore/iBuffer_i_buffer_reg[0][0]/SE} {theCore/iBuffer_i_buffer_reg[0][0]/SI}}] 
set_ideal_network  [get_ports {pad_scan_enable}]
set_ideal_network  [get_pins {iopad_scan_enable/Y}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/VDDPAD5VALL}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/VDDPAD1V8ALL}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/GNDPAD1V8_CORE}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/IOPAD5V_3}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/FILLCELLX1}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/GNDPAD5V_CORE}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/FILLCELLX16}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/GNDPAD1V8ALL}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/FILLCELLX8}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/FILLCELLX2}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/VDDPAD1V8L}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/TIE1}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/IOPAD1V8_3}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/TIE0}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/GNDPAD5VALL}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/IOPAD1V8_8}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/IOPAD1V8_40}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/IOPAD5V_20}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/FILLCELLX4}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/IOPAD5V_8}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/FILLCELLX32}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/BUSHDX1}]
set_dont_use  [get_lib_cells {h18_CORELIB_TYP/ANTENNA}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/VDDPAD5V}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/IOPAD1V8_20}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/VDDPAD1V8_CORE}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/VDDPAD5V_CORE}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/VDDPAD5VL}]
set_dont_use  [get_lib_cells {h18_IOLIB_TYP/VDDPAD1V8}]
