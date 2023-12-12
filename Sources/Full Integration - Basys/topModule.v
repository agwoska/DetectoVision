`timescale 1ns / 1ps


module topModule(
    input wire clkMain,
    input wire resetButton,
    input wire pclk,
    input wire href,
    inout wire siod,
    output wire sioc,
    input wire vsync, 
    
    output reg  [14:0] LED,
    output wire reset,
    output wire PWDN,
    output wire xclk,
    output reg pixelValid_verify,
    input wire [7:0] data,
    
    // 7 Segment Display
    output  [6:0]       SEG,
    output  [3:0]       AN,
    output              DP,
    
    // switch 
    input redHue, // turns on the red hue
    input positionSW, // display edge detection
    
    // display
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output wire VS,
    output wire HS
);

    wire clk25_reg;
    wire clk1_reg;
    wire [15:0] pixelValue;
    wire [3:0] pixelVGA;
    wire [9:0]outX; 
    wire [9:0]outX_vgaOut;
    wire [8:0]outY_vgaOut;
    wire [8:0] outY;
    wire pixelValid;
    
    
    //hough transform
    wire [9:0] idealX;
    wire [8:0] idealY;
    
    reg changeIdeal = 0;
    
    clk25_mod clkDiv(
        .clk(clkMain),
        .reset(resetButton),
        .clk25_output(clk25_reg)
    );
    
    clkDiv_1Hz clkDiv2(
        .clk(clkMain),
        .reset(resetButton),
        .clk25_output(clk1_reg)
    );
    
    
    
    
    cameraControl cam (
        .clk25(clk25_reg),
        .OV7670_D(data),
        .OV7670_HREF(href),
        .OV7670_VSYNC(vsync),
        .OV7670_PCLK(pclk),
        .OV7670_SIOD(siod),
        .OV7670_SIOC(sioc),
        .OV7670_PWDN(PWDN),
        .OV7670_RESET(reset),
        .OV7670_XCLK(xclk),
        .outX(outX),
        .outY(outY),
        .pixelValue(pixelValue),
        .pixelValid(pixelValid)  
    );
    
    
    
    // main module for grey scale and color masking
    frameBuffer_greyScale frame(
        .clk(clkMain),
        .reset(resetButton),
        .redHue(redHue),
        .inX(outX),
        .inY(outY),
        .outX(outX_vgaOut),
        .outY(outY_vgaOut),
        .inPixel(pixelValue),
        .pixelValid(pixelValid),
        .outPixel(pixelVGA)
    );
    
    houghAccumulator accumulator (
        .clk(clkMain),
        .X(outX_vgaOut),
        .Y(outY_vgaOut),
        .pixel(pixelVGA),
        .idealX(idealX),
        .idealY(idealY)    
    );

    
    
    
    // used mainly for debugging
    segDisplay disp(
//        .x(pixelValue),
        .x(idealX),
        .clk(clk1_reg),
        .seg(SEG),
        .an(AN),
        .dp(DP)
    
    );
    
    VGA display(
        .pixel_clk(clk25_reg),
        .redHue(redHue),
        .changeIdeal(changeIdeal),
        .positionSW(positionSW),
        .ball_x(idealX),
        .ball_y(idealY),
        .vgaIn(pixelVGA),
        .outX(outX_vgaOut),
        .outY(outY_vgaOut),
        .VGA_R(red),
        .VGA_G(green),
        .VGA_B(blue),
        .VGA_HS(HS),
        .VGA_VS(VS)
    );
    

    
    always@(posedge clk1_reg)
    begin
        if(changeIdeal == 1'b0)begin
            changeIdeal <= 1'b1;
        end
        else
             changeIdeal <= 1'b0;
    end

    // used mainly for debugging
    always@(posedge clk1_reg)
    begin
        LED[0] = outX[0];
        LED[1] = outX[1];
        LED[2] = outX[2];
        LED[3] = outX[3];
        LED[4] = outX[4];
        LED[5] = outX[5];
        LED[6] = outX[6];
        LED[7] = outX[7];
        LED[8] = outX[8];
        LED[9] = outX[9];
        LED[10] = pixelVGA[0];
        LED[11] = pixelVGA[1];
        LED[12] = pixelVGA[2];
        LED[13] = pixelVGA[3];
        LED[14] = pixelValue[4];
        pixelValid_verify = pixelValid;
    end
   

endmodule
