TOPLEVEL = counter
MODULE = testbench

VHDL_SOURCES  = $(shell pwd)/../../src/$(TOPLEVEL).vhd

TOPLEVEL_LANG = vhdl
SIM = ghdl

GTKWAVE = /usr/bin/gtkwave

SIM_ARGS += -gG_CLK_FREQ_HZ=100
#SIM_ARGS += -gG_CLOG2_CLK_FREQ_HZ=7
SIM_ARGS += --vcd=$(TOPLEVEL).vcd

export COCOTB_REDUCED_LOG_FMT=1
include $(shell cocotb-config --makefiles)/Makefile.sim

view:
	$(GTKWAVE) waveform.gtkw
