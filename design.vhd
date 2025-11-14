library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        clk_in     : in std_logic;
        btn_mode   : in std_logic;
        btn_action : in std_logic;

        sseg1 : out std_logic_vector(6 downto 0);
        sseg2 : out std_logic_vector(6 downto 0);
        sseg3 : out std_logic_vector(6 downto 0);
        sseg4 : out std_logic_vector(6 downto 0)
    );
end top;

architecture rtl of top is

    signal clk_1hz        : std_logic;
    signal watch_mode_sig : std_logic;
    signal stp_en_sig     : std_logic;
    signal set_hour_sig   : std_logic;
    signal set_min_sig    : std_logic;

begin

    clk_1hz <= clk_in;

    fsm_inst: entity work.fsm
        port map (
            btn_mode   => btn_mode,
            btn_action => btn_action,
            clk        => clk_in,

            watch_mode => watch_mode_sig,
            stpwtch_en => stp_en_sig,
            set_hour   => set_hour_sig,
            set_min    => set_min_sig
        );

    dp: entity work.datapath
        port map (
            clk_1hz    => clk_1hz,
            watch_mode => watch_mode_sig,
            stpwtch_en => stp_en_sig,
            set_hour   => set_hour_sig,
            action     => btn_action,

            sseg1 => sseg1,
            sseg2 => sseg2,
            sseg3 => sseg3,
            sseg4 => sseg4
        );

end rtl;
