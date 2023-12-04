`timescale 1ns / 1ps


module clk_div_25(
    input clk,
    input reset,
    output reg clk25
);

reg [2:0] counter = 0;

initial
begin
    clk25 <= 0;
end

always@(posedge clk)
begin
    if (reset)
    begin 
        counter <= 0;
//        clk25 <= 0;
    end
    else
    begin
        if(counter >= 1)
        begin
            counter <= 0;
            clk25 <= ~clk25;
        end
        else
            counter <= counter + 1;   
    
    end
end

endmodule
