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
    -- top
    top_out: out std_logic
);
end entity pps_synth;

architecture rtl of pps_synth is

    signal count_r: std_logic_vector(G_CLOG2_CLK_FREQ_HZ-1 downto 0) := (others => '0');
    signal pw_r: std_logic_vector(15 downto 0) := std_logic_vector(unsigned(G_INIT_PW));
begin

    sync_delta_r: process (clk)
    begin
    if rising_edge (clk) then
        -- a revoir, pas le bon moment pour latcher
        if unsigned(count_r) = 0 then
            delta_r(G_CLOG2_CLK_FREQ_HZ-1 downto 1) <= (others => '0');
            delta_r(0) <= '1';
        end if;
    end if;
    end process;

    process (clk)
    begin
    if rising_edge (clk) then
        if enable = '1' then
            if unsigned(count_r) = 0 then 
                count_r <= std_logic_vector(to_signed(G_CLK_FREQ_HZ) + signed(delta_r) -1);
            else
                count_r <= std_logic_vector(signed(count_r)-1); 
            end if;
        end if;
    end if;
    end process;
    
    clk_mgmt_clk: process (clk)
    begin
    if rising_edge (clk) then
        pw_en_r(0) <= pw_en;
        pw_en_r(pw_en_r'length-1 downto 1) <= pw_en_r(pw_en_r'length-2 downto 0);
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
        pulse_active_mgmt_clk_r(pulse_active_mgmt_clk_r'length-1 downto 1) <= 
            pulse_active_mgmt_clk_r(pulse_active_mgmt_clk_r'length-2 downto 0);
    end if;
    end process mgmt_clk_clk;

end rtl;
