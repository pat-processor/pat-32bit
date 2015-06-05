create_library_set -name TYP\
   -timing\
    [list H18/liberty/h18_1.8V/h18_CORELIB_TYP.lib\
    H18/liberty/h18_1.8V/h18_IOLIB_TYP.lib\
    H18/liberty/h18_1.8V/h18_PHYSICAL.lib]
create_op_cond -name TYP -library_file H18/cds/HK_H18/cds.lib -P 10 -V 10 -T 10
create_rc_corner -name TYP\
   -cap_table H18/cds/HK_H18/LEF/h18a6/h18a6.capTable\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name TYP\
   -library_set TYP\
   -rc_corner TYP
create_constraint_mode -name TYP\
   -sdc_files\
    [list ${cvd}/mmmc/modes/TYP/TYP.sdc]
create_analysis_view -name TYP -constraint_mode TYP -delay_corner TYP
set_analysis_view -setup [list TYP] -hold [list TYP]
