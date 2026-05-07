library IEEE;
use IEEE.std_logic_1164.all;

entity Core_Microcontroller_4bit is
    port (
        CLK : in std_logic;
        RESET : in std_logic;
        SEL_ROUTE : in  std_logic_vector (3 DOWNTO 0);
        SEL_OUT : in std_logic_vector (1 DOWNTO 0);
        SEL_FCT : in std_logic_vector (3 DOWNTO 0);
        A_IN, B_IN : in std_logic_vector (3 DOWNTO 0);
        SR_IN_L, SR_IN_R : in std_logic;

        SR_OUT_L : out std_logic;
        SR_OUT_R : out std_logic;
        RES_OUT : out std_logic_vector(7 DOWNTO 0);

    );
end Core_Microcontroller_4bit;

architecture Behavioral of Core_Microcontroller_4bit is

    type memoire_array is array (0 to 127) of std_logic_vector(9 DOWNTO 0);

    constant MEM_INSTRUCTIONS : memoire_array :=(
        0 => "0000000000",
        1 => "0110011101",
        others => (others => '0')
    )

    signal Buffer_A, Buffer_B : std_logic_vector (3 DOWNTO 0);
    signal MEM_CACHE_1, MEM_CACHE_2 : std_logic_vector(7 DOWNTO 0);
    signal MEM_SR_IN_L, MEM_SR_IN_R : std_logic;
    signal MEM_SEL_FCT : std_logic_vector(3 DOWNTO 0);
    signal MEM_SEL_OUT : std_logic_vector(1 DOWNTO 0);
    signal PC : unsigned(6 DOWNTO 0) := (others => '0');

    
    signal S : std_logic_vector(7 DOWNTO 0);
    signal SEL_ROUTE : std_logic_vector (3 DOWNTO 0);
    signal INSTR : std_logic_vector(9 DOWNTO 0);

begin
    process(CLK, RESET)
        begin
            INSTR <= MEM_INSTRUCTIONS(to_integer(PC));
            SEL_FCT <= INSTR(9 DOWNTO 6);
            SEL_ROUTE <= INSTR(5 DOWNTO 2);
            SEL_OUT <= INSTR(1 DOWNTO 0);

            if RESET = '1' then
                PC <= (others => '0');
                Buffer_A <= (others => '0');
                Buffer_B  <= (others => '0');
                MEM_CACHE_1 <= (others => '0');
                MEM_CACHE_2 <= (others => '0');
                RES_OUT <= (others => '0');

            elsif rising_edge(CLK) then 
                PC <= PC +1;

                MEM_SR_IN_L <= SR_IN_L;
                MEM_SR_IN_R <= SR_IN_R;

                -- === Routage des données === 
                case SEL_ROUTE is
                    When "0000" => Buffer_A <= A_IN; -- Stockage de l'entrée A_IN dans Buffer_A
                    When "0001" => Buffer_B <= B_In; -- Stockage de l'entrée B_IN dans Buffer_B
                    When "0010" => Buffer_A <= S(3 DOWNTO 0); -- Stockage de S dans Buffer_A (4 bits de poids faibles)
                    When "0011" => Buffer_A <= S(7 DOWNTO 4); -- Stockage de S dans Buffer_A (4 bits de poids forts)
                    When "0100" => Buffer_B <= S(3 DOWNTO 0); -- Stockage de S dans Buffer_B (4 bits de poids faibles)
                    When "0101" => Buffer_B <= S(7 DOWNTO 4); -- Stockage de S dans Buffer_B (4 bits de poids forts)
                    When "0110" => MEM_CACHE_1 <= S; -- Stockage de S dans MEM_CACHE_1
                    When "0111" => MEM_CACHE_2 <= S; -- Stockage de S dans MEM_CACHE_2
                    When "1000" => Buffer_A <= MEM_CACHE_1(3 DOWNTO 0); -- Stockage de MEM_CACHE_1 dans Buffer_A (4 bits de poids faibles)
                    When "1001" => Buffer_A <= MEM_CACHE_1(7 DOWNTO 4); -- Stockage de MEM_CACHE_1 dans Buffer_A (4 bits de poids forts)
                    When "1010" => Buffer_B <= MEM_CACHE_1(3 DOWNTO 0); -- Stockage de MEM_CACHE_1 dans Buffer_B (4 bits de poids faibles)
                    When "1011" => Buffer_B <= MEM_CACHE_1(7 DOWNTO 4); -- Stockage de MEM_CACHE_1 dans Buffer_B (4 bits de poids forts)
                    When "1100" => Buffer_A <= MEM_CACHE_2(3 DOWNTO 0); -- Stockage de MEM_CACHE_2 dans Buffer_A (4 bits de poids faibles)
                    When "1101" => Buffer_A <= MEM_CACHE_2(7 DOWNTO 4); -- Stockage de MEM_CACHE_2 dans Buffer_A (4 bits de poids forts)
                    When "1110" => Buffer_B <= MEM_CACHE_2(3 DOWNTO 0); -- Stockage de MEM_CACHE_2 dans Buffer_B (4 bits de poids faibles)
                    When "1111" => Buffer_B <= MEM_CACHE_2(7 DOWNTO 4); -- Stockage de MEM_CACHE_2 dans Buffer_B (4 bits de poids forts)
                end case;

                -- === Sélection de la sortie (sel_out) ===
                case MEM_SEL_OUT is
                    When "00" => RES_OUT <= (others => '0');
                    When "01" => RES_OUT <= MEM_CACHE_1; -- sortie du cache 1
                    When "10" => RES_OUT <= MEM_CACHE_2; -- Sortie du cache 2
                    When "11" => RES_OUT <= S; -- Sortie directe de l'UAL
                end case;
            end if;
        end process;




end Behavioral;





