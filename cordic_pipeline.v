`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: CORDIC 32-Stage Unrolled Pipeline with End-Stage ALU
// Module Name: cordic_pipeline
// Description: Structural wrapper that instances 32 spatial copies of cordic_block.
//              Captures final CORDIC values and dedicated ALU calculations at stage 31.
//////////////////////////////////////////////////////////////////////////////////

module cordic_pipeline (
    input  wire        clk,
    input  wire        rst,
    input  wire [4:0]  opcode_in,
    input  wire signed [31:0] a_in,  // Initial X vector coordinate input
    input  wire signed [31:0] b_in,  // Initial Y vector coordinate input
    input  wire signed [31:0] z_in,  // Initial Target Angle input
    
    output wire [4:0]  opcode_out,
    output wire signed [31:0] a_out, // Final X coordinate result (after 32 cycles)
    output wire signed [31:0] b_out, // Final Y coordinate result (after 32 cycles)
    output wire signed [31:0] z_out, // Final Residual Angle result (after 32 cycles)
    
    // Dedicated ALU Outputs (Valid 32 cycles after the corresponding input enters)
    output wire signed [31:0] add_out,
    output wire signed [31:0] sub_out,
    output wire signed [31:0] shift_a_out,
    output wire signed [31:0] shift_b_out,
    output wire signed [31:0] comp_a_out,
    output wire signed [31:0] comp_b_out
);

    // 1. Declare vector arrays of wires to interconnect the stages.
    // 32 unrolled physical stages require 33 total interconnected boundaries.
    wire signed [31:0] a_pipe [0:32];
    wire signed [31:0] b_pipe [0:32];
    wire signed [31:0] z_pipe [0:32];
    wire [4:0]         op_pipe[0:32];

    // Arrays to collect ALU outputs from all stages (though only stage 31 produces valid data)
    wire signed [31:0] add_pipe   [0:31];
    wire signed [31:0] sub_pipe   [0:31];
    wire signed [31:0] sh_a_pipe  [0:31];
    wire signed [31:0] sh_b_pipe  [0:31];
    wire signed [31:0] cp_a_pipe  [0:31];
    wire signed [31:0] cp_b_pipe  [0:31];

    // 2. Map the top-level incoming module signals straight into the Stage 0 inputs
    assign a_pipe[0]  = a_in;
    assign b_pipe[0]  = b_in;
    assign z_pipe[0]  = z_in;
    assign op_pipe[0] = opcode_in;

    // 3. Hardware generation engine: structurally wires up 32 discrete stages
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : cordic_pipeline_stages
            
            cordic_block u_stage (
                .clk         (clk),
                .rst         (rst),
                .counter_in  (i[4:0]),         // Passes the loop index (0 to 31) as the shift value
                .opcode_in   (op_pipe[i]),     // Reads data outputted from previous stage boundary
                .a_in        (a_pipe[i]),
                .b_in        (b_pipe[i]),
                .z_in        (z_pipe[i]),
                
                .opcode_out  (op_pipe[i+1]),   // Routes data outputs directly to next stage inputs
                .a_out       (a_pipe[i+1]),
                .b_out       (b_pipe[i+1]),
                .z_out       (z_pipe[i+1]),
                
                // Connect intermediate ALU buses for every stage
                .add_out     (add_pipe[i]),
                .sub_out     (sub_pipe[i]),
                .shift_a_out (sh_a_pipe[i]),
                .shift_b_out (sh_b_pipe[i]),
                .comp_a_out  (cp_a_pipe[i]),
                .comp_b_out  (cp_b_pipe[i])
            );
            
        end
    endgenerate

    // 4. Extract data from the last stage boundary out to top-level ports
    assign a_out      = a_pipe[32];
    assign b_out      = b_pipe[32];
    assign z_out      = z_pipe[32];
    assign opcode_out = op_pipe[32];

    // Explicitly grab the ALU outputs coming from the 31st stage block
    assign add_out     = add_pipe[31];
    assign sub_out     = sub_pipe[31];
    assign shift_a_out = sh_a_pipe[31];
    assign shift_b_out = sh_b_pipe[31];
    assign comp_a_out  = cp_a_pipe[31];
    assign comp_b_out  = cp_b_pipe[31];

endmodule