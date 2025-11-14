library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity watch_datapath is
    port(
        clk_1hz     : in std_logic;
        action_btn  : in std_logic;
        set_min     : in std_logic;
        set_hour    : in std_logic;
        watch_clear : in std_logic;

        hour2_q     : out std_logic_vector(3 downto 0);
        hour1_q     : out std_logic_vector(3 downto 0);
        min2_q      : out std_logic_vector(3 downto 0);
        min1_q      : out std_logic_vector(3 downto 0);
        sec_q       : out std_logic_vector(3 downto 0)
    );
end watch_datapath;

architecture rtl of watch_datapath is

    signal cout_sec  : std_logic;
    signal cout_min1 : std_logic;
    signal cout_min2 : std_logic;
    signal cout_hr1  : std_logic;
    signal cout_hr2  : std_logic;

begin

    -- SEC (0..59) formato BINARIO (6 bits internos)
    sec_counter: entity work.counter
        generic map(N => 6)
        port map(
            CLEAR => watch_clear,
            CLK   => clk_1hz,
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            Q     => sec_q,
            COUT  => cout_sec
        );

    -- MIN1 (0..9)
    min1: entity work.counter
        generic map(N => 4)
        port map(
            CLEAR => watch_clear or cout_min1,
            CLK   => cout_sec or (set_min and action_btn),
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
            CLEAR => watch_clear or cout_min2,
            CLK   => cout_min1 or (set_min and action_btn),
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            Q     => min2_q,
            COUT  => cout_min2
        );

    -- HOUR1 (0..9)
    hour1: entity work.counter
        generic map(N => 4)
        port map(
            CLEAR => watch_clear or cout_hr1,
            CLK   => cout_min2 or (set_hour and action_btn),
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            Q     => hour1_q,
            COUT  => cout_hr1
        );

    -- HOUR2 (0..2)
    hour2: entity work.counter
        generic map(N => 4)
        port map(
            CLEAR => watch_clear or cout_hr2,
            CLK   => cout_hr1 or (set_hour and action_btn),
            COUNT => '1',
            LD    => '0',
            DIN   => (others => '0'),
            Q     => hour2_q,
            COUT  => cout_hr2
        );

end rtl;
