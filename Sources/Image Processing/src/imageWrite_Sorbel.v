`timescale 1ns/1ps /**************************************************/ 
////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: 
//////////////////////////////////////////////////////////////////////////////////
//`include "parameter.v" // include definition file module tb_simulation; 
//------------------ // Internal Signals 
//------------------------------------------------- 
module imageWrite_Sorbel #(parameter 
WIDTH = 768, // Image width 
HEIGHT = 512, // Image height 
OUTFILE = "outputSorbel.bmp",
BMP_HEADER_NUM = 54, // Header for bmp image 
BITS_FOR_INDEX = 10, // ceil(lg(max(width, height)))
sizeOfWidth = 8,
sizeOfLengthReal = WIDTH*HEIGHT*3
) 
( 
input HCLK, // Clock input 
HRESETn, // Reset active low 
input [BITS_FOR_INDEX-1:0]rowIndex,
input [BITS_FOR_INDEX-1:0]colIndex,
input [sizeOfWidth-1:0] DATA_WRITE_R0, // Red 8-bit data (odd) 
input [sizeOfWidth-1:0] DATA_WRITE_G0, // Green 8-bit data (odd) 
input [sizeOfWidth-1:0] DATA_WRITE_B0, // Blue 8-bit data (odd) 
input writeBackImage,
output reg Write_Done 
); 


integer fd;
wire close;
integer BMP_header [0:BMP_HEADER_NUM-1];
reg [sizeOfWidth-1:0] out_BMP[0:HEIGHT*WIDTH*3-1];
reg [BITS_FOR_INDEX-1:0] rowTemp, colTemp;
integer i,k;
reg idle;

//parameter sizeOfWidth = 32;   // data width
//parameter sizeOfLengthReal = WIDTH*HEIGHT*3;



initial  begin 
BMP_header[ 0] = 66;BMP_header[28] =24; 
BMP_header[ 1] = 77;BMP_header[29] = 0; 
BMP_header[ 2] = 54;BMP_header[30] = 0; 
BMP_header[ 3] = 0;BMP_header[31] = 0;
BMP_header[ 4] = 18;BMP_header[32] = 0;
BMP_header[ 5] = 0;BMP_header[33] = 0; 
BMP_header[ 6] = 0;BMP_header[34] = 0; 
BMP_header[ 7] = 0;BMP_header[35] = 0; 
BMP_header[ 8] = 0;BMP_header[36] = 0; 
BMP_header[ 9] = 0;BMP_header[37] = 0; 
BMP_header[10] = 54;BMP_header[38] = 0; 
BMP_header[11] = 0;BMP_header[39] = 0; 
BMP_header[12] = 0;BMP_header[40] = 0; 
BMP_header[13] = 0;BMP_header[41] = 0; 
BMP_header[14] = 40;BMP_header[42] = 0; 
BMP_header[15] = 0;BMP_header[43] = 0; 
BMP_header[16] = 0;BMP_header[44] = 0; 
BMP_header[17] = 0;BMP_header[45] = 0; 
BMP_header[18] = 0;BMP_header[46] = 0; 
BMP_header[19] = 3;BMP_header[47] = 0;
BMP_header[20] = 0;BMP_header[48] = 0;
BMP_header[21] = 0;BMP_header[49] = 0; 
BMP_header[22] = 0;BMP_header[50] = 0; 
BMP_header[23] = 2;BMP_header[51] = 0; 
BMP_header[24] = 0;BMP_header[52] = 0; 
BMP_header[25] = 0;BMP_header[53] = 0; 
BMP_header[26] = 1; BMP_header[27] = 0; 
end


always@(rowIndex or colIndex)
begin
    rowTemp <= rowIndex;
    colTemp <= colIndex;
    
end




always@(posedge HCLK, posedge HRESETn) 
begin
    if(HRESETn)
    begin
        for(k=0; k<WIDTH*HEIGHT*3; k = k+1) begin
            out_BMP[k] <= 0;
        end
    end
    
    else begin
        if(~idle & writeBackImage == 1'b1) begin
            out_BMP[WIDTH*3*(HEIGHT-rowTemp-1)+ 3*colTemp+2] <= DATA_WRITE_R0;
            out_BMP[WIDTH*3*(HEIGHT-rowTemp-1)+ 3*colTemp+1] <= DATA_WRITE_G0;
            out_BMP[WIDTH*3*(HEIGHT-rowTemp-1)+ 3*colTemp+0] <= DATA_WRITE_B0;  
        end
    end    
 end






always@(posedge HCLK, posedge HRESETn) 
begin
    if(HRESETn) begin
        Write_Done <= 1'b0;
        idle <= 1'b0;
    end
    else begin
        if(~idle & writeBackImage == 1'b1) begin
            if(rowTemp == (HEIGHT-1))
            begin
                if(colTemp == (WIDTH -1))
                   begin
                        Write_Done <= 1'b1;
                        idle <= 1'b1;
                   end
                else
                    Write_Done <= 1'b0;
            end
            else
                Write_Done <= 1'b0;
         end
         else
            Write_Done <= 1'b0;
     end
end


//---------------------------------------------------------//
//--------------Write .bmp file  ----------------------//
//----------------------------------------------------------//
initial begin
    fd = $fopen(OUTFILE, "wb+");
end
always@(Write_Done) begin // once the processing was done, bmp image will be created
    if(Write_Done == 1'b1) begin
        for(i=0; i<BMP_HEADER_NUM; i=i+1) begin
            $fwrite(fd, "%c", BMP_header[i][7:0]); // write the header
        end
        
        for(i=0; i<WIDTH*HEIGHT*3; i=i+1) begin
  // write R0B0G0 and R1B1G1 (6 bytes) in a loop
            $fwrite(fd, "%c", out_BMP[i  ][7:0]);
        end
        $fclose(OUTFILE);    
    end
end

endmodule