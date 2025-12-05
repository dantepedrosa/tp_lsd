library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity auxiliary_clock is
    port (
        clk        : in  std_logic;
        pulse_1s   : out std_logic;
        pulse_1min : out std_logic
    );
end auxiliary_clock;

architecture rtl of auxiliary_clock is

    -- sinais de saida dos counters
    signal cout_1s  : std_logic;
    signal cout_min : std_logic;

begin

    ----------------------------------------------------------------
    -- Contador de 1 segundo
    ----------------------------------------------------------------
    sec_counter_inst : entity work.counter
        generic map (
            N => 26,                       -- 2^26 = 67M
            MAX_VALUE => 50_000_000 - 1    -- 1 segundo
        )
        port map (
            CLEAR => '0',                  -- sempre ligado
            CLK   => clk,
            COUNT => '1',                  -- sempre contando
            Q     => open,
            COUT  => cout_1s
        );

    ----------------------------------------------------------------
    -- Contador de 60 segundos
    ----------------------------------------------------------------
    min_counter_inst : entity work.counter
        generic map (
            N => 6,            -- 2^6 = 64
            MAX_VALUE => 59    -- 60 segundos
        )
        port map (
            CLEAR => '0',
            CLK   => clk,
            COUNT => cout_1s,  -- so conta quando completar 1s
            Q     => open,
            COUT  => cout_min
        );

    ----------------------------------------------------------------
    -- Pulsos diretamente dos COUTs
    ----------------------------------------------------------------
    pulse_1s   <= cout_1s;
    pulse_1min <= cout_min;

end rtl;
