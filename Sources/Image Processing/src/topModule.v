`timescale 1ns/1ps


////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Top module
//////////////////////////////////////////////////////////////////////////////////


module topModule #(
    parameter INFILE  = "./image.hex",
    parameter WIDTH = 768, // Image width 
    parameter HEIGHT = 512, // Image height 
    parameter OUTFILE = "outputSorbel.bmp", // Output image 
    parameter BITS_FOR_INDEX = 10,// ceil(lg(max(width, height)))
    parameter sizeOfWidth = 8,
    parameter sizeOfLengthReal = WIDTH*HEIGHT*3,
    parameter BMP_HEADER_NUM = 54
)
(
    input CAMERA_CLK,
    input rst,
    output reg writeDone
//    output reg[7:0] outputPixel_R,
//    output reg[7:0] outputPixel_G,
//    output reg [7:0] outputPixel_B,
//    output reg [10:0] outX,
//    output reg [10:0] outY,
//    output reg [7:0] outputPixel,
//    output reg writeDone
);



wire [7:0] red, green, blue, outputPixel;
wire [10:0] outX, outY;
wire [10:0] outX_n, outY_n;
wire writeDone_temp;
reg writeEn;


// read data from file like reading from camera pixel by pixel
fileRead simCamera2 (
    .CAMERA_CLK(CAMERA_CLK),
    .rst(rst),
    .outputPixel_R(red),
    .outputPixel_G(green),
    .outputPixel_B(blue),
    .X(outX),
    .Y(outY)
);


// store data in frame buffer
frameBuffer Fbuf2(
    .CAMERA_CLK(CAMERA_CLK),
    .rst(rst),
    .inputPixel_R(red),
    .inputPixel_G(green),
    .inputPixel_B(blue),
    .coordinate_X(outX),
    .coordinate_Y(outY),
    .readWrite(writeEn),
    .outputPixel_R(),
    .outputPixel_G(),
    .outputPixel_B(),
    .outX(outX_n),
    .outY(outY_n),
    .outputPixel(outputPixel),
    .writeDone(writeDone_temp)
);


always@(posedge CAMERA_CLK)
begin
    if(rst)
    begin
        writeEn <= 1'b1;  
        writeDone <= 1'b0;
    end
    else
    begin
        writeDone <= writeDone_temp;
    end     

end


endmodule