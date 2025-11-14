library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is
    port(
        clk                 : in  STD_LOGIC;
        rst                 : in  STD_LOGIC;

        -- controller signals
        start_stop_stopwatch : in STD_LOGIC;
        reset_stopwatch      : in STD_LOGIC;
        up_hr_min            : in STD_LOGIC;
        hr_min_adj_sel       : in STD_LOGIC;   -- 0 = hours / 1 = minutes
        function_selection   : in STD_LOGIC;   -- 0 = normal mode / 1 = adjust

        -- display outputs
        disp0_center_up      : out STD_LOGIC;
        disp0_center_center  : out STD_LOGIC;
        disp0_center_down    : out STD_LOGIC;
        disp0_left_up        : out STD_LOGIC;
        disp0_left_down      : out STD_LOGIC;
        disp0_right_up       : out STD_LOGIC;
        disp0_right_down     : out STD_LOGIC;

        disp1_center_up      : out STD_LOGIC;
        disp1_center_center  : out STD_LOGIC;
        disp1_center_down    : out STD_LOGIC;
        disp1_left_up        : out STD_LOGIC;
        disp1_left_down      : out STD_LOGIC;
        disp1_right_up       : out STD_LOGIC;
        disp1_right_down     : out STD_LOGIC
    );
end datapath;

architecture structural of datapath is

	signal hr0, min0, s0, min1, s1 : unsigned(5 downto 0);
    signal num0, num1 : unsigned(5 downto 0);
    signal comp_hr0_less, comp_min0_less, comp_s0_less : STD_LOGIC;
    signal comp_temp_eq : STD_LOGIC;
    signal comp_min1_less, comp_s1_less : STD_LOGIC;
    signal active_stopwatch : STD_LOGIC;
    constant cnt_temp : STD_LOGIC := '1';
    signal temp : unsigned(9 downto 0);
    constant hr_max : integer := 23;
    constant min_s_max : integer := 59;
    constant zero : integer := 0;

begin

	-- counter temp
    counter_temp: entity work.fixed_reset_down_counter
        generic map (N => 10, reset_val => 999)
        port map(
            clk	=> clk,
            rst => comp_temp_eq,
            count => cnt_temp,
            A => temp
        );

	-- and
    active_sw_and: entity work.and_port
        port map(
            A => start_stop_stopwatch,
            B => comp_temp_eq,
            Y => active_stopwatch
        );

	-- demux
    demux: entity work.demux_1x2
        port map(
            din	=> up_hr_min,
            sel => hr_min_adj_sel,
            A => comp_min0_less,
            B => comp_s0_less
        );
    

	-- counters clock
    counter_hr0: entity work.counter
        generic map (N => 6)
        port map(
            clk	=> clk,
            rst => comp_hr0_less,
            count => comp_min0_less,
            A => hr0
        );
        
    counter_min0: entity work.counter
        generic map (N => 6)
        port map(
            clk	=> clk,
            rst => comp_min0_less,
            count => comp_s0_less,
            A => min0
        );
    
    counter_s0: entity work.counter
        generic map (N => 6)
        port map(
            clk	=> clk,
            rst => comp_s0_less,
            count => comp_temp_eq,
            A => s0
        );
        
    -- counters stopwatch
    counter_min1: entity work.counter
        generic map (N => 6)
        port map(
            clk	=> clk,
            rst => comp_min1_less,
            count => comp_s1_less,
            A => min1
        );
    
    counter_s1: entity work.counter
        generic map (N => 6)
        port map(
            clk	=> clk,
            rst => comp_s1_less,
            count => active_stopwatch,
            A => s1
        );
        
    -- comparators
    comp_hr0: entity work.comparator
        generic map (N => 6)
        port map(
            A => to_unsigned(hr_max, 6),
            B => hr0,
            less => comp_hr0_less,
            equal => open,
            greater => open,
        );
    
    comp_min0: entity work.comparator
        generic map (N => 6)
        port map(
            A => to_unsigned(min_s_max, 6),
            B => min0,
            less => comp_min0_less,
            equal => open,
            greater => open,
        );
    
    comp_s0: entity work.comparator
        generic map (N => 6)
        port map(
            A => to_unsigned(min_s_max, 6),
            B => s0,
            less => comp_s0_less,
            equal => open,
            greater => open,
        );
        
    comp_min1: entity work.comparator
        generic map (N => 6)
        port map(
            A => to_unsigned(min_s_max, 6),
            B => min1,
            less => comp_min1_less,
            equal => open,
            greater => open,
        );
    
    comp_s1: entity work.comparator
        generic map (N => 6)
        port map(
            A => to_unsigned(min_s_max, 6),
            B => s1,
            less => comp_s1_less,
            equal => open,
            greater => open,
        );
        
    comp_temp: entity work.comparator
        generic map (N => 6)
        port map(
            A => to_unsigned(zero, 10),
            B => temp,
            less => open,
            equal => comp_temp_eq,
            greater => open,
        );


	-- mux
    mux0: entity work.mux_2x1
        generic map (N => 6)
        port map(
            A => hr0,
            B => min1,             
            sel => function_selection,   
            X => num0                  
        );

    mux1: entity work.mux_2x1
        generic map (N => 6)
        port map(
            A => min0,
            B => s1,
            sel => function_selection,
            X => num1
        );


end structural;
