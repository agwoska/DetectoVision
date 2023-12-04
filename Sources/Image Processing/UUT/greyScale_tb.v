`timescale 1ns/1ps /**************************************************/ 
////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: testbench for the gray scale
//////////////////////////////////////////////////////////////////////////////////
//`include "parameter.v" // include definition file module tb_simulation; 
//------------------ // Internal Signals 
//------------------------------------------------- 

`define INPUTFILENAME "image.hex" // Input file name 
//`define OUTPUTFILENAME "output3.bmp" // Output file name 
// fpga4student.com FPGA projects, Verilog projects, VHDL projects


module greyScale_tb();
reg HCLK, HRESETn; 
parameter BITS_FOR_INDEX = 10;
wire [BITS_FOR_INDEX-1:0]rowIndex;
wire [BITS_FOR_INDEX-1:0]colIndex;
wire [ 7 : 0] data_R0; 
wire [ 7 : 0] data_G0; 
wire [ 7 : 0] data_B0; 
wire enc_done; 

greyScale #(.INFILE(`INPUTFILENAME)) 
u_image_read 
( .HCLK (HCLK ), 
.HRESETn (HRESETn ),
 .rowIndex (rowIndex ), 
.colIndex (colIndex ), 
.DATA_R0 (data_R0 ),
 .DATA_G0 (data_G0 ), 
.DATA_B0 (data_B0 ),  
.ctrl_done (enc_done) 
); 
imageWrite #(.INFILE(`OUTPUTFILENAME)) 
u_image_write ( 
.HCLK(HCLK), 
.HRESETn(HRESETn),
 .rowIndex (rowIndex ), 
.colIndex (colIndex ),
.DATA_WRITE_R0(data_R0),
 .DATA_WRITE_G0(data_G0),
 .DATA_WRITE_B0(data_B0), 
 .Write_Done()
 ); 
//------------- // Test Vectors 
//------------------------------------- 
initial 
begin 
HCLK = 0; 
forever #10 HCLK = ~HCLK; 
end 
initial 
begin 
HRESETn = 0; 
#25 HRESETn = 1; 
#25 HRESETn = 0; 
end endmodule
