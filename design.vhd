-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity datapath_clock_stopwatch is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        start_stop_stopwatch    : in  STD_LOGIC;
        reset_stopwatch    : in  STD_LOGIC;
        up_hr_min   : in  STD_LOGIC;
        hr_min_adj_sel     : in STD_LOGIC;
        function_selection	: in STD_LOGIC;
        
        first_number	: out unsigned(5 downto 0);
        second_number	: out unsigned(5 downto 0);
    );
end datapath;

architecture rtl of datapath_clock_stopwatch is
	signal hour_clock	: unsigned(4 downto 0) := (others => '0');
    signal min_clock	: unsigned(5 downto 0) := (others => '0');
    signal sec_clock	: unsigned(5 downto 0) := (others => '0');
    signal min_stopwatch	: unsigned(5 downto 0) := (others => '0');
    signal sec_stopwatch	: unsigned(5 downto 0) := (others => '0');
    signal tick_1_sec	: unsigned(9 downto 0) := (others => '0');
begin
