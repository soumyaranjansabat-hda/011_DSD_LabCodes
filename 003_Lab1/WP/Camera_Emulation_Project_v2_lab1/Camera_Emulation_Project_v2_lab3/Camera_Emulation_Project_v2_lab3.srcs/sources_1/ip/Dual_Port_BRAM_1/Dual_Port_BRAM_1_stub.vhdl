-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
-- Date        : Fri Aug 24 11:47:27 2018
-- Host        : LAPTOP-H0UJ14FD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {H:/student job/Lab
--               work/lab3/Camera_Emulation_Project_v2_lab3/Camera_Emulation_Project_v2_lab3.srcs/sources_1/ip/Dual_Port_BRAM_1/Dual_Port_BRAM_1_stub.vhdl}
-- Design      : Dual_Port_BRAM_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Dual_Port_BRAM_1 is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 15 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 13 downto 0 );
    clkb : in STD_LOGIC;
    enb : in STD_LOGIC;
    addrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 13 downto 0 )
  );

end Dual_Port_BRAM_1;

architecture stub of Dual_Port_BRAM_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,wea[0:0],addra[15:0],dina[13:0],clkb,enb,addrb[15:0],doutb[13:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_1,Vivado 2018.2";
begin
end;
