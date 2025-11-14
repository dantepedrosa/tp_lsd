library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
      generic (
        N : integer := 6  -- número de bits (padrão = 6)
      );
    port (
        clk	: in STD_LOGIC;
        rst : in STD_LOGIC;
        count : in STD_LOGIC;
        A	: out unsigned(N-1 downto 0)
    );
end counter;

architecture behavior of counter is
    signal counter_reg : unsigned(N-1 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter_reg <= (others => '0');
            elsif count = '1' then
                counter_reg <= counter_reg + to_unsigned(1, N);
            end if;
        end if;
    end process;
    
    A <= counter_reg;
end behavior;