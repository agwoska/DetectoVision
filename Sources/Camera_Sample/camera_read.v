`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:12:24 12/03/2014 
// Design Name: 
// Module Name:    camera_read 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module camera_read(
	input wire p_clock,
	input wire vsync,
	input wire href,
	input wire [7:0] p_data,
	output reg [15:0] pixel_data = 16'hFEC8,   // random start val bc why not.
	output     [9:0]  pixelX,
	output     [8:0]  pixelY,
	output            out_valid,
	output reg frame_done = 0
    );
	 
	
	reg [1:0] FSM_state = 0;
    reg pixel_half = 0;
    reg prevHref = 0;
	reg pixel_valid = 0;
	
	localparam WAIT_FRAME_START = 0;
	localparam ROW_CAPTURE = 1;
	reg [9:0] hIdx = 10'h000;
	reg [8:0] vIdx = 9'h000;
	
	assign pixelX = hIdx;
	assign pixelY = vIdx;
    reg [7:0] firstHalfPixel = 8'h00;
	always@(posedge p_clock) begin 
        prevHref <= href;
        case(FSM_state)
            WAIT_FRAME_START: begin //wait for VSYNC
                FSM_state <= (!vsync) ? ROW_CAPTURE : WAIT_FRAME_START;
                frame_done <= 0;
                pixel_half <= (href) ? 1 : 0;
                firstHalfPixel <= p_data;
                pixel_valid <= 0;
                hIdx <= 0;
                vIdx <= 0;
            end

            ROW_CAPTURE: begin 
                FSM_state <= vsync ? WAIT_FRAME_START : ROW_CAPTURE;
                frame_done <= vsync ? 1 : 0;
                pixel_valid <= (href && pixel_half) ? 1 : 0;
                // if href goes low, then we need to reset our horizontal position.
                hIdx <= (href) ? ((pixel_half && (hIdx < 10'd641)) ? hIdx + 1 : hIdx) : 10'h000;
                // if href transitions from high to low, then we need to move to the next row
                if (prevHref == 1 && href == 0) begin
                    vIdx <= (vIdx < 9'd481) ? vIdx + 1 : vIdx;
                    pixel_half <= 0;
                    firstHalfPixel <= 0;
                end else if (href) begin
                    if (pixel_half == 0)
                        firstHalfPixel <= p_data;
                    pixel_half <= ~pixel_half;
                end
            end
        endcase
    end

    always@(posedge pixel_valid) begin
        pixel_data <= {firstHalfPixel, p_data};
    end

    assign out_valid = (vIdx <= 480 && hIdx <= 640) ? pixel_valid           : 1'b0;
endmodule