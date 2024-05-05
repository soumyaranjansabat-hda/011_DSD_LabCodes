----------------------------------------------------------------------------------
-- Engineer(s): Max Fehn, Apratim Gupta and Vinay Madapura
-- 
-- 
-- Description: Controller for the OV7670 camera - transfers registers to the 
--              camera over an I2C like bus
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_controller is
    Port ( 	clk   : in    STD_LOGIC;			--clk driver for this module
			resend  :in    STD_LOGIC;			--Resend all register settings
			switch  :in    STD_LOGIC;			--Switch for Colour/Monochrome Mode
			config_finished : out std_logic;	--LED to show when config is finished
			sioc  : out   STD_LOGIC;			--IC2 Clock
			siod  : inout STD_LOGIC;			--IC2 Data
			reset : out   STD_LOGIC;			--Always '1' - normal mode
			pwdn  : out   STD_LOGIC;			--LED shows if it is at the power saver mode
			xclk  : out   STD_LOGIC             --Clk Driver for OV7670 camera
);
end ov7670_controller;

architecture Behavioral of ov7670_controller is
	COMPONENT ov7670_registers
		PORT(
			clk      : IN std_logic;
			advance  : IN std_logic;          				--busy ('1' when registers r sending)
			resend   : in STD_LOGIC;						--resend all registers
			switch   : in STD_LOGIC;						--Switch for Colour/Monochrome Mode
			command  : OUT std_logic_vector(15 downto 0); 	--8Bit MSB = Register address|8 LSB = Register Value
			finished : OUT std_logic						--LED to show when config is finished
			);
	END COMPONENT;
		
	COMPONENT i2c_sender_cam
		PORT(
			clk   : IN std_logic;
			send  : IN std_logic;
			taken : out std_logic;
			id    : IN std_logic_vector(7 downto 0);	--Device ID
			reg   : IN std_logic_vector(7 downto 0);	--Register Address
			value : IN std_logic_vector(7 downto 0);    --Register Value
			siod  : INOUT std_logic;      
			sioc  : OUT std_logic
			);
	END COMPONENT;

	signal sys_clk  : std_logic := '0';   
	signal command  : std_logic_vector(15 downto 0);
	signal finished : std_logic := '0';
	signal taken    : std_logic := '0';
	signal send     : std_logic;

	constant camera_address : std_logic_vector(7 downto 0) := x"42"; -- 42"; -- Device write ID - see top of page 11 of data sheet
begin
	config_finished <= finished;

	send <= not finished;						--send = '1' when sending data

	Inst_i2c_sender_cam : i2c_sender_cam PORT MAP(
		clk   => clk,
		taken => taken,
		siod  => siod,
		sioc  => sioc,
		send  => send,
		id    => camera_address,
		reg   => command(15 downto 8),
		value => command(7 downto 0)
	);

	reset <= '1';                   -- Normal mode
	pwdn  <= '0';                   -- Power device up
	xclk  <= sys_clk;
   
	Inst_ov7670_registers: ov7670_registers PORT MAP(
		clk      => clk,
		advance  => taken,
		command  => command,
		finished => finished,
		switch   => switch, 
		resend   => resend
	);

	process(clk)
	begin
		if rising_edge(clk) then
			sys_clk <= not sys_clk;
		end if;
	end process;
end Behavioral;