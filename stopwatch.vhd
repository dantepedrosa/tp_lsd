library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity stopwatch is
    port (
        clock     : in  std_logic;
        count     : in  std_logic;
        reset     : in  std_logic;

        sec_units : out std_logic_vector(3 downto 0);
        sec_tens  : out std_logic_vector(3 downto 0);
        min_units : out std_logic_vector(3 downto 0);
        min_tens  : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of stopwatch is

    -- Saidas contadores
    signal q_sec_units, q_sec_tens : std_logic_vector(3 downto 0);
    signal q_min_units, q_min_tens : std_logic_vector(3 downto 0);

    signal cout_sec_units, cout_sec_tens : std_logic;
    signal cout_min_units, cout_min_tens : std_logic;

    -- Comparadores para deteccao de limite
    signal sec_units_over 	: std_logic;
    signal sec_tens_over  	: std_logic;
    signal min_units_over 	: std_logic;
    signal min_tens_over  	: std_logic;
    signal one_minute_pulse : std_logic;
    signal ten_minute_pulse	: std_logic;

    
    -- Comparadores para limpar os contadores
    signal sec_units_clear : std_logic;
    signal sec_tens_clear  : std_logic;
    signal min_units_clear : std_logic;
    signal min_tens_clear  : std_logic;

begin

    -- Comparacoes para detectar limite 
    sec_units_over <= '1' when unsigned(q_sec_units) = 9 else '0';
    sec_tens_over  <= '1' when unsigned(q_sec_tens)  = 5 else '0';
    min_units_over <= '1' when unsigned(q_min_units) = 9 else '0';
    min_tens_over  <= '1' when unsigned(q_min_tens)  = 5 else '0'; -- Inutilizado
    
    -- Para resetar corretamente os minutos
    one_minute_pulse <= sec_tens_over AND sec_units_over;
    ten_minute_pulse <= min_units_over AND one_minute_pulse;

    
    -- Comparacoes para limpar os contadores
    sec_units_clear <= reset;
    sec_tens_clear  <= reset;
    min_units_clear <= reset;
    min_tens_clear  <= reset;

    sec_units_counter : entity work.counter
        generic map (
            N => 4,
            MAX_VALUE => 9
        )
        port map (
            CLEAR => sec_units_clear,
            CLK   => clock,
            COUNT => count,
            Q     => q_sec_units,
            COUT  => cout_sec_units
        );

    sec_tens_counter : entity work.counter
        generic map (
            N => 4,
            MAX_VALUE => 5
        )
        port map (
            CLEAR => sec_tens_clear,
            CLK   => clock,
            COUNT => sec_units_over,
            Q     => q_sec_tens,
            COUT  => cout_sec_tens
        );

    min_units_counter : entity work.counter
        generic map (
            N => 4,
            MAX_VALUE => 9
        )
        port map (
            CLEAR => min_units_clear,
            CLK   => clock,
            COUNT => one_minute_pulse,
            Q     => q_min_units,
            COUT  => cout_min_units
        );

    min_tens_counter : entity work.counter
        generic map (
            N => 4,
            MAX_VALUE => 5
        )
        port map (
            CLEAR => min_tens_clear,
            CLK   => clock,
           	COUNT => ten_minute_pulse,
            Q     => q_min_tens,
            COUT  => cout_min_tens
        );

    sec_units <= q_sec_units;
    sec_tens  <= q_sec_tens;
    min_units <= q_min_units;
    min_tens  <= q_min_tens;

end architecture;
