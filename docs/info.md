<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## Digital Temperature Monitor

![Blcok Diagram](tt06-blockdiag.png) 

This project reads the LM70 temperature sensor using Serial Peripheral Interface (SPI) protocol. The LM70 is a digital temperature sensor that uses an SPI bus for communication with other devices. The sensor can measure temperatures ranging from -55°C to 150°C with a resolution of ±0.25°C.
This circuit reads the LM07 data in a binary format, converts into BCD and then to 7-segment display and displays it.

### Mode of Operation

| DIP-1 | DIP-2 | DIP-3 | |
| `ui_in[0]` | `ui_in[1]` | `ui_in[2]` | DESCRIPTION |
|-|-|-|-|
| `0` | `X` | `0` | External Display in deg-C |
| `0` | `X` | `1` | External Display in deg-F |
| `1` | `0` | `X` | MSB Onboard Display in deg-C |
| `1` | `1` | `X` | LSB Onboard Display in deg-C |



## How to test

A LM07 is connected to the PMOD to interface it for SPI read (CS, CLK, MISO). A detail test plan is coming.

## External hardware

Needs a LM07 interfaced on the PCB. Detail hardware plan coming soon.
