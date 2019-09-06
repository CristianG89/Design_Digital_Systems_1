library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;   -- For function "To_integer"

entity Block_3 is
	generic (
		C_BLOCK_SIZE: integer := 32		-- Number of bits of the incoming message
	);
    port (
        i_b3_clk:   in std_logic;
        i_b3_reset: in std_logic;
		i_b3_en: 	in std_logic;
        i_b3_A:   	in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
        i_b3_B:   	in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
        i_b3_N:   	in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
        o_b3_C:   	out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		o_b3_done:	out std_logic
    );
end Block_3;

architecture Behavioral of Block_3 is
    signal s_b3_C:     std_logic_vector (C_BLOCK_SIZE-1 downto 0);
	signal s_b3_done:  std_logic;
	signal s_b3_index: integer range 0 to C_BLOCK_SIZE;
begin
    process (i_b3_clk, i_b3_reset) is
    variable v_b3_C: std_logic_vector ((C_BLOCK_SIZE+2) downto 0);	-- Extra length to ensure the multiplication is used for will fit
	variable v_b3_pointer: std_logic;	-- Elements updated and then checked in the same process MUST be variable, not signal,
	variable v_start: std_logic;		-- because signals are just updated once the process finishes!!!!!
    begin
        if (i_b3_reset = '0') then
            s_b3_C <= (others => '0');
            v_b3_C := (others => '0');
			v_b3_pointer := '0';
			s_b3_done <= '0';
			s_b3_index <= 0;
			v_start := '0';
        elsif (rising_edge(i_b3_clk)) then
			if (i_b3_en = '1') then
				if (s_b3_index <= (C_BLOCK_SIZE-1)) then
					if ((s_b3_index = 0) and (i_b3_B(C_BLOCK_SIZE-1) = '0')) then	-- Only the first time (and if first bit to check is 0)
						v_start := '0';
						for k in 0 to (C_BLOCK_SIZE-1) loop
							v_start := v_start or i_b3_B((C_BLOCK_SIZE-1)-k);	-- Multiplication algorithm is done from Left to Right!
							if (v_start = '1') then
								s_b3_index <= k;
								exit;	-- It leaves the for loop
							end if;
						end loop;
					else
						v_b3_pointer := i_b3_B((C_BLOCK_SIZE-1)-s_b3_index);	-- Multiplication algorithm is done from Left to Right!
						if (v_b3_pointer = '1') then
							v_b3_C := std_logic_vector(shift_left(unsigned(v_b3_C), 1) + unsigned(i_b3_A));
						else
							v_b3_C := std_logic_vector(shift_left(unsigned(v_b3_C), 1));
						end if;
						if (v_b3_C > i_b3_N) then			-- Up to 2 subtracts, if the number is big enough
							v_b3_C := v_b3_C - i_b3_N;
						end if;
						if (v_b3_C > i_b3_N) then	-- If a value must be updated and checked in the same process, it must be a variable!
							v_b3_C := v_b3_C - i_b3_N;
						end if;
						s_b3_C <= v_b3_C ((C_BLOCK_SIZE-1) downto 0);		-- Output is updated continuously
						s_b3_index <= s_b3_index + 1;
					end if;
				else
					s_b3_C <= v_b3_C ((C_BLOCK_SIZE-1) downto 0);
					s_b3_done <= '1';
				end if;
			else
				v_b3_pointer := '0';		-- Data to restart once the block is disabled
				v_b3_C := (others => '0');	-- This variable must restart every time the block restarts to ensure the MSB 0s are ignored
				s_b3_done <= '0';
				s_b3_index <= 0;
			end if;
		end if;		
    end process;
	
    o_b3_C <= s_b3_C;
	o_b3_done <= s_b3_done;
	
end Behavioral;