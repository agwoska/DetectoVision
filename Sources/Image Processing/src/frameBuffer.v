`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Frame buffer to store the images
//////////////////////////////////////////////////////////////////////////////////

module frameBuffer #(
parameter INFILE  = "./image.hex",
parameter WIDTH = 768, // Image width 
parameter HEIGHT = 512, // Image height 
parameter OUTFILE = "output3.bmp", // Output image 
parameter BITS_FOR_INDEX = 10,// ceil(lg(max(width, height)))
parameter sizeOfWidth = 8,
parameter sizeOfLengthReal = WIDTH*HEIGHT*3,
parameter BMP_HEADER_NUM = 54
)(
input CAMERA_CLK,
input rst, 
input[7:0] inputPixel_R,
input[7:0] inputPixel_G,
input [7:0] inputPixel_B,
input [10:0] coordinate_X,
input [10:0] coordinate_Y,
input readWrite,  //1-> Read 0-> Write
output reg[7:0] ul,
output reg[7:0] uc,
output reg[7:0] ur,
output reg[7:0] ml,
output reg[7:0] mc,
output reg[7:0] mr,
output reg[7:0] dl,
output reg[7:0] dc,
output reg[7:0] dr,
output reg writeDone
);

reg [sizeOfWidth-1:0] redReg[0: sizeOfLengthReal-1];
reg [sizeOfWidth-1:0] greenReg[0: sizeOfLengthReal-1];
reg [sizeOfWidth-1:0] blueReg [0: sizeOfLengthReal-1];
reg [sizeOfWidth-1:0] editePixelReg [0: sizeOfLengthReal-1];
wire [sizeOfWidth-1:0] editedPixel;
wire writeBackImage;
wire writeDone_wire;


//combines colormasking with greyscaling
colorMask colorGray (
    .CAMERA_CLK(CAMERA_CLK),
    .rst(rst),
    .inputPixel_R(inputPixel_R),
    .inputPixel_G(inputPixel_G),
    .inputPixel_B(inputPixel_B),
    .coordinate_X(coordinate_X),
    .coordinate_Y(coordinate_Y),
    .readWrite(readWrite),
    .writeBackImage(writeBackImage),
    .outputPixel(editedPixel)
);


imageWrite writeBack (
    .HCLK(CAMERA_CLK),
    .HRESETn(rst),
    .rowIndex(coordinate_X),
    .colIndex(coordinate_Y),
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
    else if(readWrite == 1'b1)
    begin
        redReg[coordinate_X*WIDTH + coordinate_Y] <= inputPixel_R;
        greenReg[coordinate_X*WIDTH + coordinate_Y] <= inputPixel_G;
        blueReg[coordinate_X*WIDTH + coordinate_Y] <= inputPixel_B;   
        editePixelReg[coordinate_X*WIDTH + coordinate_Y] <= editedPixel;
        writeDone <= writeDone_wire;
    end
    else if(readWrite == 1'b0)
    begin
        if(coordinate_X == 0 | coordinate_Y == 0 | coordinate_X == HEIGHT-1 | coordinate_Y == WIDTH -1)
        begin
            ul <= 0;
            uc <= 0;
            ur <= 0;
            ml <= 0;
            mc <= 0;
            mr <= 0;
            dl <= 0;
            dc <= 0;
            dr <= 0;
        end
        else
        begin
            ul <= editePixelReg[(coordinate_X - 1)*WIDTH + (coordinate_Y - 1)];
            uc <= editePixelReg[(coordinate_X - 1)*WIDTH + (coordinate_Y - 0)];
            ur <= editePixelReg[(coordinate_X - 1)*WIDTH + (coordinate_Y + 1)];
            ml <= editePixelReg[(coordinate_X - 0)*WIDTH + (coordinate_Y - 1)];
            mc <= editePixelReg[(coordinate_X - 0)*WIDTH + (coordinate_Y - 0)];
            mr <= editePixelReg[(coordinate_X - 0)*WIDTH + (coordinate_Y + 1)];
            dl <= editePixelReg[(coordinate_X + 1)*WIDTH + (coordinate_Y - 1)];
            dc <= editePixelReg[(coordinate_X + 1)*WIDTH + (coordinate_Y - 0)];
            dr <= editePixelReg[(coordinate_X + 1)*WIDTH + (coordinate_Y + 1)];
        end
        writeDone <= writeDone_wire;
    end
end

endmodule
