#! /usr/bin/env python3

import cocotb

from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.utils import get_sim_time
from cocotb.result import TestFailure, TestComplete, TestSuccess

@cocotb.test()
async def testbench (dut):
    clock = Clock (dut.clk, 10, units="ns")

    # init dut
    cocotb.fork(clock.start())
    dut.reset <= 1
    dut.enable <= 0
    dut.dly_en <= 0
    dut.dly_value <= 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    dut.reset <= 0
    await RisingEdge(dut.clk)
    dut.enable <= 1
    await RisingEdge(dut.clk)

    prev_t = None

    for dly in [0, 10, 100, -10, -20, -30]:
        await RisingEdge(dut.clk)
        dut.dly_en <= 1
        dut.dly_value <= dly
        await RisingEdge(dut.clk)
        dut.dly_en <= 0

        await RisingEdge(dut.sig)
        now = get_sim_time(units='ns')
        if prev_t is not None:
            print(now - prev_t)

        prev_t = now
            
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut._log.info("Test passed!")
