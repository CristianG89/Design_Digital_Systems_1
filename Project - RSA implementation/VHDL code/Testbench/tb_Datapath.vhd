library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_Datapath is
	generic (
		C_BLOCK_SIZE: integer := 32		-- Number of bits of the incoming message
	);
end tb_Datapath;

architecture Behavioral of tb_Datapath is
    component Datapath
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
    end component;

	signal tb_data_clk:	std_logic;
	signal tb_data_rst:	std_logic;
	signal tb_data_E:	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_data_N:	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_data_M:	std_logic_vector((C_BLOCK_SIZE-1) downto 0);	
	signal tb_data_C:	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	
	signal tb_data_b2_en: 	 std_logic;
	signal tb_data_b2_charge:std_logic;
	signal tb_data_b2_wait:  std_logic;
	signal tb_data_b2_up_CP: std_logic;
	signal tb_data_b2_done:  std_logic;

	signal tb_data_b31_en: 	 std_logic;
	signal tb_data_b32_en: 	 std_logic;
	signal tb_data_b31_done: std_logic;
	signal tb_data_b32_done: std_logic;

begin
    uut: Datapath port map (
		i_data_clk => tb_data_clk,
		i_data_rst => tb_data_rst,
		i_data_E => tb_data_E,
		i_data_N => tb_data_N,
		i_data_M => tb_data_M,
		o_data_C => tb_data_C,
		
		i_data_b2_en => tb_data_b2_en,
		i_data_b2_charge => tb_data_b2_charge,
		o_data_b2_wait => tb_data_b2_wait,
		o_data_b2_up_CP => tb_data_b2_up_CP,
		o_data_b2_done => tb_data_b2_done,

		i_data_b31_en => tb_data_b31_en,
		i_data_b32_en => tb_data_b32_en,
		o_data_b31_done => tb_data_b31_done,
		o_data_b32_done => tb_data_b32_done
    );
    
    tb0 : process
    begin
        tb_data_clk <= '1'; wait for 2 ns;
        tb_data_clk <= '0'; wait for 2 ns;
    end process;
    
    tb1 : process
    begin
		tb_data_b2_en <= '0';
		tb_data_b2_charge <= '0';
		tb_data_b31_en <= '0';
		tb_data_b32_en <= '0';
        tb_data_M <= "00000000101110100001101111010001";
        tb_data_E <= "00000000101011001110011101101101";
		tb_data_N <= "00000000111001100100111100001011";
		tb_data_rst <= '0';		wait for 10 ns;
        tb_data_rst <= '1';		wait for 10 ns;
		
		tb_data_b2_en <= '1';
        tb_data_b2_charge <= '1';	wait for 5 ns;
		tb_data_b2_charge <= '0';
        tb_data_b2_en <= '0';	wait for 10 ns;
		tb_data_b31_en <= '1';
		tb_data_b32_en <= '1';	wait for 135 ns;
		tb_data_b31_en <= '0';
		tb_data_b32_en <= '0';	wait for 10 ns;
		
		tb_data_b2_en <= '1';	wait for 10 ns;
        tb_data_b2_en <= '0';	wait for 10 ns;
		tb_data_b32_en <= '1';	wait for 135 ns;
		tb_data_b32_en <= '0';	wait for 10 ns;
		
		tb_data_b2_en <= '1';	wait for 10 ns;
        tb_data_b2_en <= '0';	wait for 10 ns;
		tb_data_b31_en <= '1';
		tb_data_b32_en <= '1';	wait for 135 ns;
		tb_data_b31_en <= '0';
		tb_data_b32_en <= '0';	wait for 10 ns;
		
		tb_data_b2_en <= '1';	wait for 10 ns;
        tb_data_b2_en <= '0';	wait for 10 ns;
		tb_data_b32_en <= '1';	wait for 135 ns;
		tb_data_b32_en <= '0';	wait for 10 ns;
		
		tb_data_b2_en <= '1';	wait for 10 ns;
        tb_data_b2_en <= '0';	wait for 10 ns;
		tb_data_b31_en <= '1';
		tb_data_b32_en <= '1';	wait for 135 ns;
		tb_data_b31_en <= '0';
		tb_data_b32_en <= '0';	wait for 10 ns;	-- Simulate with 890 ns
    end process;

end architecture Behavioral;