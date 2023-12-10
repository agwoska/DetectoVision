`timescale 1ns / 1ps


module frameBuffer_greyScale(
        input clk,
        input reset,
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
    
    reg [1:0] DIV_CST = 2'b11; 
    // variables for writing to BRAM
    reg [17:0] inAddress;
    reg [3:0] inputPixel;
    wire enableWrite = (inX < 620 & inX >= 20 & inY < 440 & inY >= 40 ) ? 1'b1:1'b0;
    
    // variables for reading from BRAM
    reg [17:0] outAddress;
    wire [3:0] outputPixel;
    
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
            inAddress <= inX + inY*ROW_LENGTH;
            inputPixel <= (inPixel[15:12]+ inPixel[10:7] + inPixel[4:1])/3;
        end
    end

    
    
    
    
    // always block for reading from BRAM  
    always@(posedge clk)
    begin
        outAddress <= outX + outY*ROW_LENGTH;
        outPixel <= outputPixel;
    end




endmodule
