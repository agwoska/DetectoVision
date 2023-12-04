`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 10:21:44 AM
// Design Name: 
// Module Name: sorbelFilter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sorbelFilter
#(
  parameter     WIDTH  = 768,   // Image width
         HEIGHT  = 512,   // Image height
  INFILE  = "./image.hex",  // image file
    BITS_FOR_INDEX = 11,// ceil(lg(max(width, height)))
    BMP_HEADER_NUM = 54, 
    sizeOfWidth = 32,
    sizeOfLengthReal = WIDTH*HEIGHT*3
)
(
  input HCLK,          // clock     
  input HRESETn,         // Reset (active low
  input [7:0] matrixforSorbel [0: WIDTH*HEIGHT-1];
  
  // Process and transmit 2 pixels in parallel to make the process faster, you can modify to transmit 1 pixels or more if needed
  output  reg   ctrl_done     // Done flag
); 



endmodule
