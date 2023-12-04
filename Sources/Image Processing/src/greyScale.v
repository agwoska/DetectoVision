`timescale 1ns/1ps /**************************************************/ 


////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Convert an image to its grey scale image
//////////////////////////////////////////////////////////////////////////////////
module greyScale
#(
  parameter     WIDTH  = 768,   // Image width
         HEIGHT  = 512,   // Image height
  INFILE  = "./image.hex",  // image file
    BITS_FOR_INDEX = 11,// ceil(lg(max(width, height)))
    BMP_HEADER_NUM = 54, 
    sizeOfWidth = 8,
sizeOfLengthReal = WIDTH*HEIGHT*3
)
(
  input HCLK,          // clock     
  input HRESETn,         // Reset (active low)
  output reg [BITS_FOR_INDEX-1:0]rowIndex,
  output reg [BITS_FOR_INDEX-1:0]colIndex,
  output reg [sizeOfWidth-1:0]  DATA_R0,  // 8 bit Red data (even)
  output reg [sizeOfWidth-1:0]  DATA_G0,  // 8 bit Green data (even)
  output reg [sizeOfWidth-1:0]  DATA_B0,  // 8 bit Blue data (even)
  // Process and transmit 2 pixels in parallel to make the process faster, you can modify to transmit 1 pixels or more if needed
  output  reg   ctrl_done     // Done flag
);   
//parameter sizeOfWidth = 32;   // data width
//parameter sizeOfLengthReal = WIDTH*HEIGHT*3;

reg [sizeOfWidth-1 : 0]   total_memory [0 : sizeOfLengthReal-1];// memory to store  8-bit data image
integer temp_BMP   [0 : WIDTH*HEIGHT*3 - 1];   
integer org_R  [0 : WIDTH*HEIGHT - 1]; // temporary storage for R component
integer org_G  [0 : WIDTH*HEIGHT - 1]; // temporary storage for G component
integer org_B  [0 : WIDTH*HEIGHT - 1]; // temporary storage for B component
reg outputReady, start;
reg [BITS_FOR_INDEX-1:0] row, col;
integer i,j, value, value1;
reg idle;





initial begin
    $readmemh(INFILE,total_memory,0,sizeOfLengthReal-1); // read file from INFILE
end

always@(start)
begin
    if(start == 1'b1) begin
         for(i=0; i<WIDTH*HEIGHT*3 ; i=i+1) begin
            temp_BMP[i] = total_memory[i+0][7:0]; 
        end
        
        for(i=0; i<HEIGHT; i=i+1) begin
            for(j=0; j<WIDTH; j=j+1) begin
     // Matlab code writes image from the last row to the first row
     // Verilog code does the same in reading to correctly save image pixels into 3 separate RGB mem
                org_R[WIDTH*i+j] = temp_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+0];// save Red component
                org_G[WIDTH*i+j] = temp_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+1];// save Green component
                org_B[WIDTH*i+j] = temp_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+2];// save Blue component
            end
        end       
        start <= 1'b0;        
    end

end

always@(posedge HCLK or posedge HRESETn)
begin
    if(HRESETn == 1'b1) begin
        outputReady <= 1'b0;
        start <= 1'b1;
        row <= 0;
        col <= 0;
        idle <= 1'b0;
        ctrl_done <=1'b0;
    end
    else begin
        if (col == (WIDTH -1)) begin
            if(row == (HEIGHT-1)) begin
                idle<=1'b1;
                ctrl_done <= 1'b1;     
            end
            else begin
                col <= 0;
                row <= row + 1;
           end
        end
        else begin
            col <= col + 1;
            
        end
    end
end


always@(row or col) 
begin
// this is were the gray scaling occurs
    if(idle == 1'b0) begin
        value <= (0.3*org_R[WIDTH * row + col])+(0.6*org_G[WIDTH * row + col])+(0.1*org_B[WIDTH * row + col]);
        DATA_R0 <= value;
        DATA_G0 <= value;
        DATA_B0 <= value;

        
        rowIndex <= row;
        colIndex <= col;        
     end
end



endmodule
