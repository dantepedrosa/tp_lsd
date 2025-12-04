library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_cronometro_subgrupo is
end entity;

architecture sim of tb_cronometro_subgrupo is

    -- DUT signals
    signal clock     : std_logic := '0';
    signal count     : std_logic := '0';
    signal reset     : std_logic := '0';

    signal sec_units : std_logic_vector(3 downto 0);
    signal sec_tens  : std_logic_vector(3 downto 0);
    signal min_units : std_logic_vector(3 downto 0);
    signal min_tens  : std_logic_vector(3 downto 0);

    -- Clock period
    constant CLK_PERIOD : time := 1 sec;

begin

    -----------------------------------------------------------------------
    -- CLOCK PROCESS
    -----------------------------------------------------------------------
    clock_process : process
    begin
        while true loop
            clock <= '0';
            wait for CLK_PERIOD/2;
            clock <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -----------------------------------------------------------------------
    -- DUT INSTANTIATION
    -----------------------------------------------------------------------
    dut : entity work.stopwatch
        port map (
            clock     => clock,
            count     => count,
            reset     => reset,
            sec_units => sec_units,
            sec_tens  => sec_tens,
            min_units => min_units,
            min_tens  => min_tens
        );

    -----------------------------------------------------------------------
    -- TEST SEQUENCE
    -----------------------------------------------------------------------
    stim_proc : process
    begin
        -- Estado inicial
        reset <= '1';
        count <= '0';
        wait for 2 sec;

        -- Libera reset
        reset <= '0';
        wait for 1 sec;

        -- Começa a contagem
        count <= '1';

        -- Deixe o cronômetro contar por 120 segundos simulados
        wait for 120 sec;

        -- Pausa
        count <= '0';
        wait for 5 sec;

        -- Continua
        count <= '1';
        wait for 20 sec;
        
        reset <= '1';
        wait for 3 sec;
        
        reset <= '0';
        wait for 20 sec;

        -- Finaliza simulação
        wait;
    end process;

end architecture;
