library IEEE;
library WORK;
use WORK.SNAKE.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity compteur is
    Port (  --entrees
            clk      : in STD_LOGIC;
            reset    : in STD_LOGIC;

            --sorties
            data_write  : out std_logic;
            modulo      : out STD_LOGIC_VECTOR (18 downto 0));
end compteur;

architecture Behavioral of compteur is

    signal compteur     : integer range 0 to 640*480 - 1 := 0;
    constant valeur_max : integer := 640*480 - 1;
    
begin
    
    valeur_modulo : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                modulo <= std_logic_vector(to_unsigned(0, 18+1));
                compteur <= 0;
                data_write <= '0';
           
            else    
                compteur <= compteur + 1;
               
                if (compteur = valeur_max) then
                    compteur <= 0;
                    data_write <= '0';

                else
                    --active data_write pour ecrire dans la memoire
                    data_write <= '1'; 
                end if;
               
                --conversion de l'entier en std_logic_vector de 19 bits
                modulo <= std_logic_vector(to_unsigned(compteur, 18+1));
            end if;
        end if;
    end process;

end Behavioral;
