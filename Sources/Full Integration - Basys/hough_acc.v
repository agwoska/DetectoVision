`timescale 1ns / 1ps


module hough_acc(
    input clk,
    input wire [9:0] X,
    input wire [8:0] Y,
    input [3:0] pixel,
    output reg [9:0] idealX,
    output reg [8:0] idealY
);

    parameter TOTAL_LENGTH = 400*600;
    parameter RADIUS = 20;
    parameter ROW_LENGTH = 600;
    parameter COL_LENGTH = 400; 
    parameter COL_BIAS = 20;
    parameter ROW_BIAS = 40;
    
    reg [3:0] accBest;
    reg [3:0] accTemp [3:0];
    reg [3:0] acc [99:0];
    
    initial
    begin
        idealX <= 0;
        idealY <= 0;
        accBest <= 0;
    end 
    
    
    // finding ideal
    always@(posedge clk)
    begin
        if(pixel > 0) begin
            if((accTemp[0] >= accTemp[1]) && (accTemp[0] >= accTemp[2]) && (accTemp[0] >= accTemp[3]) && (accTemp[0] > accBest))
            begin
               idealX <= X-RADIUS;
               idealY <= Y;
               accBest <= accTemp[0]; 
            end
            else if((accTemp[1] >= accTemp[0]) && (accTemp[1] >= accTemp[2]) && (accTemp[1] >= accTemp[3]) && (accTemp[1] > accBest))
            begin
               idealX <= X+RADIUS;
               idealY <= Y;
               accBest <= accTemp[1];
            end
            else if((accTemp[2] >= accTemp[1]) && (accTemp[2] >= accTemp[0]) && (accTemp[2] >= accTemp[3]) && (accTemp[2] > accBest))
            begin
               idealX <= X;
               idealY <= Y - RADIUS;
               accBest <= accTemp[2];
            end
            else if((accTemp[3] >= accTemp[1]) && (accTemp[3] >= accTemp[2]) && (accTemp[3] >= accTemp[0]) && (accTemp[3] > accBest))
            begin
               idealX <= X;
               idealY <= Y + RADIUS;
               accBest <= accTemp[3];
            end
        
        end
    
    end
    
    
    // LEFT CIRCLE
    always@(posedge clk)
    begin
        if(pixel > 0) begin
             if(X >= (COL_BIAS + RADIUS))
             begin
                 acc[(X-RADIUS-COL_BIAS) + (Y-ROW_BIAS)*ROW_LENGTH] <= acc[(X-RADIUS-COL_BIAS) + (Y-ROW_BIAS)*ROW_LENGTH] + 1; 
                 accTemp[0] <= acc[(X-RADIUS-COL_BIAS) + (Y-ROW_BIAS)*ROW_LENGTH];        
             end
             else
                accTemp[0] <= 0;
          end
    end
    
    // RIGHT CIRCLE
    always@(posedge clk)
    begin
        if(pixel > 0) begin
            if(X < (ROW_LENGTH + COL_BIAS - RADIUS))
            begin
                 acc[(X+RADIUS-COL_BIAS) + (Y-ROW_BIAS)*ROW_LENGTH] <= acc[(X+RADIUS-COL_BIAS) + (Y-ROW_BIAS)*ROW_LENGTH] + 1;
                 accTemp[1] <= acc[(X+RADIUS-COL_BIAS) + (Y-ROW_BIAS)*ROW_LENGTH];
                        
            end
            else
                accTemp[1] <= 0;
        end     
    end
    
    
    // UP CIRCLE
    always@(posedge clk)
    begin
        if(pixel > 0) begin
             if(Y >= (ROW_BIAS + RADIUS))
             begin
                  acc[(X-COL_BIAS) + (Y-ROW_BIAS-RADIUS)*ROW_LENGTH] <= acc[(X-COL_BIAS) + (Y-ROW_BIAS-RADIUS)*ROW_LENGTH] + 1;   
                  accTemp[2] <= acc[(X-COL_BIAS) + (Y-ROW_BIAS-RADIUS)*ROW_LENGTH];
             end
             else
                accTemp[2] <= 0;
        end
    end
    
    
    // DOWN CIRCLE
    always@(posedge clk)
    begin
        if(pixel > 0) begin
             if(Y <(COL_LENGTH + ROW_BIAS - RADIUS))
             begin
                  acc[(X-COL_BIAS) + (Y-ROW_BIAS+RADIUS)*ROW_LENGTH] <= acc[(X-COL_BIAS) + (Y+ROW_BIAS-RADIUS)*ROW_LENGTH] + 1;       
                  accTemp[3] <= acc[(X-COL_BIAS) + (Y-ROW_BIAS+RADIUS)*ROW_LENGTH];
             end
             else
                accTemp[3] <= 0;
         end    
     end
endmodule
