----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Apratim Gupta, Peter Wochnik
-- 
-- Create Date:    17:46:23 05/28/2014 
-- Design Name: 
-- Module Name:    HDMI_V1 - Behavioral 
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
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity HDMI_V1 is
   port ( 
          clk_100M    : in    std_logic; 
          resend      : in    STD_LOGIC;
          Data_out    : out   std_logic_vector (15 downto 0); 
          de          : out   std_logic; 
          HDMI_CLK    : out   std_logic; 
          h_Sync      : out   std_logic;  
          v_Sync      : out   std_logic; 
		  sioc_hdmi   : out   STD_LOGIC;
          siod_hdmi   : inout std_logic;
          cam_resend  : in    std_logic;
          config_done : out   std_logic;
          sioc        : out   std_logic;
          siod        : inout std_logic;
          reset       : out   std_logic; 
          PwDn        : out   std_logic;
          xClk        : out   std_logic;
          switch      : in    std_logic;
          Cam_pclk    : in    std_logic;
          Cam_hRef    : in    std_logic;
          Cam_vSync   : in    std_logic;
          Data_in     : in    std_logic_vector (7 downto 0)
          );
end HDMI_V1;


architecture Behavioral of HDMI_V1 is

  	component vga_pll_zedboard
		port ( CLK100M       : in  std_logic;
		       CLK50M_camera : out std_logic;
		       CLK25M_vga    : out std_logic);
	end component;
   
   
   component vga_controller
      PORT(
        pixel_clk :  IN   STD_LOGIC;  --pixel clock at frequency of VGA mode being used
        reset_n   :  IN   STD_LOGIC;  --active low asycnchronous reset
        h_sync    :  OUT  STD_LOGIC;  --horiztonal sync pulse
        v_sync    :  OUT  STD_LOGIC;  --vertical sync pulse
        disp_ena  :  OUT  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
        column    :  OUT  INTEGER;    --horizontal pixel coordinate
        row       :  OUT  INTEGER);   --vertical pixel coordinate
    end component vga_controller;
	
	component i2c_sender 
      Port ( clk    : in    STD_LOGIC; -- 50 MHz
             resend : in    STD_LOGIC; -- initial reset kinda
             sioc_hdmi   : out   STD_LOGIC;
             siod_hdmi   : inout STD_LOGIC; -- can read from/ write to the registers
		     i2c_finished : out STD_LOGIC );-- start video data transmission only after this is becoming 1
    end component;
    
    component capture_logic
      Port ( pclk : in STD_LOGIC;
             href : in STD_LOGIC;
             vsync: in STD_LOGIC;
             data_in : in STD_LOGIC_VECTOR (7 downto 0);
             wAddress : out STD_LOGIC_VECTOR (18 downto 0);
             data_out : out STD_LOGIC_VECTOR (15 downto 0);
             we : out STD_LOGIC);
    end component capture_logic; 
    
    component frame_buffer
      Port ( data_in   : IN STD_LOGIC_VECTOR (15 DOWNTO 0);         -- Input Data bits
             rdaddress : IN STD_LOGIC_VECTOR (18 DOWNTO 0);         -- Read address to read data
             rdclock   : IN STD_LOGIC;                              -- Read clock
             wraddress : IN STD_LOGIC_VECTOR (18 DOWNTO 0);         -- Write address to write data
             wrclock   : IN STD_LOGIC;                              -- Write clock
             wren      : IN STD_LOGIC;                              -- Write enable
             data_out  : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));         -- Data output    
    end component frame_buffer;	 
    
    component ov7670_controller
       Port ( clk   : in    STD_LOGIC;            --clk driver for this module
              resend  :in    STD_LOGIC;           --Resend all register settings
              switch  :in    STD_LOGIC;           --Switch for Colour/Monochrome Mode
              config_finished : out std_logic;    --LED to show when config is finished
              sioc  : out   STD_LOGIC;            --IC2 Clock
              siod  : inout STD_LOGIC;            --IC2 Data
              reset : out   STD_LOGIC;            --Always '1' - normal mode
              pwdn  : out   STD_LOGIC;            --LED shows if it is at the power saver mode
              xclk  : out   STD_LOGIC);           --Clk Driver for OV7670 camera
    end component ov7670_controller;

	signal i2c_done_tmp : std_logic;
	signal clk_25M      : std_logic; 
    signal clk_50M      : std_logic;
    signal display_en   : std_logic;
    signal column_tmp   : INTEGER;
    signal row_tmp      : INTEGER;
    signal rdaddress_tmp : std_logic_vector(18 downto 0);
    signal wAddress_tmp  : std_logic_vector(18 downto 0);
    signal data_out_tmp  : std_logic_vector(15 downto 0);
    signal we_tmp : std_logic;
    signal rdclock_tmp : std_logic;
    signal config_done_tmp : std_logic;
begin

de <= display_en;
HDMI_CLK <= clk_25M;
config_done <= config_done_tmp;

process (row_tmp, column_tmp)
begin
    
    if (row_tmp < 480 and column_tmp < 640) then
        rdaddress_tmp <= std_logic_vector(to_unsigned((row_tmp * 640 + column_tmp), rdaddress_tmp'length));
    end if;
    
end process;

vga_pll_inst : vga_pll_zedboard
        port map (CLK100M => clk_100M,
                  CLK50M_camera => clk_50M,
                  CLK25M_vga => clk_25M);
	
i2c_sender_inst : i2c_sender 
	    port map (clk => clk_50M,    
                  resend => resend, 
                  sioc_hdmi => sioc_hdmi, 
                  siod_hdmi => siod_hdmi,
		          i2c_finished => i2c_done_tmp);

vga_controller_inst : vga_controller
        port map (pixel_clk => clk_25M,
                  reset_n => (i2c_done_tmp and config_done_tmp),
                  h_sync => h_Sync,
                  v_sync => v_Sync,
                  disp_ena => display_en,
                  column => column_tmp,
                  row => row_tmp);
                  
capture_logic_Inst : capture_logic
        port map (pclk => Cam_pclk,
                  href => Cam_hRef,
                  vsync => Cam_vSync,
                  data_in => Data_in,
                  wAddress => wAddress_tmp,
                  data_out => data_out_tmp,
                  we => we_tmp);
                  
frame_buffer_Inst : frame_buffer
        port map (data_in => data_out_tmp,
                  rdaddress => rdaddress_tmp,
                  rdclock => (not clk_25M),
                  wraddress => wAddress_tmp,
                  wrclock => (not cam_pclk),      
                  wren => we_tmp,
                  data_out => Data_out);
                  
ov7670_controller_Inst : ov7670_controller
        port map (clk => clk_50M,
                  resend => cam_resend,
                  switch => switch,
                  config_finished => config_done_tmp, 
                  sioc => sioc,
                  siod => siod, 
                  reset => reset,
                  pwdn => PwDn, 
                  xclk => xClk);
                  
	 	   
end BEHAVIORAL;