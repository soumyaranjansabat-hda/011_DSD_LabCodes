----------------------------------------------------------------------------------
-- Company: 
-- Engineer:
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: Pixel_Generator - Behavioral
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

entity Pixel_Generator is
    Port ( pclk : in STD_LOGIC;
           href : in STD_LOGIC;
           vsync : in STD_LOGIC;
           data : out STD_LOGIC_VECTOR (7 downto 0));
end Pixel_Generator;



architecture Behavioral of Pixel_Generator is
begin
-- your code
end Behavioral;
