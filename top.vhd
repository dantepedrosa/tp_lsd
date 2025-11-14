library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
    port (
        clk_in     : in std_logic;      -- clock da placa, ex 50MHz ou 100MHz
        btn_mode   : in std_logic;
        btn_action : in std_logic;

        -- saidas dos displays
        sseg1 : out std_logic_vector(6 downto 0);
        sseg2 : out std_logic_vector(6 downto 0);
        sseg3 : out std_logic_vector(6 downto 0);
        sseg4 : out std_logic_vector(6 downto 0)
    );
end top;

architecture rtl of top is

    --------------------------------------------------------------------
    -- sinais internos
    --------------------------------------------------------------------
    signal clk_1hz        : std_logic;
    signal mode_clean     : std_logic;
    signal action_clean   : std_logic;

    signal watch_mode_sig : std_logic;
    signal stp_en_sig     : std_logic;
    signal set_hour_sig   : std_logic;
    signal set_min_sig    : std_logic;

begin

    --------------------------------------------------------------------
    -- divisor de clock para gerar 1 Hz
    --------------------------------------------------------------------
    clkdiv: entity work.clock_div_1hz
        port map (
            clk_in  => clk_in,
            clk_out => clk_1hz
        );

    --------------------------------------------------------------------
    -- debouncers para botoes
    --------------------------------------------------------------------
    db_mode: entity work.debouncer
        port map (
            clk   => clk_in,
            btn   => btn_mode,
            clean => mode_clean
        );

    db_action: entity work.debouncer
        port map (
            clk   => clk_in,
            btn   => btn_action,
            clean => action_clean
        );

    --------------------------------------------------------------------
    -- FSM
    --------------------------------------------------------------------
    fsm_inst: entity work.fsm
        port map (
            btn_mode   => mode_clean,
            btn_action => action_clean,
            clk        => clk_in,

            watch_mode => watch_mode_sig,
            stpwtch_en => stp_en_sig,
            set_hour   => set_hour_sig,
            set_min    => set_min_sig
        );

    --------------------------------------------------------------------
    -- DATAPATH COMPLETO (relogio + cronometro + mux + decoders)
    --------------------------------------------------------------------
    dp: entity work.watch_stpwtch_datapath
        port map (
            clk_1hz    => clk_1hz,

            watch_mode => watch_mode_sig,
            stpwtch_en => stp_en_sig,
            set_hour   => set_hour_sig,
            action     => action_clean,

            sseg1 => sseg1,
            sseg2 => sseg2,
            sseg3 => sseg3,
            sseg4 => sseg4
        );

end rtl;
