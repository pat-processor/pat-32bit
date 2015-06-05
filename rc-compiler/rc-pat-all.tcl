set currentDesign pads

set_attribute lib_search_path /home/research/software/asic/kits/ams/H18/liberty/h18_1.8V
#set_attribute library {h18_CORELIB_HV_TYP.lib h18_IOLIB_HV_TYP.lib}
set_attribute library {h18_CORELIB_TYP.lib h18_IOLIB_TYP.lib}

set_attribute information_level 2
set_attribute hdl_track_filename_row_col true

# trade size for speed in optimisation
set_attribute dp_postmap_upsize true 

# turn off data path sharing (e.g. mux to a single adder)
#set_attribute dp_sharing none [find /designs* -subdesign name ]

read_hdl -sv pat.sv
read_hdl -sv digital.sv
read_hdl -v2001 pads.v

# enable clock gating
#set_attribute lp_insert_clock_gating true /
#set_attribute lp_clock_gating_min_flops 3 [find /designs -design testbench]
#set_attribute lp_clock_gating_cell [find / -libcell LGN*] /designs/testbench

elaborate $currentDesign


#set_attribute lp_clock_gating_test_signal *ssel* /
#report clock_gating -preview -gated_ff -clock_pin clk


#set clock [define_clock -period 2000 -name clock_pat [find / -port clock_pat]]
set clock [define_clock -period 2000 -name clock_pat [find / -port pad_clock_in]]

dc::current_design $currentDesign
dc::set_time_unit -picoseconds
# external output capacitance in fF. 1.5 is approx INVX1 
set_attribute external_driver [find [find / -libcell CLKBUFX32] -libpin Q] /designs/$currentDesign/ports_in/*
# SJH set_attribute external_pin_cap 15 /designs/$currentDesign/ports_out/*

# Set output slack needed w.r.t. this module's clock
#dc::set_output_delay 0 -clock clk [find /designs/ -port pwm_low]
#dc::set_output_delay 0 -clock clk [find /designs/ -port pwm_high]


# SJH set_attribute max_transition 300 [find /designs/ -port ports_out/*]

# Preserve pads not connected in the verilog
# This may not strictly be necessary, but this is belt-and-braces



# SJH dc::set_multicycle_path -setup 3 -from [find /des* -port ports_in/*]
# SJHdc::set_multicycle_path -setup 1 -from [find /des* -port ports_in/pad_clock_in]

set_attribute ungroup_ok false [find /designs/ -instance thePC ]
set_attribute optimize_merge_flops true /
#set_attribute optimize_merge_seq false [find / -inst field_out_reg*]
# new below
set_attribute auto_partition true /
set_attribute ungroup_ok false [find /designs/ -instance thePAT]

dc::set_multicycle_path -setup 2 -from [find / -inst pc_out_reg*] -to [find / -inst iBuffer/i_buffer_reg*]


# Relax I/O timing
dc::set_false_path -from [find / -port pad_imem_write] -exception_name imem_write
#dc::set_false_path -from [find / -port pad_scan_enable] -exception_name scan_enable
#dc::set_false_path -from [find / -port pad_scan_in] -exception_name scan_in
#dc::set_false_path -from [find / -port imem_load] -exception_name imem_load
#dc::set_false_path -from [find / -inst input_shifter* ] -exception_name input_shifter

# false path has higher priority than multi-cycle path
dc::set_false_path -from [find / -port pad_reset ] -exception_name reset
# I/O pad latency, as seen by encounter (why so high - unrepeated! 13ns is the min observed latency)
#dc::set_multicycle_path -setup 13 -from [ find / -port pad_inputs ] -exception_name inputs


if {$insertScanChain == "y"} {
# SCAN CHAIN
set_attribute dft_scan_style muxed_scan /
#define_dft test_clock -name scan_clock -period 2000 /designs/pads/ports_in/clock_pat
#define_dft test_clock -name scan_clock -period 2000 /designs/pads/ports_out/clock_pat
define_dft test_clock -name scan_clock -period 2000 /designs/pads/ports_in/pad_clock_in -hookup_pin iopad_clock_in/Y


define_dft shift_enable -active high pad_scan_enable -hookup_pin iopad_scan_enable/Y
#define_dft scan_chain -shared_out -sdo iopad_b5/A -hookup_pin_sdo iopad_b5/A -sdi iopad_a7/Y -domain scan_clock -name scan_chain_1
#define_dft scan_chain -sdo iopad_scan_out/A -non_shared_output -hookup_pin_sdo iopad_scan_out/A -sdi iopad_scan_in/Y -domain scan_clock -name scan_chain_1
define_dft scan_chain -shared_out -sdo iopad_output/A -hookup_pin_sdo iopad_output/A -sdi iopad_inputs/Y -domain scan_clock -name scan_chain_1
#  Choose between this and shared system 
#define_dft scan_chain -sdi scan_in_2 -sdo scan_out_2 -create_ports -domain scan_clock -name scan_chain_2
set_attribute optimize_merge_seq false [find / -inst field_out_reg*]
set_attribute dft_dont_scan false [find / -inst field_out_reg*]
#set_attribute dft_dont_scan true [find / -inst data_out_reg*]
set_attribute dft_dont_scan false [find / -inst data_out_reg*]

# choose what to scan and what not to
#set_attribute dft_dont_scan true /designs/patternbuffer/instances_hier/theBuffers/

check_dft_rules
report dft_registers
# allow dft engine to determine if output scan is inverted or not
set_attribute dft_scan_output_preference auto $currentDesign
# map all flops that pass DFT rules to scannable
set_attr dft_scan_map_mode tdrc_pass $currentDesign
# set for synthesis drive
set_attr dft_connect_scan_data_pins_during_mapping loopback $currentDesign
set_attribute dft_prefix SCAN_ / 

report dft_setup


synthesize -to_mapped $currentDesign

replace_scan



# if already mapped, use "replace_scan" before running the next scan commands
connect_scan_chains -preview -auto_create_chains -pack

#define_dft scan_chain -name scanchain1 -sdi scan_in_pin -sdo scan_out_pin -shift_enable scan_enable

# TODO: enable below to make scan chains
connect_scan_chains 
report dft_chains > $currentDesign-scanchains
report dft_setup > $currentDesign-dftsetup


# improve timing now the scan chain is there
#synthesize -incremental -effort high

# END SCAN CHAIN
}

# request an extra 30ps slack on the register paths
#set all_regs [find / -instance instances_seq/*] 
#path_adjust -from $all_regs -to $all_regs -delay -30 -name slack-30_regs









synthesize -to_mapped -effort high $currentDesign

write -mapped > $currentDesign-mapped.v
write_script > $currentDesign-mapped.script
write_sdc > $currentDesign-mapped.sdc
write_hdl -mapped > $currentDesign-mapped.enc
report dft_chains > $currentDesign-scanchains
report dft_setup > $currentDesign-dftsetup

report area
report gates
report clocks
report datapath
report timing 
