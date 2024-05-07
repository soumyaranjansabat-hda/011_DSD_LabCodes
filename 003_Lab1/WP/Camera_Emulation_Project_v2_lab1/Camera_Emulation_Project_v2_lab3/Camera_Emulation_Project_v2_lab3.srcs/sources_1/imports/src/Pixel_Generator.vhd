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
    --Hex value representation for blue pixel in YCbCr format.
    constant y_blue : STD_LOGIC_VECTOR (7 downto 0) := x"29";
    constant cb_blue : STD_LOGIC_VECTOR (7 downto 0) := x"F0";
    constant cr_blue : STD_LOGIC_VECTOR (7 downto 0) := x"6E";
    
    --A counter of 640 as resolution is 640x480
    signal count : integer range 0 to 639 := 0;

begin
    --On the falling edge of pixel clock
    blue_pixel_generation : process(pclk)
    
    begin
    if(falling_edge(pclk)) then
        if((count rem 4) = 0) then
            data <= cb_blue;
        elsif ((count rem 4) = 1) then
            data <= y_blue;
        elsif ((count rem 4) = 2) then
            data <= cr_blue;
        elsif ((count rem 4) = 3) then
            data <= y_blue;
        end if;
    
        if(count = 639) then
            count <= 0;
        else
            count <= (count + 1);
        end if;
    end if;
    
    end process;
end Behavioral;
