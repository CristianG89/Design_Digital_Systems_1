library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design2 is
    port(
        clk: in std_logic;
        reset: in std_logic;
        A: in std_logic;
        B: in std_logic;
        Y: out std_logic
    );
end design2;

architecture Behavioral of design2 is
begin
    process (clk, reset) is
    variable t : std_ulogic;
    begin
        if (reset = '1') then
            t := '0';
            Y <= '0';
        elsif (rising_edge(clk)) then
            t := A xor B;
            Y <= t;
        end if;
    end process;
end Behavioral;