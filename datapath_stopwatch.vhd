-- enable/reset vindos da FSM
sw_sec_en         : std_logic;
sw_sec_rst        : std_logic;
sw_min_en         : std_logic;
sw_min_rst        : std_logic;

-- valores atuais
sw_sec_val        : unsigned(5 downto 0);
sw_min_val        : unsigned(5 downto 0);

-- limites
max_sw_sec        : std_logic;   -- = '1' quando chegar em 59
max_sw_min        : std_logic;   -- = '1' quando chegar em 59
