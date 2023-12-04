`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 02:14:21 AM
// Design Name: 
// Module Name: colorMask
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


module colorMask#(
parameter INFILE  = "./image.hex",
parameter WIDTH = 768, // Image width 
parameter HEIGHT = 512, // Image height 
parameter OUTFILE = "outputSorbel.bmp", // Output image 
parameter BITS_FOR_INDEX = 10,// ceil(lg(max(width, height)))
parameter sizeOfWidth = 8,
parameter sizeOfLengthReal = WIDTH*HEIGHT*3,
parameter BMP_HEADER_NUM = 54,
//parameter threshold = 140,
parameter threshold = 180,
parameter bit2choose = 1 // 1->R 2->G 3->B
)(
input CAMERA_CLK,
input rst, 
input[7:0] inputPixel_R,
input[7:0] inputPixel_G,
input [7:0] inputPixel_B,
input [10:0] coordinate_X,
input [10:0] coordinate_Y,
input readWrite,
output reg writeBackImage,
output reg [7:0] outputPixel
);


always@(posedge CAMERA_CLK)
begin
    if(rst)
    begin
        outputPixel <= 0;
        writeBackImage <= 1'b0;
//        outX <= 0;
//        outY <= 0;
    end
    else if(readWrite == 1'b1)
    begin
        writeBackImage <= 1'b1;



//        if (((0.3*inputPixel_R) + (0.6*inputPixel_G) + (0.1*inputPixel_B)) > threshold)
//            outputPixel <= 80;
//        else
//            outputPixel <= 0;


        case(bit2choose)
            1: outputPixel <= (inputPixel_R > threshold)? 77:0;
            2: outputPixel <= (inputPixel_G > threshold)? 77:0;        
            default: outputPixel <= (inputPixel_B > threshold)? 77:0; 
        endcase
    end
end






endmodule
