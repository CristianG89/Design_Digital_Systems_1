library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design1 is
    port(
        clk: in std_logic;
        reset: in std_logic;
        A: in std_logic;
        B: in std_logic;
        Y: out std_logic
    );
end design1;

architecture Behavioral of design1 is
begin
    process (clk, reset) is
    variable t : std_ulogic;
    begin
        if (reset = '1') then
            t := '0';
            Y <= '0';
        elsif (rising_edge(clk)) then
            Y <= t;
            t := A xor B;
        end if;
    end process;
end Behavioral;