library ieee;
use     ieee.std_logic_1164.all;

entity unisim;
use    unisim.vcomponents.all;

entity clock_subsystem is
port (
    -- clk_ext
    clk_ext_p: in std_logic;
    clk_ext_n: in std_logic;
    -- clk_int
    clk_int_p: in std_logic;
    clk_int_n: in std_logic;
    -- sel
    sel: in std_logic;
);
end clock_subsystem;

architecture rtl of clock_subsystem is

    signal clk_ext_s: std_logic := '0';
    signal clk_int_s: std_logic := '0';
    signal clk_s: std_logic := '0';
begin

    bufgmux_inst: BUFGMUX 
    port map (
        I1 => clk_int_s,
        I2 => clk_ext_s,
        S => sel,
        O => clk_s
    );

end rtl;
