library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparator is
    generic (N : integer := 6);
    port (
        A       : in  unsigned(N-1 downto 0);
        B       : in  unsigned(N-1 downto 0);
        less    : out std_logic;
        equal   : out std_logic;
        greater : out std_logic
    );
end entity comparator;

architecture rtl of comparator is
begin
    process(A, B)
    begin
        if A < B then
            less    <= '1';
            equal   <= '0';
            greater <= '0';
        elsif A = B then
            less    <= '0';
            equal   <= '1';
            greater <= '0';
        else
            less    <= '0';
            equal   <= '0';
            greater <= '1';
        end if;
    end process;
end architecture rtl;