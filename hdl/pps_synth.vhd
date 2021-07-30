library ieee;
use     ieee.std_logic_1164.all;

entity pps_synth is
generic (
    G_CLK_FREQ_HZ: positive := 100000000;
    G_CLOG2_CLK_FREQ_HZ: positive := 16;
    G_INIT_PW: positive := 1000
);
port (
    clk: in std_logic;
    reset: in std_logic;
    enable: in std_logic;
    -- opmode
    opmode: in std_logic_vector(2 downto 0);
    -- pw
    pw_en: in std_logic;
    pw: in std_logic_vector(15 downto 0);
    -- status
    mgmt_clk: in std_logic;
    pulse_active: out std_logic;
);
end entity pps_synth;

architecture rtl of pps_synth is

    signal count_r: std_logic_vector(G_CLOG2_CLK_FREQ_HZ-1 downto 0) := (others => '0');
    signal pw_r: std_logic_vector(15 downto 0) := std_logic_vector(unsigned(G_INIT_PW));

    signal pw_idle_r: std_logic := '1';

    signal pw_en_r: std_logic_vector(3 downto 0) := (others => '0');
    signal pulse_active_mgmt_clk_r: std_logic_vector(2 downto 0) := (others => '0');
begin

    clk_mgmt_clk: process (clk)
    begin
    if rising_edge (clk) then
        pw_en_r(0) <= pw_en;
        pw_en_r(pw_en_r'length-1 downto 0) <= pw_en_r(pw_en_r'length-2 downto 0);
    end if;
    end process;

    pulse_width_value: process (clk)
    begin
    if rising_edge (clk) then
    end if;
    end process;

    delta_producer: process (clk)
    begin
    if rising_edge (clk) then
        if delta_prod_idle = '1' then
        else
            if :x

            else
            end if;
        end if;
    end if;
    end process;

    process (clk)
    begin
    if rising_edge (clk) then
        if reset = '1' then
            count_r <= std_logic_vector(to_unsigned(G_CLK2_FREQ_HZ) -1, C_CLOG2_CLK_FREQ_HZ); 
        else
            if enable = '1' then
                count_r <= std_logic_vector(unsigned(count_r)-1); 
            end if;
        end if;
    end if;
    end process;
    
    process (clk)
    begin
    if rising_edge (clk) then
        if enable = '1' then
            if pw_idle_r = '1' then
                if unsigned(count_r) = 0 then
                    pw_idle_r <= '0';
                    pw_count_r <= std_logic_vector(unsigned(pw_value_r)-1);
                end if;
            else
                pw_count_r <= std_logic_vector(unsigned(pw_count_r) +1);
            end if;
        end if;
    end if;
    end process;

    mgmt_clk_clk: process (mgmt_clk)
    begin
    if rising_edge (mgmt_clk) then
        pulse_active_mgmt_clk_r(0) <= not(pw_idle_r);
        pulse_active_mgmt_clk_r(pulse_active_mgmt_clk_r'length-1 downto 1) <= pulse_active_mgmt_clk_r(pulse_active_mgmt_clk_r'length-2 downto 0);
    end if;
    end process mgmt_clk_clk;

end rtl;
