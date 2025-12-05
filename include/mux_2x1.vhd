-- TRABALHO PRÁTICO FINAL
-- arquivo: mux_2x1.vhd
-- Multiplexador 2x1 genérico
-- Desenvolvido por:
-- Dante Junqueira Pedrosa
-- Maria Eduarda Jotadiemel Antunes
-- Laboratório de Sistemas Digitais - Turma PN1

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2x1 is
    generic (
        N : integer := 4
    );
    port (
        A   : in unsigned(N-1 downto 0);
        B   : in unsigned(N-1 downto 0);
        sel : in std_logic;
        dout : out unsigned(N-1 downto 0)
    );
end mux_2x1;

architecture behavior of mux_2x1 is
begin
    process (A, B, sel)
    begin
        if sel = '0' then
            dout <= A;
        else
            dout <= B;
        end if;
    end process;
end behavior;
