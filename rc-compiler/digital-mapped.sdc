# ####################################################################

#  Created by Encounter(R) RTL Compiler v11.20-s017_1 on Tue May 27 19:09:16 +0100 2014

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design digital

create_clock -name "clk" -period 1.0 -waveform {0.0 0.5} 
set_multicycle_path -from [list \
  [get_ports scan_enable]  \
  [get_ports scan_in]  \
  [get_ports clk]  \
  [get_ports reset]  \
  [get_ports {inputs[7]}]  \
  [get_ports {inputs[6]}]  \
  [get_ports {inputs[5]}]  \
  [get_ports {inputs[4]}]  \
  [get_ports {inputs[3]}]  \
  [get_ports {inputs[2]}]  \
  [get_ports {inputs[1]}]  \
  [get_ports {inputs[0]}]  \
  [get_ports {imem_write_adr[9]}]  \
  [get_ports {imem_write_adr[8]}]  \
  [get_ports {imem_write_adr[7]}]  \
  [get_ports {imem_write_adr[6]}]  \
  [get_ports {imem_write_adr[5]}]  \
  [get_ports {imem_write_adr[4]}]  \
  [get_ports {imem_write_adr[3]}]  \
  [get_ports {imem_write_adr[2]}]  \
  [get_ports {imem_write_adr[1]}]  \
  [get_ports {imem_write_adr[0]}]  \
  [get_ports imem_write]  \
  [get_ports {imem_in[39]}]  \
  [get_ports {imem_in[38]}]  \
  [get_ports {imem_in[37]}]  \
  [get_ports {imem_in[36]}]  \
  [get_ports {imem_in[35]}]  \
  [get_ports {imem_in[34]}]  \
  [get_ports {imem_in[33]}]  \
  [get_ports {imem_in[32]}]  \
  [get_ports {imem_in[31]}]  \
  [get_ports {imem_in[30]}]  \
  [get_ports {imem_in[29]}]  \
  [get_ports {imem_in[28]}]  \
  [get_ports {imem_in[27]}]  \
  [get_ports {imem_in[26]}]  \
  [get_ports {imem_in[25]}]  \
  [get_ports {imem_in[24]}]  \
  [get_ports {imem_in[23]}]  \
  [get_ports {imem_in[22]}]  \
  [get_ports {imem_in[21]}]  \
  [get_ports {imem_in[20]}]  \
  [get_ports {imem_in[19]}]  \
  [get_ports {imem_in[18]}]  \
  [get_ports {imem_in[17]}]  \
  [get_ports {imem_in[16]}]  \
  [get_ports {imem_in[15]}]  \
  [get_ports {imem_in[14]}]  \
  [get_ports {imem_in[13]}]  \
  [get_ports {imem_in[12]}]  \
  [get_ports {imem_in[11]}]  \
  [get_ports {imem_in[10]}]  \
  [get_ports {imem_in[9]}]  \
  [get_ports {imem_in[8]}]  \
  [get_ports {imem_in[7]}]  \
  [get_ports {imem_in[6]}]  \
  [get_ports {imem_in[5]}]  \
  [get_ports {imem_in[4]}]  \
  [get_ports {imem_in[3]}]  \
  [get_ports {imem_in[2]}]  \
  [get_ports {imem_in[1]}]  \
  [get_ports {imem_in[0]}]  \
  [get_ports {field_toPAT_low[7]}]  \
  [get_ports {field_toPAT_low[6]}]  \
  [get_ports {field_toPAT_low[5]}]  \
  [get_ports {field_toPAT_low[4]}]  \
  [get_ports {field_toPAT_low[3]}]  \
  [get_ports {field_toPAT_low[2]}]  \
  [get_ports {field_toPAT_low[1]}]  \
  [get_ports {field_toPAT_low[0]}]  \
  [get_ports {field_toPAT_high[7]}]  \
  [get_ports {field_toPAT_high[6]}]  \
  [get_ports {field_toPAT_high[5]}]  \
  [get_ports {field_toPAT_high[4]}]  \
  [get_ports {field_toPAT_high[3]}]  \
  [get_ports {field_toPAT_high[2]}]  \
  [get_ports {field_toPAT_high[1]}]  \
  [get_ports {field_toPAT_high[0]}] ] -setup -end 4
set_multicycle_path -from [list \
  [get_cells {thePAT/thePC/pc_out_reg[2]}]  \
  [get_cells {thePAT/thePC/pc_out_reg[3]}]  \
  [get_cells {thePAT/thePC/pc_out_reg[4]}]  \
  [get_cells {thePAT/thePC/pc_out_reg[5]}]  \
  [get_cells {thePAT/thePC/pc_out_reg[6]}]  \
  [get_cells {thePAT/thePC/pc_out_reg[7]}]  \
  [get_cells {thePAT/thePC/pc_out_reg[8]}]  \
  [get_cells {thePAT/thePC/pc_out_reg[0]}]  \
  [get_cells {thePAT/thePC/pc_out_reg[1]}] ] -to [list \
  [get_cells {iBuffer_i_buffer_reg[0][0]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][10]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][11]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][12]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][13]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][14]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][15]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][16]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][17]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][18]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][19]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][1]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][2]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][3]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][4]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][5]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][6]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][7]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][8]}]  \
  [get_cells {iBuffer_i_buffer_reg[0][9]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][0]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][10]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][11]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][12]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][13]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][14]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][15]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][16]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][17]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][18]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][19]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][1]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][2]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][3]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][4]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][5]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][6]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][7]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][8]}]  \
  [get_cells {iBuffer_i_buffer_reg[1][9]}] ] -setup -end 2
set_clock_gating_check -setup 0.0 
set_ideal_network [get_ports scan_enable]
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
