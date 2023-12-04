`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Sorbel edge detection
//////////////////////////////////////////////////////////////////////////////////


module sorbelFunction#(parameter 
WIDTH = 768, // Image width 
HEIGHT = 512, // Image height 
BITS_FOR_INDEX = 10, // ceil(lg(max(width, height)))
sizeOfWidth = 8,
sizeOfLengthReal = WIDTH*HEIGHT*3,
BMP_HEADER_NUM = 54,
THRESHOLD = 100,
BW_THRESHOLD = 150,
SQRT_EST = 180
) 
( 
input CAMERA_CLK, // Clock input 
rst, // Reset active low 
input [BITS_FOR_INDEX-1:0]rowIndex,
input [BITS_FOR_INDEX-1:0]colIndex,
input [7:0] ul,
input [7:0] uc,
input [7:0] ur,
input [7:0] ml,
input [7:0] mc,
input [7:0] mr,
input [7:0] dl,
input [7:0] dc,
input [7:0] dr,
input readWrite,
output reg [BITS_FOR_INDEX-1:0] outX,
output reg [BITS_FOR_INDEX-1:0] outY,
output reg [sizeOfWidth-1:0] outPixel,
output reg writeBackImage
);

reg [sizeOfWidth*2 -1: 0] gx, gy, g_temp;
reg [sizeOfWidth -1: 0] g;


// insert square root function here




always@(posedge CAMERA_CLK)
begin
    if(rst)
    begin
        outPixel <= 1'b0;
        outX <= 0;
        outY <= 0;
        writeBackImage <= 0;
    end
    else if(readWrite == 1'b0)
    begin
        writeBackImage <= 1;
        outX <= rowIndex;
        outY <= colIndex;
        if(rowIndex == 0 | colIndex == 0 | rowIndex == HEIGHT-1 | colIndex == WIDTH -1)
        begin
            g<=0;
        end
        else
        begin
            gx <= ul - ur +2*ml - 2*mr + dl -dr;    
            gy <= ul + 2*uc + ur - dl -2*dc - dr;
            
            if(gy == 0)
            begin
                g_temp <= gx;
            end
            else
            begin
                g_temp <= gy + ((0.5*gx*gx)/gy);            
            end
            
            if(g_temp>=BW_THRESHOLD)
                g <= 255;
            else
                g <= 0;
        end
        outPixel <= $unsigned(g);
    end
end





endmodule
