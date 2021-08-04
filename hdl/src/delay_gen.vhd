library ieee;
use     ieee.std_logic_1164.all;

entity delay_gen is
port (
    clk: in std_logic;
    reset: in std_logic;
    enable: in std_logic;
    -- opmode
    opmode_en: in std_logic;
    opmode_v : in std_logic_vector(3 downto 0);
    -- opmode: drift
    opmode_drift_sign: in std_logic;
    opmode_drift_rate_v: in std_logic_vector(31 downto 0);
    opmode_drift_min_v: in std_logic_vector(31 downto 0);
    opmode_drift_max_v: in std_logic_vector(31 downto 0);
    -- opmode: rand
    opmode_rand_scaling_v: in std_logic_vector(31 downto 0);
    -- dly
    dly_en: out std_logic;
    dly_v : out std_logic_vector(31 downto 0)
);
end delay_gen;

architecture rtl of delay_gen is

begin

    rand_dly_inst: entity work.rand_delay_gen
    port map (
        clk => clk,
        reset => reset,
        enable => enable,
        dly_en => rand_dly_en_r,
        dly_v => rand_dly_v_r
    );

    sync_scaling: process (clk)
    begin
    if rising_edge (clk) then
        if reset = '1' then
            rand_dly_en_s <= '0';
            rand_dly_v_s <= (others => '0');
        else
            rand_dly_en_s <= '0';
            if enable = '1' then
                if rand_dly_en_r = '1' then
                    rand_dly_en_s <= '1';
                    rand_dly_v_s <= std_logic_vector(signed(rand_dly_v_r) * signed(opmode_rand_scaling_v));
                end if;
            end if;
        end if;
    end if;
    end process;

end rtl;
