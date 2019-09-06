library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_Block_2 is
	generic (
		C_BLOCK_SIZE: integer := 32		-- Number of bits of the incoming message
	);
end tb_Block_2;

architecture Behavioral of tb_Block_2 is
    component Block_2
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
    end component;
	
	signal tb_b2_clk:   std_logic;
	signal tb_b2_reset: std_logic;
	signal tb_b2_en:    std_logic;
	signal tb_b2_charge:std_logic;
	signal tb_b2_M:   	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_b2_E:   	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_b2_P:   	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_b2_C:   	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tbo_b2_P:  	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tbo_b2_C:  	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_b2_wait:  std_logic;
	signal tb_b2_up_CP:	std_logic;
	signal tb_b2_done:  std_logic;
	
begin
    uut: Block_2 port map (
		i_b2_clk => tb_b2_clk,
		i_b2_reset => tb_b2_reset,
		i_b2_en => tb_b2_en,
		i_b2_charge => tb_b2_charge,
		i_b2_M => tb_b2_M,
		i_b2_E => tb_b2_E,
		i_b2_P => tb_b2_P,
		i_b2_C => tb_b2_C,
		o_b2_P => tbo_b2_P,
		o_b2_C => tbo_b2_C,
		o_b2_wait => tb_b2_wait,
		o_b2_up_CP => tb_b2_up_CP,
		o_b2_done => tb_b2_done
    );
    
    tb0 : process
    begin
        tb_b2_clk <= '1'; wait for 2.5 ns;
        tb_b2_clk <= '0'; wait for 2.5 ns;
    end process;
    
    tb1 : process
    begin
        tb_b2_M <= "00000000000000000000000000000000";
        tb_b2_E <= "00000000000000000000000000000000";
        tb_b2_P <= "00000000000000000000000000000000";
		tb_b2_C <= "00000000000000000000000000000000";
		tb_b2_charge <= '0';
        tb_b2_en <= '0';
		tb_b2_reset <= '0'; wait for 5 ns;
        tb_b2_reset <= '1'; wait for 5 ns;
		
        tb_b2_M <= "00110011001100110011001100110011";
        tb_b2_E <= "01010010100110100101100101101010";
        tb_b2_P <= "01100101001100110010111000101001";
		tb_b2_C <= "00001111000011110000111100001111";
		tb_b2_charge <= '1';
		tb_b2_en <= '1'; wait for 10 ns;
		tb_b2_charge <= '0';
        tb_b2_en <= '0'; wait for 10 ns;		
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		
        tb_b2_P <= "11010101010101001101101110101010";
		tb_b2_C <= "11110000111100001111000011110000";
		
		tb_b2_charge <= '1';
        tb_b2_en <= '1'; wait for 10 ns;
		tb_b2_charge <= '0';
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 10 ns;
		tb_b2_en <= '1'; wait for 10 ns;
        tb_b2_en <= '0'; wait for 50 ns;	-- Simulate with 400 ns
    end process;

end Behavioral;