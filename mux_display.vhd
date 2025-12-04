library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_display is
    port(
        -- Relógio
        w_min1_q  : in std_logic_vector(3 downto 0);
        w_min2_q  : in std_logic_vector(3 downto 0);
        w_hour1_q : in std_logic_vector(3 downto 0);
        w_hour2_q : in std_logic_vector(3 downto 0);

        -- Cronômetro
        stp_sec1_q : in std_logic_vector(3 downto 0);
        stp_sec2_q : in std_logic_vector(3 downto 0);
        stp_min1_q : in std_logic_vector(3 downto 0);
        stp_min2_q : in std_logic_vector(3 downto 0);

        watch_mode : in std_logic;

        -- Saídas 7 segmentos
        sseg1 : out std_logic_vector(6 downto 0);
        sseg2 : out std_logic_vector(6 downto 0);
        sseg3 : out std_logic_vector(6 downto 0);
        sseg4 : out std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of mux_display is

    -- Sinais internos BCD multiplexados
    signal mux1_bcd, mux2_bcd, mux3_bcd, mux4_bcd : std_logic_vector(3 downto 0);

begin

    -- Multiplexação
    mux1_bcd <= stp_sec1_q when watch_mode = '0' else w_min1_q;
    mux2_bcd <= stp_sec2_q when watch_mode = '0' else w_min2_q;
    mux3_bcd <= stp_min1_q when watch_mode = '0' else w_hour1_q;
    mux4_bcd <= stp_min2_q when watch_mode = '0' else w_hour2_q;

    -- Decodificação BCD -> 7 segmentos
    dec1: entity work.decoder port map(BCD_IN => mux1_bcd, SSEG => sseg1);
    dec2: entity work.decoder port map(BCD_IN => mux2_bcd, SSEG => sseg2);
    dec3: entity work.decoder port map(BCD_IN => mux3_bcd, SSEG => sseg3);
    dec4: entity work.decoder port map(BCD_IN => mux4_bcd, SSEG => sseg4);

end architecture;
