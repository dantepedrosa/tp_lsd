library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_display_blink is
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
        set_hour   : in std_logic;   -- habilita blink hora
        set_min    : in std_logic;   -- habilita blink minuto
        pulse_1s   : in std_logic;   -- clock de 1 segundo

        -- Saídas 7 segmentos
        sseg1 : out std_logic_vector(6 downto 0);
        sseg2 : out std_logic_vector(6 downto 0);
        sseg3 : out std_logic_vector(6 downto 0);
        sseg4 : out std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of mux_display_blink is

    signal mux1_bcd, mux2_bcd, mux3_bcd, mux4_bcd : std_logic_vector(3 downto 0);
    signal blink_state : std_logic := '1';

begin

    -- Blink control
    process(pulse_1s)
    begin
        if rising_edge(pulse_1s) then
            blink_state <= not blink_state;
        end if;
    end process;

    -- Multiplexação com blink
    mux1_bcd <= stp_sec1_q when watch_mode = '0' else 
                (w_min1_q when (not set_min or blink_state = '1') else (others => '0'));
                
    mux2_bcd <= stp_sec2_q when watch_mode = '0' else 
                (w_min2_q when (not set_min or blink_state = '1') else (others => '0'));
                
    mux3_bcd <= stp_min1_q when watch_mode = '0' else 
                (w_hour1_q when (not set_hour or blink_state = '1') else (others => '0'));
                
    mux4_bcd <= stp_min2_q when watch_mode = '0' else 
                (w_hour2_q when (not set_hour or blink_state = '1') else (others => '0'));

    -- Decodificação BCD -> 7 segmentos
    dec1: entity work.decoder port map(BCD_IN => mux1_bcd, SSEG => sseg1);
    dec2: entity work.decoder port map(BCD_IN => mux2_bcd, SSEG => sseg2);
    dec3: entity work.decoder port map(BCD_IN => mux3_bcd, SSEG => sseg3);
    dec4: entity work.decoder port map(BCD_IN => mux4_bcd, SSEG => sseg4);

end architecture;
