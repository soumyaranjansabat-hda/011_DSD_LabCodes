// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.2 (win64) Build 932637 Wed Jun 11 13:33:10 MDT 2014
// Date        : Fri Jan 02 21:05:05 2015
// Host        : Peter-Laptop running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               C:/Xilinx/Projects/Camera_Emulator/Camera_Emulation_Project_V2/Camera_Emulation_Project_V2.srcs/sources_1/ip/vga_pll_zedboard/vga_pll_zedboard_stub.v
// Design      : vga_pll_zedboard
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module vga_pll_zedboard(CLK100M, CLK50M_camera, CLK25M_vga)
/* synthesis syn_black_box black_box_pad_pin="CLK100M,CLK50M_camera,CLK25M_vga" */;
  input CLK100M;
  output CLK50M_camera;
  output CLK25M_vga;
endmodule
