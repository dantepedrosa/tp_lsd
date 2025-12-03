library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (
        N : integer := 4;
        MAX_VALUE : natural := 9
    );
    port (
        CLEAR : in  std_logic;  -- reset assincrono ativo em '1'
        CLK   : in  std_logic;  -- clock
        COUNT : in  std_logic;  -- habilita contagem quando '1'
        Q     : out std_logic_vector(N-1 downto 0);  -- saida do contador (valor atual)
        COUT  : out std_logic  -- carry-out ao chegar em MAX_VALUE
    );
end counter;

architecture rtl of counter is
    -- sinais usados internamente
    signal cnt : unsigned(N-1 downto 0) := (others => '0');
    signal COUT_reg : std_logic := '0'; 

begin

    process (CLK, CLEAR)
    begin
        if CLEAR = '1' then
            cnt <= (others => '0');
            COUT_reg <= '0';

        elsif rising_edge(CLK) then
            if COUNT = '1' then
                if cnt = MAX_VALUE then
                    cnt <= (others => '0');
                    COUT_reg <= '1';  -- carry out
                else
                    cnt <= cnt + 1;
                    COUT_reg <= '0';
                end if;
            else
                COUT_reg <= '0';
            end if;
        end if;
    end process;

    Q <= std_logic_vector(cnt);
    COUT <= COUT_reg;


end rtl;
