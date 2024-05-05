----------------------------------------------------------------------------------
-- Company: HDA
-- Engineer: Max Fehn and Mustapha Eddaoui
-- 
-- Create Date:    23:29:31 06/03/2014 
-- Design Name: 
-- Module Name:    ov7670_registers - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_registers is
    Port ( clk      : in  STD_LOGIC;
           resend   : in  STD_LOGIC;
           advance  : in  STD_LOGIC;
		   switch   : in  STD_LOGIC;
           command  : out  std_logic_vector(15 downto 0);
           finished : out  STD_LOGIC);
end ov7670_registers;

architecture Behavioral of ov7670_registers is
   signal sreg   : std_logic_vector(15 downto 0);
   signal address : std_logic_vector(7 downto 0) := (others => '0');
begin
   command <= sreg;
   with sreg select finished  <= '1' when x"FFFF", '0' when others;
   
   process(clk)
   begin
      if rising_edge(clk) then
         if resend = '1' then 
            address <= (others => '0');
         elsif advance = '1' then
            address <= std_logic_vector(unsigned(address)+1); -- Increase address
         end if;

         case address is
            when x"00" => sreg <= x"1280"; -- COM7   Reset
            when x"01" => sreg <= x"1280"; -- COM7   Reset
            when x"02" => sreg <= x"1101"; -- CLKRC  Prescaler - Fin/(1+1)
            when x"03" => sreg <= x"1200"; -- COM7   QIF + RGB output
            when x"04" => sreg <= x"0C00"; -- COM3  Lots of stuff, enable scaling, all others off
            when x"05" => sreg <= x"3E00"; -- COM14  PCLK scaling = 0
            
            when x"06" => sreg <= x"40c0"; -- COM15  Full 0-255 output, RGB 565

            when x"07" => 
				
				  if (switch = '1') then 	-- Switching Monochrome / colour
				    sreg <= x"3A04";--x"3a0C";
			     else 
				    sreg <= x"3A14";--x"3a1C";
				  end if;-- TSLB   Set UV ordering,  do not auto-reset window
            when x"08" => sreg <= x"3D88"; -- RGB444 Set RGB format
            
            when x"09" => sreg <= x"1714"; -- HSTART HREF start (high 8 bits)
            when x"0a" => sreg <= x"1802"; -- HSTOP  HREF stop (high 8 bits)
            when x"0b" => sreg <= x"32A4"; -- HREF   Edge offset and low 3 bits of HSTART and HSTOP
            when x"0c" => sreg <= x"1903"; -- VSTART VSYNC start (high 8 bits)
            when x"0d" => sreg <= x"1A7b"; -- VSTOP  VSYNC stop (high 8 bits) 
            when x"0e" => sreg <= x"030a"; -- VREF   VSYNC low two bits
            
            when x"0f" => sreg <= x"703a"; -- SCALING_XSC
            when x"10" => sreg <= x"7135"; -- SCALING_YSC

            when x"11" => sreg <= x"7211"; -- SCALING_DCWCTR
            when x"12" => sreg <= x"73F0"; -- SCALING_PCLK_DIV
            when x"13" => sreg <= x"a202"; -- SCALING_PCLK_DELAY  PCLK scaling = 4, must match COM14
            
            when x"14" => sreg <= x"1500"; -- COM10 Use HREF not hSYNC
            when x"15" => sreg <= x"7a20"; -- SLOP
            when x"16" => sreg <= x"7b10"; -- GAM1
            when x"17" => sreg <= x"7c1e"; -- GAM2
            when x"18" => sreg <= x"7d35"; -- GAM3
            when x"19" => sreg <= x"7e5a"; -- GAM4
            when x"1A" => sreg <= x"7f69"; -- GAM5
            when x"1B" => sreg <= x"8076"; -- GAM6
            when x"1C" => sreg <= x"8180"; -- GAM7
            when x"1D" => sreg <= x"8288"; -- GAM8
            when x"1E" => sreg <= x"838f"; -- GAM9
            when x"1F" => sreg <= x"8496"; -- GAM10
            when x"20" => sreg <= x"85a3"; -- GAM11
            when x"21" => sreg <= x"86af"; -- GAM12
            when x"22" => sreg <= x"87c4"; -- GAM13
            when x"23" => sreg <= x"88d7"; -- GAM14
            when x"24" => sreg <= x"89e8"; -- GAM15
            when x"25" => sreg <= x"138F"; -- COM8 - AGC, White balance
            when x"26" => sreg <= x"0000"; -- GAIN AGC 
            when x"27" => sreg <= x"1000"; -- AECH Exposure
            when x"28" => sreg <= x"0D40"; -- COMM4 - Window Size
            when x"29" => sreg <= x"1418"; -- COMM9 AGC 
            when x"2a" => sreg <= x"a505"; -- AECGMAX banding filter step
            when x"2b" => sreg <= x"2495"; -- AEW AGC Stable upper limite
            when x"2c" => sreg <= x"2533"; -- AEB AGC Stable lower limi
            when x"2d" => sreg <= x"26e3"; -- VPT AGC fast mode limits
            when x"2e" => sreg <= x"9f78"; -- HRL High reference level
            when x"2f" => sreg <= x"A068"; -- LRL low reference level
            when x"30" => sreg <= x"a103"; -- DSPC3 DSP control
            when x"31" => sreg <= x"A6d8"; -- LPH Lower Prob High
            when x"32" => sreg <= x"A7d8"; -- UPL Upper Prob Low
            when x"33" => sreg <= x"A8f0"; -- TPL Total Prob Low
            when x"34" => sreg <= x"A990"; -- TPH Total Prob High
            when x"35" => sreg <= x"AA94"; -- NALG AEC Algo select
            when x"36" => sreg <= x"13E5"; -- COM8 AGC Settings
				---------------------------------------------
				
				
				when x"37" => sreg <= x"0E61"; -- com 5
				when x"38" => sreg <= x"0F4b"; --com6
				when x"39" => sreg <= x"1602"; --RSVD (Reserved)
				when x"3a" => sreg <= x"1E07"; --Mirror/VFlip Enable
				when x"3b" => sreg <= x"2102"; --ADCCTR1 (ADC Control)
				when x"3c" => sreg <= x"2291"; --ADCCTR2 (ADC Control)
				when x"3d" => sreg <= x"2907"; --RSVD (Reserved)
				when x"3e" => sreg <= x"330B"; --CHLF (Array Current Control)
				when x"3f" => sreg <= x"350B"; --RSVD (Reserved)
				when x"40" => sreg <= x"371D"; --ADC (ADC Control)
				when x"41" => sreg <= x"3871"; --ACOM (ADC and Analog Common Mode Control)
				when x"42" => sreg <= x"392A"; --OFON (ADC Offeset Control)
				when x"43" => sreg <= x"3C78"; --COM12 (Common Control 12)
				when x"44" => sreg <= x"4D40"; --DM_POS (Dummy row position)
				when x"45" => sreg <= x"4E20"; --RSVD (Reserved)
				when x"46" => sreg <= x"6910"; --GFIX Fix Gain Control
				when x"47" => sreg <= x"6b4a"; --DBLV (PLL control | Regulator control)
				when x"48" => sreg <= x"7410"; --REG74 (Digital gain control select | Digtial gain manual control)
				when x"49" => sreg <= x"8d4f"; --RSVD (Reserved)
				when x"4a" => sreg <= x"8e00"; --RSVD (Reserved)
				when x"4b" => sreg <= x"8f00"; --RSVD (Reserved)
				when x"4c" => sreg <= x"9000"; --RSVD (Reserved)
				when x"4d" => sreg <= x"9100"; --RSVD (Reserved)
				when x"4e" => sreg <= x"9600"; --RSVD (Reserved)
				when x"4f" => sreg <= x"9a00"; --RSVD (Reserved)
				when x"50" => sreg <= x"b084"; --RSVD (Reserved)
				when x"51" => sreg <= x"b10c"; --ABLC1 (ABLC enable)
				when x"52" => sreg <= x"b20e"; --RSVD (Reserved)
				when x"53" => sreg <= x"b382"; --THL_ST (ABLC Target)
				when x"54" => sreg <= x"b80a"; --RSVD (Reserved)				
				----------------------------------------------
				when x"55" => sreg <= x"4112"; --COM16 (Common Control 16)
				when x"56" => sreg <= x"589e"; --MTXS (Matrix Coefficient Sign for coefficient 5 to 0) | Auto contrast center enable
				
				when x"57" => sreg <= x"4F86";--MTX1 (Matrix Coefficient 1)
				when x"58" => sreg <= x"5080";--MTX2 (Matrix Coefficient 2)
				when x"59" => sreg <= x"5100";--MTX3 (Matrix Coefficient 3)
				when x"5a" => sreg <= x"5222";--MTX4 (Matrix Coefficient 4)
				when x"5b" => sreg <= x"535e";--MTX5 (Matrix Coefficient 5)
				when x"5c" => sreg <= x"5481";--MTX6 (Matrix Coefficient 6)
            -----------------------------------------------
				when x"5d" => sreg <= x"4314";--AWBC1 (AWB Control 1)
				when x"5e" => sreg <= x"44f0";--AWBC2 (AWB Control 2)				
				when x"5f" => sreg <= x"4545";--AWBC3 (AWB Control 3)				
				when x"60" => sreg <= x"4751";--AWBC5 (AWB Control 5)
				when x"61" => sreg <= x"4879";--AWBC6 (AWB Control 6)
				when x"62" => sreg <= x"4661";--AWBC4 (AWB Control 4)
				
				when others => sreg <= x"ffff";
         end case;
      end if;
   end process;
end Behavioral;