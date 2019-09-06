library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_Block_3 is
	generic (
		C_BLOCK_SIZE: integer := 32		-- Number of bits of the incoming message
	);
end tb_Block_3;

architecture Behavioral of tb_Block_3 is
    component Block_3
        port (
			i_b3_clk:   in std_logic;
			i_b3_reset: in std_logic;
			i_b3_en: 	in std_logic;
			i_b3_A:     in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
			i_b3_B:     in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
			i_b3_N:     in std_logic_vector((C_BLOCK_SIZE-1) downto 0);
			o_b3_C:     out std_logic_vector((C_BLOCK_SIZE-1) downto 0);
			o_b3_done:	out std_logic
        );
    end component;
	
	signal tb_b3_clk:   std_logic;
	signal tb_b3_reset: std_logic;
	signal tb_b3_en:    std_logic;
	signal tb_b3_A:     std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_b3_B:     std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_b3_N:     std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_b3_C:     std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_b3_done:  std_logic;
    
begin
    uut: Block_3 port map (
		i_b3_clk => tb_b3_clk,
		i_b3_reset => tb_b3_reset,
		i_b3_en => tb_b3_en,
		i_b3_A => tb_b3_A,
		i_b3_B => tb_b3_B,
		i_b3_N => tb_b3_N,
		o_b3_C => tb_b3_C,
		o_b3_done => tb_b3_done
    );
    
    tb0 : process
    begin
        tb_b3_clk <= '1'; wait for 2 ns;
        tb_b3_clk <= '0'; wait for 2 ns;
    end process;
    
    tb1 : process
    begin
    -- These numbers are coprimes, and E (B) must be smaller than N (https://www.dcode.fr/coprimes)
        tb_b3_A <= "10100110110000111110011101010101";	-- 2797856597
        tb_b3_B <= "10100111011001000111001110111010";	-- 2808378298
		tb_b3_N <= "11111000011001100100111100001011";	-- 4167454475
        -- tb_b3_A <= "00000000011110100001101111010001";	-- 8002513
        -- tb_b3_B <= "00000000101011001110011101101101";	-- 11331437
		-- tb_b3_N <= "00000000111001100100111100001011";	-- 15093515
        tb_b3_en <= '0';
		tb_b3_reset <= '0'; wait for 10 ns; 
        tb_b3_reset <= '1'; wait for 10 ns;
		tb_b3_en <= '1'; wait for 150 ns;
        tb_b3_en <= '0'; wait for 10 ns;	-- Simulate with 200 ns
    end process;

end Behavioral;