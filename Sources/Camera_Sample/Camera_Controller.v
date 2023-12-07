`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2022 05:49:10 PM
// Design Name: 
// Module Name: Camera_Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Camera_Controller(
    // Camera Pins
    input               clk25,
    input wire [7:0]    OV7670_D,
    input               OV7670_HREF,
    input               OV7670_VSYNC,
    input               OV7670_PCLK,
    inout               OV7670_SIOD,
    output              OV7670_SIOC,
    output              OV7670_PWDN,
    output              OV7670_RESET,
    output              OV7670_XCLK,
    
    // output to RAM
    output      [9:0]   outX,
    output      [8:0]   outY,
    output      [15:0]  pixelValue,
    output              pixelValid
    );
    
    assign OV7670_XCLK = clk25; // supposedly 10-48MHZ, some say 24MHZ max...
    assign OV7670_PWDN = 0;     // active high
    assign OV7670_RESET = 1;    // active low
    
    reg [3:0]   startTimer = 4'hF;
    reg         configStart = 1;
    wire        configDone;
    // just leave start high for a bit before setting it to 0.  Really only need 1 clock cycle
    // though
    always@(posedge clk25) begin
        startTimer <= startTimer -1;
        if (startTimer == 4'h0) begin
            configStart <= 0;
        end
    end
    camera_configure camConfig  (   .clk(clk25),
                                    .start(configStart),
                                    .sioc(OV7670_SIOC),
                                    .siod(OV7670_SIOD),
                                    .done(configDone)
    );
    
    wire frameDone;
    camera_read camCapture (        .p_clock(OV7670_PCLK),
                                    .vsync(OV7670_VSYNC),
                                    .href(OV7670_HREF),
                                    .p_data(OV7670_D),
                                    .pixel_data(pixelValue),
                                    .out_valid(pixelValid),
                                    .pixelX(outX),
                                    .pixelY(outY),
                                    .frame_done(frameDone)
    );



endmodule
