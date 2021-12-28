library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.SNAKE.all;

entity collision is
  Port ( --entrees
        clk     : in std_logic;
        reset   : in std_logic;
        restart : in std_logic;
        up      : in std_logic;
        down    :  in std_logic;
        right    : in std_logic;
        left     : in std_logic;
        play     : in std_logic;
        SNAKE_IN : in SNAKE_TAB (TAILLE downto 0);
        
        --sorties
        SNAKE_OUT : out SNAKE_TAB (TAILLE downto 0);
        perdu : out std_logic);
end collision;

architecture Behavioral of collision is

    signal collision_corps  : std_logic := '0';
    signal collision_mur    : std_logic := '0';
    signal i                : integer range 0 to TAILLE := 0;
    signal tete             : integer range 0 to 524287 := SNAKE_IN(0);
    signal cellule          : integer range 0 to 524287;
    
begin

    test_corps : process(clk) --test la collision de la tete dans le corps
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                collision_corps <= '0';
            
            else
                collision_corps <= '0';
                for i in 3 to TAILLE - 1 loop
                    -- si l'adresse de la tete est la meme que celle d'un element du corps
                    cellule <= SNAKE_IN(i);
                    if (tete = cellule) then
                        collision_corps <= '1';
                    end if;
                end loop;
            end if;
        end if;
    end process;
    
    test_mur : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then 
                collision_mur <= '0';
                
            else
                collision_mur <= '0';
                tete <= SNAKE_IN(0);
                
                --si on monte et que la tete est sur la premiere ligne
                if (up = '1') then
                    if (tete < 640) then
                        collision_mur <= '1';
                    end if;
                
                --si on descend et que la tete est sur la derniere ligne
                elsif (down = '1') then
                    if (tete > 640*479) then
                        collision_mur <= '1';
                    end if;
                
                --si on va a gauche et que la tete est sur la premiere colonne
                elsif (left = '1') then
                    if (tete mod 640 = 0) then
                        collision_mur <= '1';
                    end if;
                
                --si on va a droite et que la tete est sur la derniere colonne
                elsif (right = '1') then
                    if (tete mod 640 = 639) then
                        collision_mur <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    --perdu si on a collision sur la corps OU sur un mur
    perdu <= collision_mur OR collision_corps;
    SNAKE_OUT <= SNAKE_IN;
              
end Behavioral;
