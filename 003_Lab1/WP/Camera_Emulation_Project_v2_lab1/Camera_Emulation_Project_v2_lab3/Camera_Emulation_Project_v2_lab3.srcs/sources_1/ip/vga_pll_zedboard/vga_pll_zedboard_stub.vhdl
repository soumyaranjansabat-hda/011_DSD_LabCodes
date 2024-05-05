-- Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2014.2 (win64) Build 932637 Wed Jun 11 13:33:10 MDT 2014
-- Date        : Fri Jan 02 21:05:05 2015
-- Host        : Peter-Laptop running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Xilinx/Projects/Camera_Emulator/Camera_Emulation_Project_V2/Camera_Emulation_Project_V2.srcs/sources_1/ip/vga_pll_zedboard/vga_pll_zedboard_stub.vhdl
-- Design      : vga_pll_zedboard
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_pll_zedboard is
  Port ( 
    CLK100M : in STD_LOGIC;
    CLK50M_camera : out STD_LOGIC;
    CLK25M_vga : out STD_LOGIC
  );

end vga_pll_zedboard;

architecture stub of vga_pll_zedboard is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK100M,CLK50M_camera,CLK25M_vga";
begin
end;
