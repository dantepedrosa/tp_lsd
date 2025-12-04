library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity one_second is
    port (
        clk      : in  std_logic;   -- 50 MHz do DE2
        pulse_1s : out std_logic
    );
end entity;

architecture rtl of one_second is
    signal cnt : unsigned(25 downto 0) := (others => '0');
    signal p   : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            p <= '0';  -- padrão

            if cnt = 50_000_000-1 then
                cnt <= (others => '0');
                p <= '1';  -- pulso
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    pulse_1s <= p;
end architecture;
