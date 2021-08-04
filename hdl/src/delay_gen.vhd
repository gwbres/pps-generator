library ieee;
use     ieee.std_logic_1164.all;

entity delay_gen is
port (
    clk: in std_logic;
    reset: in std_logic;
    enable: in std_logic;
    -- opmode
    opmode_en: in std_logic;
    opmode_v : in std_logic_vector(1 downto 0);
    -- opmode: drift
    opmode_drift_rate_v: in std_logic_vector(31 downto 0);
    opmode_drift_min_v: in std_logic_vector(31 downto 0);
    opmode_drift_max_v: in std_logic_vector(31 downto 0);
    -- opmode: rand
    opmode_rand_scaling_v: in std_logic_vector(31 downto 0);
    -- dly
    dly_en: out std_logic;
    dly_v : out std_logic_vector(31 downto 0);
    -- loopback
    sig_in: in std_logic
);
end delay_gen;

architecture rtl of delay_gen is

begin

    rand_dly_inst: entity work.rand_delay_gen
    port map (
        clk => clk,
        reset => reset,
        enable => enable,
        sig_in => sig_in,
        dly_en => rand_dly_en_r,
        dly_v => rand_dly_v_r
    );
    
    drift_dly_inst: entity work.slope_delay_gen
    port map (
        clk => clk,
        reset => reset,
        enable => enable,
        sig_in => sig_in,
        sign_bit => drift_dly_sign_bit,
        min_v => opmode_drift_min_v,
        max_v => opmode_drift_max_v
        dly_en => drift_dly_en_r,
        dly_v => drift_dly_v_r
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

    resync_latch: process (clk)
    begin
    if rising_edge (clk) then
        if reset = '1' then
            opmode_r <= (others => '0');
        else
            if opmode_en = '1' then
                opmode_r <= opmode_v;
            end if;
        end if;
    end if;
    end process;

    int_latch: process (clk)
    begin
    if rising_edge (clk) then
        if reset = '1' then
            sig_z1 <= '0';
            opmode_rr <= (others => '0');
        else
            sig_z1 <= sig_in;
            if sig_in = '1' then
                if sig_z1 = '0' then
                    opmode_rr <= opmode_r;
                end if;
            end if;
        end if;
    end if;
    end process;

    sawtooth_gen: process (clk)
    begin
    if rising_edge (clk) then
        if reset = '1' then
            sawtooth_sign_bit_r <= '0';
        else
            if sig_in = '1' then
                if sig_z1 = '0' then
                    if sawtooth_sign_bit_r = '0' then
                        if unsigned(drift_dly_v_r) = unsigned(opmode_drift_max_v) then
                            sawtooth_sign_bit_r <= '1';
                        end if;
                    else
                        if unsigned(drift_dly_v_r) = unsigned(opmode_drift_min_v) then
                            sawtooth_sign_bit_r <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end if;
    end process;

    sync_sel: process (clk)
    begin
    if rising_edge (clk) then
        case (opmode_rr) is
            WHEN "00" =>
                drift_dly_sign_bit <= '0';
                dly_en <= drift_dly_en_r;
                dly_v  <= drift_dly_v_r;
                            
            WHEN "01" =>
                drift_dly_sign_bit <= '1';
                dly_en <= drift_dly_en_r;
                dly_v  <= drift_dly_v_r;

            WHEN "10" =>
                drift_dly_sign_bit <= sawtooth_sign_bit_r;
                dly_en <= drift_dly_en_r;
                dly_v  <= drift_dly_v_r;

            WHEN "11" =>
                dly_en <= rand_dly_en_s;
                dly_v  <= rand_dly_v_s;
                
        end case;
    end if;
    end process;

end rtl;
