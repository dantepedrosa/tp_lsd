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

    type state_type is (
        ST_RELOGIO,
        ST_CRONOMETRO_STOP,
        ST_CRONOMETRO_RUN,
        ST_AJUSTA_HORA,
        ST_AJUSTA_MIN
    );

    signal PS, NS : state_type;
    signal PS_vec : std_logic_vector(2 downto 0);

    -- flags de borda detectada
    signal mode_rise    : std_logic := '0';
    signal action_rise  : std_logic := '0';
    signal set_rst_rise : std_logic := '0';

begin

    PS_vec <= "000" when PS = ST_RELOGIO else
              "001" when PS = ST_CRONOMETRO_STOP else
              "010" when PS = ST_CRONOMETRO_RUN else
              "011" when PS = ST_AJUSTA_HORA else
              "100";

    --------------------------------------------------------------------
    -- Process que sincroniza a FSM e detecta bordas dos botoes
    --------------------------------------------------------------------
    sync_p: process(clk)
        variable mode_old    : std_logic := '0';
        variable action_old  : std_logic := '0';
        variable set_rst_old : std_logic := '0';
    begin
        if rising_edge(clk) then

            -- FSM
            PS <= NS;

            ------------------------------------------------------------
            -- Deteccao da borda dos botoes (sinal antigo -> variavel)
            ------------------------------------------------------------
            if mode_old = '0' and btn_mode = '1' then
                mode_rise <= '1';
            else
                mode_rise <= '0';
            end if;

            if action_old = '0' and btn_action = '1' then
                action_rise <= '1';
            else
                action_rise <= '0';
            end if;

            if set_rst_old = '0' and btn_set_rst = '1' then
                set_rst_rise <= '1';
            else
                set_rst_rise <= '0';
            end if;

            -- atualiza estado antigo
            mode_old    := btn_mode;
            action_old  := btn_action;
            set_rst_old := btn_set_rst;

        end if;
    end process sync_p;

    --------------------------------------------------------------------
    -- Logica combinacional da FSM
    --------------------------------------------------------------------
    comb_p: process (PS, mode_rise, action_rise, set_rst_rise)
    begin
        watch_mode  <= '1';
        stpwtch_en  <= '0';
        rst_stpwtch <= '0';
        set_hour    <= '0';
        set_min     <= '0';

        case PS is

            when ST_RELOGIO =>
                watch_mode <= '1';
                set_min    <= '0';

                if set_rst_rise = '1' then
                    NS <= ST_AJUSTA_HORA;
                elsif mode_rise = '1' then
                    NS <= ST_CRONOMETRO_STOP;
                else
                    NS <= ST_RELOGIO;
                end if;

            when ST_CRONOMETRO_STOP =>
                watch_mode <= '0';
                stpwtch_en <= '0';

                if action_rise = '1' then
                    NS <= ST_CRONOMETRO_RUN;
                elsif set_rst_rise = '1' then
                    rst_stpwtch <= '1';
                    NS <= ST_CRONOMETRO_STOP;
                elsif mode_rise = '1' then
                    NS <= ST_RELOGIO;
                else
                    NS <= ST_CRONOMETRO_STOP;
                end if;

            when ST_CRONOMETRO_RUN =>
                watch_mode <= '0';
                stpwtch_en <= '1';

                if action_rise = '1' then
                    NS <= ST_CRONOMETRO_STOP;
                elsif set_rst_rise = '1' then
                    rst_stpwtch <= '1';
                    NS <= ST_CRONOMETRO_STOP;
                elsif mode_rise = '1' then
                    NS <= ST_RELOGIO;
                else
                    NS <= ST_CRONOMETRO_RUN;
                end if;

            when ST_AJUSTA_HORA =>
                set_hour <= '1';

                if set_rst_rise = '1' then
                    NS <= ST_AJUSTA_MIN;
                else
                    NS <= ST_AJUSTA_HORA;
                end if;

            when ST_AJUSTA_MIN =>
                set_min <= '1';

                if set_rst_rise = '1' then
                    NS <= ST_RELOGIO;
                else
                    NS <= ST_AJUSTA_MIN;
                end if;

            when others =>
                NS <= ST_RELOGIO;

        end case;
    end process comb_p;

end rtl;