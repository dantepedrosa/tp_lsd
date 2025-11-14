library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (
        N : integer := 4
    );
    port (
        CLEAR : in  std_logic;
        CLK   : in  std_logic;
        COUNT : in  std_logic;
        LD    : in  std_logic;
        DIN   : in  std_logic_vector(N-1 downto 0);
        Q     : out std_logic_vector(N-1 downto 0);
        COUT  : out std_logic
    );
end counter;

architecture my_count of counter is
    signal t_cnt : unsigned(N-1 downto 0);
begin

    process (CLK, CLEAR)
    begin
        if CLEAR = '1' then
            t_cnt <= (others => '0');
        elsif rising_edge(CLK) then
            if LD = '1' then
                t_cnt <= unsigned(DIN);
            elsif COUNT = '1' then
                t_cnt <= t_cnt + 1;
            end if;
        end if;
    end process;

    Q <= std_logic_vector(t_cnt);

    COUT <= '1' when (t_cnt = (2**N - 1) and COUNT = '1') else '0';

end my_count;
