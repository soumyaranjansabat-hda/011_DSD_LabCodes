----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Peter Wochnik
-- 
-- Create Date: 19.12.2014 11:23:43
-- Design Name: 
-- Module Name: Img_Generator - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Img_Generator is
    Port ( 
		cam_data : out std_logic_vector(7 downto 0);
		cam_href : out std_logic; 
		cam_vsync: out std_logic; 
        cam_pclk : out std_logic;
        cam_pwdn : in std_logic;
        cam_reset: in std_logic;
        cam_sioc : in std_logic;
        cam_siod : inout std_logic;
        cam_xclk : in std_logic
	);
end Img_Generator;

architecture Behavioral of Img_Generator is

component Camera_Clock_Generator is
	Port ( 
		pclk : in STD_LOGIC;
        href : out STD_LOGIC;
        vsync : out STD_LOGIC
	);
end component Camera_Clock_Generator;

component Pixel_Generator is
	Port (
		pclk : in STD_LOGIC;
		href : in STD_LOGIC;
		vsync : in STD_LOGIC;
		data : out STD_LOGIC_VECTOR( 7 downto 0 )
	);
end component Pixel_Generator;

signal temp_href : STD_LOGIC;
signal temp_vsync : STD_LOGIC;
signal temp_pclk : STD_LOGIC;

begin

    temp_pclk <= not cam_xclk; -- xclk is used for pclk (25MHz)
	cam_href <= temp_href;
	cam_pclk <= temp_pclk;
	cam_vsync <= temp_vsync;

	Camera_Clock_Generator_inst : Camera_Clock_Generator
		port map( 
			pclk => temp_pclk,
            href => temp_href,
            vsync => temp_vsync
		);
		
	Pixel_Generator_inst : Pixel_Generator
		Port map(
			pclk => temp_pclk,
			href => temp_href,
			vsync => temp_vsync,
			data => cam_data
		);

end Behavioral;
