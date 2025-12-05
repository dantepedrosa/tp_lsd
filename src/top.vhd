-- TRABALHO PRÁTICO FINAL
-- arquivo: top.vhd
-- Arquivo principal que integra relógio, cronômetro, FSM e multiplexador de displays
-- Desenvolvido para utilização no kit Altera DE2
-- Desenvolvido por:
-- Dante Junqueira Pedrosa
-- Maria Eduarda Jotadiemel Antunes
-- Laboratório de Sistemas Digitais - Turma PN1

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_watch is
    port (
        SW   : in  std_logic_vector(2 downto 0);  -- botões de entrada
        HEX0  : out std_logic_vector(6 downto 0);  -- displays 7 segmentos
        HEX1  : out std_logic_vector(6 downto 0);
        HEX2  : out std_logic_vector(6 downto 0);
        HEX3  : out std_logic_vector(6 downto 0);
        CLOCK_50 : in std_logic                     -- clock 50 MHz do DE2
    );
end entity;

architecture rtl of top_watch is

    -- Sinais FSM
    signal watch_mode, stpwtch_en, rst_stpwtch, set_hour, set_min : std_logic;

    -- Sinais relógio
    signal min_units, min_tens, hour_units, hour_tens : std_logic_vector(3 downto 0);

    -- Sinais cronômetro
    signal sec_units, sec_tens, stp_min_units, stp_min_tens : std_logic_vector(3 downto 0);

    -- Sinais do clock auxiliar
    signal pulse_1s, pulse_1min : std_logic;

begin

    -----------------------------------------------------------------------
    -- Clock auxiliar
    -----------------------------------------------------------------------
    aux_clk_inst : entity work.auxiliary_clock
        port map(
            clk        => CLOCK_50,
            pulse_1s   => pulse_1s,
            pulse_1min => pulse_1min
        );

    -----------------------------------------------------------------------
    -- FSM
    -----------------------------------------------------------------------
    fsm_inst : entity work.fsm
        port map(
            btn_mode    => SW(0),
            btn_action  => SW(1),
            btn_set_rst => SW(2),
            clk         => CLOCK_50,
            watch_mode  => watch_mode,
            stpwtch_en  => stpwtch_en,
            rst_stpwtch => rst_stpwtch,
            set_hour    => set_hour,
            set_min     => set_min
        );

    -----------------------------------------------------------------------
    -- Relógio
    -----------------------------------------------------------------------
    watch_inst : entity work.watch
        port map(
            clock      => pulse_1min,  -- incrementa a cada minuto
            reset      => rst_stpwtch,
            inc_time   => SW(1),
            set_min    => set_min,
            set_hour   => set_hour,
            min_units  => min_units,
            min_tens   => min_tens,
            hour_units => hour_units,
            hour_tens  => hour_tens
        );

    -----------------------------------------------------------------------
    -- Cronômetro
    -----------------------------------------------------------------------
    stopwatch_inst : entity work.stopwatch
        port map(
            clock      => pulse_1s,  -- incrementa a cada segundo
            count      => stpwtch_en,
            reset      => rst_stpwtch,
            sec_units  => sec_units,
            sec_tens   => sec_tens,
            min_units  => stp_min_units,
            min_tens   => stp_min_tens
        );

    -----------------------------------------------------------------------
    -- Multiplexação e displays
    -----------------------------------------------------------------------
    mux_display_inst : entity work.mux_display
        port map(
            w_min1_q  => min_units,
            w_min2_q  => min_tens,
            w_hour1_q => hour_units,
            w_hour2_q => hour_tens,
            stp_sec1_q => sec_units,
            stp_sec2_q => sec_tens,
            stp_min1_q => stp_min_units,
            stp_min2_q => stp_min_tens,
            watch_mode => watch_mode,
            sseg1     => HEX0,
            sseg2     => HEX1,
            sseg3     => HEX2,
            sseg4     => HEX3
        );


end architecture;
