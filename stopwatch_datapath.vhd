library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity stpwtch_datapath is
    port(
        clk_1hz      : in std_logic;
        stpwtch_en   : in std_logic;
        rst_stpwtch  : in std_logic;

        sec1_q       : out std_logic_vector(3 downto 0);
        sec2_q       : out std_logic_vector(3 downto 0);
        min1_q       : out std_logic_vector(3 downto 0);
        min2_q       : out std_logic_vector(3 downto 0)
    );
end stpwtch_datapath;

architecture rtl of stpwtch_datapath is

    signal cout_sec1 : std_logic;
    signal cout_sec2 : std_logic;
    signal cout_min1 : std_logic;
    signal cout_min2 : std_logic;

begin

    -- SEC1 (0..9)
    sec1: entity work.counter
        generic map(N => 4)
        port map(
            CLEAR => rst_stpwtch or (cout_sec1),
            CLK   => clk_1hz,
            COUNT => stpwtch_en,
            LD    => '0',
            DIN   => (others => '0'),
            Q     => sec1_q,
            COUT  => cout_sec1
        );

    -- SEC2 (0..5)
    sec2: entity work.counter
        generic map(N => 4)
        port map(
            CLEAR => rst_stpwtch or (cout_sec2),
            CLK   => cout_sec1,
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            Q     => sec2_q,
            COUT  => cout_sec2
        );

    -- MIN1 (0..9)
    min1: entity work.counter
        generic map(N => 4)
        port map(
            CLEAR => rst_stpwtch or (cout_min1),
            CLK   => cout_sec2,
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            Q     => min1_q,
            COUT  => cout_min1
        );

    -- MIN2 (0..5)
    min2: entity work.counter
        generic map(N => 4)
        port map(
            CLEAR => rst_stpwtch or (cout_min2),
            CLK   => cout_min1,
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            Q     => min2_q,
            COUT  => cout_min2
        );

end rtl;
