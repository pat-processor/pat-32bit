source utility.tcl

puts "Set script into interactive mode? y/n"
set answer [gets stdin]
set interactive [string compare $answer "y"]

# load
set defHierChar /
set locv_inter_clock_use_worst_derate false
set conf_gen_footprint 1
set fp_core_to_left 50.000000
set fp_core_to_right 50.000000
set init_io_file pads.io
set init_oa_ref_lib {TECH_H18A6 CORELIB_HV IOLIB_HV_6AM}
set init_oa_search_lib {}
set lsgOCPGainMult 1.000000
set conf_ioOri R0
set init_verilog pads-mapped.v
set fp_core_util 0.850000
set init_pwr_net {vdd! vdd1v8l! vdd1v8r! vdd1v8o! por1v8r! trig1v8! vdd5vl! vdd5vr! vdd5vo! trig5v! por5vr!}
set init_mmmc_file pads.view
set delaycal_input_transition_delay 0.1ps
set init_assign_buffer 0
set init_top_cell pads
set conf_in_tran_delay 0.1ps
set init_import_mode { -keepEmptyModule 1 -treatUndefinedCellAsBbox 0}
set fpIsMaxIoHeight 0
set fp_core_to_top 50.000000
set init_gnd_net {gnd! gnd1v8l! gnd1v8r! gnd1v8o! subc1v8! gnd5vl! gnd5vr! gnd5vo! subc5v! subc!}
set init_abstract_view abstract
set timing_case_analysis_for_icg_propagation false
set fp_core_to_bottom 50.000000


init_design
set_analysis_view -setup {HV_TYP} -hold {HV_TYP}

setDesignMode -process 180
setOaxMode -compressLevel 0
set init_oa_abstract_view {abstract layout}

# Add I/O filler to complete pad rings. Do before floorplan since tool
# won't consider those outside floorplan
#amsFillperi
# locate the components
#                                             left btm right top
# -200um
# below will have some I/O pads out of routing range.


floorPlan -site ams018hvSite -d 950 800 50 50 50 50

# below is big enough to encompass the I/O pads.
#floorPlan -site ams018hvSite -d 3000.0 3000.0 100.43 1100.03 1830.0 100.0


# 50% util
#setObjFPlanBox Module theCore 435.680 1331.680 1395.155 2571.520
# -100um
#setObjFPlanBox Module theCore 328.720 1326.955 1288.000 2672.320
# -200um
#setObjFPlanBox Module theCore 328.720 1326.640 1199.442 2672.320
# -230um
#setObjFPlanBox Module theCore 297.16 1326.64 1167.96 2672.32
# 60% util
#setObjFPlanBox Module theCore 428.400 1335.939 1183.280 2566.480
# 70% util
#setObjFPlanBox Module theCore 428.400 1336.720 1093.470 2566.480
# blockage width 750 height 750 X 635 Y 340 Layers All
#createRouteBlk -layer {M1 M2 M3 M4 MT AM} -box {300 430 1050 1180}
#createRouteBlk -layer {M1 M2 M3 M4 MT AM} -box {1300 400 2100 1210}


# move corner pads closer to corners.
#setObjFPlanBox Instance iopad_a4 0.262 2680.395 226.872 2768.895
#setObjFPlanBox Instance iopad_a3 230.162 2774.571 318.662 3001.181
#setObjFPlanBox Instance iopad_b5 1.634 232.024 228.244 320.524
#setObjFPlanBox Instance iopad_b6 232.612 0.0 321.112 226.61


#setObjFPlanPolygon Cell {pads} 0.0000 0.0000 0.0000 3000.0000 3000.0000 3000.0000 3000.0000 2753.4400 1242.7300 2753.4400 1242.7300 284.7700 3000.0000 284.7700 3000.0000 0.0000 0.0000 0.0000

# too small setObjFPlanPolygon Cell {pads} 0.0000 0.0000 0.0000 2998.1300 2700.0000 2998.1300 2700.0000 2636.4100 1224.8500 2636.4100 1224.8500 387.4800 2700.0000 387.4800 2700.0000 0.0000 0.0000 0.0000



setOaxMode -compressLevel 0
setMultiCpuUsage -localCpu 4 -cpuPerRemoteHost 1 -remoteHost 0 -keepLicense true




# ams scripts
amsUserGrid





# -- begin power planning

amsGlobalConnect both

globalNetConnect vdd1v8l! -type pgpin -pin vdd1v8l! -inst * -module {}
globalNetConnect vdd1v8r! -type pgpin -pin vdd1v8r! -inst * -module {}
globalNetConnect vdd1v8o! -type pgpin -pin vdd1v8o! -inst * -module {}
globalNetConnect por1v8r! -type pgpin -pin por1v8r! -inst * -module {}
globalNetConnect trig1v8! -type pgpin -pin trig1v8! -inst * -module {}

globalNetConnect gnd1v8l! -type pgpin -pin gnd1v8l! -inst * -module {}
globalNetConnect gnd1v8r! -type pgpin -pin gnd1v8r! -inst * -module {}
globalNetConnect gnd1v8o! -type pgpin -pin gnd1v8o! -inst * -module {}
globalNetConnect subc1v8! -type pgpin -pin subc1v8! -inst * -module {}

globalNetConnect vdd! -type pgpin -pin vdd! -inst * -module {}
globalNetConnect gnd! -type pgpin -pin gnd! -inst * -module {}


setViaGenMode -viarule_preference generated -invoke_verifyGeometry true
selectObject Module theCore
addRing -stacked_via_top_layer AM -around core -jog_distance 4.9 -threshold 4.9 -nets {gnd! vdd!} -stacked_via_bottom_layer M1 -layer {bottom M1 top M1 right AM left AM} -width {left 15 bottom 15 top 15 right 15} -spacing 10 -offset 4.9


addStripe -block_ring_top_layer_limit AM -max_same_layer_jog_length 10 -padcore_ring_bottom_layer_limit MT -set_to_set_distance 100 -stacked_via_top_layer AM -padcore_ring_top_layer_limit AM -spacing 5 -merge_stripes_value 4.9 -layer AM -block_ring_bottom_layer_limit MT -width 10 -nets {gnd! vdd!} -stacked_via_bottom_layer M1







# === End power planning


# Allow cut-outs!!!
setPreference EnableRectilinearDesign 1
puts "--> Adding cut-out"
#setObjFPlanPolygon Cell {pads} 0.0000 0.0000 0.0000 3000.0000 3000.0000 3000.0000 3000.0000 2700 1271.0000 2700 1271.0000 1291.5600 3000.0000 1291.5600 3000.0000 0.0000 0.0000 0.0000


puts "--> Adjusting pins"
# Edit pin positions
#source pads-pin-edit.tcl

#addRing -stacked_via_top_layer AM -user_defined_region {450 2550 1250 2550 1250 1200 450 1200} -around user_defined -jog_distance 4.9 -threshold 4.9 -type block_rings -nets {gnd! vdd!} -stacked_via_bottom_layer M1 -layer {bottom MT top MT right AM left AM} -width 20 -spacing 10 -offset 4.9


#addStripe -block_ring_top_layer_limit AM -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit MT -set_to_set_distance 100 -stacked_via_top_layer AM -padcore_ring_top_layer_limit AM -spacing 5 -merge_stripes_value 4.9 -layer AM -block_ring_bottom_layer_limit MT -width 10 -area {450 2600 1250 2600 1250 1140 450 1140} -nets {gnd! vdd!} -stacked_via_bottom_layer M1




next "Begin placement? y/n"

# Place
puts "--> Setting place mode"
setPlaceMode -congEffort auto -timingDriven 1 -modulePlan 1 -clkGateAware 1 -powerDriven 0 -ignoreScan 1 -reorderScan 1 -ignoreSpare 1 -placeIOPins 1 -moduleAwareSpare 0 -checkPinLayerForAccess {  1 } -maxRouteLayer 5 -preserveRouting 0 -rmAffectedRouting 0 -checkRoute 0 -swapEEQ 0
puts "--> placingDesign"
placeDesign -prePlaceOpt

puts "--> Adjusting pins"
# Edit pin positions
#source pads-pin-edit.tcl


puts "--> Performing power routing"
# power routing
sroute -connect { blockPin padPin padRing corePin } -layerChangeRange { M1 AM } -blockPinTarget { nearestRingStripe nearestTarget } -padPinPortConnect { allPort oneGeom } -checkAlignedSecondaryPin 1 -blockPin useLef -allowJogging 1 -crossoverViaBottomLayer M1 -allowLayerChange 1 -targetViaTopLayer AM -crossoverViaTopLayer AM -targetViaBottomLayer M1 -nets { gnd! vdd! }
# Whatever the last sroute operation is, it breaks the via spacing, so undo it!
undo

# to fix any DRC problems in power vias (forces generation of new custom power vias)
editPowerVia -bottom_layer M1 -delete_vias 1 -top_layer AM
setViaGenMode -viarule_preference generated -invoke_verifyGeometry true
editPowerVia -bottom_layer M1 -add_vias 1 -top_layer AM

# Fix some DRCs
#editSelect -type Special -shapes STRIPE -status {ROUTED FIXED}
#editTrim
#editPowerVia -via_columns 3 -bottom_layer M1 -modify_vias 1 -via_rows 1 -top_layer AM

# reserve routing for power connections
# Putting this before power routing could cause M1 and power vias in the rings to be missed
#sjhHVringBlk 20 37 65
#createRouteBlk -layer {M2 AM} -box 219.474 1026.543 308.622 1252.106
#createRouteBlk -layer {M2 AM} -box 224.568 1496.468 282.115 1585.368
#createRouteBlk -layer {M2 AM} -box 1215 2708.595 1267.430 2757.95
#createRouteBlk -layer M2 -box 1215 2716.816 1266.940 3018.136


next "Begin post-power optimisation? y/n"
puts "-->"
puts "--> Beginning pre-clock optimisation"

# optimise for speed
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -preCTS
#optDesign -preCTS

next "Clock design? y/n"

clockDesign -specFile Clock-pads.ctstch -outDir clock_report -fixedInstBeforeCTS

#report_timing

next "Post-clock opt? y/n"

puts "-->"
puts "--> Beginning post-clock optimisation"
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postCTS


next "Begin routing? y/n"

# main routing
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail

next "Post-route optimisation? y/n"
puts "-->"
puts "--> Beginning post-route optimisation"


# report and optimise timing
#timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix patternbuffer_postRoute -outDir timingReports
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postRoute

next "Add filler? y/n"

# add core filler to prevent DRC violation
amsFillcore
amsFillperi

# sign my name :)
#source sign.tcl

set_interactive_constraint_modes [all_constraint_modes -active]



