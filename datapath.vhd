library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is
    port (
        clk_1hz    : in  std_logic;

        watch_mode : in  std_logic;
        stpwtch_en : in  std_logic;
        set_hour   : in  std_logic;
        action     : in  std_logic;

        sseg1 : out std_logic_vector(6 downto 0);
        sseg2 : out std_logic_vector(6 downto 0);
        sseg3 : out std_logic_vector(6 downto 0);
        sseg4 : out std_logic_vector(6 downto 0)
    );
end datapath;

architecture rtl of datapath is

    -- raw bcd outputs (unsigned)
    signal stp_sec1_bcd, stp_sec2_bcd, stp_min1_bcd, stp_min2_bcd : unsigned(3 downto 0);
    signal stp_sec1_cout, stp_sec2_cout, stp_min1_cout, stp_min2_cout : std_logic;

    signal w_sec_bcd, w_min1_bcd, w_min2_bcd, w_hour1_bcd, w_hour2_bcd : unsigned(3 downto 0);
    signal w_sec_cout, w_min1_cout, w_min2_cout, w_hour1_cout, w_hour2_cout : std_logic;

    -- converted bcd for port map (std_logic_vector)
    signal stp_sec1_q, stp_sec2_q, stp_min1_q, stp_min2_q : std_logic_vector(3 downto 0);
    signal w_sec_q, w_min1_q, w_min2_q, w_hour1_q, w_hour2_q : std_logic_vector(3 downto 0);

    -- mux outputs
    signal mux1_bcd, mux2_bcd, mux3_bcd, mux4_bcd : unsigned(3 downto 0);
    signal mux1_vec, mux2_vec, mux3_vec, mux4_vec : std_logic_vector(3 downto 0);

    -- aux signals for ORs that cannot be used directly in port map
    signal w_min1_clk  : std_logic;
    signal w_hour1_clk : std_logic;

begin

    -- conversion to std_logic_vector (mandatory)
    stp_sec1_q <= std_logic_vector(stp_sec1_bcd);
    stp_sec2_q <= std_logic_vector(stp_sec2_bcd);
    stp_min1_q <= std_logic_vector(stp_min1_bcd);
    stp_min2_q <= std_logic_vector(stp_min2_bcd);

    w_sec_q    <= std_logic_vector(w_sec_bcd);
    w_min1_q   <= std_logic_vector(w_min1_bcd);
    w_min2_q   <= std_logic_vector(w_min2_bcd);
    w_hour1_q  <= std_logic_vector(w_hour1_bcd);
    w_hour2_q  <= std_logic_vector(w_hour2_bcd);

    -- aux clock signals (cannot OR inside port map)
    w_min1_clk  <= w_sec_cout or (set_hour and action);
    w_hour1_clk <= w_min2_cout or (set_hour and action);

    -------------------------------------------------------------
    -- STOPWATCH
    -------------------------------------------------------------

    stp_sec1: entity work.counter
        generic map(N => 4)
        port map(
            CLK   => clk_1hz,
            CLEAR => '0',
            COUNT => stpwtch_en,
            LD    => '0',
            DIN   => (others => '0'),
            COUT  => stp_sec1_cout,
            Q     => stp_sec1_q
        );

    stp_sec2: entity work.counter
        generic map(N => 4)
        port map(
            CLK   => stp_sec1_cout,
            CLEAR => '0',
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            COUT  => stp_sec2_cout,
            Q     => stp_sec2_q
        );

    stp_min1: entity work.counter
        generic map(N => 4)
        port map(
            CLK   => stp_sec2_cout,
            CLEAR => '0',
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            COUT  => stp_min1_cout,
            Q     => stp_min1_q
        );

    stp_min2: entity work.counter
        generic map(N => 4)
        port map(
            CLK   => stp_min1_cout,
            CLEAR => '0',
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            COUT  => stp_min2_cout,
            Q     => stp_min2_q
        );

    -------------------------------------------------------------
    -- WATCH
    -------------------------------------------------------------

    w_sec: entity work.counter
        generic map(N => 4)
        port map(
            CLK   => clk_1hz,
            CLEAR => '0',
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            COUT  => w_sec_cout,
            Q     => w_sec_q
        );

    w_min1: entity work.counter
        generic map(N => 4)
        port map(
            CLK   => w_min1_clk,
            CLEAR => '0',
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            COUT  => w_min1_cout,
            Q     => w_min1_q
        );

    w_min2: entity work.counter
        generic map(N => 4)
        port map(
            CLK   => w_min1_cout,
            CLEAR => '0',
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            COUT  => w_min2_cout,
            Q     => w_min2_q
        );

    w_hour1: entity work.counter
        generic map(N => 4)
        port map(
            CLK   => w_hour1_clk,
            CLEAR => '0',
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            COUT  => w_hour1_cout,
            Q     => w_hour1_q
        );

    w_hour2: entity work.counter
        generic map(N => 4)
        port map(
            CLK   => w_hour1_cout,
            CLEAR => '0',
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            COUT  => w_hour2_cout,
            Q     => w_hour2_q
        );

    -------------------------------------------------------------
    -- MUXES
    -------------------------------------------------------------

    mux1: entity work.mux_2x1
        generic map(N => 4)
        port map(A => stp_sec1_bcd, B => w_min1_bcd, sel => watch_mode, dout => mux1_bcd);

    mux2: entity work.mux_2x1
        generic map(N => 4)
        port map(A => stp_sec2_bcd, B => w_min2_bcd, sel => watch_mode, dout => mux2_bcd);

    mux3: entity work.mux_2x1
        generic map(N => 4)
        port map(A => stp_min1_bcd, B => w_hour1_bcd, sel => watch_mode, dout => mux3_bcd);

    mux4: entity work.mux_2x1
        generic map(N => 4)
        port map(A => stp_min2_bcd, B => w_hour2_bcd, sel => watch_mode, dout => mux4_bcd);

    -------------------------------------------------------------
    -- VECTORS FOR DECODER
    -------------------------------------------------------------

    mux1_vec <= std_logic_vector(mux1_bcd);
    mux2_vec <= std_logic_vector(mux2_bcd);
    mux3_vec <= std_logic_vector(mux3_bcd);
    mux4_vec <= std_logic_vector(mux4_bcd);

    -------------------------------------------------------------
    -- DECODERS
    -------------------------------------------------------------

    dec1: entity work.decoder port map(BCD_IN => mux1_vec, SSEG => sseg1);
    dec2: entity work.decoder port map(BCD_IN => mux2_vec, SSEG => sseg2);
    dec3: entity work.decoder port map(BCD_IN => mux3_vec, SSEG => sseg3);
    dec4: entity work.decoder port map(BCD_IN => mux4_vec, SSEG => sseg4);

end rtl;
