-- Codigo baseado no exemplo do livro VHDL Caipira, adaptado

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    port (
        CLEAR : in std_logic;                       -- reset assincrono
        CLK   : in std_logic;                       -- clock
        COUNT : in std_logic;                       -- habilita incremento
        LD    : in std_logic;                       -- load sincron o
        DIN   : in std_logic_vector(7 downto 0);    -- valor para carregar
        Q     : out std_logic_vector(7 downto 0);   -- saida do contador
        COUT  : out std_logic                       -- carry-out quando atinge o valor maximo
    );
end counter;

architecture my_count of counter is
    signal t_cnt : unsigned(7 downto 0); -- contador interno
begin

    process (CLK, CLEAR)
    begin
        if (CLEAR = '1') then
            t_cnt <= (others => '0');            -- clear assincrono

        elsif rising_edge(CLK) then
            if (LD = '1') then
                t_cnt <= unsigned(DIN);          -- load sincron o
            elsif (COUNT = '1') then
                t_cnt <= t_cnt + 1;              -- incrementa
            end if;
        end if;
    end process;

    -- saida do contador
    Q <= std_logic_vector(t_cnt);

    -- carry-out quando atinge o valor maximo
    COUT <= '1' when t_cnt = x"FF" and COUNT = '1' else '0';

end my_count;
