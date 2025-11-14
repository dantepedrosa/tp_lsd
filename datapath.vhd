library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is
    port (
        clk_1hz    : in  std_logic;

        -- sinais vindos da FSM
        watch_mode : in  std_logic;
        stpwtch_en : in  std_logic;
        set_hour   : in  std_logic;
        action     : in  std_logic;

        -- saidas finais dos displays
        sseg1 : out std_logic_vector(6 downto 0); -- unidades
        sseg2 : out std_logic_vector(6 downto 0); -- dezenas
        sseg3 : out std_logic_vector(6 downto 0); -- centenas
        sseg4 : out std_logic_vector(6 downto 0)  -- milhares
    );
end datapath;

architecture rtl of datapath is

    --------------------------------------------------------------------
    -- sinais internos dos contadores do stopwatch
    --------------------------------------------------------------------
    signal stp_sec1_bcd  : unsigned(3 downto 0);
    signal stp_sec2_bcd  : unsigned(3 downto 0);
    signal stp_min1_bcd  : unsigned(3 downto 0);
    signal stp_min2_bcd  : unsigned(3 downto 0);

    signal stp_sec1_cout : std_logic;
    signal stp_sec2_cout : std_logic;
    signal stp_min1_cout : std_logic;
    signal stp_min2_cout : std_logic;

    --------------------------------------------------------------------
    -- sinais internos dos contadores do watch
    --------------------------------------------------------------------
    signal w_sec_bcd     : unsigned(3 downto 0);
    signal w_min1_bcd    : unsigned(3 downto 0);
    signal w_min2_bcd    : unsigned(3 downto 0);
    signal w_hour1_bcd   : unsigned(3 downto 0);
    signal w_hour2_bcd   : unsigned(3 downto 0);

    signal w_sec_cout    : std_logic;
    signal w_min1_cout   : std_logic;
    signal w_min2_cout   : std_logic;
    signal w_hour1_cout  : std_logic;
    signal w_hour2_cout  : std_logic;

    --------------------------------------------------------------------
    -- sinais dos multiplexadores 2x1
    --------------------------------------------------------------------
    signal mux1_bcd, mux2_bcd, mux3_bcd, mux4_bcd : unsigned(3 downto 0);

begin

    --------------------------------------------------------------------
    -- STOPWATCH CONTADORES
    --------------------------------------------------------------------

    -- unidade de segundos (0..9)
    stp_sec1: entity work.counter
        generic map(N => 4)
        port map(
            clk   => clk_1hz,
            clr   => '1',              -- reset automatico interno (contador deve tratar)
            count => stpwtch_en,
            cout  => stp_sec1_cout,
            bcd   => stp_sec1_bcd
        );

    -- dezenas de segundos (0..5)
    stp_sec2: entity work.counter
        generic map(N => 4)
        port map(
            clk   => stp_sec1_cout,
            clr   => '1',
            count => '1',
            cout  => stp_sec2_cout,
            bcd   => stp_sec2_bcd
        );

    -- unidade de minutos (0..9)
    stp_min1: entity work.counter
        generic map(N => 4)
        port map(
            clk   => stp_sec2_cout,
            clr   => '1',
            count => '1',
            cout  => stp_min1_cout,
            bcd   => stp_min1_bcd
        );

    -- dezenas de minutos (0..5)
    stp_min2: entity work.counter
        generic map(N => 4)
        port map(
            clk   => stp_min1_cout,
            clr   => '1',
            count => '1',
            cout  => stp_min2_cout,
            bcd   => stp_min2_bcd
        );

    --------------------------------------------------------------------
    -- WATCH CONTADORES
    --------------------------------------------------------------------

    -- segundos (0..59)
    w_sec: entity work.counter
        generic map(N => 4)
        port map(
            clk   => clk_1hz,
            clr   => '1',
            count => '1',
            cout  => w_sec_cout,
            bcd   => w_sec_bcd
        );

    -- unidades de minutos (clk = cout anterior OR set_hour AND action)
    w_min1: entity work.counter
        generic map(N => 4)
        port map(
            clk   => w_sec_cout or (set_hour and action),
            clr   => '1',
            count => '1',
            cout  => w_min1_cout,
            bcd   => w_min1_bcd
        );

    -- dezenas de minutos
    w_min2: entity work.counter
        generic map(N => 4)
        port map(
            clk   => w_min1_cout,
            clr   => '1',
            count => '1',
            cout  => w_min2_cout,
            bcd   => w_min2_bcd
        );

    -- unidades de horas (clk = cout anterior OR set_hour AND action)
    w_hour1: entity work.counter
        generic map(N => 4)
        port map(
            clk   => w_min2_cout or (set_hour and action),
            clr   => '1',
            count => '1',
            cout  => w_hour1_cout,
            bcd   => w_hour1_bcd
        );

    -- dezenas de horas
    w_hour2: entity work.counter
        generic map(N => 4)
        port map(
            clk   => w_hour1_cout,
            clr   => '1',
            count => '1',
            cout  => w_hour2_cout,
            bcd   => w_hour2_bcd
        );

    --------------------------------------------------------------------
    -- MULTIPLEXADORES (watch_mode seleciona o que vai pro display)
    --------------------------------------------------------------------

    -- MUX1: unidades de minutos watch / unidades de segundos stopwatch
    mux1: entity work.mux_2x1
        generic map(N => 4)
        port map(
            A   => stp_sec1_bcd,
            B   => w_min1_bcd,
            sel => watch_mode,
            dout => mux1_bcd
        );

    -- MUX2: dezenas de minutos watch / dezenas de segundos stopwatch
    mux2: entity work.mux_2x1
        generic map(N => 4)
        port map(
            A   => stp_sec2_bcd,
            B   => w_min2_bcd,
            sel => watch_mode,
            dout => mux2_bcd
        );

    -- MUX3: unidades de horas watch / unidades de minutos stopwatch
    mux3: entity work.mux_2x1
        generic map(N => 4)
        port map(
            A   => stp_min1_bcd,
            B   => w_hour1_bcd,
            sel => watch_mode,
            dout => mux3_bcd
        );

    -- MUX4: dezenas de horas watch / dezenas de minutos stopwatch
    mux4: entity work.mux_2x1
        generic map(N => 4)
        port map(
            A   => stp_min2_bcd,
            B   => w_hour2_bcd,
            sel => watch_mode,
            dout => mux4_bcd
        );

    --------------------------------------------------------------------
    -- DECODIFICADORES DOS DISPLAYS
    --------------------------------------------------------------------
    dec1: entity work.decoder port map(BCD_IN => std_logic_vector(mux1_bcd), SSEG => sseg1);
    dec2: entity work.decoder port map(BCD_IN => std_logic_vector(mux2_bcd), SSEG => sseg2);
    dec3: entity work.decoder port map(BCD_IN => std_logic_vector(mux3_bcd), SSEG => sseg3);
    dec4: entity work.decoder port map(BCD_IN => std_logic_vector(mux4_bcd), SSEG => sseg4);

end rtl;
