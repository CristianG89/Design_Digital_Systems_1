library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_rsa_core is
	generic (
		C_BLOCK_SIZE: integer := 32		-- Number of bits of the incoming message
	);
end tb_rsa_core;

architecture Behavioral of tb_rsa_core is
    component rsa_core
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
    end component;

	signal tb_clk:			std_logic;
	signal tb_reset_n:		std_logic;

	signal tb_msgin_valid:	std_logic; 
	signal tb_msgin_ready:	std_logic;
	signal tb_msgin_data:	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_msgin_last:	std_logic;

	signal tb_msgout_valid:	std_logic;
	signal tb_msgout_ready:	std_logic;
	signal tb_msgout_data:	std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_msgout_last:	std_logic;

	signal tb_key_e_d:		std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_key_n:		std_logic_vector((C_BLOCK_SIZE-1) downto 0);
	signal tb_rsa_status:	std_logic_vector(31 downto 0);

begin
    uut: rsa_core port map (
		clk => tb_clk,
		reset_n => tb_reset_n,
		
		msgin_valid => tb_msgin_valid,
		msgin_ready => tb_msgin_ready,
		msgin_data => tb_msgin_data,
		msgin_last => tb_msgin_last,
		
		msgout_valid => tb_msgout_valid,
		msgout_ready => tb_msgout_ready,
		msgout_data => tb_msgout_data,
		msgout_last => tb_msgout_last,

		key_e_d => tb_key_e_d,
		key_n => tb_key_n,
		rsa_status => tb_rsa_status
    );
    
    tb0 : process
    begin
        tb_clk <= '1'; wait for 2 ns;
        tb_clk <= '0'; wait for 2 ns;
    end process;
    
    tb1 : process
    begin
		tb_msgin_valid <= '0';
		tb_msgin_last <= '0';
		tb_msgout_ready <= '0';
		-- These numbers must be coprimes each other, and E must be smaller than N & M (https://www.dcode.fr/coprimes)
		-- tb_msgin_data <= "10111010000110111101000101100101";
        -- tb_key_e_d <= "10100111011001000111001110111000";
		-- tb_key_n <= "11111000011001100100111100001011";	-- 4167454475
        tb_msgin_data <= "00000000011110100001101111010001";	-- 8002513
        tb_key_e_d <= "00000000101011001110011101101101";	-- 11331437
		tb_key_n <= "00000000111001100100111100001011";	-- 15093515
		tb_reset_n <= '0';		wait for 10 ns;
        tb_reset_n <= '1';		wait for 10 ns;
		
		tb_msgin_valid <= '1';	wait for 10 ns;
		tb_msgin_valid <= '0';	wait for 5400 ns;
		tb_msgout_ready <= '1';	wait for 10 ns;
		tb_msgout_ready <= '0';	wait for 100 ns;
		
		tb_msgin_data <= "10100110110000111110011101010101";	-- 2797856597
        tb_key_e_d <= "10100111011001000111001110111010";	-- 2808378298
		tb_key_n <= "11111000011001100100111100001011";	-- 4167454475
        -- tb_msgin_data <= "00000000011110100001101111010001";	-- 8002513
        -- tb_key_e_d <= "00000000101011001110011101101101";	-- 11331437
		-- tb_key_n <= "00000000111001100100111100001011";	-- 15093515
		tb_msgin_valid <= '1';
		tb_msgin_last <= '1';	wait for 15 ns;		-- +5 because of waiting for msgin_ready
		tb_msgin_valid <= '0';
		tb_msgin_last <= '0';	wait for 5400 ns;
		tb_msgout_ready <= '1';	wait for 10 ns;
		tb_msgout_ready <= '0';	wait for 300 ns;
    end process;

end architecture Behavioral;