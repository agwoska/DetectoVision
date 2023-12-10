`timescale 1ns / 1ps


module VGA(
    input   wire pixel_clk,   //25MHZ clk
    // From memory
    input       [3:0] vgaIn,
    output      [9:0] outX,
    output      [8:0] outY,
    
    // To VGA
    output  reg [3:0] VGA_R,
    output  reg [3:0] VGA_G,
    output  reg [3:0] VGA_B,
    output  wire VGA_HS,
    output  wire VGA_VS
    );

wire [10:0] vga_hcnt, vga_vcnt;
wire vga_blank;

//wire inBounds = ((vga_vcnt <= 480) && (vga_hcnt <= 640));
wire inBounds = ((vga_vcnt < 440) && (vga_hcnt < 620) && (vga_hcnt >= 20) && (vga_vcnt >= 40));
assign outX = vga_hcnt;
assign outY = vga_vcnt;

// Instantiate VGA controller
vga_controller vga_control(
    .pixel_clk(pixel_clk),
    .HS(VGA_HS),
    .VS(VGA_VS),
    .hcounter(vga_hcnt),
    .vcounter(vga_vcnt),
    .blank(vga_blank)
);

// Generate figure to be displayed
// Decide the color for the current pixel at index (hcnt, vcnt).
// This example displays an white square at the center of the screen with a colored checkerboard background.
always @(*) begin
    // Set pixels to black during Sync. Failure to do so will result in dimmed colors or black screens.
    // also write 0 if we are out of bounds for the VGA display
    if (vga_blank | ~inBounds) begin 
        VGA_R = 0;
        VGA_G = 0;
        VGA_B = 0;
    end
    else begin  // Image to be displayed
        VGA_R = vgaIn;
        VGA_G = vgaIn;
        VGA_B = vgaIn;
    end
end

endmodule
