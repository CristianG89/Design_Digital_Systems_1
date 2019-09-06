----------------------------------------------------------------------------------
-- Description:   
--   Datapath for the mega_adder. The datapath consists of shift registers
--   at the inputs and outputs and a large 128 bit adder.
--
--   CHALLENGE 1:
--   Set different synthesis constraints for the max frequency and check how the
--   area of the design changes.
--  
--   CHALLENGE 2: 
--   Can you think of a way to significantly increase the max clock frequency 
--   as well as reducing the area?
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_datapath is
  port (      
    -- Clocks and resets
    clk             : in std_logic;
    reset_n         : in std_logic;
    
    -- Data in interface       
    data_in         : in std_logic_vector (31 downto 0);
    input_reg_en    : in std_logic;
    
    -- Data out interface
    data_out        : out std_logic_vector (31 downto 0);
    output_reg_en   : in std_logic;
    output_reg_load : in std_logic);
end adder_datapath;

architecture rtl of adder_datapath is
  -- Signals associated with the input registers
  signal a_r, a_nxt: std_logic_vector(127 downto 0);
  signal b_r, b_nxt: std_logic_vector(127 downto 0);
  
  -- Signals associated with the output registers
  signal y_r, y_nxt: std_logic_vector(127 downto 0);
    
begin
  process (clk, reset_n) begin
    if(reset_n = '0') then
      a_r <= (others => '0');
      b_r <= (others => '0');      
    elsif(clk'event and clk='1') then
      if(input_reg_en ='1') then
        a_r <= a_nxt;
        b_r <= b_nxt;        
      end if;
    end if;
  end process;

  process (data_in, a_r, b_r) begin		-- New data is stored from MSBs to LSBs,
    a_nxt <= data_in & a_r(127 downto 32);	 -- filling both A and B at a time
    b_nxt <= a_r(31 downto 0) & b_r(127 downto 32);
  end process;

  process (clk, reset_n) begin
    if(reset_n = '0') then
      y_r <= (others => '0');     
    elsif(clk'event and clk='1') then
      if(output_reg_en ='1') then
        y_r <= y_nxt;       
      end if;
    end if;
  end process;

  process (y_r, a_r, b_r, output_reg_load) begin
    if(output_reg_load = '1') then	-- Complete sum done only when I have the order
      -- y_nxt <= std_logic_vector(unsigned(a_r) + unsigned(b_r));
      y_nxt(127 downto 96)<= std_logic_vector(unsigned(a_r(127 downto 96)) + unsigned(b_r(127 downto 96)));
	  y_nxt(95 downto 64) <= std_logic_vector(unsigned(a_r(95 downto 64)) + unsigned(b_r(95 downto 64)));
	  y_nxt(63 downto 32) <= std_logic_vector(unsigned(a_r(63 downto 32)) + unsigned(b_r(63 downto 32)));
	  y_nxt(31 downto 0)  <= std_logic_vector(unsigned(a_r(31 downto 0)) + unsigned(b_r(31 downto 0)));
    else				-- Otherwise last chunk is set to 0
      y_nxt <= x"00000000" & y_r(127 downto 32);
    end if;
  end process;
  
  data_out <= y_r(31 downto 0);

end rtl;