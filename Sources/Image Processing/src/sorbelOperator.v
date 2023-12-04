`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 10:43:16 AM
// Design Name: 
// Module Name: sorbelOperator
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


module sorbelOperator#(parameter 
WIDTH = 768, // Image width 
HEIGHT = 512, // Image height 
INFILE = "outputSorbel.bmp", // Output image 
BITS_FOR_INDEX = 10, // ceil(lg(max(width, height)))
sizeOfWidth = 8,
sizeOfLengthReal = WIDTH*HEIGHT*3,
BMP_HEADER_NUM = 54,
THRESHOLD = 100
) 
( 
input HCLK, // Clock input 
HRESETn, // Reset active low 
input [BITS_FOR_INDEX-1:0]rowIndex,
input [BITS_FOR_INDEX-1:0]colIndex,
input [sizeOfWidth-1:0] DATA_WRITE_R0, // Red 8-bit data (odd) 
output reg Write_Done
); 
integer fd;
wire close;
reg [sizeOfWidth-1:0] out_BMP[0:HEIGHT*WIDTH-1];
reg [sizeOfWidth-1:0] sorbelMat[0:HEIGHT*WIDTH*3-1];
reg [BITS_FOR_INDEX-1:0] rowTemp, colTemp;
integer BMP_header [0:BMP_HEADER_NUM-1];
reg [sizeOfWidth-1:0] out_BMP[0:HEIGHT*WIDTH-1];
integer i,j,k;
reg idle;
reg [(sizeOfWidth*3)-1:0]temp1,temp2, temp3, temp4;
reg [sizeOfWidth*2-1:0] tempL, tempR, tempU, tempD;
reg startSorbel;
reg allDone;
reg [sizeOfWidth*2-1:0] gx, gy, g_temp; 
reg [sizeOfWidth-1:0] g; 
wire [sizeOfWidth-1:0] gWire; 

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
        for(k=0; k<WIDTH*HEIGHT; k = k+1) begin
            out_BMP[k] <= 0;
        end
    end
    
    else begin
        if(~idle) begin
            out_BMP[WIDTH*rowTemp + colTemp] <= DATA_WRITE_R0;
        end
    end    
 end






always@(posedge HCLK, posedge HRESETn) 
begin
    if(HRESETn) begin
        Write_Done <= 1'b0;
        idle <= 1'b0;
        gx <= 1'b0;
        gy <= 1'b0;
    end
    else begin
        if(~idle) begin
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


// finds the sorbel matrix for edge detection
always@(posedge HCLK, posedge HRESETn) 
begin
    if(HRESETn) begin
        startSorbel <= 1'b0;
        allDone <= 1'b0;
        for(k=0; k<WIDTH*HEIGHT*3; k = k+1) begin
            sorbelMat[k] <= 0;
        end
    end
    else begin
        if (startSorbel == 1'b1) begin
            
            //used to find the x grad
            temp1 <= {out_BMP[(rowTemp+1)*WIDTH +colTemp -1], out_BMP[(rowTemp)*WIDTH +colTemp -1], out_BMP[(rowTemp-1)*WIDTH +colTemp -1]};
            temp2 <= {out_BMP[(rowTemp+1)*WIDTH +colTemp +1], out_BMP[(rowTemp)*WIDTH +colTemp +1], out_BMP[(rowTemp-1)*WIDTH +colTemp +1]};
            //used to find the y grad
            temp3 <= {out_BMP[(rowTemp-1)*WIDTH +colTemp -1], out_BMP[(rowTemp-1)*WIDTH +colTemp ], out_BMP[(rowTemp-1)*WIDTH +colTemp +1]};
            temp4 <= {out_BMP[(rowTemp+1)*WIDTH +colTemp -1], out_BMP[(rowTemp+1)*WIDTH +colTemp ], out_BMP[(rowTemp+1)*WIDTH +colTemp +1]};
            
             tempL <= (temp1[(3*sizeOfWidth)-1:(2*sizeOfWidth)]) + (2*temp1[(2*sizeOfWidth)-1:(1*sizeOfWidth)]) +(temp1[(1*sizeOfWidth)-1:0]);
             tempR <= (-1*temp2[(3*sizeOfWidth)-1:(2*sizeOfWidth)]) + (-2*temp2[(2*sizeOfWidth)-1:(1*sizeOfWidth)]) +(-1*temp2[(1*sizeOfWidth)-1:0]);
             gx <= tempL + tempR;
//            

            tempU <= (temp4[(3*sizeOfWidth)-1:(2*sizeOfWidth)]) + (2*temp4[(2*sizeOfWidth)-1:(1*sizeOfWidth)]) +(temp4[(1*sizeOfWidth)-1:0]);
            tempD <= (-1*temp3[(3*sizeOfWidth)-1:(2*sizeOfWidth)]) + (-2*temp3[(2*sizeOfWidth)-1:(1*sizeOfWidth)]) +(-1*temp3[(1*sizeOfWidth)-1:0]);
            gy <= tempU + tempD;
    
            g <= ((gx*gx) + (gy*gy))/(gx*gy); // may need a square root function or a different way of detecting edges
            
         
            
   
            sorbelMat[WIDTH*3*(HEIGHT-rowTemp-1)+ 3*colTemp+2] <= g;
            sorbelMat[WIDTH*3*(HEIGHT-rowTemp-1)+ 3*colTemp+1] <= g;
            sorbelMat[WIDTH*3*(HEIGHT-rowTemp-1)+ 3*colTemp+0] <= g;  
            
            if(colTemp == WIDTH - 2) begin
                if(rowTemp == HEIGHT -2)begin
                   startSorbel <= 1'b0; 
                   allDone<=1'b1;
                end
                else begin
                    colTemp <= 1;
                    rowTemp <= rowTemp + 1;
                end
            end
            else begin
                colTemp <= colTemp + 1;
            end   

        end    
    end
end

//sqrt function
//always@(g_temp)
//begin
//    g <= (1+ (g_temp/3));    
//end


//sorbel_X xGrad (temp1, temp2, gx);
//sorbelY yGrad (temp3, temp4, gy);


always@(Write_Done) begin // once the processing was done, bmp image will be created
    if(Write_Done == 1'b1) begin
        rowTemp <= 1;
        colTemp <= 1;
        startSorbel <= 1'b1;           
    end
end


initial begin
    fd = $fopen(INFILE, "wb+");
end

always@(allDone) begin // once the processing was done, bmp image will be created
    if(allDone == 1'b1) begin
        for(i=0; i<BMP_HEADER_NUM; i=i+1) begin
            $fwrite(fd, "%c", BMP_header[i][7:0]); // write the header
        end
        
        for(i=0; i<WIDTH*HEIGHT*3; i=i+1) begin
  // write R0B0G0 and R1B1G1 (6 bytes) in a loop
            $display(sorbelMat[i  ][7:0]);
            $fwrite(fd, "%c", sorbelMat[i  ][7:0]);
        end
        allDone <= 1'b0;
        $fclose(INFILE);    
    end
end



endmodule
