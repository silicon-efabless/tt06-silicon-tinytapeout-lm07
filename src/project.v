//--------------------Tiny Tapeout template Donot touch it--------------------
/*
 * Copyright (c) 2024 Silicon University, Bhubaneswar, India
 * SPDX-License-Identifier: Apache-2.0
 */
// Code your design here
`timescale 1ns / 1ps
//DEFINES
`define RST_COUNT       5'd0
`define CS_LOW_COUNT    5'd4
`define CS_HIGH_COUNT   5'd20
`define WRITE_LSB_COUNT	5'd22
//`define WRITE_LSB_COUNT	5'd24
`define MAX_COUNT       5'd28
`define SPI_IDLE	2'b00
`define SPI_READ	2'b01
`define DISP_WRITE_MSB	2'b10
`define DISP_WRITE_LSB	2'b11


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
    assign sel_ob_LSB  = ui_in[1];        //DIP switch-2
    // 7-segment display output
    assign uo_out[0] = dataSeg[7];        //7-seg A
    assign uo_out[1] = dataSeg[6];        //7-seg B
    assign uo_out[2] = dataSeg[5];        //7-seg C
    assign uo_out[3] = dataSeg[4];        //7-seg D
    assign uo_out[4] = dataSeg[3];        //7-seg E
    assign uo_out[5] = dataSeg[2];        //7-seg F
    assign uo_out[6] = dataSeg[1];        //7-seg G
    assign uo_out[7] = dataSeg[0];      //7-seg SEL 0-LSB 1-MSB
    // SPI signals
    assign uio_out[0] = CS;              //CS-->chip select for LM70
    assign uio_out[1] = SCK;             //SCK--> clock for LM70
    assign uio_out[2] = sel_ext[1];      //MSB
    assign uio_out[3] = sel_ext[0];      //LSB
    assign SIO = uio_in[4];              //SDI/MISO Data input

  wire SIO;
  wire CS;
  reg SCK;
  wire [1:0] disp;
  reg [7:0] dataSeg;
  

  reg [7:0] shift_reg;
  reg [1:0] spi_state;
  reg [4:0] count;
  wire sysclk_gated;
  wire [7:0] temp_bin;
  wire [3:0] bcd_msb;
  wire [3:0] bcd_lsb;
  wire [3:0] bcd_latch;
  //reg  [3:0] bcd_data;
  reg ext_lsb_ctrl;         //for controlling the the 7 segment displays outside the board
  wire [1:0] sel_ext;       //sel_ext[1]-MSB/sel_ext[0]-LSB
  wire sel_ext_seg;              
  // input signal for ui[0]-->ui[0]=1:use external 7 segment/=0:use demoboard 7 segment
  wire sel_ob_LSB;               
  // input signal for ui[1]-->ui[1]=1:show LSB/:show MSB in on board 7 segment hence ui[0] = 0 for this


  assign bcd_latch = (sel_ext_seg ? ext_lsb_ctrl : sel_ob_LSB) ? bcd_lsb : bcd_msb ;
  


  // Frequency Divider Clock
  // Frequency divide by 8
  reg [2:0] cnt;
  always @ (posedge clk) begin
     if(!rst_n) begin
      ext_lsb_ctrl = 0;
      cnt =0;
      end	
     else  cnt = cnt+1;
     if (cnt==4) begin
        ext_lsb_ctrl = ~ext_lsb_ctrl;
        cnt = 0;
       end
    end

  always @(*) begin//represents combinational logic
    case (bcd_latch)
        4'b0000: dataSeg = 8'b11111100;
        4'b0001: dataSeg = 8'b01100000;
        4'b0010: dataSeg = 8'b11011010;
        4'b0011: dataSeg = 8'b11110010;
        4'b0100: dataSeg = 8'b01100110;
        4'b0101: dataSeg = 8'b10110110;
        4'b0110: dataSeg = 8'b10111110;
        4'b0111: dataSeg = 8'b11100000;
        4'b1000: dataSeg = 8'b11111110;
        4'b1001: dataSeg = 8'b11110110;
        default: dataSeg = 8'b00000000; // Default case to avoid latches
    endcase
end

  //Since LSB is 2-deg C, multiply by 2
  assign temp_bin = shift_reg<<1;

  //BCD Logic
  //Temp/10 approx. 1/16 + 1/32
  assign bcd_msb = (temp_bin + (temp_bin>>1))>>4;
  //LSB = temp - 10*MSB = temp - (8*MSB + 2*MSB)
  assign bcd_lsb = temp_bin - ((bcd_msb<<3) + (bcd_msb<<1));  
 
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


//7-Segment select lines
 assign disp[1] =  (spi_state == `DISP_WRITE_MSB);
 assign disp[0] =  (spi_state == `DISP_WRITE_LSB);
 assign sel_ext[1] = disp[1] & sel_ext_seg;
 assign sel_ext[0] = disp[0] & sel_ext_seg;
// 1 for MSB 0 for LSB always --> our covention

//assign bcd_latch <= bcd_data;
// 2-spi_state (IDE, READ) spi_state-machine
always @(posedge clk or negedge rst_n)
  if (~rst_n)
      begin	    
        spi_state <= `SPI_IDLE;
      //  bcd_data <= 4'b0000;
      end
  else if ((count >= `CS_LOW_COUNT) && (count < `CS_HIGH_COUNT) )
      begin
        spi_state <= `SPI_READ;
      end
  else if (count == `CS_HIGH_COUNT)
      begin	    
        spi_state <= `DISP_WRITE_MSB;
    //  bcd_data <= bcd_msb;
      end
  else if (count == `WRITE_LSB_COUNT)
      begin	    
        spi_state <= `DISP_WRITE_LSB;
   //   bcd_data <= bcd_lsb;
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
