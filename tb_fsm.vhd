library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_fsm is
end entity;

architecture sim of tb_fsm is

    -- DUT signals
    signal clk         : std_logic := '0';
    signal btn_mode    : std_logic := '0';
    signal btn_action  : std_logic := '0';
    signal btn_set_rst : std_logic := '0';

    signal watch_mode  : std_logic;
    signal stpwtch_en  : std_logic;
    signal rst_stpwtch : std_logic;
    signal set_hour    : std_logic;
    signal set_min     : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    -----------------------------------------------------------------------
    -- CLOCK PROCESS (com tempo controlado para encerrar simulacao)
    -----------------------------------------------------------------------
    clk_process : process
    begin
        while now < 300*CLK_PERIOD loop  -- Ajuste o número de ciclos necessários
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;  -- finaliza simulacao
    end process;

    -----------------------------------------------------------------------
    -- DUT INSTANTIATION
    -----------------------------------------------------------------------
    dut: entity work.fsm
        port map (
            clk         => clk,
            btn_mode    => btn_mode,
            btn_action  => btn_action,
            btn_set_rst => btn_set_rst,
            watch_mode  => watch_mode,
            stpwtch_en  => stpwtch_en,
            rst_stpwtch => rst_stpwtch,
            set_hour    => set_hour,
            set_min     => set_min
        );

    -----------------------------------------------------------------------
    -- TEST SEQUENCE
    -----------------------------------------------------------------------
    stim_proc: process
    begin
        -- Test 1: Reset com cronometro rodando
        btn_mode <= '1'; wait for 5*CLK_PERIOD; btn_mode <= '0';
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0';
        btn_set_rst <= '1'; wait for 5*CLK_PERIOD; btn_set_rst <= '0';
        btn_mode <= '1'; wait for 5*CLK_PERIOD; btn_mode <= '0';
        wait for 20*CLK_PERIOD;

        -- Test 2: Rodar e resetar cronometro parado
        btn_mode <= '1'; wait for 5*CLK_PERIOD; btn_mode <= '0';
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0';
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0';
        btn_set_rst <= '1'; wait for 5*CLK_PERIOD; btn_set_rst <= '0';
        btn_mode <= '1'; wait for 5*CLK_PERIOD; btn_mode <= '0';
        wait for 20*CLK_PERIOD;

        -- Test 3: Ajustar horas
        btn_set_rst <= '1'; wait for 5*CLK_PERIOD; btn_set_rst <= '0'; 
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0'; wait for 5*CLK_PERIOD;
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0'; wait for 5*CLK_PERIOD;
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0'; wait for 5*CLK_PERIOD;
        btn_set_rst <= '1'; wait for 5*CLK_PERIOD; btn_set_rst <= '0';
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0'; wait for 5*CLK_PERIOD;
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0'; wait for 5*CLK_PERIOD;
        btn_set_rst <= '1'; wait for 5*CLK_PERIOD; btn_set_rst <= '0';
        wait for 20*CLK_PERIOD;

        -- Test 4: Deixar cronometro rodando
        btn_mode <= '1'; wait for 5*CLK_PERIOD; btn_mode <= '0';
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0';
        btn_mode <= '1'; wait for 5*CLK_PERIOD; btn_mode <= '0';
        btn_mode <= '1'; wait for 5*CLK_PERIOD; btn_mode <= '0';
        btn_set_rst <= '1'; wait for 5*CLK_PERIOD; btn_set_rst <= '0';
        btn_mode <= '1'; wait for 5*CLK_PERIOD; btn_mode <= '0';
        wait for 20*CLK_PERIOD;

        -- Test 5: Comando ilegal
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0';wait for 5*CLK_PERIOD;
        btn_action <= '1'; wait for 5*CLK_PERIOD; btn_action <= '0';wait for 5*CLK_PERIOD;
        btn_set_rst <= '1'; wait for 5*CLK_PERIOD; btn_set_rst <= '0';wait for 5*CLK_PERIOD;
        btn_mode <= '1'; wait for 5*CLK_PERIOD; btn_mode <= '0';wait for 5*CLK_PERIOD;
        wait for 50*CLK_PERIOD;

        wait;  -- espera o clock_process finalizar
    end process;

end architecture;
