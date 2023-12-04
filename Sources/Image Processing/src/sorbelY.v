`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 12:33:07 PM
// Design Name: 
// Module Name: sorbelY
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


module sorbelY#(parameter 
WIDTH = 768, // Image width 
HEIGHT = 512, // Image height 
INFILE = "output3.bmp", // Output image 
BITS_FOR_INDEX = 10, // ceil(lg(max(width, height)))
sizeOfWidth = 8,
sizeOfLengthReal = WIDTH*HEIGHT*3
) 

( input [(3*sizeOfWidth)-1:0] temp3, temp4,
  output  [(2*sizeOfWidth)-1:0] out
);
    wire tempL, tempR;

    assign tempL = (temp4[(3*sizeOfWidth)-1:(2*sizeOfWidth)]) + (2*temp4[(2*sizeOfWidth)-1:(1*sizeOfWidth)]) +(temp4[(1*sizeOfWidth)-1:0]);
    assign tempR = (-1*temp3[(3*sizeOfWidth)-1:(2*sizeOfWidth)]) + (-2*temp3[(2*sizeOfWidth)-1:(1*sizeOfWidth)]) +(-1*temp3[(1*sizeOfWidth)-1:0]);
    assign out = tempL + tempR;



endmodule
