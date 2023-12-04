`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Unit under test for file read
//////////////////////////////////////////////////////////////////////////////////


module frameBuffer_UUT();
    
    
parameter INFILE  = "./image.hex";
parameter WIDTH = 768; // Image width 
parameter HEIGHT = 512; // Image height 
parameter OUTFILE = "outputSorbel.bmp"; // Output image 
parameter BITS_FOR_INDEX = 10;// ceil(lg(max(width, height)))
parameter sizeOfWidth = 8;
parameter sizeOfLengthReal = WIDTH*HEIGHT*3;
parameter BMP_HEADER_NUM = 54;

reg clk;
reg rst;

wire [7:0] red, green, blue, outputPixel;
wire [10:0] outX, outY;
wire [10:0] outX_n, outY_n;
wire writeDone;
// read data from file like reading from camera pixel by pixel
fileRead simCamera (
    .CAMERA_CLK(clk),
    .rst(rst),
    .outputPixel_R(red),
    .outputPixel_G(green),
    .outputPixel_B(blue),
    .X(outX),
    .Y(outY)
);


// store data in frame buffer
frameBuffer Fbuf(
    .CAMERA_CLK(clk),
    .rst(rst),
    .inputPixel_R(red),
    .inputPixel_G(green),
    .inputPixel_B(blue),
    .coordinate_X(outX),
    .coordinate_Y(outY),
    .readWrite(1'b1),
    .ul(),
    .uc(),
    .ur(),
    .ml(),
    .mc(),
    .mr(),
    .dl(),
    .dc(),
    .dr(),
    .writeDone(writeDone)
);


always@(writeDone)
begin
    if(writeDone == 1'b1)
        $finish;
end



initial 
begin 
    clk = 0; 
    forever #10 clk = ~clk; 
end 

initial 
begin 
     rst = 1; 
    #85 rst = 0; 
//    #100000 $finish;
end 
endmodule

