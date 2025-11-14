library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is
    port (
        btn_mode   : in std_logic;
        btn_action : in std_logic;
        clk        : in std_logic;

        watch_mode : out std_logic;
        stpwtch_en : out std_logic;
        set_hour   : out std_logic;
        set_min    : out std_logic
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

begin
    sync_p: process (clk)
    begin
        if rising_edge(clk) then
            PS <= NS;
        end if;
    end process sync_p;

    comb_p: process (PS, btn_mode, btn_action)
    begin
        -- inicializacao das variaveis de saida
        watch_mode <= '1';
        stpwtch_en <= '0';
        set_hour   <= '0';
        set_min    <= '0';
        NS         <= PS;

        case PS is

            -- ESTADO - RELOGIO CONTANDO
            when ST_RELOGIO =>
                watch_mode <= '1';

                if btn_mode = '1' then
                    NS <= ST_CRONOMETRO_STOP;
                end if;

            
            -- ESTADO - CRONOMETRO PARADO
            when ST_CRONOMETRO_STOP =>
                watch_mode <= '0';
                stpwtch_en <= '0';

                if btn_action = '1' then
                    NS <= ST_CRONOMETRO_RUN;
                elsif btn_mode = '1' then
                    NS <= ST_AJUSTA_HORA;
                end if;

            -- ESTADO - CRONOMETRO CONTANDO
            when ST_CRONOMETRO_RUN =>
                watch_mode <= '0';
                stpwtch_en <= '1';

                if btn_action = '1' then
                    NS <= ST_CRONOMETRO_STOP;
                end if;

            -- ESTADO - SETAR HORAS
            -- Obs.: Apenas habilita a edicao de horas. Incremento feito diretamente pelo botao
            when ST_AJUSTA_HORA =>
                watch_mode <= '1';
                set_hour   <= '1';

                if btn_mode = '1' then
                    NS <= ST_AJUSTA_MIN;
                elsif btn_action = '1' then
                    NS <= ST_AJUSTA_HORA; 
                end if;

            -- ESTADO - SETAR MINUTOS
            -- Obs.: Apenas habilita a edicao de minutos. Incremento feito diretamente pelo botao
            when ST_AJUSTA_MIN =>
                watch_mode <= '1';
                set_min    <= '1';

                if btn_mode = '1' then
                    NS <= ST_RELOGIO;
                elsif btn_action = '1' then
                    NS <= ST_AJUSTA_MIN;
                end if;

            -- ESTADO - PADRAO
            when others =>
                NS <= ST_RELOGIO;

        end case;
    end process comb_p;

end rtl;
