//`timescale 1ns / 1ps


//// maybe use a LUT since we know the pixel value will be at most 255, but closer to 0 since thats what we really care about.
//module sqrt#(parameter 
//WIDTH = 768, // Image width 
//HEIGHT = 512, // Image height 
//BITS_FOR_INDEX = 10, // ceil(lg(max(width, height)))
//sizeOfWidth = 8
//) (
//input clk,
//input rst, 
//input [sizeOfWidth*2 -1: 0] gx,
//input [sizeOfWidth*2 -1: 0] gy,
//output reg [sizeOfWidth -1: 0] g 
//);

//reg [sizeOfWidth*2 -1: 0] g_temp;

//always@(posedge clk)
//begin
//    if(rst)
//    begin
//        g<= 0;
//    end
//    else
//    begin
//        g_temp <= (gx*gx + gy*gy);
        
//        if(g_temp <1 & g_temp >=0)
//        begin 
//            g <= 0;
//        end 
//        else if(g_temp <2.5 & g_temp >=1)
//        begin 
//            g <= 
//        end 
//        else if(g_temp <6.5 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <12.5 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <20.5 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <30.5 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <42.5 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <56.5 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <72.5 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <90.5 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <1 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <1 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <1 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <1 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <1 & g_temp >=0)
//        begin 
        
//        end 
//        else if(g_temp <1 & g_temp >=0)
//        begin 
        
//        end 
          
//    end
//end








//endmodule