`timescale 1ns / 1ps

/////////////////////////////////////////
// Team: DetectoVision
// EC 551 Advanced Digital Design
// Description: clk divider to 8 Hz
/////////////////////////////////////////
module clkDiv_visual(
    input clk,
    input reset,
    output reg clk25_output
);

reg [25:0] counter = 0;

initial
begin
    clk25_output <= 0;
end

always@(posedge clk)
begin
    if (reset)
    begin 
        counter <= 0;
    end
    else
    begin
        if(counter >= 6250000)
        begin
            counter <= 0;
            clk25_output <= ~clk25_output;
        end
        else
            counter <= counter + 1;   
    
    end
end

endmodule