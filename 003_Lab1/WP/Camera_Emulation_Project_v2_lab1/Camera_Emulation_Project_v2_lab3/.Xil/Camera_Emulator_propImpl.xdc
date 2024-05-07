set_property SRC_FILE_INFO {cfile:e:/HDA_Lectures/001_Repository/011_DSD/011_DSD_LabCodes/003_Lab1/WP/Camera_Emulation_Project_v2_lab1/Camera_Emulation_Project_v2_lab3/Camera_Emulation_Project_v2_lab3.srcs/sources_1/ip/vga_pll_zedboard/vga_pll_zedboard.xdc rfile:../Camera_Emulation_Project_v2_lab3.srcs/sources_1/ip/vga_pll_zedboard/vga_pll_zedboard.xdc id:1 order:EARLY scoped_inst:HDMI_V1_Inst/vga_pll_inst/U0} [current_design]
current_instance HDMI_V1_Inst/vga_pll_inst/U0
set_property src_info {type:SCOPED_XDC file:1 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports CLK100M]] 0.1
