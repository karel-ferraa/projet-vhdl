-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Déclaration d'une entité pour la simulation sans ports d'entrées et de sorties
entity myALUtestbench is

	end myALUtestbench;

architecture myALUtestbench_Arch of myALUtestbench is

	-- Déclaration du composant à tester -> renvoie vers l'entité ALU !
	component ALU is
		port (
		     -- Entrées de données (4 bits)
			     A_IN     : in  signed(3 downto 0);
			     B_IN     : in  signed(3 downto 0);
		     -- Retenues d'entrée
			     SR_IN_L  : in  std_logic;
			     SR_IN_R  : in  std_logic;
		     -- Sélection de la fonction (4 bits)
			     SEL_FCT  : in  std_logic_vector(3 downto 0);
		     -- Sorties de données (8 bits)
			     S        : out signed(7 downto 0);
		     -- Retenues de sortie
			     SR_OUT_L : out std_logic;
			     SR_OUT_R : out std_logic
		     );
	end component;

    -- Déclaration des signaux internes à l'architecture pour réaliser les simulations
	signal A_IN_sim, B_IN_sim : signed(3 downto 0) := (others => '0');
	signal SR_IN_R_sim, SR_IN_L_sim	: std_logic := '0';
	signal SEL_FCT_sim : std_logic_vector(3 downto 0) := (others => '0');
	signal S_sim : signed(7 downto 0) := (others => '0');
	signal SR_OUT_L_sim, SR_OUT_R_sim : std_logic := '0';
	-- signal S_calc : signed(7 downto 0) := (others => '0');
	-- signal SR_OUT_L_calc, SR_OUT_R_calc : std_logic := '0';
begin

    -- Instanciation du composant à tester 
	MyComponentALUunderTest : ALU
    --raccordement des ports du composant aux signaux dans l'architecture
	port map ( 
		     A_IN => A_IN_sim,
		     B_IN => B_IN_sim,
		     SR_IN_L => SR_IN_L_sim,
		     SR_IN_R => SR_IN_R_sim,
		     SEL_FCT => SEL_FCT_sim,
		     S => S_sim,
		     SR_OUT_L => SR_OUT_L_sim,
		     SR_OUT_R => SR_OUT_R_sim
		 );

    -- process explicite - instruction séquentielle - calcul du résultat S_calc à comparer avec S_sim
	--MyCalculate_Proc1 : process (sel_sim, e1_calc, e2_calc, c_in_calc, e1_sim, e2_sim) 	
	--begin
	--	if sel_sim = '0' then
	--		s1_calc (N downto 0) <= e1_calc + e2_calc + c_in_calc;
	--		s1_calc (2*N-1 downto N+1) <= (others => '0'); 
	--	else
	--		s1_calc <= e1_calc(N-1 downto 0) * e2_calc(N-1 downto 0);
	--	end if;
	--end process;

    -- Définition du process permettant de faire évoluer les signaux d'entrée du composant à tester	
	MyStimulus_Proc : process
	begin
		for SEL_FCT_counter in 0 to (2**4) -1 loop
			for A_IN_counter in 0 to (2**4)-1 loop
				for B_IN_counter in 0 to (2**4)-1 loop
					for SR_IN_L_counter in 0 to 1 loop
						for SR_IN_R_counter in 0 to 1 loop
							A_IN_sim <= to_signed(A_IN_counter, 4);
							B_IN_sim <= to_signed(B_IN_counter,4);
							SR_IN_L_sim <= to_unsigned(SR_IN_L_counter,1)(0);
							SR_IN_R_sim <= to_unsigned(SR_IN_R_counter,1)(0);
							SEL_FCT_sim <= std_logic_vector(to_unsigned(SEL_FCT_counter,4));
							wait for 100 us;
							report "A_IN_sim=" & integer'image(to_integer(A_IN_sim)) & " | B_IN_sim=" & integer'image(to_integer(B_IN_sim)) & " | SR_IN_L_sim=" & std_logic'image(SR_IN_L_sim) & " | SR_IN_R_sim=" & std_logic'image(SR_IN_R_sim) & " | SEL_FCT_sim = " & integer'image(to_integer(unsigned(SEL_FCT_sim))) & " || S_sim = " & integer'image(to_integer(S_sim)) & " || SR_OUT_L = " & std_logic'image(SR_OUT_L_sim) & " || SR_OUT_R = " & std_logic'image(SR_OUT_R_sim);
					-- assert (s1_calc = s1_sim) report "Failure" severity failure; 
						end loop;
					end loop;
				end loop;
			end loop;
		end loop;        
		-- report "Test ok (no assert...)";
		wait;

	end process;

end myALUtestbench_Arch;
