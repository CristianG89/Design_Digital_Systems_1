----------------------------------------------------------------------------------
-- Company    :  NTNU
-- Engineer   : Øystein Gjermundnes
-- 
-- Create Date: 09/11/2016 04:21:16 PM
-- Module Name: mega_adder_tb
-- Description:   
--   Testbench for the mega adder design
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mega_adder_tb is
--  Port ( );
end mega_adder_tb;

architecture behavioral of mega_adder_tb is

  -- Constants
  constant COUNTER_WIDTH : natural := 8;
  constant CLK_PERIOD    : time := 10 ns;
  constant RESET_TIME    : time := 10 ns;

  -- Clocks and resets 
  signal clk            : std_logic := '0';
  signal reset_n        : std_logic := '0';

  -- Data input interface           
  signal data_in_valid  : std_logic := '0';
  signal data_in_ready  : std_logic;           
  signal data_in        : std_logic_vector (31 downto 0);
           
  -- Data output interface           
  signal data_out_valid : std_logic;
  signal data_out_ready : std_logic := '1'; 
  signal data_out       : std_logic_vector (31 downto 0);

begin

  -- DUT instantiation
  dut: entity work.mega_adder 
    port map (
    
      -- Clocks and resets 
      clk            => clk, 
      reset_n        => reset_n, 
  
      -- Data input interface           
      data_in_valid  => data_in_valid, 
      data_in_ready  => data_in_ready,            
      data_in        => data_in,
             
      -- Data output interface           
      data_out_valid => data_out_valid,
      data_out_ready => data_out_ready, 
      data_out       => data_out
         
    );

  -- Clock generation
  clk <= not clk after CLK_PERIOD/2;

  -- Reset generation
  reset_proc: process
  begin  
    wait for RESET_TIME;
    reset_n <= '1';
    wait;
  end process;

  -- Stimuli generation
  stimuli_proc: process
  begin
  
    -- Send in first test vector
    wait for 10*CLK_PERIOD;
    data_in_valid <= '1';
    data_in       <= x"00000000";
    
    wait for 1*CLK_PERIOD;
    data_in       <= x"00000001";    

    wait for 1*CLK_PERIOD;
    data_in       <= x"00000002";    

    wait for 1*CLK_PERIOD;
    data_in       <= x"00000003";

    wait for 1*CLK_PERIOD;
    data_in       <= x"00000000";
    
    wait for 1*CLK_PERIOD;
    data_in       <= x"00000010";    

    wait for 1*CLK_PERIOD;
    data_in       <= x"00000020";    

    wait for 1*CLK_PERIOD;
    data_in       <= x"00000030";

    wait for 1*CLK_PERIOD;    
    data_in_valid <= '0';        
    wait for 4*CLK_PERIOD;
       
    
    -- Send in second test vector
    wait for 10*CLK_PERIOD;
    data_in_valid <= '1';
    data_in       <= x"10000000";
    
    wait for 1*CLK_PERIOD;
    data_in       <= x"10000000";    

    wait for 1*CLK_PERIOD;
    data_in       <= x"10000000";    

    wait for 1*CLK_PERIOD;
    data_in       <= x"10000000";

    wait for 1*CLK_PERIOD;
    data_in       <= x"20000000";
    
    wait for 1*CLK_PERIOD;
    data_in       <= x"20000000";    

    wait for 1*CLK_PERIOD;
    data_in       <= x"20000000";    

    wait for 1*CLK_PERIOD;
    data_in       <= x"20000000";
    
    wait for 1*CLK_PERIOD;
    data_in       <= x"00000000";    
    data_in_valid <= '0';
    
    -- Wait for results
    wait;
  end process;  


end Behavioral;
