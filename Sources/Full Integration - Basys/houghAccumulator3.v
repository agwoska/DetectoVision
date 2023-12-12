`timescale 1ns / 1ps


module houghAccumulator3(
    input clk, 
    input [9:0] X,
    input [8:0] Y,
    input [3:0] pixel,
    output reg [9:0] idealX,
    output reg [8:0] idealY
);


    parameter TOTAL_LENGTH = 400*600;
    parameter RADIUS = 100;
    parameter ROW_LENGTH = 450;//600;
    parameter COL_LENGTH = 290;//400; 
    parameter COL_BIAS = 95;
    parameter ROW_BIAS = 95;
    parameter MUL_CST = 2;
    
    
    reg started = 1'b0;
    reg [2:0] caseReg = 2'b00;
    reg [9:0] X_reg;
    reg [8:0] Y_reg;
    
     // variables for reading from BRAM
    reg [17:0] outAddress;
    wire [3:0] outputPixel;
    
    // variables for writing to BRAM
    reg [17:0] inAddress;
    reg [3:0] inputPixel;
    
    // temp Values
    reg [5:0] accBest = 0;
    reg [5:0] accTemp;   
    
    
    
        // bram to store the accumulator
    //450x290
 bram3 accumulator(
        .clka(clk),
        .clkb(clk),
        .addra(inAddress),
        .addrb(outAddress),
        .dina(inputPixel),
        .dinb(),
        .ena(1'b1),
        .enb(1'b1),
        .wea(started),
        .doutb(outputPixel),
        .douta(),
        .web()        
    );
    
    
    initial begin
        idealX <= 0;
        idealY <= 0;
    end
    
    
    always@(posedge clk)
    begin
         
    end
    
    


endmodule
