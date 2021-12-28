library IEEE;
library WORK;
use WORK.SNAKE.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mise_en_forme is
    Port (  --entrees 
            clk     : in STD_LOGIC;
            reset   : in STD_LOGIC;
            perdu   : in std_logic;
            modulo  : in STD_LOGIC_VECTOR ( 18 downto 0);
            serpent : in SNAKE_TAB (TAILLE downto 0);
           
            --sorties
            data    : out STD_LOGIC_vector(2 downto 0);
            led     : out std_logic);
end mise_en_forme;

architecture Behavioral of mise_en_forme is

    signal i : integer range 0 to TAILLE := 0;
    
begin

    affichage_cellule : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then 
                led <= '0';
                data <= "000";
                
            --ecran rouge    
            elsif perdu = '1' then
                led <= '1';
                data <= "100";
                
            else 
                led <= '1';
                data <= "000"; --pixel noir
                for i in 0 to TAILLE - 1 loop
                    --cherche si la valeur du modulo correspond a une adresse du serpent
                    if (to_integer(unsigned(modulo)) = serpent(i)) then
                        --pixel blanc
                        data <= "111";
                    end if;
                end loop;
            end if;

        end if;
    end process;

end Behavioral;
