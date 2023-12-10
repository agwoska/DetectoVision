`timescale 1ns / 1ps

// clock divider to 25 MHz
module clkDiv_1Hz(
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
//        clk25 <= 0;
    end
    else
    begin
        if(counter >= 50000000)
        begin
            counter <= 0;
            clk25_output <= ~clk25_output;
        end
        else
            counter <= counter + 1;   
    
    end
end

endmodule