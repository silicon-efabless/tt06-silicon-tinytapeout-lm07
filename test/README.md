# Testing with the TinyTapeout Demo Board

## Test Resources

- [Getting Started with Demo Board](https://tinytapeout.com/guides/get-started-demoboard/)
- [Analog Testing with Analog Discovery-2](https://tinytapeout.com/guides/analog-discovery/)
- [Demo Video](https://youtube.com/shorts/WfNDrHECN1A)

## Qucik Start Guide

Instruction below are a quick start guide to getting started. Detail instruction can be found in the [Getting Started with Demo Board](https://tinytapeout.com/guides/get-started-demoboard/) guide at TinyTapeout.

- Connect the temperature sensor to the Demo Board using the BDIR (middle) PMOD:
  - `BDIR0 (top right) -> CS`, `BDIR1 -> SCK`, `BDIR2 -> SDO`, `3.3V (Left) -> Power`, and `GND (Left+1) -> Gnd`
  - [Pinout Overview of the Demo Booard](docs)

# Design Verification (TBD) 

This is a sample testbench for a Tiny Tapeout project. It uses [cocotb](https://docs.cocotb.org/en/stable/) to drive the DUT and check the outputs.

## Setting up

1. Edit [Makefile](Makefile) and modify `PROJECT_SOURCES` to point to your Verilog files.
2. Edit [tb.v](tb.v) and replace `tt_um_example` with your module name.

## How to run

To run the RTL simulation:

```sh
make
```

To run gatelevel simulation, first harden your project and copy `../runs/wokwi/results/final/verilog/gl/{your_module_name}.v` to `gate_level_netlist.v`.

Then run:

```sh
make GATES=yes
```

## How to view the VCD file

```sh
gtkwave tb.vcd tb.gtkw
```

