library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux_1x2 is
    port (
    	din	: in STD_LOGIC;
        sel : in STD_LOGIC;
        A : out STD_LOGIC;
      	B : out STD_LOGIC
	);
end demux_1x2;

architecture behavior of demux_1x2 is
begin
	process (din, sel)
    begin
    	if sel = '0' then
        	A <= din;
            B <= '0';
        else
        	A <= '0';
            B <= din;
        end if;
    end process;
end behavior;