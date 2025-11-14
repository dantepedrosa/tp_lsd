library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is
    port (
        clk_1hz    : in  std_logic;

        watch_mode : in  std_logic;  -- 0: stopwatch, 1: watch (relogio)
        stpwtch_en : in  std_logic;  -- habilita incremento do cronometro
        set_rst    : in  std_logic;  -- modo ajuste de hora e reset de cronometro
        action     : in  std_logic;  -- acao para ajustar/avancar hora

        sseg1 : out std_logic_vector(6 downto 0); -- segmentos unidade direita
        sseg2 : out std_logic_vector(6 downto 0);
        sseg3 : out std_logic_vector(6 downto 0);
        sseg4 : out std_logic_vector(6 downto 0)  -- segmentos mais significativos
    );
end datapath;

architecture rtl of datapath is

    -- BCD e sinais de carry para cronometro (stopwatch)
    signal stp_sec1_q, stp_sec2_q, stp_min1_q, stp_min2_q : std_logic_vector(3 downto 0);
    signal stp_sec1_cout, stp_sec2_cout, stp_min1_cout, stp_min2_cout : std_logic;

    -- BCD e sinais de carry para relogio (watch)
    signal w_sec_q, w_min1_q, w_min2_q, w_hour1_q, w_hour2_q : std_logic_vector(3 downto 0);
    signal w_sec_cout, w_min1_cout, w_min2_cout, w_hour1_cout, w_hour2_cout : std_logic;

    -- Multiplexadores
    signal mux1_bcd, mux2_bcd, mux3_bcd, mux4_bcd : unsigned(3 downto 0);
    signal mux1_vec, mux2_vec, mux3_vec, mux4_vec : std_logic_vector(3 downto 0);

    -- clocks internos para minutos/horas do relogio
    signal w_min1_clk, w_hour1_clk : std_logic;

    -- reset automático às 24 horas
    signal reset_hours : std_logic;

begin

    -- Gerar reset automático quando hora = 24
    reset_hours <= '1' when (w_hour2_q = "0010" and w_hour1_q = "0100") else '0';

    -- Clocks para relogio
    w_min1_clk  <= w_sec_cout or (set_rst and action);
    w_hour1_clk <= w_min2_cout or (set_rst and action);

    -- Contadores do cronometro (stopwatch)
    stp_sec1: entity work.counter
        generic map(N => 4, MAX_VALUE => 9)
        port map(
            CLK   => clk_1hz,
            CLEAR => set_rst,
            COUNT => stpwtch_en,
            Q     => stp_sec1_q,
            COUT  => stp_sec1_cout
        );

    stp_sec2: entity work.counter
        generic map(N => 4, MAX_VALUE => 5)
        port map(
            CLK   => stp_sec1_cout,
            CLEAR => set_rst,
            COUNT => '1',
            Q     => stp_sec2_q,
            COUT  => stp_sec2_cout
        );


    -- unidades de minutos
    stp_min1: entity work.counter
        generic map(N => 4, MAX_VALUE => 9)
        port map(
            CLK   => stp_sec2_cout,
            CLEAR => set_rst,
            COUNT => '1',
            Q     => stp_min1_q,
            COUT  => stp_min1_cout
        );

    -- dezendas de minutos
    stp_min2: entity work.counter
        generic map(N => 4, MAX_VALUE => 5)
        port map(
            CLK   => stp_min1_cout,
            CLEAR => set_rst,
            COUNT => '1',
            Q     => stp_min2_q,
            COUT  => stp_min2_cout
        );

    -- CONTADORES DE SEGUNDOS (RELÓGIO) 
    -- (Este contador não é mostrado em nenhum display)
    w_sec: entity work.counter
        generic map(N => 4, MAX_VALUE => 59)
        port map(
            CLK   => clk_1hz,
            CLEAR => '0',
            COUNT => '1',
            Q     => w_sec_q,
            COUT  => w_sec_cout
        );

    -- CONTADORES DE MINUTOS (RELÓGIO)

    -- unidades de minutos
    w_min1: entity work.counter
        generic map(N => 4, MAX_VALUE => 9)
        port map(
            CLK   => w_min1_clk,
            CLEAR => '0',
            COUNT => '1',
            Q     => w_min1_q,
            COUT  => w_min1_cout
        );

    -- dezenas de minutos
    w_min2: entity work.counter
        generic map(N => 4, MAX_VALUE => 5)
        port map(
            CLK   => w_min1_cout,
            CLEAR => '0',
            COUNT => '1',
            Q     => w_min2_q,
            COUT  => w_min2_cout
        );


    -- CONTADORES DE HORAS (RELÓGIO)

    -- dezenas de horas
    w_hour1: entity work.counter
        generic map(N => 4, MAX_VALUE => 9)  -- unidades
        port map(
            CLK   => w_hour1_clk,
            CLEAR => reset_hours,
            COUNT => '1',
            Q     => w_hour1_q,
            COUT  => w_hour1_cout
        );

    -- unidades de horas
    w_hour2: entity work.counter
        generic map(N => 4, MAX_VALUE => 2)  -- dezenas
        port map(
            CLK   => w_hour1_cout,
            CLEAR => reset_hours,
            COUNT => '1',
            Q     => w_hour2_q,
            COUT  => w_hour2_cout
        );


    -- Multiplexadores para escolher entre cronometro e relogio
    mux1_bcd <= unsigned(stp_sec1_q) when watch_mode = '0' else unsigned(w_min1_q);
    mux2_bcd <= unsigned(stp_sec2_q) when watch_mode = '0' else unsigned(w_min2_q);
    mux3_bcd <= unsigned(stp_min1_q) when watch_mode = '0' else unsigned(w_hour1_q);
    mux4_bcd <= unsigned(stp_min2_q) when watch_mode = '0' else unsigned(w_hour2_q);

    mux1_vec <= std_logic_vector(mux1_bcd);
    mux2_vec <= std_logic_vector(mux2_bcd);
    mux3_vec <= std_logic_vector(mux3_bcd);
    mux4_vec <= std_logic_vector(mux4_bcd);

    -- Decodificadores BCD -> 7-segmentos
    dec1: entity work.decoder port map(BCD_IN => mux1_vec, SSEG => sseg1);
    dec2: entity work.decoder port map(BCD_IN => mux2_vec, SSEG => sseg2);
    dec3: entity work.decoder port map(BCD_IN => mux3_vec, SSEG => sseg3);
    dec4: entity work.decoder port map(BCD_IN => mux4_vec, SSEG => sseg4);

end rtl;
