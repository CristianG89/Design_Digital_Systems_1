library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Latch is
    port(
        A: in std_logic_vector(1 downto 0);
        -- B: in std_logic;
        Y: out std_logic
    );
end Latch;

architecture Behavioral of Latch is

begin
     latch: process (A) is
     begin
        case A is
            when "00" => Y <= '1';
            when "01" => Y <= '0';
            when "10" => Y <= '1';
            when "11" => Y <= '0';
            -- when others => Y <= '1';
        end case;
     end process latch;
    
    -- process (A) is
    -- begin
      -- if (A = '1') then
       -- Y <= B;
      -- else
        -- y <= '0';
      -- end if;
    -- end process;
    
end Behavioral;