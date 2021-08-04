library ieee;
use     ieee.numeric_std.all;
use     ieee.std_logic_1164.all;

entity counter is
generic (
    G_CLK_FREQ_HZ: positive := 100000000
);
port (
    clk: in std_logic;
    reset: in std_logic;
    enable: in std_logic;
    -- dly
    dly_en: in std_logic;
    dly_value: in std_logic_vector(31 downto 0);
    -- output
    sig: out std_logic
);
end entity counter;

architecture rtl of counter is

    signal dly_r: std_logic_vector(31 downto 0) := (others => '0');
    signal count_r: std_logic_vector(31 downto 0) := (others => '0');

    signal out_r: std_logic := '0';
begin

    process (clk)
    begin
    if rising_edge (clk) then
        if dly_en = '1' then
            dly_r <= dly_value;
        end if;
    end if;
    end process;

    process (clk)
    begin
    if rising_edge (clk) then
        if reset = '1' then
            out_r <= '0';
            count_r <= std_logic_vector(to_unsigned(G_CLK_FREQ_HZ, 32) -1); 
        else
            out_r <= '0';
            if enable = '1' then
                if signed(count_r) = 0 then 
                    out_r <= '1';
                    count_r <= std_logic_vector(
                        to_signed(G_CLK_FREQ_HZ, 32)
                        + signed(dly_value) -1
                    );
                else
                    count_r <= std_logic_vector(signed(count_r)-1); 
                end if;
            end if;
        end if;
    end if;
    end process;

    sig <= out_r;

end rtl;
