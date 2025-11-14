library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_all is
end tb_all;

architecture tb of tb_all is
    -- component declarations (match the source entities)
    component and_port is
        port(
            A : in  std_logic;
            B : in  std_logic;
            Y : out std_logic
        );
    end component;

    component demux_1x2 is
        port (
            din : in STD_LOGIC;
            sel : in STD_LOGIC;
            A   : out STD_LOGIC;
            B   : out STD_LOGIC
        );
    end component;

    component comparator is
        generic (N : integer := 6);
        port (
            A       : in unsigned(N-1 downto 0);
            B       : in unsigned(N-1 downto 0);
            less    : out STD_LOGIC;
            equal   : out STD_LOGIC;
            greater : out STD_LOGIC
        );
    end component;

    -- signals for and_port
    signal a_and, b_and, y_and : std_logic := '0';

    -- signals for demux
    signal din_demux, sel_demux, a_demux, b_demux : std_logic := '0';

    -- signals for comparator
    signal A_comp, B_comp : unsigned(5 downto 0) := (others => '0');
    signal less_s, equal_s, greater_s : std_logic := '0';

begin
    -- instantiate DUTs
    DUT_and: and_port port map(A => a_and, B => b_and, Y => y_and);
    DUT_demux: demux_1x2 port map(din => din_demux, sel => sel_demux, A => a_demux, B => b_demux);
    DUT_comp: comparator port map(A => A_comp, B => B_comp, less => less_s, equal => equal_s, greater => greater_s);

    -- simple clock generator for counter (1 ns period)
    clk_gen: process
    begin
        while now < 1 ms loop  -- long enough for tests; stops only when sim stops
            clk_tb <= '0';
            wait for 0.5 ns;
            clk_tb <= '1';
            wait for 0.5 ns;
        end loop;
        wait;
    end process;

    -- combined stimulus and asserts
    stim_proc: process
    begin
        ------------------------------------------------------------------
        -- Test AND gate (truth table)
        ------------------------------------------------------------------
        a_and <= '0'; b_and <= '0';
        wait for 1 ns; assert (y_and = '0') report "AND Fail 0/0" severity error;

        b_and <= '1'; -- 0/1
        wait for 1 ns; assert (y_and = '0') report "AND Fail 0/1" severity error;

        a_and <= '1'; -- 1/1
        wait for 1 ns; assert (y_and = '1') report "AND Fail 1/1" severity error;

        b_and <= '0'; -- 1/0
        wait for 1 ns; assert (y_and = '0') report "AND Fail 1/0" severity error;

        ------------------------------------------------------------------
        -- Test DEMUX 1x2
        ------------------------------------------------------------------
        din_demux <= '1'; sel_demux <= '0'; -- sel = 0 => A = din, B = 0
        wait for 1 ns; assert (a_demux = '1' and b_demux = '0') report "DEMUX Fail sel=0" severity error;

        sel_demux <= '1'; -- sel = 1 => A = 0, B = din
        wait for 1 ns; assert (a_demux = '0' and b_demux = '1') report "DEMUX Fail sel=1" severity error;

        din_demux <= '0'; sel_demux <= '0';
        wait for 1 ns; assert (a_demux = '0' and b_demux = '0') report "DEMUX Fail din=0" severity error;

        ------------------------------------------------------------------
        -- Test COMPARATOR
        ------------------------------------------------------------------
        A_comp <= to_unsigned(2, 6); B_comp <= to_unsigned(3, 6); -- A < B
        wait for 1 ns; assert (less_s = '1' and equal_s = '0' and greater_s = '0') report "COMP Fail A<B" severity error;

        A_comp <= to_unsigned(5, 6); B_comp <= to_unsigned(1, 6); -- A > B
        wait for 1 ns; assert (less_s = '0' and equal_s = '0' and greater_s = '1') report "COMP Fail A>B" severity error;

        A_comp <= to_unsigned(7, 6); B_comp <= to_unsigned(7, 6); -- A = B
        wait for 1 ns; assert (less_s = '0' and equal_s = '1' and greater_s = '0') report "COMP Fail A=B" severity error;


        report "All tests done." severity note;
        wait; -- STOP!
    end process;
end tb;
