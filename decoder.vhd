library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port (
        A : in unsigned(3 downto 0);
        center_up     : out STD_LOGIC;
        center_center : out STD_LOGIC;
        center_down   : out STD_LOGIC;
        left_up       : out STD_LOGIC;
        left_down     : out STD_LOGIC;
        right_up      : out STD_LOGIC;
        right_down    : out STD_LOGIC
    );
end decoder;

architecture behavior of decoder is
begin
    process (A)
    begin
        center_up     <= '0';
        center_center <= '0';
        center_down   <= '0';
        left_up       <= '0';
        left_down     <= '0';
        right_up      <= '0';
        right_down    <= '0';

        if A = to_unsigned(0,4) then
            center_up     <= '1';
            center_center <= '0';
            center_down   <= '1';
            left_up       <= '1';
            left_down     <= '1';
            right_up      <= '1';
            right_down    <= '1';

        elsif A = to_unsigned(1,4) then
            center_up     <= '0';
            center_center <= '0';
            center_down   <= '0';
            left_up       <= '0';
            left_down     <= '0';
            right_up      <= '1';
            right_down    <= '1';

        elsif A = to_unsigned(2,4) then
            center_up     <= '1';
            center_center <= '1';
            center_down   <= '1';
            left_up       <= '0';
            left_down     <= '1';
            right_up      <= '1';
            right_down    <= '0';

        elsif A = to_unsigned(3,4) then
            center_up     <= '1';
            center_center <= '1';
            center_down   <= '1';
            left_up       <= '0';
            left_down     <= '0';
            right_up      <= '1';
            right_down    <= '1';

        elsif A = to_unsigned(4,4) then
            center_up     <= '0';
            center_center <= '1';
            center_down   <= '0';
            left_up       <= '1';
            left_down     <= '0';
            right_up      <= '1';
            right_down    <= '1';

        elsif A = to_unsigned(5,4) then
            center_up     <= '1';
            center_center <= '1';
            center_down   <= '1';
            left_up       <= '1';
            left_down     <= '0';
            right_up      <= '0';
            right_down    <= '1';

        elsif A = to_unsigned(6,4) then
            center_up     <= '1';
            center_center <= '1';
            center_down   <= '1';
            left_up       <= '1';
            left_down     <= '1';
            right_up      <= '0';
            right_down    <= '1';

        elsif A = to_unsigned(7,4) then
            center_up     <= '1';
            center_center <= '0';
            center_down   <= '0';
            left_up       <= '0';
            left_down     <= '0';
            right_up      <= '1';
            right_down    <= '1';

        elsif A = to_unsigned(8,4) then
            center_up     <= '1';
            center_center <= '1';
            center_down   <= '1';
            left_up       <= '1';
            left_down     <= '1';
            right_up      <= '1';
            right_down    <= '1';

        elsif A = to_unsigned(9,4) then
            center_up     <= '1';
            center_center <= '1';
            center_down   <= '1';
            left_up       <= '1';
            left_down     <= '0';
            right_up      <= '1';
            right_down    <= '1';

        else
            center_up     <= '0';
            center_center <= '0';
            center_down   <= '0';
            left_up       <= '0';
            left_down     <= '0';
            right_up      <= '0';
            right_down    <= '0';
        end if;

    end process;
end behavior;
