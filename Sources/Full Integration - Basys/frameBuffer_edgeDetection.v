`timescale 1ns / 1ps



module frameBuffer_edgeDetection(
    input clk,
    input reset,
    input redHue,
    input  edgeValid,
    input  [3:0] ul,
    input  [3:0] uc,
    input  [3:0] ur,
    input  [3:0] ml,
    input  [3:0] mr,
    input  [3:0] dl,
    input  [3:0] dc,
    input  [3:0] dr,
    input  [9:0] outX_edgeOut,
    input  [8:0] outY_edgeOut,
    input  [9:0] outX_VGA,
    input  [8:0] outY_VGA,
    output reg [3:0] outPixel,
    output reg [9:0] outX_edge,
    output reg [8:0] outY_edge 
);

    parameter WIDTH = 620;
    parameter HEIGHT = 480;
    parameter COL_BIAS = 20;
    parameter ROW_BIAS = 40;
    parameter ROW_LENGTH = 600;
    parameter COL_LENGTH = 400; 
    parameter BW_THRESHOLD = 10;
    parameter DIV_CST = 2;
    
    
    // variables for reading from BRAM
    reg [17:0] outAddress;
    wire [3:0] outputPixel;
    
    // variables for writing to BRAM
    reg [17:0] inAddress;
    reg [3:0] inputPixel;

    // variables for edge detection
    reg [7:0] gx, gy, g_temp;

    
// bram to store the edge results
 bram greyScale(
        .clka(clk),
        .clkb(clk),
        .addra(inAddress),
        .addrb(outAddress),
        .dina(inputPixel),
        .ena(1'b1),
        .enb(1'b1),
        .wea(edgeValid),
        .doutb(outputPixel) // only output
    );


initial
begin 
    outX_edge <= 21;
    outY_edge <= 41;
end

// next pixel to find edge around
always@(posedge clk)
begin
    if(edgeValid)
    begin
    
     if(outX_edge == WIDTH-2)
        begin
            if(outY_edge == HEIGHT -2)
            begin
                outX_edge <= 21;
                outY_edge <= 41; 
            end
            else
            begin
                outY_edge <= outY_edge + 1;
                outX_edge <= 21;
            end
        end       
        else
        begin
            outX_edge <= outX_edge + 1;
        end  
    end
end



// writing to BRAM
always @(posedge clk)
begin
    if(edgeValid)
    begin
        inAddress <= (outX_edgeOut-COL_BIAS) + (outY_edgeOut-ROW_BIAS)*ROW_LENGTH;
        
        gx <= ul - ur +2*ml - 2*mr + dl -dr;    
        gy <= ul + 2*uc + ur - dl -2*dc - dr;
   
        if(gy == 0)
        begin
            g_temp <= gx;
        end
        else
        begin
            g_temp <= gy + ((gx*gx)/(gy*DIV_CST));            
        end
        
        if(g_temp>=BW_THRESHOLD)
            inputPixel <= 15;
        else
            inputPixel <= 0; 
    end

end


// reading from BRAM
// always block for reading from BRAM  
    always@(posedge clk)
    begin
        outAddress <= (outX_VGA-COL_BIAS) + (outY_VGA-ROW_BIAS)*ROW_LENGTH;
        outPixel <= outputPixel;
    end


endmodule