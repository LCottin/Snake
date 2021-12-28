library IEEE;
library WORK;
use WORK.SNAKE.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity diviseur_horloge is
    Port (  --entrees 
            clk     : in std_logic; --100MHz
            reset   : in std_logic;
            
            --sortie
            clk_out : out std_logic); --horloge plus lente
end diviseur_horloge;

architecture Behavioral of diviseur_horloge is
    
    constant compteur_max : integer := 2000000; --0.02s = 20ms => 50Hz
    signal compteur       : integer range 0 to compteur_max := 0;
    
begin

    diviseur : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                clk_out <= '0';
                compteur <= 0;
            
            else 
                compteur <= compteur + 1;
                
                if (compteur = compteur_max) then
                    clk_out <= '1';
                    compteur <= 0;
                else 
                    clk_out <= '0';
                end if;

            end if;
        end if;
    end process;

end Behavioral;
