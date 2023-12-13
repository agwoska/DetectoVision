`timescale 1ns / 1ps

/////////////////////////////////////////
// Team: DetectoVision
// EC 551 Advanced Digital Design
// Description: grey scaling, 
// color masking, edge detection
/////////////////////////////////////////

module frameBuffer_greyScale(
        input clk,
        input reset,
        input redHue,
        input edgeOn,
        input visualSW,
        input [9:0] inX,
        input [8:0] inY,
        input [9:0] outX,
        input [8:0] outY,
        input [15:0] inPixel,
        input pixelValid,
        output reg [3:0] outPixel          
    );
    
    parameter ROW_LENGTH = 600;
    parameter COL_LENGTH = 400; 
    parameter THRESHOLD_MIN = 9;
    parameter THRESHOLD_MAX = 5;
    parameter THRESHOLD_MIN2 = 8;
    parameter THRESHOLD_MAX2 = 7;
    parameter COL_BIAS = 20;
    parameter ROW_BIAS = 40;
    
    reg [1:0] DIV_CST = 2'b11; 
    // variables for writing to BRAM
    reg [17:0] inAddress;
    reg [3:0] inputPixel;
    wire enableWrite = ((inX < 620) && (inX >= 20) && (inY < 440) && (inY >= 40)) ? 1'b1:1'b0;
    
    // variables for reading from BRAM
    reg [17:0] outAddress;
    wire [3:0] outputPixel;
    wire [3:0] outputPixelEdge_temp; // used for edge detector
    
    // edge detection
    reg edgeValid_temp = 1'b0;
    reg [17:0] outAddress_edge;
    reg [2:0]edgeState = 3'b0;
    reg [9:0] edgeX_temp;
    reg [8:0] edgeY_temp;
    reg [3:0] tempValueHolder [0:7];
    
    // bram to store grey scale images
    // only 4 bits is required to save a grey scale image
    // since r == g == b
    bram greyScale(
        .clka(clk),
        .clkb(clk),
        .addra(inAddress),
        .addrb(outAddress),
        .dina(inputPixel),
        .ena(1'b1),
        .enb(1'b1),
        .wea(enableWrite & pixelValid),
        .doutb(outputPixel) // only output
    );
    

    
    
    // always block for writing to BRAM    
    always@(posedge clk)
    begin
        if(enableWrite & pixelValid)
        begin
            inAddress <= (inX-COL_BIAS) + (inY-ROW_BIAS)*ROW_LENGTH;
            if (redHue == 1'b0 && visualSW == 1'b0 && edgeOn == 1'b0) begin                
                inputPixel <= (inPixel[15:12]+ inPixel[10:7] + inPixel[4:1])/3;
            end
            else if(redHue == 1'b0 && visualSW == 1'b0 && edgeOn == 1'b1)
            begin
                if ((inPixel[15:12] >= THRESHOLD_MIN2) && (inPixel[10:7] < THRESHOLD_MAX2) && (inPixel[4:1] < THRESHOLD_MAX2))
                    inputPixel <= 8;
                else
                    inputPixel <= 0;           
            end
            else
            begin
                if ((inPixel[15:12] >= THRESHOLD_MIN) && (inPixel[10:7] < THRESHOLD_MAX) && (inPixel[4:1] < THRESHOLD_MAX))
                    inputPixel <= inPixel[15:12];
                else
                    inputPixel <= 0;            
            end
        end
    end

    
    
    
    
    // always block for reading from BRAM  
    always@(posedge clk)
    begin
        outAddress <= (outX-COL_BIAS) + (outY-ROW_BIAS)*ROW_LENGTH;
        outPixel <= outputPixel;
    end


   
endmodule
