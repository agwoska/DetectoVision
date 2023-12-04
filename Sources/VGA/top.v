`timescale 1ns / 1ps



module top(
    input clk,
    input reset,
    input wire [9:0]SW,
    input wire chooseXY,
    output wire [9:0] LED,
    output wire [3:0] red, // 4-bit red channel
    output wire [3:0] green, // 4-bit green channel
    output wire [3:0] blue, // 4-bit blue channel
    output wire hsync, // Horizontal sync: negative logic
    output wire vsync // Vertical sync: negative logic
);



reg[9:0] X, Y;
wire clk25;

clk_div_25 cl25(

    .clk(clk),
    .reset(reset),
    .clk25(clk25)
);

vga_controller vga (
    .clk(clk25),
    .ball_x(X),
    .ball_y(Y),
    .hsync(hsync),
    .vsync(vsync),
    .red(red),
    .green(green),
    .blue(blue)
);

always@(posedge clk)
begin
    if(reset)
    begin
        X <= 0;
        Y <= 0;
    end
    else
    begin
        if(chooseXY)
        begin
            X <= SW;        
        end
        else
        begin
            Y <= SW;        
        end   
    end
end


assign LED = SW;

endmodule
