library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_Controller is
end tb_Controller;

architecture Behavioral of tb_Controller is
    component Controller
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
    end component;
	
	signal tb_FSM_clk:		std_logic;
	signal tb_FSM_reset:	std_logic;
	
	signal tb_msgin_valid:	std_logic;
	signal tb_msgin_ready:	std_logic;
	signal tb_msgin_last:	std_logic;
	
	signal tb_msgout_valid:	std_logic;
	signal tb_msgout_ready:	std_logic;
	signal tb_msgout_last:	std_logic;
	
	signal tb_b2_wait:		std_logic;
	signal tb_b2_up_CP:		std_logic;
	signal tb_b2_done:		std_logic;
	signal tb_b2_charge:	std_logic;
	signal tb_b2_en:		std_logic;
	
	signal tb_b31_done:		std_logic;
	signal tb_b32_done:		std_logic;
	signal tb_b31_en:		std_logic;
	signal tb_b32_en:		std_logic;
	
	signal tb_fsm_state:	std_logic_vector(31 downto 0);
	
begin
    uut: Controller port map (		
		i_FSM_clk => tb_FSM_clk,
		i_FSM_reset => tb_FSM_reset,
		
		msgin_valid => tb_msgin_valid,
		msgin_ready => tb_msgin_ready,
		msgin_last => tb_msgin_last,
		
		msgout_valid => tb_msgout_valid,
		msgout_ready => tb_msgout_ready,
		msgout_last => tb_msgout_last,
		
		i_b2_wait => tb_b2_wait,
		i_b2_up_CP => tb_b2_up_CP,
		i_b2_done => tb_b2_done,
		o_b2_charge => tb_b2_charge,
		o_b2_en => tb_b2_en,
		
		i_b31_done => tb_b31_done,
		i_b32_done => tb_b32_done,
		o_b31_en => tb_b31_en,
		o_b32_en => tb_b32_en,
		
		o_fsm_state => tb_fsm_state
    );
    
    tb0 : process
    begin
        tb_FSM_clk <= '1'; wait for 2 ns;
        tb_FSM_clk <= '0'; wait for 2 ns;
    end process;
    
    tb1 : process
    begin
		tb_msgin_valid <= '0';
		tb_msgin_last <= '0';
		tb_msgout_ready <= '0';
		tb_b2_wait <= '0';
		tb_b2_up_CP <= '0';
		tb_b2_done <= '0';	
		tb_b31_done <= '0';
		tb_b32_done <= '0';
        tb_FSM_reset <= '0'; wait for 5 ns;
        tb_FSM_reset <= '1'; wait for 5 ns;
		
		
		tb_msgin_valid <= '1'; wait for 10 ns;
		tb_msgin_valid <= '0'; wait for 10 ns;
		tb_b2_wait <= '1';	wait for 10 ns;
		tb_b2_wait <= '0';	wait for 10 ns;
		tb_b32_done <= '1';	wait for 10 ns;
		tb_b31_done <= '0';	wait for 10 ns;
		tb_b32_done <= '0';	wait for 10 ns;
        
		tb_b2_up_CP <= '1';
		tb_b2_wait <= '1';	wait for 10 ns;
		tb_b2_up_CP <= '0';
		tb_b2_wait <= '0';	wait for 10 ns;
		tb_b31_done <= '1';	wait for 10 ns;
		tb_b32_done <= '1';	wait for 10 ns;
		tb_b31_done <= '0';	wait for 10 ns;
		tb_b32_done <= '0';	wait for 10 ns;

		tb_b2_done <= '1';	wait for 10 ns;
		tb_b2_done <= '0';	wait for 30 ns;
		
		
		tb_msgout_ready <= '1'; wait for 50 ns;
		tb_msgin_valid <= '1';
		tb_msgin_last <= '1'; wait for 10 ns;
        tb_msgin_valid <= '0';
		tb_msgin_last <= '0'; wait for 10 ns;
		tb_msgout_ready <= '1';
		tb_b2_wait <= '1';	wait for 10 ns;
		tb_b2_wait <= '0';	wait for 10 ns;
		tb_b32_done <= '1';	wait for 10 ns;
		tb_b31_done <= '0';	wait for 10 ns;
		tb_b32_done <= '0';	wait for 10 ns;
        
		tb_b2_up_CP <= '1';
		tb_b2_wait <= '1';	wait for 10 ns;
		tb_b2_up_CP <= '0';
		tb_b2_wait <= '0';	wait for 10 ns;
		tb_b31_done <= '1';	wait for 10 ns;
		tb_b32_done <= '1';	wait for 10 ns;
		tb_b31_done <= '0';	wait for 10 ns;
		tb_b32_done <= '0';	wait for 10 ns;
        
		tb_b2_done <= '1';	wait for 10 ns;
		tb_b2_done <= '0';	wait for 50 ns;
    end process;

end Behavioral;