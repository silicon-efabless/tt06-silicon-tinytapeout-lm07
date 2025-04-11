# Testing with the TinyTapeout Demo Board

## Test Resources

- [Getting Started with Demo Board](https://tinytapeout.com/guides/get-started-demoboard/)
- [Analog Testing with Analog Discovery-2](https://tinytapeout.com/guides/analog-discovery/)
- [Demo Video](https://youtube.com/shorts/WfNDrHECN1A)

## Qucik Start Guide

Instruction below are a quick start guide to getting started. Detail instruction can be found in the [Getting Started with Demo Board](https://tinytapeout.com/guides/get-started-demoboard/) guide at TinyTapeout.

- Connect the temperature sensor to the Demo Board using the BDIR (middle) PMOD:
  - `BDIR0 (top right) -> CS`, `BDIR1 -> SCK`, `BDIR2 -> SDO`, `3.3V (Left) -> Power`, and `GND (Left+1) -> Gnd`
  - [Pinout Overview of the Demo Booard](/docs/tt08-demoboard-pinout.jpg)
  - [Schematic of the Demo Board](/docs/tt08-schematic-preview.jpg) [[PDF](/docs/demoboard-v2-1-2.pdf)]
  - You can find everything about the demoboard on this [GitHub Page](https://github.com/TinyTapeout/tt-demo-pcb)
- Using your browser connect to the [Commander App](https://commander.tinytapeout.com/)
- Connect the board via USB-C and click `CONNECT TO BOARD`
- If the board is connected properly, a pop-up should pop and select the apprpriate device and `Connect`
- If all goes well, the Commander App Window should pop up

![Commander App Window](/docs/commander-connected-cropped.png)

- Click the project drop-down and find the project you want. You can start typing the name of the project and it should automatically start matching the right one.
- If your required clock speed was entered in the project YAML file, it should automatically fill up else you can maually enter it.
- Then click `SELECT` to make the changes to the demo board and you should see the MSB of the temperature on the 7-seg display.
- Select the second DIP switch to display the LSB.
- Select the third DIP switch to display the temperature in Farenheit.

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

