library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;   -- For function "To_integer"

entity rsa_core is
	generic (
		C_BLOCK_SIZE: integer := 32		-- Number of bits of the incoming message
	);
    port (
        clk:			in std_logic;
        reset_n:		in std_logic;
		
		msgin_valid:	in std_logic; 
		msgin_ready:	out std_logic;
		msgin_data:		in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
		msgin_last:		in std_logic;
		
		msgout_valid:	out std_logic;
		msgout_ready:	in std_logic;
		msgout_data:	out std_logic_vector((C_BLOCK_SIZE-1) downto 0);
		msgout_last:	out std_logic;

		key_e_d:		in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
		key_n:			in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
		rsa_status:		out std_logic_vector(31 downto 0)
    );
end rsa_core;

architecture Behavioral of rsa_core is
    component Datapath is
		port (
			i_data_clk:			in std_logic;
			i_data_rst:			in std_logic;
			i_data_M:			in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
			i_data_E:			in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
			i_data_N:			in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
			o_data_C:			out std_logic_vector((C_BLOCK_SIZE-1) downto 0);
			
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
	end component Datapath;
	
	component Controller is
		port (
			i_FSM_clk:		in std_logic;
			i_FSM_reset:	in std_logic;
			
			msgin_valid:	in std_logic;
			msgin_ready:	out std_logic;
			msgin_last:		in std_logic;
			
			msgout_valid:	out std_logic;
			msgout_ready:	in std_logic;
			msgout_last:	out std_logic;
			
			i_b2_wait:		in std_logic;
			i_b2_up_CP:		in std_logic;
			i_b2_done:		in std_logic;
			o_b2_charge:	out std_logic;
			o_b2_en:		out std_logic;
			
			i_b31_done:		in std_logic;
			i_b32_done:		in std_logic;
			o_b31_en:		out std_logic;
			o_b32_en:		out std_logic;
			
			o_fsm_state:	out std_logic_vector(31 downto 0)
		);
    end component Controller; 
	
	signal s_b2_en: std_logic;
	signal s_b31_en: std_logic;
	signal s_b32_en: std_logic;
	signal s_b2_charge: std_logic;
	signal s_b2_wait: std_logic;
	signal s_b2_up_CP: std_logic;
	signal s_b2_done: std_logic;
	signal s_b31_done: std_logic;
	signal s_b32_done: std_logic;
	
begin
    DP: Datapath port map (		-- Datapath for doing all necessary calculations
		i_data_clk => clk,
		i_data_rst => reset_n,
		i_data_M => msgin_data,
		i_data_E => key_e_d,
		i_data_N => key_n,
		o_data_C => msgout_data,

		i_data_b2_en => s_b2_en,
		i_data_b2_charge => s_b2_charge,
		o_data_b2_wait => s_b2_wait,
		o_data_b2_up_CP => s_b2_up_CP,
		o_data_b2_done => s_b2_done,

		i_data_b31_en => s_b31_en,
		i_data_b32_en => s_b32_en,
		o_data_b31_done => s_b31_done,
		o_data_b32_done => s_b32_done
	);
    FSM: Controller port map (	-- Controller that manages the datapath
		i_FSM_clk => clk,
        i_FSM_reset => reset_n,
		
		msgin_valid => msgin_valid,
		msgin_ready => msgin_ready,
		msgin_last => msgin_last,
		
		msgout_valid => msgout_valid,
		msgout_ready => msgout_ready,
		msgout_last => msgout_last,
		
		i_b2_wait => s_b2_wait,
		i_b2_up_CP => s_b2_up_CP,
		i_b2_done => s_b2_done,
		o_b2_charge => s_b2_charge,
		o_b2_en => s_b2_en,
		
		i_b31_done => s_b31_done,
		i_b32_done => s_b32_done,
        o_b31_en => s_b31_en,
        o_b32_en => s_b32_en,
		o_fsm_state => rsa_status
	);
	
end Behavioral;