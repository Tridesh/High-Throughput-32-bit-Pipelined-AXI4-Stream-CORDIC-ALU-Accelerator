`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 13.07.2026 00:31:27
// Design Name: alu_pipeline
// Module Name: alu_pipeline
// Description: A 32-stage parallel pipelined ALU structure.
//////////////////////////////////////////////////////////////////////////////////

module alu_pipeline(
    input clk,
    input rst,
    input signed [31:0] a_in,
    input signed [31:0] b_in,
    
    // Top-level outputs after 32 pipeline stages
    output wire signed [31:0] inca_out,
    output wire signed [31:0] add_out,
    output wire signed [31:0] sub_out,
    output wire signed [31:0] deca_out,
    output wire signed [31:0] and_out,
    output wire signed [31:0] or_out,
    output wire signed [31:0] xor_out,
    output wire signed [31:0] coma_out,
    output wire signed [31:0] shra_out,
    output wire signed [31:0] shla_out
    );
    
    // 2D Arrays to hold pipeline bus routing from stage 0 to 32
    wire signed [31:0] inca_pipe [0:32];
    wire signed [31:0] add_pipe  [0:32];
    wire signed [31:0] sub_pipe  [0:32];
    wire signed [31:0] deca_pipe [0:32];
    wire signed [31:0] and_pipe  [0:32];
    wire signed [31:0] or_pipe   [0:32];
    wire signed [31:0] xor_pipe  [0:32];
    wire signed [31:0] coma_pipe [0:32];
    wire signed [31:0] shra_pipe [0:32];
    wire signed [31:0] shla_pipe [0:32];

    // Stage 0: Combinational computation from your original ALU block
    alu_bypass dut (
        .a_in(a_in),
        .b_in(b_in),
        .inca_out(inca_pipe[0]),
        .add_out(add_pipe[0]),
        .sub_out(sub_pipe[0]),
        .deca_out(deca_pipe[0]),
        .and_out(and_pipe[0]),
        .or_out(or_pipe[0]),
        .xor_out(xor_pipe[0]),
        .coma_out(coma_pipe[0]),
        .shra_out(shra_pipe[0]),
        .shla_out(shla_pipe[0])
    );

    // Generation loop for the 32 register stages
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : alu_pipeline_stages
            alu_reg u_stage (
                .clk(clk),
                .rst(rst),
                // Input drives from the current index i
                .inca_in(inca_pipe[i]),
                .add_in(add_pipe[i]),
                .sub_in(sub_pipe[i]),
                .deca_in(deca_pipe[i]),
                .and_in(and_pipe[i]),
                .or_in(or_pipe[i]),
                .xor_in(xor_pipe[i]),
                .coma_in(coma_pipe[i]),
                .shra_in(shra_pipe[i]),
                .shla_in(shla_pipe[i]),
                
                // Output pushes to the next index i + 1
                .inca_out(inca_pipe[i+1]),
                .add_out(add_pipe[i+1]),
                .sub_out(sub_pipe[i+1]),
                .deca_out(deca_pipe[i+1]),
                .and_out(and_pipe[i+1]),
                .or_out(or_pipe[i+1]),
                .xor_out(xor_pipe[i+1]),
                .coma_out(coma_pipe[i+1]),
                .shra_out(shra_pipe[i+1]),
                .shla_out(shla_pipe[i+1])
            );
        end
    endgenerate

    // Route the final stage (index 32) directly to module outputs
    assign inca_out = inca_pipe[32];
    assign add_out  = add_pipe[32];
    assign sub_out  = sub_pipe[32];
    assign deca_out = deca_pipe[32];
    assign and_out  = and_pipe[32];
    assign or_out   = or_pipe[32];
    assign xor_out  = xor_pipe[32];
    assign coma_out = coma_pipe[32];
    assign shra_out = shra_pipe[32];
    assign shla_out = shla_pipe[32];

endmodule