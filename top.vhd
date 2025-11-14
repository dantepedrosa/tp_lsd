u_clock_minutes : entity work.counter
    generic map ( N => 6 )
    port map (
        clk   => clk,
        rst   => clk_min_rst,
        count => clk_min_en,
        A     => clk_min_val
    );

u_clock_hours : entity work.counter
    generic map ( N => 5 ) -- 0–23 cabe em 5 bits
    port map (
        clk   => clk,
        rst   => clk_hour_rst,
        count => clk_hour_en,
        A     => clk_hour_val
    );


u_sw_seconds : entity work.counter
    generic map ( N => 6 )  -- 0–59
    port map (
        clk   => clk,
        rst   => sw_sec_rst,
        count => sw_sec_en,
        A     => sw_sec_val
    );

u_sw_minutes : entity work.counter
    generic map ( N => 6 )
    port map (
        clk   => clk,
        rst   => sw_min_rst,
        count => sw_min_en,
        A     => sw_min_val
    );
