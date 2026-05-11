library ieee;
use ieee.std_logic_1164.all;

entity lfsr_4bits is
	port (
		clk   : in  std_logic;
		eset : in  std_logic;
		enable : in std_logic;
		rnd : out std_logic_vector(3 downto 0)
	);
end entity;

architecture rtl of lfsr_4bits is
	signal reg : std_logic_vector(1 to 4) := "1011";
	signal counter : interger range 0 to 99999 := 0;
	signal tick : std_logic := '0';
begin
	process(clk)
	begin
		if rising_edge(clk) then 
			if reset = '1' then
				tick <= '0';
			elsif counter = 99999 then
				counter <= 0;
				tick <= '1';
			else
				couter <= counter + 1;
				tick = '0';
			end if;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then 
			if reset = '1' then
				reg <= '1011'
			elsif enable ='1' and tick = '1' then
				reg <= (reg(3) xor reg(4)) & reg(1 to 3);
			end if;
		end if;
	end process;

	rnd <= reg;
end architecture;