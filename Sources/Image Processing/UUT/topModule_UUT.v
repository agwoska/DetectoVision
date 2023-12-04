`timescale 1ns/1ps

////////////////////////////////////////////////////////////////////////////////// 
// EC 551 Adcanced Digital Design 
// Team DetectoVision 
// Team Members: Mehedi Hasan, Visaal Nekkanti, Andrew Woska, Abin George 

// Description: Unit under test for file read
//////////////////////////////////////////////////////////////////////////////////


module topModule_UUT();
    
reg clk;
reg rst;

wire writeDone1;
wire writeDone2;
// read data from file like reading from camera pixel by pixel
top test (
    .CAMERA_CLK(clk),
    .rst(rst),
    .writeDone1(writeDone1),
    .writeDone2(writeDone2)
);


always@(writeDone2)
begin
    if(writeDone2 == 1'b1)
        $finish;
end



initial 
begin 
    clk = 0; 
    forever #10 clk = ~clk; 
end 

initial 
begin 
     rst = 1; 
    #85 rst = 0; 
//    #100000 $finish;
end 
endmodule

