-- Codigo baseado no exemplo do livro VHDL Caipira, adaptado

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (
        N : integer := 8               -- numero de bits
    );
    port (
        CLEAR : in  std_logic;                     -- reset assincrono
        CLK   : in  std_logic;                     -- clock
        COUNT : in  std_logic;                     -- enable de incremento
        LD    : in  std_logic;                     -- load sincrono
        DIN   : in  std_logic_vector(N-1 downto 0);-- valor de entrada
        Q     : out std_logic_vector(N-1 downto 0);-- saida
        COUT  : out std_logic                      -- carry out
    );
end counter;

architecture my_count of counter is
    signal t_cnt : unsigned(N-1 downto 0);         -- registrador interno
begin

    process (CLK, CLEAR)
    begin
        if (CLEAR = '1') then
            t_cnt <= (others => '0');              -- reset

        elsif rising_edge(CLK) then
            if (LD = '1') then
                t_cnt <= unsigned(DIN);            -- load
            elsif (COUNT = '1') then
                t_cnt <= t_cnt + 1;                -- incremento
            end if;
        end if;
    end process;

    -- saida Q
    Q <= std_logic_vector(t_cnt);

    -- carry-out quando atingir o valor maximo
    COUT <= '1' when t_cnt = (2**N - 1) and COUNT = '1' else '0';

end my_count;
