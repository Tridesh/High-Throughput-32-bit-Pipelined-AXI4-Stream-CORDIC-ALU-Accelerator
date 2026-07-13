`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2026 00:35:16
// Design Name: 
// Module Name: alu_reg
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


module alu_reg(
    input clk,
    input rst,
    input signed [31:0] inca_in,
    input signed [31:0] add_in,
    input signed [31:0] sub_in,
    input signed [31:0] deca_in,
    input signed [31:0] and_in,
    input signed [31:0] or_in,
    input signed [31:0] xor_in,
    input signed [31:0] coma_in,
    input signed [31:0] shra_in,
    input signed [31:0] shla_in,
    output reg signed [31:0] inca_out,
    output reg signed [31:0] add_out,
    output reg signed [31:0] sub_out,
    output reg signed [31:0] deca_out,
    output reg signed [31:0] and_out,
    output reg signed [31:0] or_out,
    output reg signed [31:0] xor_out,
    output reg signed [31:0] coma_out,
    output reg signed [31:0] shra_out,
    output reg signed [31:0] shla_out
    );
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            inca_out <= 32'sd0;
            add_out <= 32'sd0;
            sub_out <= 32'sd0;
            deca_out <= 32'sd0;
            and_out <= 32'sd0;
            or_out <= 32'sd0;
            xor_out <= 32'sd0;
            coma_out <= 32'sd0;
            shra_out <= 32'sd0;
            shla_out <= 32'sd0;
        end else begin
            inca_out <= inca_in;
            add_out <= add_in;
            sub_out <= sub_in;
            deca_out <= deca_in;
            and_out <= and_in;
            or_out <= or_in;
            xor_out <= xor_in;
            coma_out <= coma_in;
            shra_out <= shra_in;
            shla_out <= shla_in;
        end
    end
endmodule
