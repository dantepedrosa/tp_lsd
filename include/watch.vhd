library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity watch is
    port (
        clock     : in  std_logic;
        reset     : in  std_logic;
        inc_time  : in  std_logic;
        set_min   : in  std_logic;
        set_hour  : in  std_logic;

        min_units : out std_logic_vector(3 downto 0);
        min_tens  : out std_logic_vector(3 downto 0);
        hour_units : out std_logic_vector(3 downto 0);
        hour_tens  : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of watch is

    -- Saidas contadores
    signal q_min_units, q_min_tens : std_logic_vector(3 downto 0);
    signal q_hour_units, q_hour_tens : std_logic_vector(3 downto 0);
    signal cout_min_units, cout_min_tens : std_logic;
    signal cout_hour_units, cout_hour_tens : std_logic;

    -- Para setar horas e minutos
    signal inc_minutes, inc_hours : std_logic;

    -- Para lidar com reset complexo das horas
    signal reset_hours : std_logic;

    -- Comparadores para deteccao de limite
    signal min_units_over 	: std_logic;
    signal min_tens_over  	: std_logic;
    signal hour_units_over  : std_logic;
    signal hour_tens_over 	: std_logic;

begin

    -- Para lidar com incremento de minutos e horas
    inc_minutes <= (inc_time AND set_min) OR clock;
    inc_hours   <= (inc_time AND set_hour) OR cout_min_tens;
    
    -- Para lidar com reset complexo das horas
    reset_hours <= 
    '1' when (
        (inc_hours = '1') and
        (unsigned(q_hour_tens) = 2) and
        (unsigned(q_hour_units) = 4)
    )
    else '0';

    min_units_counter : entity work.counter
        generic map (
            N => 4,
            MAX_VALUE => 9
        )
        port map (
            CLEAR => '0',
            CLK   => inc_minutes,
            COUNT => '1',
            Q     => q_min_units,
            COUT  => cout_min_units
        );

    min_tens_counter : entity work.counter
        generic map (
            N => 4,
            MAX_VALUE => 5
        )
        port map (
            CLEAR => '0',
            CLK   => cout_min_units,
            COUNT => '1',
            Q     => q_min_tens,
            COUT  => cout_min_tens
        );

    hour_units_counter : entity work.counter
        generic map (
            N => 4,
            MAX_VALUE => 9
        )
        port map (
            CLEAR => reset_hours,
            CLK   => inc_hours,
            COUNT => '1',
            Q     => q_hour_units,
            COUT  => cout_hour_units
        );

    hour_tens_counter : entity work.counter
        generic map (
            N => 4,
            MAX_VALUE => 5
        )
        port map (
            CLEAR => reset_hours,
            CLK   => cout_hour_units,
           	COUNT => '1',
            Q     => q_hour_tens,
            COUT  => cout_hour_tens
        );

    min_units <= q_min_units;
    min_tens  <= q_min_tens;
    hour_units <= q_hour_units;
    hour_tens  <= q_hour_tens;

end architecture;
