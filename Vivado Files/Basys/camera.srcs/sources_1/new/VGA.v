`timescale 1ns / 1ps

/////////////////////////////////////////
// Team: DetectoVision
// EC 551 Advanced Digital Design
// Description: display
/////////////////////////////////////////

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
    output  wire VGA_VS,
    
    // object detection
    input [9:0]idealX,
    input [9:0]idealY,
    
    //switch
    input redHue,
    input edgeOn,
    input visualSW,
    input idealStart
);

wire [10:0] vga_hcnt, vga_vcnt;
wire vga_blank;
reg counter;
reg [9:0] ballX_reg;
reg [8:0] ballY_reg;
wire ballDetections = vga_hcnt >= ballX_reg-10 && vga_hcnt < ballX_reg + 10 && 
                vga_vcnt >= ballY_reg-10 && vga_vcnt < ballY_reg + 10;
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



always@(posedge pixel_clk)
begin
    if(idealStart && counter == 1'b0)
    begin
        counter <= 1;
        ballX_reg <= idealX;
        ballY_reg <= idealY;        
    end else if (idealStart == 1'b0) begin
        counter <= 0;
    end
end



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
        if(visualSW == 1'b0)
        begin
            VGA_R = vgaIn;
            VGA_G = vgaIn;
            VGA_B = vgaIn;
        end else begin
            if (ballDetections) begin
                // Set the ball's color
                VGA_R <= 4'h0; // Full red for the ball
                VGA_G <= 4'hF; // Full green for the ball
                VGA_B <= 4'h0; // Full blue for the ball
            end else begin
                // Set background color
                VGA_R <= 15;
                VGA_G <= 15;
                VGA_B <= 15;
            end
           
        end
    end
end

endmodule
