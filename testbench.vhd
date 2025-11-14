-- AULA 12 - TRABALHO PRÁTICO FINAL
-- arquivo: testbench.vhd
-- Testbench para relógio/cronômetro (watch/stopwatch)
-- Desenvolvido por:
-- Dante Junqueira Pedrosa
-- Maria Eduarda Jotadiemel Antunes
-- Laboratório de Sistemas Digitais - Turma PN1

library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is

    -- clock 10 Hz apenas para simulacao
    constant CLK_PERIOD : time := 100 ms;

    signal clk_1hz    : std_logic := '0';

    -- sinais da datapath
    signal watch_mode : std_logic := '1';  -- comeca no modo relogio
    signal stpwtch_en : std_logic := '0';  -- timer desligado
    signal set_hour   : std_logic := '0';
    signal action     : std_logic := '0';

    -- displays
    signal s1, s2, s3, s4 : std_logic_vector(6 downto 0);

begin

    uut: entity work.datapath
        port map(
            clk_1hz    => clk_1hz,
            watch_mode => watch_mode,
            stpwtch_en => stpwtch_en,
            set_hour   => set_hour,
            action     => action,
            sseg1      => s1,
            sseg2      => s2,
            sseg3      => s3,
            sseg4      => s4
        );


    -- clock 10 Hz para simulacao
    clk_gen : process
    begin
        while now < 60 sec loop
            clk_1hz <= '0';
            wait for CLK_PERIOD / 2;
            clk_1hz <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stim : process
    begin
        ------------------------------------------------------------
        -- 1 - Relogio por 15 segundos
        ------------------------------------------------------------
        watch_mode <= '1';   -- modo relogio
        stpwtch_en <= '0';
        wait for 15 sec;

        ------------------------------------------------------------
        -- 2) Modo timer: inicia, roda por 10s, pausa e reseta
        ------------------------------------------------------------
        watch_mode <= '0';   -- muda para modo timer

        -- iniciar timer
        stpwtch_en <= '1';
        wait for 10 sec;

        -- pausar
        stpwtch_en <= '0';
        wait for 1 sec;

        -- resetar timer
        -- assumindo set_hour = reset do timer (ajuste se necessario)
        set_hour <= '1';
        action   <= '1';
        wait for 200 ms;     -- pulso rapido
        set_hour <= '0';
        action   <= '0';

        wait for 2 sec;

        ------------------------------------------------------------
        -- 3) Voltar para relogio por 15 s
        ------------------------------------------------------------
        watch_mode <= '1';   -- volta relogio
        stpwtch_en <= '0';
        wait for 15 sec;

        wait;
    end process;

end tb;
