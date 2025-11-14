library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
  	generic (
    	N : integer := 6  -- número de bits (padrão = 6)
  	);
    port (
        A	: in unsigned(N-1 downto 0);
        B	: in unsigned(N-1 downto 0);
        less	: out STD_LOGIC;
        equal	: out STD_LOGIC;
        greater	: out STD_LOGIC;
	);
end comparator;

architecture behavior of comparator is
begin
	process (A,B)
    begin
    	if A>B then
        	greater <= '1';
            equal <= '0';
            less <= '0';
        else if A<B then
        	greater <= '0';
            equal <= '0';
            less <= '1';
        else
        	greater <= '0';
            equal <= '1';
            less <= '0';
        end if;
    end process;
end behavior;