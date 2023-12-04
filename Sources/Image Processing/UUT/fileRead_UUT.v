`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Unit under test for file read
//////////////////////////////////////////////////////////////////////////////////


module fileRead_UUT();
    
    
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

wire [7:0] red, green, blue;
wire [10:0] outX, outY;


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

initial 
begin 
    clk = 0; 
    forever #10 clk = ~clk; 
end 

initial 
begin 
    rst = 0; 
    #25 rst = 1; 
    #25 rst = 0; 
    #100000 $finish;
end 
endmodule

