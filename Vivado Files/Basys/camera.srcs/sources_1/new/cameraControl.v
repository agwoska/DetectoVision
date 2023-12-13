`timescale 1ns / 1ps

/////////////////////////////////////////
// Team: DetectoVision
// EC 551 Advanced Digital Design
// Description: Main camera module
/////////////////////////////////////////

module cameraControl(
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
    output  wire     [9:0]   outX,
    output  wire    [8:0]   outY,
    output      [15:0]  pixelValue,
    output              pixelValid
    );
    
    assign OV7670_XCLK = clk25; // supposedly 10-48MHZ, some say 24MHZ max...
    assign OV7670_PWDN = 0;     // active high
    assign OV7670_RESET = 1;    // active low
    
    reg [3:0]   startTimer = 4'hF;
    reg         configStart = 1;
    wire        configDone;
    
    // making sure that the config only runs for a finite number of cycles
    always@(posedge clk25) begin
        startTimer <= startTimer -1;
        if (startTimer == 4'h0) begin
            configStart <= 0;
        end
    end
    cameraConfig_top camConfig  (   .clk(clk25),
                                    .start(configStart),
                                    .sioc(OV7670_SIOC),
                                    .siod(OV7670_SIOD),
                                    .done(configDone)
    );
    
    wire frameDone;
    cameraCaptureImage camCapture (     
                                    .p_clock(OV7670_PCLK),
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
