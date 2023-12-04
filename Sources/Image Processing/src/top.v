`timescale 1ns/1ps


////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Top module
//////////////////////////////////////////////////////////////////////////////////


module top #(
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
    output reg writeDone1,
    output reg writeDone2
//    output reg[7:0] outputPixel_R,
//    output reg[7:0] outputPixel_G,
//    output reg [7:0] outputPixel_B,
//    output reg [10:0] outX,
//    output reg [10:0] outY,
//    output reg [7:0] outputPixel,
//    output reg writeDone
);



wire [7:0] red, green, blue;
wire [10:0] outX, outY;
reg [10:0] inX, inY;
wire writeDone_temp, writeDone_temp2;
reg writeEn;

wire [7:0] ul, uc, ur, ml, mc, mr, dl, dc, dr;

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
    .coordinate_X(inX),
    .coordinate_Y(inY),
    .readWrite(writeEn),
    .ul(ul),
    .uc(uc),
    .ur(ur),
    .ml(ml),
    .mc(mc),
    .mr(mr),
    .dl(dl),
    .dc(dc),
    .dr(dr),
    .writeDone(writeDone_temp)
);

frameBuffer_sorbel edgeDetect_buffer (
    .CAMERA_CLK(CAMERA_CLK),
    .rst(rst),
    .readWrite(writeEn),
    .coordinate_X(inX),
    .coordinate_Y(inY),
    .ul(ul),
    .uc(uc),
    .ur(ur),
    .ml(ml),
    .mc(mc),
    .mr(mr),
    .dl(dl),
    .dc(dc),
    .dr(dr),
    .writeDone(writeDone_temp2)
);


always@(posedge CAMERA_CLK)
begin
    if(rst)
    begin
        writeEn <= 1'b1;  
        writeDone1 <= 1'b0;
        writeDone2 <= 1'b0;
    end
    else if(writeEn == 1'b1)
    begin
        writeDone1 <= writeDone_temp;
        writeDone2 <= writeDone_temp2;
        inX <= outX;
        inY <= outY;
        if(writeDone_temp == 1'b1)
        begin
            writeEn <= 1'b0;
            inX <= 0;
            inY <= 0;
        end
    end     
    else if(writeEn == 1'b0)
    begin
        writeDone1 <= writeDone_temp;
        writeDone2 <= writeDone_temp2;
        if(inY == WIDTH-1)
        begin
            if(inX == HEIGHT -1)
            begin
//                writeEn = 1'b1;
//                writeDone2 <= 1'b1;
                inX <= inX;
                inY <= inY;
            end
            else
            begin
                inX <= inX + 1;
                inY <= 0;
            end
        end       
        else
        begin
            inY <= inY + 1;
        end
        
        
        if(writeDone_temp == 1'b1)
        begin
            writeEn <= 1'b1;
        end
        
    end  

end


endmodule