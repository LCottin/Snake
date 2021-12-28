library IEEE;
library WORK;
use WORK.SNAKE.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    Port (  --entrees
            clk      : in std_logic;
            reset    : in std_logic;
            b_up     : in std_logic;
            b_down   : in std_logic;
            b_left   : in std_logic;
            b_right  : in std_logic;
            b_center : in std_logic;
            
            --sorties
            restart  : out std_logic;
            up       : out std_logic;
            down     : out std_logic;
            right    : out std_logic;
            left     : out std_logic;
            play     : out std_logic);
end FSM;

architecture Behavioral of FSM is

    type STATE_TYPE is (init, go_up, go_down, go_left, go_right, play_pause);
    signal current_state : STATE_TYPE;
    
begin
    
    --calcul du prochain etat
    next_state : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= init;
            else 
                case current_state is 

                    when init => 
                        if b_up = '1' then
                            current_state <= go_up;
                        elsif b_right = '1' then
                            current_state <= go_right;
                        elsif b_left = '1' then
                            current_state <= go_left;
                        elsif b_down = '1' then
                            current_state <= go_down;
                        else 
                            current_state <= current_state;
                        end if;
              
                    
                    when go_down | go_up =>
                        if b_center = '1' then
                            current_state <= play_pause;
                        elsif b_right = '1' then
                            current_state <= go_right;
                        elsif b_left = '1' then
                            current_state <= go_left;
                        else    
                            current_state <= current_state;
                        end if;
                    
                    when go_left | go_right =>
                        if b_center = '1' then
                            current_state <= play_pause;
                        elsif b_up = '1' then
                            current_state <= go_up;
                        elsif b_down = '1' then
                            current_state <= go_down;
                        else 
                            current_state <= current_state;
                        end if;
                       
                    when play_pause =>
                        if b_up = '1' then
                            current_state <= go_up;
                        elsif b_down = '1' then
                            current_state <= go_down;
                        elsif b_left = '1' then
                            current_state <= go_left;
                        elsif b_right = '1' then
                            current_state <= go_right;
                        elsif b_center = '1' then
                            current_state <= init;
                        else 
                            current_state <= current_state;
                        end if;
                    
                end case;
            end if;
        end if;
    end process;
    
    --evaluation des sorties pour l'etat courant
    define_current_state : process(current_state)
    begin
        case current_state is
            when init =>
                play <= '0';
                restart <= '1';
                up <= '0';
                down <= '0';
                left <= '0';
                right <= '0';
                
            when go_up =>
                play <= '1';
                restart <= '0';
                up <= '1';
                down <= '0';
                left <= '0';
                right <= '0';

            when go_down =>
                play <= '1';
                restart <= '0';
                up <= '0';
                down <= '1';
                left <= '0';
                right <= '0';
    
            when go_left =>
                play <= '1';
                restart <= '0';
                up <= '0';
                down <= '0';
                left <= '1';
                right <= '0';
    
            when go_right =>
                play <= '1';
                restart <= '0';
                up <= '0';
                down <= '0';
                left <= '0';
                right <= '1';
                    
            when play_pause =>
                play <= '1';
                restart <= '0';
                up <= '0';
                down <= '0';
                left <= '0';
                right <= '0';                    
    
        end case;
    end process;
        
end Behavioral;
