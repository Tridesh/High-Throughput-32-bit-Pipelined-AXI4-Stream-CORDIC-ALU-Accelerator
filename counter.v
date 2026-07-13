`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 13:51:56
// Design Name: 
// Module Name: counter
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


module counter(
    input wire clk, wire rst,
    output reg [4:0] counter_out
    );
    always @(posedge clk or negedge rst) begin
        if (!rst) counter_out <= 5'd0;
        else counter_out <= counter_out + 1'b1;
    end
endmodule
