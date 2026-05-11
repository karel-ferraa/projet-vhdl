library ieee;
use ieee.std_logic_1164.all;

entity lfsr_4bits is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        q_out : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of lfsr_4bits is
    signal reg : std_logic_vector(1 to 4) := "0001";
begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg <= "0001";
        elsif rising_edge(clk) then
            reg <= (reg(3) xor reg(4)) & reg(1 to 3);
        end if;
    end process;

    q_out <= reg;
end architecture;