LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY detec_impulsion IS
	PORT (	--entrees
			clk   	: IN  STD_LOGIC;
			entree  : IN  STD_LOGIC;
			
			--sortie
			sortie  : OUT STD_LOGIC);
END detec_impulsion;

ARCHITECTURE Behavioral OF detec_impulsion IS

	SIGNAL memoire : STD_LOGIC := '0';

BEGIN

	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			memoire <= entree;
			sortie 	<= (memoire XOR entree) AND entree;
		END IF;
	END PROCESS;

END Behavioral;