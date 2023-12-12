`timescale 1ns / 1ps


module houghAccumulator(
    input clk, 
    input [9:0] X,
    input [8:0] Y,
    input [3:0] pixel,
    output reg [9:0] idealX,
    output reg [8:0] idealY
);


    parameter TOTAL_LENGTH = 400*600;
    parameter RADIUS = 100;
    parameter ROW_LENGTH = 450;//600;
    parameter COL_LENGTH = 290;//400; 
    parameter COL_BIAS = 95;
    parameter ROW_BIAS = 95;
    parameter MUL_CST = 2;


    reg started = 1'b0;
    reg [2:0] caseReg = 2'b00;
    reg [9:0] X_reg;
    reg [8:0] Y_reg;
    
     // variables for reading from BRAM
    reg [17:0] outAddress;
    wire [3:0] outputPixel;
    
    // variables for writing to BRAM
    reg [17:0] inAddress;
    reg [3:0] inputPixel;
    
    // temp Values
    reg [5:0] accBest = 0;
    reg [5:0] accTemp;   
    
    // bram to store the accumulator
    //450x290
 bram2 accumulator(
        .clka(clk),
        .clkb(clk),
        .addra(inAddress),
        .addrb(outAddress),
        .dina(inputPixel),
        .ena(1'b1),
        .wea(started),
        .doutb(outputPixel) // only output
    );
    
    
    
    
    initial begin
        idealX <= 0;
        idealY <= 0;
    end
    
    always@(*)
    begin
        if(started == 1'b1)
        begin
            if (accTemp > accBest)
            begin
                accBest <= accTemp;
                idealX <= X_reg;
                idealY <= Y_reg;
            end       
        end
    end
    
    always@(posedge clk)
    begin
        if(caseReg == 2'b00 && pixel>3)
        begin
             started <= 1'b1;         
        end
        else if(caseReg == 2'b00 && pixel<=3)
        begin
             started <= 1'b0;         
        end
    end 
    
    always@(posedge clk)
    begin
    
        case(caseReg)
            2'b00:
            begin
            caseReg <= 2'b01;
            
            if(started) begin
                X_reg <= X-RADIUS;
                Y_reg <= Y;
                if(X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    inputPixel <= outputPixel + 1;
                    inAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    accTemp <= outputPixel + 1;
                end
                else
                    accTemp <= 0;    
            end              
            end 
            2'b01:
            begin
            caseReg <= 2'b10;
            
            if(started) begin
                X_reg <= X_reg+(2*RADIUS);
                Y_reg <= Y_reg;
                if(X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    inputPixel <= outputPixel + 1;
                    inAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    accTemp <= outputPixel + 1;
                end
                else
                    accTemp <= 0;  
            end
            end
            2'b10:
            begin
            caseReg <= 2'b11;
            
            if(started) begin
                X_reg <= X_reg - RADIUS;
                Y_reg <= Y_reg - RADIUS;
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    inputPixel <= outputPixel + 1;
                    inAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    accTemp <= outputPixel + 1;
                end
                else
                    accTemp <= 0;  
            end        
            end
            default:
            begin
            caseReg <= 2'b00;
            
            if(started) begin
                X_reg <= X_reg;
                Y_reg <= Y_reg+(2*RADIUS);
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    inputPixel <= outputPixel + 1;
                    inAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    accTemp <= outputPixel + 1;
                end
                else
                    accTemp <= 0;  
                    
            end
            end
        
        endcase    
    end
    

endmodule
