`timescale 1ns / 1ps


module houghAccumulator3(
    input clk, 
    input [9:0] X,
    input [8:0] Y,
    input [3:0] pixel,
    output reg [3:0] accBest,
    output reg [9:0] idealX,
    output reg [8:0] idealY
);


    parameter TOTAL_LENGTH = 400*600;
    parameter RADIUS = 4;
    parameter ROW_LENGTH = 450;//600;
    parameter COL_LENGTH = 290;//400; 
    parameter COL_BIAS = 95;
    parameter ROW_BIAS = 95;
    parameter MUL_CST = 2;
    
    
    reg startedDone = 1'b0;
    reg [2:0] caseReg = 3'b00;
    reg [9:0] X_reg;
    reg [8:0] Y_reg;
    
     // variables for reading from BRAM
    reg [17:0] outAddress;
    wire [3:0] outputPixel;
    
    // variables for writing to BRAM
    reg [17:0] inAddress;
    reg [3:0] inputPixel;
    reg writeEnable = 1'b0;
    reg writeEnable_B = 1'b0;
    
    // temp Values
//    reg [5:0] accBest = 0;
    reg [5:0] accTemp;   
    
    
    
    // bram to store the accumulator
    //450x290
 bram3 accumulator(
        .clka(clk),
        .clkb(clk),
        .addra(inAddress),
        .addrb(outAddress),
        .dina(inputPixel),
        .dinb(),
        .ena(1'b1),
        .enb(1'b1),
        .wea(writeEnable),
        .doutb(outputPixel),
        .douta(),
        .web(writeEnable_B)        
    );
    
    
    initial begin
        idealX <= 0;
        idealY <= 0;
        accBest <= 0;
    end
    
    
    
    
    always@(posedge clk)
    begin
         if(X>= COL_BIAS && X< (ROW_LENGTH-COL_BIAS)) begin
            if(Y >= ROW_BIAS && Y<(COL_LENGTH - ROW_BIAS))
            begin
                inAddress <= (X-COL_BIAS) + (Y-ROW_BIAS)*ROW_LENGTH;
                writeEnable <= 1'b1;
                if(pixel > 2)
                begin
                    inputPixel <= 1;
                end
                else
                    inputPixel <= 0;
            end
            else
                writeEnable <= 1'b0;
         end
         else
            writeEnable <= 1'b0;
    end
    
    
//    always@(posedge clk)
//    begin
//        if(caseReg == 2'b00) begin
//            accTemp <= 0;
            
//        end
//    end
      
    
    always@(posedge clk)
    begin
    
        case(caseReg)
            3'b000:
            begin
             caseReg <= 3'b001;
             startedDone <= 1'b0;   
            
            
                X_reg <= X-RADIUS;
                Y_reg <= Y;
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS) && (X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS)))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    if (outputPixel > 0)
                        accTemp <= 1;
                     else
                        accTemp <= 0;
                end                          
            end 
            
            3'b001:
            begin
            caseReg <= 3'b010;
            
//            if(started) begin
                X_reg <= X_reg+(2*RADIUS);
                Y_reg <= Y_reg;
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS) && (X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS)))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    if (outputPixel > 0)
                        accTemp <= accTemp + 1;
                end
//            end
            end
            
            3'b010:
            begin
            caseReg <= 3'b011;
            
//            if(started) begin
                X_reg <= X_reg - RADIUS;
                Y_reg <= Y_reg - RADIUS;
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS) && (X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS)))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    if (outputPixel > 0)
                        accTemp <= accTemp + 1;
                end
               
//            end        
            end
            3'b011:
            begin
                caseReg <= 3'b100;
                startedDone <= 1'b1;
                X_reg <= X_reg;
                Y_reg <= Y_reg+(2*RADIUS);
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS) && (X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS)))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    if (outputPixel > 0)
                        accTemp <= accTemp + 1;
                end
            end
            
            3'b100:
            begin
                caseReg <= 3'b101;
                startedDone <= 1'b1;
                X_reg <= X_reg + RADIUS;
                Y_reg <= Y_reg;
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS) && (X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS)))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    if (outputPixel > 0)
                        accTemp <= accTemp + 1;
                end
            end
            
            3'b101:
            begin
                caseReg <= 3'b110;
                startedDone <= 1'b1;
                X_reg <= X_reg - (2*RADIUS);
                Y_reg <= Y_reg;
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS) && (X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS)))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    if (outputPixel > 0)
                        accTemp <= accTemp + 1;
                end
            end
            
            3'b110:
            begin
                caseReg <= 3'b111;
                startedDone <= 1'b1;
                X_reg <= X_reg;
                Y_reg <= Y_reg-(2*RADIUS);
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS) && (X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS)))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    if (outputPixel > 0)
                        accTemp <= accTemp + 1;
                end
            end
            default:
            begin
                caseReg <= 3'b000;
                startedDone <= 1'b1;
                X_reg <= X_reg+ (2*RADIUS);
                Y_reg <= Y_reg;
                if(Y_reg >= (ROW_BIAS) && Y_reg < (COL_LENGTH + ROW_BIAS) && (X_reg >= (COL_BIAS) && X_reg < (ROW_LENGTH + COL_BIAS)))
                begin
                    outAddress <= (X_reg-COL_BIAS) + (Y_reg-ROW_BIAS)*ROW_LENGTH;
                    if (outputPixel > 0)
                        accTemp <= accTemp + 1;
                end
            end
        
        endcase    
    end
    

    
    always@(startedDone)
    begin
        if(startedDone)
        begin
            if((accTemp >= 7))
            begin
                if(((Y_reg +RADIUS) >= (ROW_BIAS)) && ((Y_reg-RADIUS) < (COL_LENGTH + ROW_BIAS)) && ((X_reg-RADIUS) >= (COL_BIAS)) && ((X_reg- RADIUS) < (ROW_LENGTH + COL_BIAS)))
                begin    
                    idealX <= X_reg - RADIUS;
                    idealY <= Y_reg + RADIUS;
                    accBest <= accTemp;                                
            end
            end 
//            accTemp <= 0;   
        end
     end
   
endmodule
