----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Peter Wochnik
-- 
-- Create Date: 30.12.2014 16:28:19
-- Design Name: 
-- Module Name: frame_buffer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

ENTITY frame_buffer IS
	PORT
	(
		data_in	  : IN STD_LOGIC_VECTOR (15 DOWNTO 0);         -- Input Data bits
		rdaddress : IN STD_LOGIC_VECTOR (18 DOWNTO 0);         -- Read address to read data
		rdclock	  : IN STD_LOGIC;                              -- Read clock
		wraddress : IN STD_LOGIC_VECTOR (18 DOWNTO 0);         -- Write address to write data
		wrclock	  : IN STD_LOGIC;                              -- Write clock
		wren	  : IN STD_LOGIC;                              -- Write enable
		data_out  : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)         -- Data output
	);
END frame_buffer;


ARCHITECTURE SYN OF frame_buffer IS
  
   signal data_out0 : STD_LOGIC_VECTOR(13 DOWNTO 0);
   signal data_out1 : STD_LOGIC_VECTOR(13 DOWNTO 0);
   signal data_out2 : STD_LOGIC_VECTOR(13 DOWNTO 0);
   signal data_in_tmp : STD_LOGIC_VECTOR(13 DOWNTO 0);
   signal wren_tmp : STD_LOGIC_VECTOR(2 DOWNTO 0);
   signal rden_tmp : STD_LOGIC_VECTOR(2 DOWNTO 0);
   
   component Dual_Port_BRAM
     PORT (
       clka : IN STD_LOGIC;
       ena : IN STD_LOGIC;
       wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
       addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
       dina : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
       clkb : IN STD_LOGIC;
       enb : IN STD_LOGIC;
       addrb : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
       doutb : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
     );
   end component Dual_Port_BRAM;
   
   component Dual_Port_BRAM_1
     PORT (
       clka : IN STD_LOGIC;
       ena : IN STD_LOGIC;
       wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
       addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
       dina : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
       clkb : IN STD_LOGIC;
       enb : IN STD_LOGIC;
       addrb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
       doutb : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
     );
   end component Dual_Port_BRAM_1;  
   
BEGIN
	
data_in_tmp <= data_in(15 downto 9) & data_in(7 downto 1);
	
process (rdaddress, wraddress, rdclock, wrclock, wren, data_out0, data_out1)
begin	
    case wraddress(18 downto 17) is
        when "00"  => wren_tmp <= "001";                    
        when "01"  => wren_tmp <= "010";   
        when "10"  => wren_tmp <= "100";                   
        when others => wren_tmp <= "000";
    end case;
    
    case rdaddress(18 downto 17) is
        when "00"  => rden_tmp <= "001";
                      data_out <= data_out0(13 downto 7) & '0' & data_out0(6 downto 0) & '0';
        when "01"  => rden_tmp <= "010";
                      data_out <= data_out1(13 downto 7) & '0' & data_out1(6 downto 0) & '0'; 
        when "10"  => rden_tmp <= "100";
                      data_out <= data_out2(13 downto 7) & '0' & data_out2(6 downto 0) & '0'; 
        when others => rden_tmp <= "000";
    end case;
	
end process;	

Dual_Port_BRAM_Inst0 : Dual_Port_BRAM
     Port map(
       clka => wrclock,
       ena => wren_tmp(0),
       wea(0) => wren,
       addra => wraddress(16 downto 0),
       dina => data_in_tmp,
       clkb => rdclock, 
       enb => rden_tmp(0),
       addrb => rdaddress(16 downto 0),
       doutb => data_out0
     );

Dual_Port_BRAM_Inst1 : Dual_Port_BRAM
     Port map(
       clka => wrclock,
       ena => wren_tmp(1),
       wea(0) => wren,
       addra => wraddress(16 downto 0),
       dina => data_in_tmp,
       clkb => rdclock, 
       enb => rden_tmp(1),
       addrb => rdaddress(16 downto 0),
       doutb => data_out1
     );

Dual_Port_BRAM_Inst2 : Dual_Port_BRAM_1
     Port map(
       clka => wrclock,
       ena => wren_tmp(2),
       wea(0) => wren,
       addra => wraddress(15 downto 0),
       dina => data_in_tmp,
       clkb => rdclock, 
       enb => rden_tmp(2),
       addrb => rdaddress(15 downto 0),
       doutb => data_out2
     );   

END SYN;