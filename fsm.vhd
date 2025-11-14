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

    type state_type is (
        ST_WATCH,
        ST_STPWATCH_IDLE,
        ST_STPWATCH_RUN,
        ST_SET_HOUR,
        ST_SET_MIN
    );

    signal PS, NS : state_type;

begin

    ----------------------------------------------------------------
    -- process sincronizado: transicao PS <= NS
    ----------------------------------------------------------------
    sync_p: process (clk)
    begin
        if rising_edge(clk) then
            PS <= NS;
        end if;
    end process sync_p;

    ----------------------------------------------------------------
    -- process combinacional: define saidas e proximo estado
    ----------------------------------------------------------------
    comb_p: process (PS, btn_mode, btn_action)
    begin
        -- valores padrao
        watch_mode <= '1';
        stpwtch_en <= '0';
        set_hour   <= '0';
        set_min    <= '0';
        NS         <= PS;

        case PS is

            --------------------------------------------------------
            -- MODO RELogio
            --------------------------------------------------------
            when ST_WATCH =>
                watch_mode <= '1';

                if btn_mode = '1' then
                    NS <= ST_STPWATCH_IDLE;
                end if;

            --------------------------------------------------------
            -- CRONOMETRO PARADO
            --------------------------------------------------------
            when ST_STPWATCH_IDLE =>
                watch_mode <= '0';
                stpwtch_en <= '0';

                if btn_action = '1' then
                    NS <= ST_STPWATCH_RUN;
                elsif btn_mode = '1' then
                    NS <= ST_SET_HOUR;
                end if;

            --------------------------------------------------------
            -- CRONOMETRO RODANDO
            --------------------------------------------------------
            when ST_STPWATCH_RUN =>
                watch_mode <= '0';
                stpwtch_en <= '1';

                if btn_action = '1' then
                    NS <= ST_STPWATCH_IDLE;
                end if;

            --------------------------------------------------------
            -- AJUSTE DE HORAS
            --------------------------------------------------------
            when ST_SET_HOUR =>
                watch_mode <= '1';
                set_hour   <= '1';

                if btn_mode = '1' then
                    NS <= ST_SET_MIN;
                elsif btn_action = '1' then
                    NS <= ST_SET_HOUR; -- incrementa horas externamente
                end if;

            --------------------------------------------------------
            -- AJUSTE DE MINUTOS
            --------------------------------------------------------
            when ST_SET_MIN =>
                watch_mode <= '1';
                set_min    <= '1';

                if btn_mode = '1' then
                    NS <= ST_WATCH;
                elsif btn_action = '1' then
                    NS <= ST_SET_MIN; -- incrementa minutos externamente
                end if;

            --------------------------------------------------------
            when others =>
                NS <= ST_WATCH;

        end case;
    end process comb_p;

end rtl;
