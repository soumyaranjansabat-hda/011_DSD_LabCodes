----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Peter Wochnik
-- 
-- Create Date: 30.12.2014 16:28:19
-- Design Name: 
-- Module Name: capture_logic - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity capture_logic is
    Port ( pclk : in STD_LOGIC;
           href : in STD_LOGIC;
	       vsync: in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           wAddress : out STD_LOGIC_VECTOR (18 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0);
           we : out STD_LOGIC);
end capture_logic;

architecture Behavioral of capture_logic is

signal wAddress_tmp : integer := 0;
signal data_tmp : std_logic_vector(15 downto 0) := (others => '0');
signal we_tmp : std_logic := '0';

begin

data_out <= data_tmp;
we <= we_tmp;
wAddress <= std_logic_vector(to_unsigned(wAddress_tmp, wAddress'length));

process (href, pclk, data_in, vsync)
variable lowByte : std_logic := '0';
begin

    if rising_edge(pclk) then
        if we_tmp = '1' then
            wAddress_tmp <= (wAddress_tmp + 1) mod 307200;
            we_tmp <= '0';
        end if;
    end if; 

    if vsync = '1' then
    
	   lowByte := '0';
	   data_tmp <= (others => '0');
	   wAddress_tmp <= 0;
	   we_tmp <= '0';
	   
    elsif href = '1' then
        if rising_edge(pclk) then
                       
            if lowByte = '0' then
                data_tmp(15 downto 8) <= data_in;
                we_tmp <= '0';
            else
                data_tmp(7 downto 0) <= data_in;
                we_tmp <= '1';
            end if;   
                    
        lowByte := not lowByte;
            
        end if;
    end if;
            
end process;

end Behavioral;
