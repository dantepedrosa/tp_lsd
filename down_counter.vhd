library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity fixed_reset_down_counter is
    generic (
        N        : integer := 6; 
        reset_val: integer := 50  
    );
    port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        count: in  STD_LOGIC;             
        A       : out unsigned(N-1 downto 0) 
    );
end entity fixed_reset_down_counter;

architecture behavior of fixed_reset_down_counter is
    
    constant init_val : unsigned(N-1 downto 0) := to_unsigned(reset_val, N);
    signal counter_reg : unsigned(N-1 downto 0) := init_val; 
    
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter_reg <= init_val;
            elsif count = '1' then
                if counter_reg /= (others => '0') then
                    counter_reg <= counter_reg - 1;
                end if;
            end if;
        end if;
    end process;
   
    A <= counter_reg;
    
end behavior;