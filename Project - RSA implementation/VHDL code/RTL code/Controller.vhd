library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;   -- For function "To_integer"

entity Controller is	-- FSM that manages the rest of the blocks
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
end Controller;

architecture Behavioral of Controller is
    type STATES is (IDLE, CHARGE_VALUES, WORK_B2, WORK_B32, WORK_BOTH_B3, FINISHED);
    signal state_next, state_reg: STATES;
    signal s_b2_charge_next, s_b2_charge_reg: std_logic;
    signal s_b2_en_next, s_b2_en_reg: std_logic;
	signal s_b31_en_next, s_b31_en_reg: std_logic;
	signal s_b32_en_next, s_b32_en_reg: std_logic;

	signal msgin_ready_next, msgin_ready_reg: std_logic;
	signal msgout_valid_next, msgout_valid_reg: std_logic;
	signal msgout_last_next, msgout_last_reg: std_logic;
	
	signal s_fsm_state_next, s_fsm_state_reg: std_logic_vector (31 downto 0);

	signal s_msg_last_next, s_msg_last_reg: std_logic;
	signal s_msg_accept: std_logic;
	
begin
    -- FSM: state and data registers
    process (i_FSM_clk, i_FSM_reset)
    begin
        if (i_FSM_reset = '0') then
			state_reg <= IDLE;
			msgin_ready_reg <= '0';
			msgout_valid_reg <= '0';
			msgout_last_reg <= '0';
			s_msg_last_reg <= '0';
			s_fsm_state_reg <= (others => '0');
			s_b2_charge_reg <= '0';
			s_b2_en_reg <= '0';
			s_b31_en_reg <= '0';
			s_b32_en_reg <= '0';
        elsif (rising_edge(i_FSM_clk)) then
            state_reg <= state_next;
			msgin_ready_reg <= msgin_ready_next;
			msgout_valid_reg <= msgout_valid_next;
			msgout_last_reg <= msgout_last_next;
			if ((state_reg = IDLE) or (state_reg = CHARGE_VALUES)) then
				s_msg_last_reg <= s_msg_last_next;
			end if;
			s_fsm_state_reg <= s_fsm_state_next;
			s_b2_charge_reg <= s_b2_charge_next;
			s_b2_en_reg <= s_b2_en_next;
			s_b31_en_reg <= s_b31_en_next;
			s_b32_en_reg <= s_b32_en_next;
        end if;
    end process;

    -- Control flow 
    process (msgin_valid, i_b2_wait, i_b2_done, i_b2_up_CP, i_b31_done, i_b32_done, state_reg, msgin_last, msgin_ready_reg, msgout_ready,
			msgout_valid_reg, msgout_last_reg, s_msg_last_reg, s_fsm_state_reg, s_b2_charge_reg, s_b2_en_reg, s_b31_en_reg, s_b32_en_reg, s_msg_accept)
    begin
        state_next <= state_reg;		-- NOTE: Here XX_reg cannot be updated. Otherwise there will be an error!
		msgin_ready_next <= '0';
		msgout_valid_next <= '0';
		msgout_last_next <= '0';
		s_msg_last_next <= '0';
		s_fsm_state_next <= (others => '0');
		s_b2_charge_next <= '0';
        s_b2_en_next <= '0';
		s_b31_en_next <= '0';
		s_b32_en_next <= '0';
		
        case state_reg is
            when IDLE =>
				s_fsm_state_next <= (others => '0');
				msgin_ready_next <= '0';
				msgout_valid_next <= '0';
				msgout_last_next <= '0';
				s_msg_last_next <= '0';
				s_b2_charge_next <= '0';
				s_b2_en_next <= '0';
				s_b31_en_next <= '0';
				s_b32_en_next <= '0';
				if (msgin_valid = '1') then
					state_next <= CHARGE_VALUES;
				end if;
			when CHARGE_VALUES =>
				s_fsm_state_next(2 downto 0) <= "001";
				msgin_ready_next <= '1';
				s_msg_last_next <= msgin_last;
				s_b2_charge_next <= '1';
				s_b2_en_next <= '1';
				if (i_b2_wait = '0') then
					state_next <= WORK_B2;
				end if;
            when WORK_B2 =>
				s_fsm_state_next(2 downto 0) <= "010";
				msgin_ready_next <= '0';
				s_b2_charge_next <= '0';
				s_b2_en_next <= '1';
				s_b31_en_next <= '0';
				s_b32_en_next <= '0';
				if (i_b2_done = '1') then
					state_next <= FINISHED;
				elsif (i_b2_wait = '1') then
					if (i_b2_up_CP = '1') then
						state_next <= WORK_BOTH_B3;
					else
						state_next <= WORK_B32;
					end if;
				end if;
			when WORK_B32 =>
				s_fsm_state_next(2 downto 0) <= "011";
				s_b2_en_next <= '0';
				s_b31_en_next <= '0';
				s_b32_en_next <= '1';
				if (i_b32_done = '1') then
					state_next <= WORK_B2;
				end if;
			when WORK_BOTH_B3 =>
				s_fsm_state_next(2 downto 0) <= "100";
				s_b2_en_next <= '0';
				s_b31_en_next <= '1';
				s_b32_en_next <= '1';
				if ((i_b31_done = '1') and (i_b32_done = '1')) then
					state_next <= WORK_B2;
				end if;
			when FINISHED =>
				s_fsm_state_next(2 downto 0) <= "101";
				msgout_valid_next <= '1';
				msgout_last_next <= s_msg_last_reg;
				s_b2_en_next <= '0';
				s_b31_en_next <= '0';
				s_b32_en_next <= '0';
				if (s_msg_accept = '1') then
				    msgout_valid_next <= '0';
					state_next <= IDLE;
				end if;
        end case;
    end process;

    s_msg_accept <= msgout_ready and msgout_valid_reg; 
	
    msgin_ready <= msgin_ready_reg;
	msgout_valid <= msgout_valid_reg;
	msgout_last <= msgout_last_reg;
	o_b2_charge <= s_b2_charge_reg;
	o_b2_en <= s_b2_en_reg;
	o_b31_en <= s_b31_en_reg;
	o_b32_en <= s_b32_en_reg;
	o_fsm_state <= s_fsm_state_reg;
	
end Behavioral;