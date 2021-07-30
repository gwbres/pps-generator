library ieee;
use     ieee.std_logic_1164.all;

entity pps_generator is
generic (

);
port (
    -- clk ext
    clk_ext_p: in std_logic;
    clk_ext_n: in std_logic;
    -- clk int
    clk_int_p: in std_logic;
    clk_int_n: in std_logic;
    -- 1PPS
    pps_out: out std_logic
);
end pps_generator;

architecture rtl of pps_generator is

    signal clk_sel_r: std_logic := '0';
begin

    clock_sub_system_inst: entity work.clock_sub_system
    port map (
        clk_ext_p => clk_ext_p,
        clk_ext_n => clk_ext_n,
        clk_int_p => clk_int_p,
        clk_int_n => clk_int_n,
        sel => clk_sel_r,
    );

    mmap_subsyst_inst: entity work.mmap_sub_system
    port map (
        -- mmap
        clk_sel_r => clk_sel_r,
    );

end rtl;
