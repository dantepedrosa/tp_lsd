library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity and_port is
    port(
        A : in  std_logic;
        B : in  std_logic;
        Y : out std_logic
    );
end and_port;

architecture behavior of and_port is
begin
    Y <= A and B;
end behavior;
