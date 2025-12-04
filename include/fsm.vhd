library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
    port (
        btn_mode    : in std_logic;
        btn_action  : in std_logic;
        btn_set_rst : in std_logic;
        clk         : in std_logic;

        watch_mode  : out std_logic;
        stpwtch_en  : out std_logic;
        rst_stpwtch : out std_logic;
        set_hour    : out std_logic;
        set_min     : out std_logic
    );
end fsm;

architecture rtl of fsm is

    -- NOMEACAO DOS ESTADOS
    type state_type is (
        ST_RELOGIO,
        ST_CRONOMETRO_STOP,
        ST_CRONOMETRO_RUN,
        ST_AJUSTA_HORA,
        ST_AJUSTA_MIN
    );

    signal PS, NS : state_type;
    -- Optional: for waveform viewing
    signal PS_vec : std_logic_vector(2 downto 0);

   
    
begin

 	PS_vec <= "000" when PS = ST_RELOGIO else
              "001" when PS = ST_CRONOMETRO_STOP else
              "010" when PS = ST_CRONOMETRO_RUN else
              "011" when PS = ST_AJUSTA_HORA else
              "100"; -- ST_AJUSTA_MIN

    sync_p: process (clk)
    begin
        if rising_edge(clk) then
            PS <= NS;
        end if;
    end process sync_p;

    comb_p: process (PS, btn_mode, btn_action, btn_set_rst)
    begin
        -- Inicializacao no modo relogio
        watch_mode  <= '1';
        stpwtch_en  <= '0';
        rst_stpwtch <= '0';
        set_hour    <= '0';
        set_min     <= '0';
        
        case PS is

            -- ESTADO - RELOGIO CONTANDO
            when ST_RELOGIO =>
                watch_mode <= '1';
                set_min    <= '0';

                if (rising_edge(btn_set_rst)) then
                    NS <= ST_AJUSTA_HORA;
                elsif (rising_edge(btn_mode)) then
                    NS <= ST_CRONOMETRO_STOP;
                end if;

            
            -- ESTADO - CRONOMETRO PARADO
            when ST_CRONOMETRO_STOP =>
                watch_mode <= '0';
                stpwtch_en <= '0';
                rst_stpwtch <= '0';

                if (rising_edge(btn_action)) then
                    NS <= ST_CRONOMETRO_RUN;
                elsif (rising_edge(btn_set_rst)) then
                    rst_stpwtch <= '1';
                    NS <= ST_CRONOMETRO_STOP;
                elsif (rising_edge(btn_mode)) then
                    NS <= ST_RELOGIO;
                end if;

            -- ESTADO - CRONOMETRO CONTANDO
            when ST_CRONOMETRO_RUN =>
                watch_mode <= '0';
                stpwtch_en <= '1';

                if (rising_edge(btn_action)) then
                    NS <= ST_CRONOMETRO_STOP;
                elsif (rising_edge(btn_set_rst)) then
                    rst_stpwtch <= '1';
                    NS <= ST_CRONOMETRO_STOP;
                elsif (rising_edge(btn_mode)) then
                    NS <= ST_RELOGIO;
                end if;

            -- ESTADO - SETAR HORAS
            -- Obs.: Apenas habilita a edicao de horas,
            -- incremento feito diretamente pelo sinal do botao
            when ST_AJUSTA_HORA =>
                set_hour   <= '1';

                if (rising_edge(btn_set_rst)) then
                    NS <= ST_AJUSTA_MIN;
                end if;

            -- ESTADO - SETAR MINUTOS
            -- Obs.: Apenas habilita a edicao de minutos,
            -- incremento feito diretamente pelo sinal do botao
            when ST_AJUSTA_MIN =>
                set_hour   <= '0';
                set_min    <= '1';

                if (rising_edge(btn_set_rst)) then
                    NS <= ST_RELOGIO;
                end if;

            -- ESTADO - PADRAO
            when others =>
                NS <= ST_RELOGIO;

        end case;
    end process comb_p;

end rtl;
