---------------------------------------------------------------------------
-- I2C sender - This file is responsible for configuring the ADV7511 
-- HDMI Tx chip
-- Engineers: Melvin Roopith Jayakumar, Gopi Kovi   
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_sender is
    Port ( clk    : in    STD_LOGIC;   		-- 50 MHz 
           resend : in    STD_LOGIC;  		-- Reset the ADV7511 registers and run the setting again
           sioc_hdmi   : out   STD_LOGIC;
           siod_hdmi   : inout STD_LOGIC;  	-- can read from/ write to the registers
		   i2c_finished : out STD_LOGIC		-- Register cconfigure finish signal
    );
end i2c_sender;

architecture Behavioral of i2c_sender is
   -- for assigning on and off width to I2C clock pulse
   signal   divider           : unsigned(7 downto 0)  := (others => '0'); 
  
   -- this value gives nearly 200ms cycles before the first register is written
   signal   initial_pause     : unsigned(23 downto 0) := (others => '0');
   
   -- configuration completion status flag
   signal   finished          : std_logic := '0';
   
   -- can accommodate 128 different values
   signal   address           : std_logic_vector(7 downto 0)  := (others => '0');
   
   signal   clk_first_quarter : std_logic_vector(28 downto 0) := (others => '1');
   signal   clk_last_quarter  : std_logic_vector(28 downto 0) := (others => '1');
   
   -- keeps the constraint of I2C clock period less than 400KHz
   signal   busy_sr           : std_logic_vector(28 downto 0) := (others => '1');
   
   signal   data_sr           : std_logic_vector(28 downto 0) := (others => '1');
   signal   tristate_sr       : std_logic_vector(28 downto 0) := (others => '0');
   signal   reg_value         : std_logic_vector(15 downto 0)  := (others => '0');
   constant i2c_wr_addr       : std_logic_vector(7 downto 0)  := x"72";

   type reg_value_pair is ARRAY(0 TO 63) OF std_logic_vector(15 DOWNTO 0);    
	-- 2D array of 64 Elements 
	-- Each 16 bits wide
   
   signal reg_value_pairs : reg_value_pair := (
            -------------------
            -- Power up !
            -------------------
            x"4110",    -- old has 0x4110 too. Analog Devices says 0x41[6] = 0   
			            -- both pin and register have to be inactive for power up 
          
		   ---------------------------------------
            -- These values must be set as follows
            ---------------------------------------
			x"9803",    -- double checked with Analog Devices
			x"9AE0",    -- 1110 000* as per spec. As well as Analog Devices ppt. 
			x"9C30",    -- double checked with Analog Devices
			x"9D61",    -- **** **01 as per spec. As well as Analog Devices ppt.
			            -- **** 00** for No clock divide
					    	-- 0110 **** Fixed. As per spec.
			x"A2A4",    -- double checked with Analog Devices
			x"A3A4",    -- double checked with Analog Devices
			x"E0D0",    -- double checked with Analog Devices
			x"F900",    -- double checked with Analog Devices
			
			x"5522", --AVI, 0010 0010 --
            
            ---------------
            -- Input mode
            ---------------
			x"4808", -- Right justified data
			x"1511", -- 0001 0001 Don't use audio; YCbCr=422 
			x"16BD", -- 1011 1101
			x"1700", -- 00000000  4:3 input video aspect ratio.
			
			-- AVI Frame
 			--x"3BC0",--80",--pixel repetition for x3 "110"0 0"00 0" 4th and 3rd bit for PLL multiplication
			--x"3C01",--User programmed VIC to sent to Rx--00100010 1080p 30 16:9
			--x"3D01",--VIC sent to HDMI Rx and Used in the AVI InfoFrame Status 10100010 1080p 30 16:9
			--x"3E04",--Input VIC Detected(640*480 and 4:3) 00000100
			--x"562A",--6A", -- 10101010- AVI info frame Aspect ratio and video colorimetry
 			
			--x"18C6",---csc disabled 1000110
			
			
            ---------------
            -- Output mode
            ---------------	
            x"AF06", -- HDMI or DVI mode 0000 0110 
		    
		            
			-- Extra space filled with FFFFs to signify end of data
            
            x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
            x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
            
            x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
            x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
            x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",
            x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF",x"FFFF", x"FFFF", x"FFFF",
            x"FFFF", x"FFFF", x"FFFF", x"FFFF", x"FFFF"
   );

begin

---------------------------------------------------------------------------
-- for address selection from the array  
---------------------------------------------------------------------------
registers: process(clk)
   begin
      if rising_edge(clk) then
         reg_value <= reg_value_pairs(to_integer(unsigned(address)));
		 -- reg_value gets the LSB of one of the register values
      end if;
   end process;

---------------------------------------------------------------------------
-- for sending serial data   
---------------------------------------------------------------------------
i2c_tristate: process(data_sr, tristate_sr)
   begin
      if tristate_sr(tristate_sr'length-1) = '0' then
         siod_hdmi <= data_sr(data_sr'length-1);
      else
         siod_hdmi <= 'Z';
		 -- acknowledgement -- pulled to 0 if successful
      end if;
   end process;
   
   -- divider (7 downto 6)	
   -- 128 pulses of divide correspond to 1 sioc clock pulse
   with divider(divider'length-1 downto divider'length-2) 
      select sioc_hdmi <= clk_first_quarter(clk_first_quarter'length -1) when "00",
                     clk_last_quarter(clk_last_quarter'length -1)   when "11",
                     '1' when others;

------------------------------------------------------------------------------
--- for I2C clock
------------------------------------------------------------------------------                      
i2c_send:   process(clk)
   begin
      if rising_edge(clk) then
         if resend = '1' then 
            address           <= (others => '0');
            clk_first_quarter <= (others => '1');
            clk_last_quarter  <= (others => '1');
            busy_sr           <= (others => '0');
            divider           <= (others => '0');
            initial_pause     <= (others => '0');
            finished <= '0';
         end if;

		 -- if busy_sr is "0 xxxx xxxx xxxx xxxx xxxx xxxx xxxx" 
		 -- basically this slows down the clock to I2C standards to keep it
		 -- less than 400kbps
         if busy_sr(busy_sr'length-1) = '0' then
			
			-- count till MSB becomes 1 for initial 200ms pause
            if initial_pause(initial_pause'length-1) = '0' then
               initial_pause <= initial_pause+1;
            
			elsif finished = '0' then
			
			   -- Equivalent to one pulse every 127 clock ticks of the slowed down clock
               if divider = "11111111" then 
                  divider <= (others =>'0');
                  
				  -- logic to feed new values every 127 ticks in the slowed down clock domain
				  if reg_value(15 downto 8) = "11111111" then
                     finished <= '1';
                  else
                     -- move the new data into the shift registers
                     clk_first_quarter <= (others => '0'); clk_first_quarter(clk_first_quarter'length-1) <= '1';
                     clk_last_quarter <= (others => '0');  clk_last_quarter(0) <= '1';
                     
                     --             Start    Address        Ack        Register           Ack          Value         Ack    Stop
                     tristate_sr <= "0" & "00000000"  & "1" & "00000000"             & "1" & "00000000"             & "1"  & "0";
                     data_sr     <= "0" & i2c_wr_addr & "1" & reg_value(15 downto 8) & "1" & reg_value( 7 downto 0) & "1"  & "0";
                     busy_sr     <= (others => '1');
                     address     <= std_logic_vector(unsigned(address)+1);
                  end if;
               else
                  divider <= divider+1; 
               end if;
            end if;
         
		 -- if busy_sr is "1 xxxx xxxx xxxx xxxx xxxx xxxx xxxx"
		 else
           if divider = "11111111" then   -- divide clkin by 255 for I2C
               
			    -- Shifting of registers
			   tristate_sr       <= tristate_sr(tristate_sr'length-2 downto 0) & '0';
               busy_sr           <= busy_sr(busy_sr'length-2 downto 0) & '0';
               data_sr           <= data_sr(data_sr'length-2 downto 0) & '1';
               clk_first_quarter <= clk_first_quarter(clk_first_quarter'length-2 downto 0) & '1';
               clk_last_quarter  <= clk_last_quarter(clk_first_quarter'length-2 downto 0) & '1';
               divider           <= (others => '0');
            else
               divider <= divider+1;
            end if;
         end if;
      end if;
   end process;
   
---------------------------------------------------------------------------
-- for registering the finish signal   
---------------------------------------------------------------------------   
i2c_finished_prc: process(clk)
begin
      if rising_edge(clk) then
	i2c_finished <= finished;
	end if;
	end process;
		
end Behavioral;