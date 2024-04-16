<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## Objective

This is an educational project for undergraduate engineering students with the objective of exposing them to real-world product design. In the process, the students learn a wide variety of engineering principles including product design, digital system design, mixed-signal modeling, digital design using Verilog, design verification, ASIC design flow, FPGA design flow, and documentation using gitHub.

## Project Brief

This project implements a digital temperature monitor by connecting a temperature sensor (LM70) and a three-segment display to measure and display a range of $0-99^\circ~C$ or $0-99^\circ~F$ with an accuracy of $\pm 2^\circ~C$.

## How it Works

![Block diagram of the complete system.](tt06-blockdiag.png) 

Figure~1 shows the overall block diagram of the complete system. The temperature sensor (Texas Instrument LM70) has a dynamic range of 11 bits with a resolution of $\pm 0.25^\circ~C$. In this project, we will only use MSB 8 bits with a resolution of $\pm2^\circ~C$. As shown in the timing diagram in the top right corner of the Figure.~1, the LM 70 is configured as an SPI \textit{peripheral}, with communication initiated by choosing the chip (CS) low. While CS is low, the data is clocked out of the sensor every \textit{negative edge} of the SPI clock (SCK) and the design reads those data at the following \textit{positive edge}. The design provides eight SCK clock pulses, and then the CS is pulled high to stop the communication.

The serial 8-bit data are captured in a shift register, and the data is \textit{latched} after 8 SCK clock pulses. Before the data are latched, it is multiplied by 2 (left shift by 1). This multiplication captures the fact that the LSB of the data is $2^\circ~C$.

### Mode of Operation

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
