/*
 * Copyright (c) 2024 Silicon University, Bhubaneswar, India
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

// DO NOT CHANGE THIS MODULE
module tt_um_silicon_tinytapeout_lm07 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_oe  = 8'b00000011;
  assign uio_out[7:2] = 6'b000000;

//Internal signal-to-port assignment
// FIX all the EXSIG_xxxx signals to reflect the internal signal
    //assign EXSIG_DIP1 = ui_in[0];    //DIP switch-1: 0-> demo brd 1 7-seg, 1-> ext 2 7-seg
    //assign EXSIG_DIP2 = ui_in[1];        //DIP switch-2
    // 7-segment display output
    //assign uo_out[0] = EXSIG_A;        //7-seg A
    //assign uo_out[1] = EXSIG_B;        //7-seg B
    //assign uo_out[2] = EXSIG_C;        //7-seg C
    //assign uo_out[3] = EXSIG_D;        //7-seg D
    //assign uo_out[4] = EXSIG_E;        //7-seg E
    //assign uo_out[5] = EXSIG_F;        //7-seg F
    //assign uo_out[6] = EXSIG_G;        //7-seg G
    //assign uo_out[7] = EXSIG_SEL;      //7-seg SEL 0-LSB 1-MSB
    // SPI signals
    //assign uio_out[0] = EXSIG_CS;      //CS
    //assign uio_out[1] = EXSIG_SCK;     //SCK
    //assign EXSIG_SDI = uio_in[2];      //SDI/MISO Data input

endmodule
