`timescale 1ns/1ps


////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Read image (only used for simulation)
//////////////////////////////////////////////////////////////////////////////////


module fileRead #(
parameter INFILE  = "./minions.hex",
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
output reg [7:0] outputPixel_R,
output reg [7:0] outputPixel_G,
output reg [7:0] outputPixel_B,
output reg [10:0] X,
output reg [10:0] Y
);



reg [BITS_FOR_INDEX-1:0] counterX = 0;
reg [BITS_FOR_INDEX-1:0] counterY = 0;

reg [sizeOfWidth-1 : 0]   total_memory [0:sizeOfLengthReal-1];
reg [7:0] green;
reg [7:0] blue;

integer temp_BMP   [0 : WIDTH*HEIGHT*3 - 1];
integer i;

initial begin
    $readmemh(INFILE,total_memory,0,sizeOfLengthReal-1); // read file from INFILE
    
    for(i=0; i<WIDTH*HEIGHT*3 ; i=i+1) begin
            temp_BMP[i] = total_memory[i+0][7:0]; 
    end
        
end


// every clock cycle sends one pixel output
always@(posedge CAMERA_CLK)
begin
    outputPixel_R <= temp_BMP[WIDTH*3*(HEIGHT-counterX-1)+3*counterY+0];// save Red component
    outputPixel_G  <= temp_BMP[WIDTH*3*(HEIGHT-counterX-1)+3*counterY+1];// save Green component
    outputPixel_B <= temp_BMP[WIDTH*3*(HEIGHT-counterX-1)+3*counterY+2];// save Blue component
end

always@(posedge CAMERA_CLK)
begin
    if(rst)
    begin
        counterX <=0;
        counterY <= 0;
    end
    else
    begin
 
        if(counterY == WIDTH-1)
        begin
            if(counterX == HEIGHT -1)
                counterX <=0;
            else
            begin
                counterX <= counterX + 1;
                counterY <= 0;
            end
        end
        else
        begin
            counterY <= counterY + 1'b1;   
        end
        
        X<=counterX;
        Y<=counterY;
            
    end
end
endmodule