library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;   -- For function "To_integer"

entity Datapath is
	generic (
		C_BLOCK_SIZE: integer := 32		-- Number of bits of the incoming message
	);
    port (
        i_data_clk:			in std_logic;
        i_data_rst:			in std_logic;
		i_data_M:			in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		i_data_E:			in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		i_data_N:			in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		o_data_C:			out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		
		i_data_b2_en: 		in std_logic;
		i_data_b2_charge:	in std_logic;
		o_data_b2_wait:  	out std_logic;
		o_data_b2_up_CP: 	out std_logic;
		o_data_b2_done:  	out std_logic;

		i_data_b31_en: 		in std_logic;
		i_data_b32_en: 		in std_logic;
		o_data_b31_done:	out std_logic;
		o_data_b32_done:	out std_logic
    );
end Datapath;

architecture Behavioral of Datapath is
    component Block_2 is
		port (
			i_b2_clk:   in std_logic;
			i_b2_reset: in std_logic;
			i_b2_en: 	in std_logic;
			i_b2_charge:in std_logic;
			i_b2_M:   	in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
			i_b2_E:   	in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
			i_b2_P:   	in std_logic_vector(C_BLOCK_SIZE-1 downto 0);	-- Feedback from Block 3
			i_b2_C:   	in std_logic_vector(C_BLOCK_SIZE-1 downto 0);	-- Feedback from Block 3
			o_b2_P:   	out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
			o_b2_C:   	out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
			o_b2_wait:  out std_logic;
			o_b2_up_CP: out std_logic;
			o_b2_done:  out std_logic
		);
    end component Block_2;
	
	component Block_3 is
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
    end component Block_3;
	
	signal s_A: std_logic_vector (C_BLOCK_SIZE-1 downto 0);
	signal s_B: std_logic_vector (C_BLOCK_SIZE-1 downto 0);
	signal s_P: std_logic_vector (C_BLOCK_SIZE-1 downto 0);
	signal s_C: std_logic_vector (C_BLOCK_SIZE-1 downto 0);
	
begin
	b1: Block_2 port map (		-- Main block (for loop)
		i_b2_clk => i_data_clk,
		i_b2_reset => i_data_rst,
		i_b2_en => i_data_b2_en,
		i_b2_charge => i_data_b2_charge,
		i_b2_M => i_data_M,
		i_b2_E => i_data_E,
		i_b2_P => s_P,
		i_b2_C => s_C,
		o_b2_P => s_B,
		o_b2_C => s_A,
		o_b2_wait => o_data_b2_wait,
		o_b2_up_CP => o_data_b2_up_CP,
		o_b2_done => o_data_b2_done
	);
    b2: Block_3 port map (		-- Secondary block (for loop), in parallel with the other block 3
		i_b3_clk => i_data_clk,
		i_b3_reset => i_data_rst,
		i_b3_en => i_data_b31_en,
		i_b3_A => s_A,		-- C = C * P mod N
		i_b3_B => s_B,
		i_b3_N => i_data_N,
		o_b3_C => s_C,
		o_b3_done => o_data_b31_done
	);
    b3: Block_3 port map (		-- Secondary block (for loop), in parallel with the other block 3
		i_b3_clk => i_data_clk,
		i_b3_reset => i_data_rst,
		i_b3_en => i_data_b32_en,
		i_b3_A => s_B,			-- P = P * P mod N
		i_b3_B => s_B,
		i_b3_N => i_data_N,
		o_b3_C => s_P,
		o_b3_done => o_data_b32_done
	);
	o_data_C <= s_A;
	
end Behavioral;