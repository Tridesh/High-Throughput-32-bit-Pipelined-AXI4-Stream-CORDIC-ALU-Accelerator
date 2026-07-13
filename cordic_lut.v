`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 13:45:24
// Design Name: 
// Module Name: cordic_lut
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic_lut (
    input  wire [4:0]  address,    // 5-bit address to index 0 to 31
    output reg  signed [31:0] lut_angle   // 32-bit signed Q2.30 angle output
);

    always @(*) begin
        case (address)
            5'd0:  lut_angle = 32'h3243F6A8; // atan(1)      = 45.00000 deg
            5'd1:  lut_angle = 32'h1DAC6705; // atan(2^-1)   = 26.56505 deg
            5'd2:  lut_angle = 32'h0FA5C692; // atan(2^-2)   = 14.03624 deg
            5'd3:  lut_angle = 32'h07F2BB14; // atan(2^-3)   =  7.12502 deg
            5'd4:  lut_angle = 32'h03FFEA9F; // atan(2^-4)   =  3.57633 deg
            5'd5:  lut_angle = 32'h01FFEAA0; // atan(2^-5)   =  1.78991 deg
            5'd6:  lut_angle = 32'h00FFAAA0; // atan(2^-6)   =  0.89517 deg
            5'd7:  lut_angle = 32'h007FFAAA; // atan(2^-7)   =  0.44761 deg
            5'd8:  lut_angle = 32'h003FFFAA; // atan(2^-8)   =  0.22381 deg
            5'd9:  lut_angle = 32'h001FFFFA; // atan(2^-9)   =  0.11191 deg
            5'd10: lut_angle = 32'h000FFFFA; // atan(2^-10)  =  0.05595 deg
            5'd11: lut_angle = 32'h0007FFFF; // atan(2^-11)  =  0.02798 deg
            5'd12: lut_angle = 32'h0003FFFF; // atan(2^-12)  =  0.01399 deg
            5'd13: lut_angle = 32'h0001FFFF; // atan(2^-13)  =  0.00699 deg
            5'd14: lut_angle = 32'h0000FFFF; // atan(2^-14)  =  0.00350 deg
            5'd15: lut_angle = 32'h00007FFF; // atan(2^-15)  =  0.00175 deg
            5'd16: lut_angle = 32'h00003FFF; // atan(2^-16)  =  0.00087 deg
            5'd17: lut_angle = 32'h00001FFF; // atan(2^-17)  =  0.00044 deg
            5'd18: lut_angle = 32'h00000FFF; // atan(2^-18)  =  0.00022 deg
            5'd19: lut_angle = 32'h000007FF; // atan(2^-19)  =  0.00011 deg
            5'd20: lut_angle = 32'h000003FF; // atan(2^-20)  =  0.00005 deg
            5'd21: lut_angle = 32'h000001FF; // atan(2^-21)  =  0.00003 deg
            5'd22: lut_angle = 32'h000000FF; // atan(2^-22)  =  0.00001 deg
            5'd23: lut_angle = 32'h0000007F; // atan(2^-23)  =  0.00001 deg
            5'd24: lut_angle = 32'h0000003F; // atan(2^-24)  =  0.00000 deg
            5'd25: lut_angle = 32'h0000001F; // atan(2^-25)  =  0.00000 deg
            5'd26: lut_angle = 32'h0000000F; // atan(2^-26)  =  0.00000 deg
            5'd27: lut_angle = 32'h00000007; // atan(2^-27)  =  0.00000 deg
            5'd28: lut_angle = 32'h00000003; // atan(2^-28)  =  0.00000 deg
            5'd29: lut_angle = 32'h00000001; // atan(2^-29)  =  0.00000 deg
            5'd30: lut_angle = 32'h00000000; // atan(2^-30)  =  0.00000 deg
            5'd31: lut_angle = 32'h00000000; // atan(2^-31)  =  0.00000 deg
            default: lut_angle = 32'h00000000;
        endcase
    end

endmodule
