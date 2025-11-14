-- AULA 12 - TRABALHO PRÁTICO FINAL
-- arquivo: counter.vhd
-- Contador genérico
-- Desenvolvido por:
-- Dante Junqueira Pedrosa
-- Maria Eduarda Jotadiemel Antunes
-- Laboratório de Sistemas Digitais - Turma PN1

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (
        N : integer := 4
    );
    port (
        CLEAR : in  std_logic;  -- reset assincrono
        CLK   : in  std_logic;  -- clock
        COUNT : in  std_logic;  -- habilita contagem
        LD    : in  std_logic;  -- load do valor em DIN
        DIN   : in  std_logic_vector(N-1 downto 0); -- valor a ser carregado
        Q     : out std_logic_vector(N-1 downto 0); -- saída
        COUT  : out std_logic   -- carry out
    );
end counter;

architecture my_count of counter is
    signal t_cnt : unsigned(N-1 downto 0) := (others => '0');
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
