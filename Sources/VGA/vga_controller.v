`timescale 1ns / 1ps


// Declare the module and its ports
module vga_controller (
    input clk, // 25MHz clock input
    input wire [9:0] ball_x, // X-coordinate of the ball
    input wire [9:0] ball_y, // Y-coordinate of the ball
    output wire hsync, // Horizontal sync: negative logic
    output wire vsync, // Vertical sync: negative logic
    output reg [3:0] red, // 4-bit red channel
    output reg [3:0] green, // 4-bit green channel
    output reg [3:0] blue // 4-bit blue channel
);

wire [10:0] vga_hcnt, vga_vcnt;
wire vga_blank;

    vga_parameter_controller(
        .pixel_clk(clk),
        .HS(hsync),
        .VS(vsync),
        .hcounter(vga_hcnt),
        .vcounter(vga_vcnt),
        .blank(vga_blank)    
    );
    
    
    
    wire inBounds = ((vga_vcnt <= 480) && (vga_hcnt <= 640));
    wire ballDetections = vga_hcnt >= ball_x-10 && vga_hcnt < ball_x + 10 && 
                vga_vcnt >= ball_y-10 && vga_vcnt < ball_y + 10;
    
    // Generate figure to be displayed
// Decide the color for the current pixel at index (hcnt, vcnt).
// This example displays an white square at the center of the screen with a colored checkerboard background.
always @(*) begin
    // Set pixels to black during Sync. Failure to do so will result in dimmed colors or black screens.
    // also write 0 if we are out of bounds for the VGA display
    if (vga_blank | ~inBounds) begin 
        red = 0;
        green = 0;
        blue = 0;
    end
    else begin  // Image to be displayed
        if (ballDetections) begin
            // Set the ball's color
            red <= 4'h0; // Full red for the ball
            green <= 4'h0; // Full green for the ball
            blue <= 4'hF; // Full blue for the ball
        end else begin
            // Set background color
            red <= 15;
            green <= 15;
            blue <= 15;
        end
    end
end

endmodule