`timescale 1ns / 1ps    


/////////////////////////////////////////
// Team: DetectoVision
// EC 551 Advanced Digital Design
// Description: NOT USED
/////////////////////////////////////////

module pixelBuffer(

    input clk,
    input reset,
    input pixelValid,
    input wire [15:0] pixelIn,
    output reg [15:0] pixelOut
);


always@(posedge clk)
begin
    if(reset)
        pixelOut <= 0;
    else
        if(pixelValid)
            pixelOut <= pixelIn;
end


endmodule
