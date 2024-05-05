----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Peter Wochnik
-- 
-- Create Date: 28.12.2014 14:21:06
-- Design Name: 
-- Module Name: Camera_Emulator - Behavioral
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

entity Camera_Emulator is
    Port ( clk_100M : in STD_LOGIC;
           switch : in STD_LOGIC;
           resend : in STD_LOGIC;
           cam_resend : in STD_LOGIC;
           config_done : out STD_LOGIC;
           Data_out : out STD_LOGIC_VECTOR (15 downto 0);
           de : out STD_LOGIC;
           HDMI_CLK : out STD_LOGIC;
           h_Sync : out STD_LOGIC;
           v_Sync : out STD_LOGIC;
           sioc_hdmi : out STD_LOGIC;
           siod_hdmi : inout STD_LOGIC);
end Camera_Emulator;

architecture Behavioral of Camera_Emulator is
   

component Img_Generator
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
end component Img_Generator;

component HDMI_V1
   port ( Cam_hRef    : in    std_logic; 
          Cam_vSync   : in    std_logic; 
		  Cam_pclk    : in    std_logic;
          clk_100M    : in    std_logic; 
          resend      : in    STD_LOGIC;
          cam_resend  : in    STD_LOGIC;			 
          Data_in     : in    std_logic_vector (7 downto 0); 
		  switch      : in    STD_LOGIC;
          config_done : out   std_logic; 
          Data_out    : out   std_logic_vector (15 downto 0); 
          de          : out   std_logic; 
          HDMI_CLK    : out   std_logic; 
          h_Sync      : out   std_logic; 
          PwDn        : out   std_logic; 
          reset       : out   std_logic; 
          sioc        : out   std_logic; 
          v_Sync      : out   std_logic; 
          xClk        : out   std_logic; 
		  sioc_hdmi   : out   STD_LOGIC;
          siod        : inout STD_LOGIC;
          siod_hdmi   : inout std_logic
    );
end component HDMI_V1;

signal cam_data_tmp : std_logic_vector( 7 downto 0);
signal cam_href_tmp : std_logic;
signal cam_vsync_tmp : std_logic;
signal cam_pclk_tmp : std_logic;
signal cam_pwdn_tmp : std_logic;
signal cam_reset_tmp : std_logic;
signal cam_sioc_tmp : std_logic;
signal cam_siod_tmp : std_logic;
signal cam_xclk_tmp : std_logic;  

begin

Img_Generator_Inst : Img_Generator
    Port map(
         cam_data => cam_data_tmp,
         cam_href => cam_href_tmp, 
         cam_vsync => cam_vsync_tmp, 
         cam_pclk => cam_pclk_tmp,
         cam_pwdn => cam_pwdn_tmp,
         cam_reset => cam_reset_tmp,
         cam_sioc => cam_sioc_tmp,
         cam_siod => cam_siod_tmp,
         cam_xclk => cam_xclk_tmp
    );

HDMI_V1_Inst : HDMI_V1
   Port map( 
          Cam_hRef => cam_href_tmp,
          Cam_vSync => cam_vsync_tmp,
		  Cam_pclk => cam_pclk_tmp,
          clk_100M => clk_100M,
          resend => resend,
          cam_resend => cam_resend,			 
          Data_in => cam_data_tmp, 
		  switch => switch,
          config_done => config_done,
          Data_out => Data_out,
          de => de, 
          HDMI_CLK => HDMI_CLK, 
          h_Sync => h_Sync, 
          PwDn => cam_pwdn_tmp,
          reset => cam_reset_tmp,
          sioc => cam_sioc_tmp,
          v_Sync => v_Sync, 
          xClk => cam_xclk_tmp, 
		  sioc_hdmi => sioc_hdmi,
          siod => cam_siod_tmp,
          siod_hdmi => siod_hdmi
    ); 

end Behavioral;
