// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Fri Aug 24 11:48:49 2018
// Host        : LAPTOP-H0UJ14FD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {H:/student job/Lab
//               work/lab3/Camera_Emulation_Project_v2_lab3/Camera_Emulation_Project_v2_lab3.srcs/sources_1/ip/Dual_Port_BRAM/Dual_Port_BRAM_stub.v}
// Design      : Dual_Port_BRAM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.2" *)
module Dual_Port_BRAM(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[16:0],dina[13:0],clkb,enb,addrb[16:0],doutb[13:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [16:0]addra;
  input [13:0]dina;
  input clkb;
  input enb;
  input [16:0]addrb;
  output [13:0]doutb;
endmodule
