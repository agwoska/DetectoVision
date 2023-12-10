`timescale 1ns / 1ps

module cameraConfig(
    input wire clk,
    input wire [7:0] addr,
    output reg [15:0] dout
    );
    //FFFF is end of rom, FFF0 is delay
    always @(posedge clk) begin
    case(addr) 
    0:  dout <= 16'h12_80; // reset
    1:  dout <= 16'hFF_F0; // delay
    2:  dout <= 16'h12_04; // COM7   Default size, RGB
    3:  dout <= 16'h11_00; // CLKRC  Prescaler - Fin/(1+1)
    4:  dout <= 16'h0C_00; // COM3   Lots of stuff, enable scaling, all others off
    5:  dout <= 16'h3E_00; // COM14  PCLK scaling off
    6:  dout <= 16'h8C_00; // RGB444 No RGB 444
    7:  dout <= 16'h04_00; // COM1   no CCIR601
    8:  dout <= 16'h40_D0; // COM15  Full 0-255 output, RGB 565
    9:  dout <= 16'h3a_04; // TSLB   Set UV ordering,  do not auto-reset window
    10: dout <= 16'h14_38; // COM9  - AGC Celling
    11: dout <= 16'h4f_40; // 16'h4fb3; // MTX1  - colour conversion matrix
    12: dout <= 16'h50_34; // 16'h50b3; // MTX2  - colour conversion matrix
    13: dout <= 16'h51_0C; // 16'h5100; // MTX3  - colour conversion matrix
    14: dout <= 16'h52_17; // 16'h523d; // MTX4  - colour conversion matrix
    15: dout <= 16'h53_29; // 16'h53a7; // MTX5  - colour conversion matrix
    16: dout <= 16'h54_40; // 16'h54e4; // MTX6  - colour conversion matrix
    17: dout <= 16'h58_9e; // 16'h581e; // MTXS  - Matrix sign and auto contrast
    18: dout <= 16'h3d_C8; // COM13 - Turn on GAMMA and UV Auto adjust
    19: dout <= 16'h11_00; // CLKRC  Prescaler - Fin/(1+1)
    20: dout <= 16'h17_11; // HSTART HREF start (high 8 bits)
    21: dout <= 16'h18_61; // HSTOP  HREF stop (high 8 bits)
    22: dout <= 16'h32_80; // HREF   Edge offset and low 3 bits of HSTART and HSTOP
    23: dout <= 16'h19_03; // VSTART VSYNC start (high 8 bits)
    24: dout <= 16'h1A_7b; // VSTOP  VSYNC stop (high 8 bits)
    25: dout <= 16'h03_0a; // VREF   VSYNC low two bits
    26: dout <= 16'h0e_61; // COM5(0x0E) 0x61
    27: dout <= 16'h0f_4b; // COM6(0x0F) 0x4B
    28: dout <= 16'h16_02;
    29: dout <= 16'h1e_27; // MVFP (0x1E) 0x07  // FLIP AND MIRROR IMAGE 0x3x
    30: dout <= 16'h21_02;
    31: dout <= 16'h22_91;
    32: dout <= 16'h29_07;
    33: dout <= 16'h33_0b;
    34: dout <= 16'h35_0b;
    35: dout <= 16'h37_1d;
    36: dout <= 16'h38_71;
    37: dout <= 16'h39_00;
    38: dout <= 16'h3c_78; // COM12 (0x3C) 0x78
    39: dout <= 16'h4d_40;
    40: dout <= 16'h4e_20;
    41: dout <= 16'h69_00; // GFIX (0x69) 0x00
    42: dout <= 16'h6b_0a; // Bypass PLL!
    43: dout <= 16'h74_00;
    44: dout <= 16'h8d_4f;
    45: dout <= 16'h8e_00;
    46: dout <= 16'h8f_00;
    47: dout <= 16'h90_00;
    48: dout <= 16'h91_00;
    49: dout <= 16'h96_00;
    50: dout <= 16'h9a_00;
    51: dout <= 16'hb0_84;
    52: dout <= 16'hb1_0c;
    53: dout <= 16'hb2_0e;
    54: dout <= 16'hb3_80;
    55: dout <= 16'hb8_0a;
    // my changes
    56: dout <= 16'h13_8F; // turn on Automatic Gain Control with fast algorithm
    57: dout <= 16'h70_4A; // horizontal scale pattern default, bit[7] controls test (C=on, 4=off)
    58: dout <= 16'h71_35; // vertical scale pattern default,   bit[7] controls test (B=on, 3=off)
    default:  dout <= 16'hFF_FF;         //mark end of ROM
    endcase

    end
endmodule