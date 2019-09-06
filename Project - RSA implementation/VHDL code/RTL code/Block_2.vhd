library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;   -- For function "To_b2_integer"

entity Block_2 is
	generic (
		C_BLOCK_SIZE: integer := 32		-- Number of bits of the incoming message
	);
    port (
        i_b2_clk:   in std_logic;
        i_b2_reset: in std_logic;
		i_b2_en: 	in std_logic;
		i_b2_charge:in std_logic;
        i_b2_M:   	in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
        i_b2_E:   	in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
		i_b2_P:   	in std_logic_vector((C_BLOCK_SIZE-1) downto 0);	-- Feedback from Block 3
		i_b2_C:   	in std_logic_vector((C_BLOCK_SIZE-1) downto 0);	-- Feedback from Block 3
		o_b2_P:   	out std_logic_vector((C_BLOCK_SIZE-1) downto 0);
		o_b2_C:   	out std_logic_vector((C_BLOCK_SIZE-1) downto 0);
		o_b2_wait:  out std_logic;
		o_b2_up_CP: out std_logic;
		o_b2_done:  out std_logic
    );
end Block_2;

architecture Behavioral of Block_2 is	
    signal s_init_C:	std_logic;
	signal s_b2_Co:		std_logic_vector ((C_BLOCK_SIZE-1) downto 0);
    signal s_b2_P:		std_logic_vector ((C_BLOCK_SIZE-1) downto 0);
	signal s_b2_wait:	std_logic;
	signal s_b2_up_CP:	std_logic;
	signal s_b2_E:		std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal s_b2_done:	std_logic;
    signal s_b2_index:	integer range 0 to C_BLOCK_SIZE;
	signal s_b2_pointer:std_logic;
	signal s_finish:	std_logic;
begin
    process (i_b2_clk, i_b2_reset) is
	variable v_b2_pointer: std_logic;
	variable v_finish: std_logic;
    begin
        if (i_b2_reset = '0') then
			s_init_C <= '0';
            s_b2_Co <= (others => '0');
            s_b2_P <= (others => '0');
			s_b2_E <= (others => '0');
            v_b2_pointer := '0';
			s_b2_pointer <= '0';
			s_b2_wait <= '0';
			s_b2_up_CP <= '0';
			s_b2_done <= '0';
			s_b2_index <= 0;
			s_finish <= '0';
			v_finish := '0';
		elsif (rising_edge(i_b2_clk)) then
			if (i_b2_en = '1') then
				if (i_b2_charge = '1') then
					s_init_C <= '0';
					s_b2_Co <= (others => '0');
					s_b2_Co(0) <= '1';	-- Initial value must be 1
					s_b2_P <= i_b2_M;
					s_b2_E <= i_b2_E;
					v_b2_pointer := '0';
					s_b2_pointer <= '0';
					s_b2_wait <= '0';
					s_b2_up_CP <= '0';
					s_b2_done <= '0';
					s_b2_index <= 0;
					s_finish <= '0';
					v_finish := '0';
				elsif (s_b2_wait = '0') then
					if (s_b2_index <= (C_BLOCK_SIZE-1)) then
						v_b2_pointer := s_b2_E(s_b2_index);	-- This algorithm checks the vector E from Right to Left!
						s_b2_pointer <= v_b2_pointer;
						if (s_b2_index /= 0) then	-- The new values from Block 3 must not be loaded in the iteration 0
							if (v_b2_pointer = '1') then	-- C (and its notification) is only updated when E(i) is 1
								if (s_init_C = '1') then
									s_b2_Co <= i_b2_C;
								end if;
								s_b2_up_CP <= '1';
								s_init_C <= '1';	-- Only after a new C is processed in Block 3 with Co = 1, Co will be updated
							end if;
							s_b2_P <= i_b2_P;
						else
							if (v_b2_pointer = '1') then
								s_b2_up_CP <= '1';	-- C's notification must be checked at i = 0, just to update it in the next attempt (if necessary)
								s_init_C <= '1';
							end if;
						end if;
						
						s_b2_wait <= '1';
						s_b2_index <= s_b2_index + 1;
						
						v_finish := '0';		-- Every time the new values are loaded, the rest of E is checked
						for i in 0 to (C_BLOCK_SIZE-1) loop
							if (i >= (s_b2_index+1)) then
								v_finish := v_finish or s_b2_E(i);
							end if;
						end loop;
						s_finish <= v_finish;
						if (v_finish = '0') then			-- If there are no more 1s in the next positions, it has no sense to continue
							s_b2_index <= C_BLOCK_SIZE;		-- Because we know that the output will not change
						end if;
					else
						s_init_C <= '0';
						s_b2_wait <= '0';
						s_b2_up_CP <= '0';
						s_b2_Co <= i_b2_C;	-- The output is updated here just in the very last iteration
						s_b2_done <= '1';
					end if;					
				end if;
			else
				v_b2_pointer := '0';	-- Initialization for starting the next iteration (once blocks 3 finishes)
				s_b2_pointer <= '0';
				s_b2_wait <= '0';
				s_b2_up_CP <= '0';
				s_b2_done <= '0';
			end if;
		end if;
    end process;
	
    o_b2_P <= s_b2_P;
	o_b2_C <= s_b2_Co;
	o_b2_wait <= s_b2_wait;
	o_b2_up_CP <= s_b2_up_CP;
	o_b2_done <= s_b2_done;
	
end Behavioral;