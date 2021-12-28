library IEEE;
library WORK;
use WORK.SNAKE.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity deplacement is
  Port ( --entrees
        clk         : in std_logic; -- 100MHz
        clk_reduit  : in std_logic; -- ~50Hz
        reset       : in std_logic;
        restart     : in std_logic;
        up          : in std_logic;
        down        : in std_logic;
        right       : in std_logic;
        left        : in std_logic;
        play        : in std_logic;
        perdu       : in std_logic;
        SNAKE_IN    : in SNAKE_TAB (TAILLE downto 0);
         
        --sortie    
        SNAKE_OUT   : out SNAKE_TAB (TAILLE downto 0));
end deplacement;

architecture Behavioral of deplacement is
    constant initialisation : integer := 20000; --pour initialiser le snake lors du reset
    signal i                : integer range 0 to TAILLE := 0; --pour la boucle

begin

    se_deplacer : process(clk_reduit)
    begin
        if rising_edge(clk_reduit) then
            if (reset = '1' or restart = '1') then
                --reinitialisation du serpent
                for i in 0 to TAILLE - 1 loop
                    SNAKE_OUT (i) <= initialisation - i;
                end loop;
                
            elsif (play = '1' and perdu = '0') then
            
                --bouge le serpent
                if (up = '1') then --enleve une ligne si on monte
                    SNAKE_OUT ( TAILLE downto 1) <= SNAKE_IN (TAILLE - 1 downto 0);
                    SNAKE_OUT(0) <= SNAKE_IN(0) - 640;
                    
                elsif (down = '1') then --ajoute une ligne si on decsend
                    SNAKE_OUT ( TAILLE downto 1) <= SNAKE_IN (TAILLE - 1 downto 0);
                    SNAKE_OUT(0) <= SNAKE_IN(0) + 640;
                    
                elsif( left = '1') then --enleve une colonne si on va a gauche
                    SNAKE_OUT ( TAILLE downto 1) <= SNAKE_IN (TAILLE - 1 downto 0);
                    SNAKE_OUT(0) <= SNAKE_IN(0) - 1;
                                        
                elsif(right = '1') then --ajoute une colonne si on va a droite 
                    SNAKE_OUT ( TAILLE downto 1) <= SNAKE_IN (TAILLE - 1 downto 0);
                    SNAKE_OUT(0) <= SNAKE_IN(0) + 1;
                end if;
                
            end if;
        end if;
    end process;
      
end Behavioral;