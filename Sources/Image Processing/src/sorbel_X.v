`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 12:00:06 PM
// Design Name: 
// Module Name: sorbel_X
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


module sorbel_X#(parameter 
WIDTH = 768, // Image width 
HEIGHT = 512, // Image height 
INFILE = "output3.bmp", // Output image 
BITS_FOR_INDEX = 10, // ceil(lg(max(width, height)))
sizeOfWidth = 8,
sizeOfLengthReal = WIDTH*HEIGHT*3
) 

( input [(3*sizeOfWidth)-1:0] temp1, temp2,
  output  [(2*sizeOfWidth)-1:0] out
);
    wire tempL, tempR;

    assign tempL = (temp1[(3*sizeOfWidth)-1:(2*sizeOfWidth)]) + (2*temp1[(2*sizeOfWidth)-1:(1*sizeOfWidth)]) +(temp1[(1*sizeOfWidth)-1:0]);
    assign tempR = (-1*temp2[(3*sizeOfWidth)-1:(2*sizeOfWidth)]) + (-2*temp2[(2*sizeOfWidth)-1:(1*sizeOfWidth)]) +(-1*temp2[(1*sizeOfWidth)-1:0]);
    assign out = tempL + tempR;



endmodule
