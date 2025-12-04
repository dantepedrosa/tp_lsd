library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity auxiliary_clock is
    port (
        clk       : in  std_logic;    -- clock principal (50 MHz)
        pulse_1s  : out std_logic;    -- pulso a cada 1 segundo
        pulse_1min: out std_logic     -- pulso a cada 60 segundos
    );
end entity;

architecture rtl of auxiliary_clock is
    -- contador para gerar pulso de 1 segundo
    signal cnt_1s  : unsigned(25 downto 0) := (others => '0');
    signal p_1s    : std_logic := '0';

    -- contador de segundos para gerar pulso de 1 minuto
    signal sec_cnt : unsigned(5 downto 0) := (others => '0');
    signal p_1min  : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- default: sem pulso
            p_1s <= '0';
            p_1min <= '0';

            -- gerar pulso 1 segundo
            if cnt_1s = 50_000_000-1 then
                cnt_1s <= (others => '0');
                p_1s <= '1';

                -- gerar pulso 1 minuto após 60 segundos
                if sec_cnt = 59 then
                    sec_cnt <= (others => '0');
                    p_1min <= '1';
                else
                    sec_cnt <= sec_cnt + 1;
                end if;
            else
                cnt_1s <= cnt_1s + 1;
            end if;
        end if;
    end process;

    pulse_1s   <= p_1s;
    pulse_1min <= p_1min;

end architecture;
