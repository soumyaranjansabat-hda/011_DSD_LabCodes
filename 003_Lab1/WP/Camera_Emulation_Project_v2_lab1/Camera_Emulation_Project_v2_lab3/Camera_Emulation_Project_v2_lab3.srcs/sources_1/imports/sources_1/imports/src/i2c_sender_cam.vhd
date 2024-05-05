----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:30:22 06/03/2014 
-- Design Name: 
-- Module Name:    i2c_sender - Behavioral 
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

entity i2c_sender_cam is
    Port ( clk   : in  STD_LOGIC;    
           siod  : inout  STD_LOGIC;
           sioc  : out  STD_LOGIC;
           taken : out  STD_LOGIC;				--'1' when sending, '0' when not sending
           send  : in  STD_LOGIC; 				--'1' when sending
           id    : in  STD_LOGIC_VECTOR (7 downto 0);		--Device ID
           reg   : in  STD_LOGIC_VECTOR (7 downto 0);		--Register Address
           value : in  STD_LOGIC_VECTOR (7 downto 0));		--Register Value
end i2c_sender_cam;

architecture Behavioral of i2c_sender_cam is
   signal   divider  : unsigned (16 downto 0) := "00000000000000001"; -- this value gives a 131071 cycle (~2,6ms) pause before the initial frame is sent
   signal   busy_sr  : std_logic_vector(31 downto 0) := (others => '0');
   signal   data_sr  : std_logic_vector(31 downto 0) := (others => '1');
begin
   process(busy_sr, data_sr(31))
   begin
      if busy_sr(11 downto 10) = "10" or 
         busy_sr(20 downto 19) = "10" or 
         busy_sr(29 downto 28) = "10"  then
         siod <= 'Z';
      else
         siod <= data_sr(31);
      end if;
   end process;
   
   process(clk)
   begin
      if rising_edge(clk) then
         taken <= '0';
         if busy_sr(31) = '0' then
            SIOC <= '1';
            if send = '1' then
               if divider = "00000000000000000" then
                  data_sr <= "100" &   id & '0'  &   reg & '0' & value & '0' & "01";	--"100" Start sequence for I2C | "01" Stop sequence for I2C
                  busy_sr <= "111" & "111111111" & "111111111" & "111111111" & "11";
                  taken <= '1';
               else
                  divider <= divider+1; -- this only happens on powerup
               end if;
            end if;
         else

            case busy_sr(32-1 downto 32-3) & busy_sr(2 downto 0) is
               when "111"&"111" => -- start seq #1
                  case divider(16 downto 15) is
                     when "00"   => SIOC <= '1';
                     when "01"   => SIOC <= '1';
                     when "10"   => SIOC <= '1';
                     when others => SIOC <= '1';
                  end case;
               when "111"&"110" => -- start seq #2
                  case divider(16 downto 15) is
                     when "00"   => SIOC <= '1';
                     when "01"   => SIOC <= '1';
                     when "10"   => SIOC <= '1';
                     when others => SIOC <= '1';
                  end case;
               when "111"&"100" => -- start seq #3
                  case divider(16 downto 15) is
                     when "00"   => SIOC <= '0';
                     when "01"   => SIOC <= '0';
                     when "10"   => SIOC <= '0';
                     when others => SIOC <= '0';
                  end case;
               when "110"&"000" => -- end seq #1
                  case divider(16 downto 15) is
                     when "00"   => SIOC <= '0';
                     when "01"   => SIOC <= '1';
                     when "10"   => SIOC <= '1';
                     when others => SIOC <= '1';
                  end case;
               when "100"&"000" => -- end seq #2
                  case divider(16 downto 15) is
                     when "00"   => SIOC <= '1';
                     when "01"   => SIOC <= '1';
                     when "10"   => SIOC <= '1';
                     when others => SIOC <= '1';
                  end case;
               when "000"&"000" => -- Idle
                  case divider(16 downto 15) is
                     when "00"   => SIOC <= '1';
                     when "01"   => SIOC <= '1';
                     when "10"   => SIOC <= '1';
                     when others => SIOC <= '1';
                  end case;
               when others      => 
                  case divider(16 downto 15) is
                     when "00"   => SIOC <= '0';
                     when "01"   => SIOC <= '1';
                     when "10"   => SIOC <= '1';
                     when others => SIOC <= '0';
                  end case;
            end case;   

            if divider = "11111111111111111" then
               busy_sr <= busy_sr(32-2 downto 0) & '0';
               data_sr <= data_sr(32-2 downto 0) & '1';
               divider <= (others => '0');
            else
               divider <= divider+1;
            end if;
         end if;
      end if;
   end process;
end Behavioral;