library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is

    -- clock de simulacao
    constant CLK_PERIOD : time := 100 ms;

    signal clk_1hz    : std_logic := '0';

    -- sinais da datapath
    signal watch_mode : std_logic := '1';  -- modo relogio
    signal stpwtch_en : std_logic := '0';
    signal set_hour   : std_logic := '0';
    signal action     : std_logic := '0';

    signal s1, s2, s3, s4 : std_logic_vector(6 downto 0);

begin

    -- DUT (somente datapath)
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

    --------------------------------------------------------------------
    -- Clock 1 Hz artificial (100 ms = 0.1 s)
    --------------------------------------------------------------------
    clk_gen : process
    begin
        while now < 200 sec loop
            clk_1hz <= '0';
            wait for CLK_PERIOD / 2;
            clk_1hz <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    --------------------------------------------------------------------
    -- Nenhum estimulo extra: apenas deixa o relogio contar
    --------------------------------------------------------------------
    stim : process
    begin
        wait; -- nada a fazer, apenas observar a contagem
    end process;

end tb;
