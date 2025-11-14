library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is

    signal clk        : std_logic := '0';
    signal btn_mode   : std_logic := '0';
    signal btn_action : std_logic := '0';

    signal s1, s2, s3, s4 : std_logic_vector(6 downto 0);

begin

    uut: entity work.top
        port map(
            clk_in     => clk,
            btn_mode   => btn_mode,
            btn_action => btn_action,
            sseg1      => s1,
            sseg2      => s2,
            sseg3      => s3,
            sseg4      => s4
        );

    clk_gen : process
    begin
        clk <= '0';
        wait for 500 ms;
        clk <= '1';
        wait for 500 ms;
    end process;

    stim : process
    begin
        wait for 2 sec;
        btn_mode <= '1';
        wait for 1 sec;
        btn_mode <= '0';

        wait for 3 sec;
        btn_action <= '1';
        wait for 1 sec;
        btn_action <= '0';

        wait;
    end process;

end tb;
