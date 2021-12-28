library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package SNAKE is
    type SNAKE_TAB is array (integer range <>) of integer range 0 to 524287;
    constant TAILLE : integer range 3 to 10 := 5;
end package;
