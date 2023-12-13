`timescale 1ns / 1ps

/////////////////////////////////////////
// Team: DetectoVision
// EC 551 Advanced Digital Design
// Description: 7 segment display
/////////////////////////////////////////

module segDisplay(
	input [15:0] x,
    input clk,
    output reg [6:0] seg,
    output reg [3:0] an,
    output wire dp 
	 );
	 
	 
wire [1:0]  s;	 
reg  [3:0]  digit;
wire [3:0]  aen;
//reg  [19:0] clkdiv;
reg  [1:0] clkdiv;

assign dp = 1;
assign s = clkdiv;
assign aen = 4'b1111; // all turned off initially

// quad 4to1 MUX.


always @(posedge clk)// or posedge clr)
	
	case(s)
	0:digit = x[3:0]; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
	1:digit = x[7:4]; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
	2:digit = x[11:8]; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8
	3:digit = x[15:12]; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
	default:digit = x[3:0];
	
	endcase
	
	//decoder or truth-table for 7seg display values
	always @(*)

        case(digit)
        
        
        //////////<---MSB-LSB<---
        //////////////gfedcba////////////////////////////////////////////           a
        0:seg = 7'b1000000;////0000												   __					
        1:seg = 7'b1111001;////0001												f/	  /b
        2:seg = 7'b0100100;////0010												  g
        //                                                                       __	
        3:seg = 7'b0110000;////0011										 	 e /   /c
        4:seg = 7'b0011001;////0100										       __
        5:seg = 7'b0010010;////0101                                            d  
        6:seg = 7'b0000010;////0110
        7:seg = 7'b1111000;////0111
        8:seg = 7'b0000000;////1000
        9:seg = 7'b0010000;////1001
        'hA:seg = 7'b0001000; 
        'hB:seg = 7'b0000011; 
        'hC:seg = 7'b1000110;
        'hD:seg = 7'b0100001;
        'hE:seg = 7'b0000110;
        'hF:seg = 7'b0001110;
        
        default: seg = 7'b0000000; // U
        
        endcase
       


    always @(*)begin
    an=4'b1111;
    if(aen[s] == 1)
    an[s] = 0;
    end


//clkdiv
        
        always @(posedge clk) begin
        clkdiv <= clkdiv+1;
        end


endmodule