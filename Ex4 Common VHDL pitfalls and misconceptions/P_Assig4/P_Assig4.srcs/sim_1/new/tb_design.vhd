library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_design is
--  Port ( );
end tb_design;

ARCHITECTURE Behavioral OF tb_design IS
    COMPONENT design2
	   PORT(
           clk: in std_logic;
           reset: in std_logic;
           A: in std_logic;
           B: in std_logic;
           Y: out std_logic
	   );
	END COMPONENT;
	
	SIGNAL clk : std_logic;
    SIGNAL reset : std_logic;
    SIGNAL A : std_logic;
    SIGNAL B : std_logic;
    SIGNAL Y : std_logic;

BEGIN
-- Please check and add your generic clause manually
	uut: design2 PORT MAP(
		clk => clk,
		reset => reset,
		A => A,
		B  => B,
        Y => Y
	);
    
    tb0 : PROCESS
    BEGIN
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    END PROCESS;
    
    tb1 : PROCESS
    BEGIN
        reset <= '1';
        A <= '0';
        B <= '0';       wait for 3 ns;
        reset <= '0';
        A <= '1';
        B <= '0';       wait for 10 ns;
        A <= '0';
        B <= '1';       wait for 40 ns;
    END PROCESS;
END Behavioral;