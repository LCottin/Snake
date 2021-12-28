library IEEE;
library WORK;
use WORK.SNAKE.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MODULE_AFFICHAGE is
	Port (  --entrees
			clk        : in std_logic;
			not_reset  : in std_logic;
			b_up       : in std_logic;
			b_down     : in std_logic;
			b_left     : in std_logic;
			b_right    : in std_logic;
			b_center   : in std_logic;
			
			--sorties
			led        : out std_logic;
			VGA_hs     : out std_logic;
			VGA_vs     : out std_logic;
			VGA_red    : out std_logic_vector(3 downto 0);   -- red output
			VGA_green  : out std_logic_vector(3 downto 0);   -- green output
			VGA_blue   : out std_logic_vector(3 downto 0));   -- blue output
end MODULE_AFFICHAGE;

architecture Behavioral of MODULE_AFFICHAGE is

    component detec_impulsion
        port (	clk    : in std_logic;
				entree : in std_logic;
				  
              	sortie : out std_logic);
  	end component;     
     
    component compteur is
        port (  clk         : in std_logic;
				reset       : in std_logic;
				
            	data_write  : out std_logic;
              	modulo      : out std_logic_vector (18 downto 0));
    end component;
    
    component VGA_bitmap_640x480 is
        generic(bit_per_pixel   : integer range 1 to 12:=1;    -- number of bits per pixel
                grayscale       : boolean := false);           -- should data be displayed in grayscale
		port(	clk          : in  std_logic;
				reset        : in  std_logic;
				VGA_hs       : out std_logic;   -- horisontal vga syncr.
				VGA_vs       : out std_logic;   -- vertical vga syncr.
				VGA_red      : out std_logic_vector(3 downto 0);   -- red output
				VGA_green    : out std_logic_vector(3 downto 0);   -- green output
				VGA_blue     : out std_logic_vector(3 downto 0);   -- blue output
		
				ADDR         : in  std_logic_vector(18 downto 0);
				data_in      : in  std_logic_vector(bit_per_pixel - 1 downto 0);
				data_write   : in  std_logic;
				data_out     : out std_logic_vector(bit_per_pixel - 1 downto 0)); 
    end component;
    
    component mise_en_forme is
        port (	clk 	: in std_logic;
				reset 	: in std_logic;
				serpent : in SNAKE_TAB (TAILLE downto 0);
				modulo 	: in std_logic_vector (18 downto 0);
				perdu 	: in std_logic;

				led 	: out std_logic;
				data 	: out std_logic_vector (2 downto 0));
    end component;
   
    component deplacement is
        port (  clk 		: in std_logic;
                clk_reduit  : in std_logic;
                reset 		: in std_logic;
                restart 	: in std_logic;
                up 			: in std_logic;
                down 		: in std_logic;
                right 		: in std_logic;
                left 		: in std_logic;
                play 		: in std_logic;
                perdu 		: in std_logic;
                SNAKE_IN 	: in SNAKE_TAB (TAILLE downto 0);
                
                SNAKE_OUT 	: out SNAKE_TAB (TAILLE downto 0));
    end component;
               
    component diviseur_horloge is
        port (	clk 	: in std_logic;
				reset 	: in std_logic;
				  
              	clk_out : out std_logic);
    end component;
     
    component FSM is
        Port (  clk 	 : in std_logic;
				reset 	 : in std_logic;
				b_up 	 : in std_logic;
				b_down 	 : in std_logic;
				b_left 	 : in std_logic;
				b_right  : in std_logic;
				b_center : in std_logic;
				
				restart  : out std_logic;
				up 		 : out std_logic;
				down 	 : out std_logic;
				right 	 : out std_logic;
				left 	 : out std_logic;
				play 	 : out std_logic);
    end component ;
     
    component collision is
        Port (	clk 	 : in std_logic;
				reset 	 : in std_logic;
				restart  : in std_logic;
				up 		 : in std_logic;
				down 	 : in std_logic;
				right 	 : in std_logic;
				left 	 : in std_logic;
				play 	 : in std_logic;
				SNAKE_IN : in SNAKE_TAB (TAILLE downto 0);
				
				SNAKE_OUT : out SNAKE_TAB (TAILLE downto 0);
				perdu 	  : out std_logic);
    end component;

     
    signal clk_reduit 		: std_logic;
    signal modulo 			: std_logic_vector(18 downto 0);
    signal data 			: std_logic_vector (2 downto 0);
    signal serpent_in 		: SNAKE_TAB (TAILLE downto 0); 
    signal data_write 		: std_logic;
	
	--signaux de la FSM
    signal restart 			: std_logic;
    signal up 				: std_logic; 
    signal play 			: std_logic; 
    signal down 			: std_logic; 
    signal right 			: std_logic; 
    signal left 			: std_logic;
	signal perdu 			: std_logic;
	
    signal serpent_out_collision : SNAKE_TAB (TAILLE downto 0);
    signal serpent_out 			 : SNAKE_TAB (TAILLE downto 0);    
    signal reset 				 : std_logic;
    signal bouton_center 	     : std_logic;
    
    BEGIN
		
	--inversion du signal reset => actif a l'etat bas
    reset <= not not_reset;
   
    DETEC : detec_impulsion
		port map(	clk    => clk,
					entree => b_center,
					sortie => bouton_center);
             
    DIVISEUR_CLK : diviseur_horloge
		port map (	clk     => clk, 
					reset   => reset, 
					clk_out => clk_reduit);
    
    MACHINE : FSM
		Port map (  clk 	 => clk,
					reset 	 => reset, 
					b_up 	 => b_up, 
					b_down 	 => b_down, 
					b_left 	 => b_left,
					b_right  => b_right, 
					b_center => bouton_center,
					
					restart => restart, 
					up 		=> up, 
					down 	=> down, 
					right 	=> right, 
					left 	=> left, 
					play 	=> play);
            
    COLLISION_SNAKE : collision
		port map (	clk 	 => clk,
					reset  	 => reset, 
					restart  => restart, 
					up 		 => up,
					down 	 => down, 
					left 	 => left,
					right    => right,
					play	 => play,
					SNAKE_IN => serpent_out,
					
					SNAKE_OUT => serpent_out_collision,
					perdu 	  => perdu);
                  
    DEPLACEMENT_SNAKE : deplacement
		port map(	clk 		=> clk,
					clk_reduit  => clk_reduit, 
					reset 		=> reset,
					restart 	=> restart,
					up 			=> up, 
					down 		=> down,
					left 		=> left,
					right 		=> right,
					perdu 		=> perdu,
					play 		=> play,
					SNAKE_IN 	=> serpent_out_collision,
					
					SNAKE_OUT 	=> serpent_out);
             
    
    CPT_ADDR : compteur
		port map (	clk 	   => clk,
					reset 	   => reset,
					modulo 	   => modulo,
					data_write => data_write);
     
     
    MISE_FORME : mise_en_forme
		port map (	clk 	=> clk,
					reset 	=> reset,
					modulo 	=> modulo,
					perdu 	=> perdu,
					serpent => serpent_out,
					data 	=> data,
					led 	=> led);
              
    VGA : vga_bitmap_640x480
		generic map (	bit_per_pixel => 3, 
						grayscale 	  => false)
		port map (		clk 		=> clk,
						reset 		=> reset,
						ADDR 		=> modulo,
						data_in 	=> data,
						data_write 	=> data_write,
						
						VGA_red 	=> VGA_red,
						VGA_blue 	=> VGA_blue,
						VGA_green	=> VGA_green,
						VGA_hs 		=> VGA_hs,
						VGA_vs 		=> VGA_vs,
						data_out 	=> open);
             
end Behavioral;
