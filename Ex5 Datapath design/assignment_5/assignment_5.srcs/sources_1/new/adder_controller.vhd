library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_controller is
  port (
    -- Clocks and resets
    clk             : in std_logic;
    reset_n         : in std_logic;

    -- Datapath control signals
    input_reg_en    : out std_logic;
    output_reg_en   : out std_logic;
    output_reg_load : out std_logic;

    -- Control signals for the input interface   
    data_in_valid   : in std_logic;
    data_in_ready   : out std_logic;
    
    -- Control signals for the output interface
    data_out_valid  : out std_logic;
    data_out_ready  : in std_logic
  );
end adder_controller;

architecture rtl of adder_controller is
  signal data_in_ready_i      : std_logic;
  signal input_reg_en_i       : std_logic;
  signal data_out_valid_i     : std_logic;
  signal output_reg_load_r    : std_logic;
  signal output_reg_shift     : std_logic;
  signal result_ready_r       : std_logic;
  signal input_shift_counter_r: unsigned(2 downto 0);	-- Until 8 (for inputs A and B)
  signal output_shift_counter_r: unsigned(1 downto 0);	-- Until 4 (for output Y)
  
begin
  -- Accept new inputs only if new outputs are accepted. 
	-- (Stall the input interface when the output interface is stalled)
  data_in_ready_i  <= data_out_ready;   
  data_in_ready    <= data_in_ready_i;
  input_reg_en_i   <= data_in_valid and data_in_ready_i;
  input_reg_en     <= input_reg_en_i;
  
  -- Increment the shift counter when a new 32-bit chunk is accepted
  process(clk, reset_n) begin
    if(reset_n='0') then
      input_shift_counter_r <= (others => '0');
    elsif(clk'event and clk='1') then
      if(input_reg_en_i = '1') then
        input_shift_counter_r <= input_shift_counter_r + 1;
      end if;
    end if;
  end process;

  -- Detect when all the operands have been shifted in and generate the signal for 
  -- loading data into the output register y    
  process(clk, reset_n) begin
    if(reset_n='0') then
      output_reg_load_r <= '0';      
    elsif(clk'event and clk='1') then
      output_reg_load_r <= '0';    
      if(input_reg_en_i = '1') then
        if(input_shift_counter_r = 7) then
          output_reg_load_r <= '1';
        end if;
      end if;
    end if;
  end process;
 
  -- Increment the output shift counter until all the data in the result has been shifted out
  process(clk, reset_n) begin
    if(reset_n='0') then
      output_shift_counter_r <= (others =>'0');
    elsif(clk'event and clk='1') then
      if(output_reg_shift = '1') then
        output_shift_counter_r <= output_shift_counter_r + 1;
      end if;
    end if;
  end process;

  -- Detect when we can start the process of shifting out data
  process(clk, reset_n) begin
    if(reset_n='0') then
      result_ready_r <= '0';
    elsif(clk'event and clk='1') then
      if(output_reg_load_r = '1') then
        result_ready_r <= '1';
      elsif(data_out_ready='1') then
        result_ready_r <= '0';      
      end if;
    end if;
  end process;
  
  -- Data is valid at the output when we are in the middle of shifting
  -- out data or when new results are ready.
  process(output_shift_counter_r, result_ready_r) begin
    if(output_shift_counter_r /= "00") or (result_ready_r ='1') then
      data_out_valid_i <= '1';		-- /= means "different from"
    else
      data_out_valid_i <= '0';
    end if;
  end process;
   
  data_out_valid   <= data_out_valid_i;
  output_reg_shift <= data_out_valid_i and data_out_ready;
  output_reg_en    <= output_reg_shift or output_reg_load_r;
  output_reg_load  <= output_reg_load_r;

end rtl;