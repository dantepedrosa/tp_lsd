-- TRABALHO PRÁTICO FINAL
-- arquivo: tb_watch.vhd
-- Testbench para o arquivo watch.vhd
-- Desenvolvido por:
-- Dante Junqueira Pedrosa
-- Maria Eduarda Jotadiemel Antunes
-- Laboratório de Sistemas Digitais - Turma PN1

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_watch is
end entity;

architecture sim of tb_watch is

    -- DUT signals
    signal clock     : std_logic := '0';
    signal reset     : std_logic := '0';
    signal inc_time  : std_logic := '0';
    signal set_min   : std_logic := '0';
    signal set_hour  : std_logic := '0';

    signal min_units : std_logic_vector(3 downto 0);
    signal min_tens  : std_logic_vector(3 downto 0);
    signal hour_units : std_logic_vector(3 downto 0);
    signal hour_tens  : std_logic_vector(3 downto 0);

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
    dut : entity work.watch
        port map (
            clock      => clock,
            reset      => reset,
            inc_time   => inc_time,
            set_min    => set_min,
            set_hour   => set_hour,
            min_units  => min_units,
            min_tens   => min_tens,
            hour_units => hour_units,
            hour_tens  => hour_tens
        );


    -----------------------------------------------------------------------
    -- TEST SEQUENCE
    -----------------------------------------------------------------------
    stim_proc : process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 2 sec;

        -- Libera reset
        reset <= '0';
        wait for 5 sec;

        -- Nada mais - demais sinais ignorados
        wait;
    end process;

end architecture;
