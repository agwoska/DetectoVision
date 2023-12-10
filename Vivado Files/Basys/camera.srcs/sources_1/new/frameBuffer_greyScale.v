`timescale 1ns / 1ps


module frameBuffer_greyScale(
        input clk,
        input reset,
        input redHue,
        input [9:0] inX,
        input [8:0] inY,
        input [9:0] outX,
        input [8:0] outY,
        input [9:0] outX_edge,
        input [8:0] outY_edge,
        input [15:0] inPixel,
        input pixelValid,
        output reg [3:0] outPixel,
        output reg edgeValid,
        output reg [3:0] ul,
        output reg [3:0] uc,
        output reg [3:0] ur,
        output reg [3:0] ml,
        output reg [3:0] mr,
        output reg [3:0] dl,
        output reg [3:0] dc,
        output reg [3:0] dr,
        output reg [9:0] outX_edgeOut,
        output reg [8:0] outY_edgeOut            
    );
    
    parameter ROW_LENGTH = 600;
    parameter COL_LENGTH = 400; 
    parameter THRESHOLD_MIN = 8;
    parameter THRESHOLD_MAX = 7;
    parameter COL_BIAS = 20;
    parameter ROW_BIAS = 40;
    
    reg [1:0] DIV_CST = 2'b11; 
    // variables for writing to BRAM
    reg [17:0] inAddress;
    reg [3:0] inputPixel;
    wire enableWrite = ((inX < 620) && (inX >= 20) && (inY < 440) && (inY >= 40)) ? 1'b1:1'b0;
    
    // variables for reading from BRAM
    reg [17:0] outAddress;
    wire [3:0] outputPixel;
    wire [3:0] outputPixelEdge_temp; // used for edge detector
    
    // edge detection
    reg edgeValid_temp = 1'b0;
    reg [17:0] outAddress_edge;
    reg [2:0]edgeState = 3'b0;
    reg [9:0] edgeX_temp;
    reg [8:0] edgeY_temp;
    reg [3:0] tempValueHolder [0:7];
    
    // bram to store grey scale images
    // only 4 bits is required to save a grey scale image
    // since r == g == b
    bram greyScale(
        .clka(clk),
        .clkb(clk),
        .addra(inAddress),
        .addrb(outAddress),
        .dina(inputPixel),
        .ena(1'b1),
        .enb(1'b1),
        .wea(enableWrite & pixelValid),
        .doutb(outputPixel) // only output
    );
    
    bram edgeDetect(
        .clka(clk),
        .clkb(clk),
        .addra(inAddress),
        .addrb(outAddress),
        .dina(inputPixel),
        .ena(1'b1),
        .enb(1'b1),
        .wea(enableWrite & pixelValid),
        .doutb(outputPixel2) // only output
    );
    
    
    // always block for writing to BRAM    
    always@(posedge clk)
    begin
        if(enableWrite & pixelValid)
        begin
            inAddress <= (inX-COL_BIAS) + (inY-ROW_BIAS)*ROW_LENGTH;
            if (redHue == 1'b0) begin                
                inputPixel <= (inPixel[15:12]+ inPixel[10:7] + inPixel[4:1])/3;
            end
            else
            begin
                if ((inPixel[15:12] >= THRESHOLD_MIN) && (inPixel[10:7] < THRESHOLD_MAX) && (inPixel[4:1] < THRESHOLD_MAX))
                    inputPixel <= 8;
                else
                    inputPixel <= 0;           
            end
        end
    end

    
    
    
    
    // always block for reading from BRAM  
    always@(posedge clk)
    begin
        outAddress <= (outX-COL_BIAS) + (outY-ROW_BIAS)*ROW_LENGTH;
        outPixel <= outputPixel;
    end


    // always blocks for the edge detections
    always@(posedge clk)
    begin
        edgeValid <= edgeValid_temp;
    end
    
    always@(posedge clk)
    begin
        case(edgeState)
        
            3'b000:
            begin
                edgeX_temp <= outX_edge - COL_BIAS -1;
                edgeY_temp <= outY_edge - ROW_BIAS - 1;
                outAddress_edge <= edgeX_temp + edgeY_temp*ROW_LENGTH;
                tempValueHolder[0] <= outputPixel2;
                edgeState <= 1;
                edgeValid_temp <= 0;
            end
            3'b001:
            begin
                edgeX_temp <= outX_edge - COL_BIAS;
                edgeY_temp <= outY_edge - ROW_BIAS  - 1;
                outAddress_edge <= edgeX_temp + edgeY_temp*ROW_LENGTH;
                tempValueHolder[1] <= outputPixel2;
                edgeState <= 2;
            end
            
            3'b010:
            begin
                edgeX_temp <= outX_edge - COL_BIAS + 1;
                edgeY_temp <= outY_edge - ROW_BIAS  - 1;
                outAddress_edge <= edgeX_temp + edgeY_temp*ROW_LENGTH;
                tempValueHolder[2] <= outputPixel2;
                edgeState <= 3;
            end
            
            3'b011:
            begin
                edgeX_temp <= outX_edge - COL_BIAS-1;
                edgeY_temp <= outY_edge - ROW_BIAS ;
                outAddress_edge <= edgeX_temp + edgeY_temp*ROW_LENGTH;
                tempValueHolder[3] <= outputPixel2;
                edgeState <= 4;
            end
            
            3'b100:
            begin
                edgeX_temp <= outX_edge - COL_BIAS+1;
                edgeY_temp <= outY_edge - ROW_BIAS ;
                outAddress_edge <= edgeX_temp + edgeY_temp*ROW_LENGTH;
                tempValueHolder[4] <= outputPixel2;
                edgeState <= 5;
                
            end
            
            3'b101:
            begin
                edgeX_temp <= outX_edge - COL_BIAS - 1;
                edgeY_temp <= outY_edge - ROW_BIAS  + 1;
                outAddress_edge <= edgeX_temp + edgeY_temp*ROW_LENGTH;
                tempValueHolder[5] <= outputPixel2;
                edgeState <= 6;
                
            end
            
            3'b110:
            begin
                edgeX_temp <= outX_edge - COL_BIAS;
                edgeY_temp <= outY_edge  - ROW_BIAS + 1;
                outAddress_edge <= edgeX_temp + edgeY_temp*ROW_LENGTH;
                tempValueHolder[6] <= outputPixel2;
                edgeState <= 7;
            end
            
            default:
            begin
                edgeX_temp <= outX_edge - COL_BIAS + 1;
                edgeY_temp <= outY_edge  - ROW_BIAS + 1;
                outAddress_edge <= edgeX_temp + edgeY_temp*ROW_LENGTH;
                tempValueHolder[7] <= outputPixel2;
                edgeState <= 0;
                //assigning output values
                edgeValid_temp <= 1;
                ul <=  tempValueHolder[0];
                uc <=  tempValueHolder[1];
                ur <=  tempValueHolder[2];
                ml <=  tempValueHolder[3];
                mr <=  tempValueHolder[4];
                dl <=  tempValueHolder[5];
                dc <=  tempValueHolder[6];
                dr <=  tempValueHolder[7];  
                outX_edgeOut <= outX_edge;
                outY_edgeOut <= outY_edge;        
            end
        
        endcase
    
    end


endmodule
