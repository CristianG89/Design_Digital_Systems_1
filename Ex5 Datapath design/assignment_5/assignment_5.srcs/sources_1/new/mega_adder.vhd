----------------------------------------------------------------------------------
-- Description:   
--   The mega adder is a module that adds two 128-bit numbers and produces a
--   128-bit sum. The inputs to the addition are shifted in 32 bits at a time. 
--   The result is shifted out 32 bits at a time as well. 

--   A transaction of information on any of the interfaces happens when 
--   ready and valid are both high at the same time. 

--   The waveform below illustrates the process of shifting in the two operands a and b.
--            |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|
--   clk    --|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--
--
--   data_in_       |-----------------------------------------------------------
--   ready   -------|                                                        
-- 
--   data_in_ |-----------------------------------------------------|
--   valid   -|                                                     |-----------
--
--            |-----------|-----|-----|-----|-----|-----|-----|-----|
--   data_in -|    a0     |  a1 |  a2 |  a3 |  b0 |  b1 |  b2 |  b3 |----------- 
--            |-----------|-----|-----|-----|-----|-----|-----|-----|
--
--   The waveform below illustrates the process of shifting out the result y of the addition
--            |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|
--   clk    --|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |--
--
--   data_out       |-----------------------------------------------------------
--   ready   -------|                                                        
-- 
--   data_out |-----------------------------|
--   valid   -|                             |-----------------------------------
--
--            |-----------|-----|-----|-----|
--   data_out-|    y0     |  y1 |  y2 |  y3 |----------------------------------- 
--            |-----------|-----|-----|-----|
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mega_adder is
  port (
    -- Clocks and resets 
    clk            : in  std_logic;
    reset_n        : in  std_logic;

    -- Data input interface           
    data_in_valid  : in  std_logic;
    data_in_ready  : out std_logic;           
    data_in        : in  std_logic_vector (31 downto 0);
           
    -- Data output interface           
    data_out_valid : out std_logic;
    data_out_ready : in  std_logic; 
    data_out       : out std_logic_vector (31 downto 0)
);
end mega_adder;

architecture rtl of mega_adder is
  signal input_reg_en    : std_logic;
  signal output_reg_en   : std_logic;
  signal output_reg_load : std_logic;

begin
  -- Instantiate the datapath
  u_adder_datapath : entity work.adder_datapath port map(
    -- Clocks and resets
    clk             => clk,
    reset_n         => reset_n,
  
    -- Data in interface       
    data_in         => data_in,
    input_reg_en    => input_reg_en,
  
    -- Data out interface
    data_out        => data_out,
    output_reg_en   => output_reg_en,
    output_reg_load => output_reg_load  
  );

  -- Instantiate the controller
  u_adder_controller : entity work.adder_controller port map(
    -- Clocks and resets
    clk             => clk,
    reset_n         => reset_n,
    
    data_in_valid   => data_in_valid,
    data_in_ready   => data_in_ready,
    input_reg_en    => input_reg_en,
    
    data_out_valid  => data_out_valid,
    data_out_ready  => data_out_ready,
    output_reg_en   => output_reg_en,
    output_reg_load => output_reg_load   
  );
end rtl;