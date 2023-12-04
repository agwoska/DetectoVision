`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Frame buffer to store the images
//////////////////////////////////////////////////////////////////////////////////

module frameBuffer_sorbel #(
parameter INFILE  = "./image.hex",
parameter WIDTH = 768, // Image width 
parameter HEIGHT = 512, // Image height 
parameter OUTFILE = "outputSorbel.bmp", // Output image 
parameter BITS_FOR_INDEX = 10,// ceil(lg(max(width, height)))
parameter sizeOfWidth = 8,
parameter sizeOfLengthReal = WIDTH*HEIGHT*3,
parameter BMP_HEADER_NUM = 54
)(
input CAMERA_CLK,
input rst, 
input readWrite,  //1-> Read 0-> Write
input [10:0] coordinate_X,
input [10:0] coordinate_Y,
input [7:0] ul,
input [7:0] uc,
input [7:0] ur,
input [7:0] ml,
input [7:0] mc,
input [7:0] mr,
input [7:0] dl,
input [7:0] dc,
input [7:0] dr,
output reg writeDone
);

reg [sizeOfWidth-1:0] redReg[0: sizeOfLengthReal-1];
reg [sizeOfWidth-1:0] greenReg[0: sizeOfLengthReal-1];
reg [sizeOfWidth-1:0] blueReg [0: sizeOfLengthReal-1];
wire writeDone_wire;
wire writeBackImage;
reg [sizeOfWidth-1:0] editePixelReg [0: sizeOfLengthReal-1];
wire [sizeOfWidth-1:0] editedPixel;
wire [BITS_FOR_INDEX-1:0] outX_s, outY_s;


sorbelFunction edgeDetect (
    .CAMERA_CLK(CAMERA_CLK),
    .rst(rst),
    .rowIndex(coordinate_X),
    .colIndex(coordinate_Y),
    .ul(ul),
    .uc(uc),
    .ur(ur),
    .ml(ml),
    .mc(mc),
    .mr(mr),
    .dl(dl),
    .dc(dc),
    .dr(dr),
    .outX(outX_s),
    .outY(outY_s),
    .readWrite(readWrite),
    .outPixel(editedPixel),
    .writeBackImage(writeBackImage)
);

imageWrite_Sorbel writeBack2(
    .HCLK(CAMERA_CLK),
    .HRESETn(rst),
    .rowIndex(outX_s),
    .colIndex(outY_s),
    .writeBackImage(writeBackImage),
    .DATA_WRITE_R0(editedPixel),
    .DATA_WRITE_G0(editedPixel),
    .DATA_WRITE_B0(editedPixel),
    .Write_Done(writeDone_wire)
);





always@(posedge CAMERA_CLK)
begin
    if(rst == 1'b1)
    begin
        writeDone <=0;
    end
    else if(readWrite == 1'b0)
    begin
        writeDone <= writeDone_wire;
        editePixelReg[outX_s*WIDTH + outY_s] <= editedPixel;
    end
end

endmodule