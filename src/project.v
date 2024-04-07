//--------------------Tiny Tapeout template Donot touch it--------------------
/*
 * Copyright (c) 2024 Silicon University, Bhubaneswar, India
 * SPDX-License-Identifier: Apache-2.0
 */
// Code your design here
//`timescale 1ns / 1ps
//DEFINES
`define RST_COUNT       5'd0
`define CS_LOW_COUNT    5'd4
`define CS_HIGH_COUNT   5'd20
`define SPI_LATCH_COUNT 5'd22
`define MAX_COUNT       5'd28
`define SPI_IDLE	2'b00
`define SPI_READ	2'b01
`define SPI_LATCH	2'b10


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
  assign uio_oe  = 8'b00001111;
  assign uio_out[7:4] = 4'b0000;
//-------------------------------------------------------------------------------------

//--------------Declaration of intenal signal to ports--------------
    //Internal signal-to-port assignment
    assign sel_ext_seg = ui_in[0];    //DIP switch-1: 0-> demo brd 1 7-seg, 1-> ext 2 7-seg
    assign sel_ob_LSB  = ui_in[1];        //DIP switch-2: if ui_in[0]=0: 1-> LSB, 0-> MSB
    assign sel_CorF = ui_in[2];		//DIP switch-3: 0-> Centigrade: 1-> Farahneight
    // 7-segment display output
    assign uo_out[0] = dataSeg[0];        //7-seg A
    assign uo_out[1] = dataSeg[1];        //7-seg B
    assign uo_out[2] = dataSeg[2];        //7-seg C
    assign uo_out[3] = dataSeg[3];        //7-seg D
    assign uo_out[4] = dataSeg[4];        //7-seg E
    assign uo_out[5] = dataSeg[5];        //7-seg F
    assign uo_out[6] = dataSeg[6];        //7-seg G
    assign uo_out[7] = dataSeg[7];        //7-seg DP
    // SPI signals
    assign uio_out[0] = CS;              //CS-->chip select for LM70
    assign uio_out[1] = SCK;             //SCK--> clock for LM70
    assign uio_out[2] = sel_ext[1];      //MSB
    assign uio_out[3] = sel_ext[0];      //LSB
    assign SIO = uio_in[4];              //SDI/MISO Data input

  wire SIO;
  wire CS;
  reg SCK;
  reg [7:0] dataSeg;
  wire sel_CorF;
  

  reg [7:0] shift_reg;
  reg [7:0] tempC_bin_latch;
  wire [7:0] tempF;
  wire [7:0] tempCorF;
  reg [1:0] spi_state;
  reg [4:0] count;
  wire sysclk_gated;
  wire [3:0] bcd_msb;
  wire [3:0] bcd_lsb;
  wire [3:0] bcd_out;
  reg ext_lsb_ctrl;         //for controlling the the 7 segment displays outside the board
  wire [1:0] sel_ext;       //sel_ext[1]-MSB/sel_ext[0]-LSB
  wire sel_ext_seg;              
  // input signal for ui[0]-->ui[0]=1:use external 7 segment/=0:use demoboard 7 segment
  wire sel_ob_LSB;               
  // input signal for ui[1]-->ui[1]=1:show LSB/:show MSB in on board 7 segment hence ui[0] = 0 for this

  // MUX1: selects LSB/MSB
  // MUX2: selects external or internal display
  assign bcd_out = (sel_ext_seg ? ext_lsb_ctrl : sel_ob_LSB) ? bcd_lsb : bcd_msb ;
  

  // BCD ot 7-segment converter
  always @(*) begin//represents combinational logic
    case (bcd_out)
        4'b0000: dataSeg = 8'b00111111;	//0 0x3F
        4'b0001: dataSeg = 8'b00000110; //1 0x06
        4'b0010: dataSeg = 8'b01011011;	//2 0x5B	
        4'b0011: dataSeg = 8'b01001111;	//3 0x4F
        4'b0100: dataSeg = 8'b01100110;	//4 0x66
        4'b0101: dataSeg = 8'b01101101;	//5 0x6D
        4'b0110: dataSeg = 8'b01111101;	//6 0x7D
        4'b0111: dataSeg = 8'b00000111;	//7 0x07
        4'b1000: dataSeg = 8'b01111111;	//8 0x7F
        4'b1001: dataSeg = 8'b01101111;	//9 0x6E
        4'b1010: dataSeg = 8'b01101111;	//9
        4'b1011: dataSeg = 8'b01101111;	//9
        4'b1100: dataSeg = 8'b01101111;	//9
        4'b1101: dataSeg = 8'b01101111;	//9
        4'b1110: dataSeg = 8'b01101111;	//9
        4'b1111: dataSeg = 8'b01101111;	//9
        default: dataSeg = 8'b01101111; // Default case to avoid latches
    endcase
end

  // Course C-to-F conversion
  // temp(F) = 2*C + 32  (Accurate: 9*C/5 +32)
  // Error % is 0.62% at 0C and 9.43% at 100C
  assign tempF = (tempC_bin_latch<<1) + 6'h20;
  //MUX: Select C or F
  assign tempCorF = sel_CorF ? tempF : tempC_bin_latch;

  //BCD Logic
  //Temp/10 approx. 1/16 + 1/32
  assign bcd_msb = (tempCorF + (tempCorF>>1))>>4;
  //LSB = temp - 10*MSB = temp - (8*MSB + 2*MSB)
  assign bcd_lsb = tempCorF - ((bcd_msb<<3) + (bcd_msb<<1));  
 
  //shift register for the input (SIO)
  always @(posedge SCK or negedge rst_n)
    if (~rst_n)
      shift_reg <= 8'h00;
    else
      begin
        shift_reg <= shift_reg<<1;
	    shift_reg[0] <= SIO ;
      end

//SPI CLOCK SCK generator
 
  always @(negedge clk or negedge rst_n)
  if (~rst_n)
    SCK <= 1'b0;
  else if(CS)
    SCK <= 1'b0;
  else
    SCK <= ~SCK;

// Chip Select CS generator
assign CS = ~(spi_state == `SPI_READ);


//7-Segment select lines: sel_ext[0]-> LSB , sel_ext[1]-> MSB
 assign sel_ext[1] = ~ext_lsb_ctrl & sel_ext_seg;
 assign sel_ext[0] =  ext_lsb_ctrl & sel_ext_seg;
// 1 for MSB 0 for LSB always --> our covention

// 3-spi_state (IDLE, READ, LATCH) spi_state-machine
always @(posedge clk or negedge rst_n)
  if (~rst_n)
      begin	    
        spi_state <= `SPI_IDLE;
        tempC_bin_latch <= 8'b0;
        ext_lsb_ctrl <= 0;
      end
  else if ((count >= `CS_LOW_COUNT) && (count < `CS_HIGH_COUNT) )
      begin
        spi_state <= `SPI_READ;
      end
  else if (count == `SPI_LATCH_COUNT)
      begin	    
        spi_state <= `SPI_LATCH;
        tempC_bin_latch <= shift_reg<<1;
        ext_lsb_ctrl <= ~ext_lsb_ctrl ;
      end
  else 
      begin	    
        spi_state <= `SPI_IDLE;
      end

  //5b Counter
  always @(posedge clk or negedge rst_n)
    if (~rst_n)
       count <= `RST_COUNT;
    else if (count == `MAX_COUNT)
       count <= `RST_COUNT;
    else
       count <= count + 1'b1;
 endmodule
