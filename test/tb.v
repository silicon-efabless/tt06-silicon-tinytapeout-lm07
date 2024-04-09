`timescale 1ns/1ps

/******************************************************************************/
`default_nettype none

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Replace tt_um_example with your module name:
  tt_um_silicon_tinytapeout_lm07 obj(

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );



/***********************************************************************/
  wire SCK;
  wire CS;
  wire [1:0] disp;
 
  assign SCK = uio_out[1];
  assign CS = uio_out[0];
  assign disp[1] = uio_out[2];
  assign disp[0] = uio_out[3];
  
  initial ena <= 1;
  initial begin
    #5 
    ui_in[0] = 1;	//0-> onboard disp. 1-> external display
    ui_in[1] = 0;	//if ui_in[0]=0;  0-> MSB, 1-> LSB 
    ui_in[2] = 0; 	//0-> Output centigrade, 1-> Fahrenheit 
  end

  //Task for simple test
  task testRead;
    begin
        #15   rst_n = 1'b1;
    end
  endtask
  
  wire SIO;
  //initial uio_in[4] <= SIO;
  //initial cannot be used as it run only once
  always @(*) begin uio_in[5] <= SIO; end
  
  //Instiate LM07
  LM07 tsense(.CS(CS), .SCK(SCK), .SIO(SIO));
 
  //Initialize CS
  initial rst_n = 1'b0;
  
  //Generate test clock
  initial clk= 1'b1;
  initial forever #10 clk = ~clk;    

  //Testbench
  initial
    begin
      //$monitor("time= %0t;data[]=,CS=%b,CLK=%b,SIO=%b,",$time,CS,CLK,SIO);
      testRead;
      #4500
      $finish(2);
    end
endmodule
//////////////////////////////TEMP SENSOR LM70 DUMMY MODEL/////////////////
//Define
// In this design we only read the 8-MSBs 
// which has a resolution of 2-deg C 
//--------TEST POINTS-----------
//                           Data given    Data we get in 7 seg in C 
`define TEMP_SET  16'h0B9F      //22 C --> 22
//`define TEMP_SET  16'h111F    //34 C --> 34
//`define TEMP_SET  16'h191F    //50 C --> 49 
//`define TEMP_SET  16'h241F    //72 C --> 69

/***********************************************************/
//-----ONLY DATA POINT THAT SYSTEM CANNOT HANDLE-----
//`define TEMP_SET  16'h251F    //74 C --> 6C
//`define TEMP_SET  16'h259F    //75 C --> 6C
/* NOTE
Our design cannot handle points data more than 74 
because of our conversion algorithm error
ex.
say sensor sends data 74 
bcd_msb = 74 * (1/16 + 1/32) = 74*0.09375 = 6.9375
=> bcd_msb = 6
bcd_lsb = 74 - 6*10 = 74 - 60 = 14 = E 
now in bcd to seven segemnt decoder we have assigned the bcd data 
e for displaying the celcius thats why result is coming 6C in the
7 segment display
*/
//---------------------------------------------------
/***********************************************************/

//`define TEMP_SET  16'h011F    //2  C --> 02
//`define TEMP_SET  16'h019F    //3  C --> 02 
//`define TEMP_SET  16'h021F    //4  C --> 04
//`define TEMP_SET  16'h039F    //7  C --> 06
//`define TEMP_SET  16'h041F    //8  C --> 08
//-------------------------------
// Verilog model for the SPI-based temperature 
// sensor LM07 or it's equivalent family.
//
module LM07(CS, SCK, SIO);
  output SIO;
  input SCK, CS;
  //
  // lm07_reg represents the register that stores
  // temperature value after A2D conversion
  // FIXME: Model the A2D
  reg [15:0] shift_reg;
  wire clk_gated;
  
  //Reset at startup
  initial begin
    shift_reg = `TEMP_SET; 
    //shift_reg = shift_reg>>1;
  end
  
  //SIO bit of the LM07 is hardwired output of
  // the MSB of the shift register
  assign SIO = shift_reg[15];

  //Gate the clock with CS
  assign clk_gated = ~CS & SCK;
  
  // When CS goes low, load temp_shift_reg with lm07_reg
  // If high, reset
  always @(CS)
   begin
     shift_reg = `TEMP_SET;
     //shift_reg = shift_reg>>1;
   end
  
  //Shift register to shift the loaded temp reg
  //every negedge of the gated clock
  always @(negedge clk_gated)
    begin
      shift_reg = shift_reg<<1;
    end
  /*initial begin
    $monitor("data=%0b,dataseg=%0b,dataout=%0b",SIO,dataSeg,dbugout);
  end*/
endmodule
