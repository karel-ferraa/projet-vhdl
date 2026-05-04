library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Nécessaire pour les conversions signed

entity ALU is
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
end ALU;

architecture ALU_arch of ALU is
begin
	process(A_IN, B_IN, SEL_FCT, SR_IN_L, SR_IN_R)
	-- Signaux de travail internes en signed pour respecter les spécifications
		variable vA_IN: signed(3 downto 0);
		variable vB_IN: signed(3 downto 0);
		variable vS: signed(7 downto 0);
		variable vSR_OUT_L: std_logic;
		variable vSR_OUT_R: std_logic;
	begin

		vA_IN := A_IN;
		vB_IN := B_IN;
		-- valeur par défaut
		vSR_OUT_L := '0';
		vSR_OUT_R := '0';

		case SEL_FCT is
			-- Opérations de base 
			when "0000" => -- nop
				vS := (others => '0');
			when "0001" => -- S = A
				vS := resize(vA_IN, 8);
			when "0010" => -- S = not A
				vS := resize(not vA_IN, 8);
			when "0011" => -- S = B
				vS := resize(vB_IN, 8);
			when "0100" => -- S = not B
				vS := resize(not vB_IN, 8);

			-- Opérations logiques 
			when "0101" => -- AND
				vS := resize(vA_IN and vB_IN, 8);
			when "0110" => -- OR
				vS := resize(vA_IN or vB_IN, 8);
			when "0111" => -- XOR
				vS := resize(vA_IN xor vB_IN, 8);

			-- Opérations arithmétiques signées 
			when "1000" => -- Addition avec retenue
				vS := resize(vA_IN, 8) + resize(vB_IN, 8) + SR_IN_R;
			when "1001" => -- Addition simple
				vS := resize(vA_IN, 8) + resize(vB_IN, 8);
			when "1010" => -- Soustraction
				vS := resize(vA_IN, 8) - resize(vB_IN, 8);
			when "1011" => -- Multiplication
				vS := vA_IN * vB_IN; -- Résultat 8 bits automatique

			-- Décalages
			when "1100" => -- Décalage droite A (avec SR_IN_L comme bit entrant)
				vS := resize(SR_IN_L & vA_IN(3 downto 1), 8);
				vSR_OUT_R := vA_IN(0);
			when "1101" => -- Décalage gauche A (avec SR_IN_R)
				vS := resize(vA_IN(2 downto 0) & SR_IN_R, 8);
				vSR_OUT_L := vA_IN(3);
			when "1110" => -- Décalage droite B (avec SR_IN_L)
				vS := resize(SR_IN_L & vB_IN(3 downto 1), 8);
				vSR_OUT_R := vB_IN(0);
			when "1111" => -- Décalage gauche B (avec SR_IN_R)
				vS := resize(vB_IN(2 downto 0) & SR_IN_R, 8);
				vSR_OUT_L := vB_IN(3);
			when others =>
				vS := (others => '0');
		end case;
		S <= vS;
		SR_OUT_L <= vSR_OUT_L;
		SR_OUT_R <= vSR_OUT_R;
	end process;
end ALU_arch;
