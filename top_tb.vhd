library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end entity;

architecture tb of top_tb is

    -- sinais do top
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';

    signal btn_start : std_logic := '0';
    signal btn_stop  : std_logic := '0';
    signal btn_mode  : std_logic := '0';

    -- saídas (ajuste conforme seu top)
    signal sseg0     : std_logic_vector(6 downto 0);
    signal sseg1     : std_logic_vector(6 downto 0);
    signal sseg2     : std_logic_vector(6 downto 0);
    signal sseg3     : std_logic_vector(6 downto 0);

begin
    --------------------------------------------------------------------
    -- instancia do DUT (Device Under Test)
    --------------------------------------------------------------------
    DUT: entity work.top
        port map(
            CLK       => clk,
            RST       => rst,
            BTN_START => btn_start,
            BTN_STOP  => btn_stop,
            BTN_MODE  => btn_mode,
            SSEG0     => sseg0,
            SSEG1     => sseg1,
            SSEG2     => sseg2,
            SSEG3     => sseg3
        );

    --------------------------------------------------------------------
    -- clock  (10 ns -> 100 MHz; ajuste se quiser)
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end process;

    --------------------------------------------------------------------
    -- reset
    --------------------------------------------------------------------
    stim_reset : process
    begin
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait;
    end process;

    --------------------------------------------------------------------
    -- estimulos gerais
    --------------------------------------------------------------------
    stim_process : process
    begin
        wait for 50 ns;

        --------------------------------------------------------------
        -- modo: watch
        --------------------------------------------------------------
        btn_mode <= '1'; wait for 20 ns;
        btn_mode <= '0'; wait for 80 ns;

        --------------------------------------------------------------
        -- start cronometro (depende da FSM configurada)
        --------------------------------------------------------------
        btn_start <= '1'; wait for 20 ns;
        btn_start <= '0';

        wait for 500 ns;

        --------------------------------------------------------------
        -- stop cronometro
        --------------------------------------------------------------
        btn_stop <= '1'; wait for 20 ns;
        btn_stop <= '0';

        wait for 300 ns;

        --------------------------------------------------------------
        -- troca modo novamente
        --------------------------------------------------------------
        btn_mode <= '1'; wait for 20 ns;
        btn_mode <= '0';

        wait for 500 ns;

        --------------------------------------------------------------
        -- fim da simulacao
        --------------------------------------------------------------
        wait;
    end process;

end architecture;
