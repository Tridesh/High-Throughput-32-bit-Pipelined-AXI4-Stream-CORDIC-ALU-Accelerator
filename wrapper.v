`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2026 01:12:48
// Design Name: 
// Module Name: wrapper
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

module wrapper(
    input clk,
    input rst,
    input signed [31:0] a_in,
    input signed [31:0] b_in,
    input signed [31:0] z_in,
    input [4:0] opcode,
    output reg [31:0] final_out
    );
    
    // --- Intermediate Wires from ALU Pipeline ---
    wire signed [31:0] inca_out_temp;
    wire signed [31:0] add_out_temp;  // Fixed: Replaced the duplicate declaration with add_out_temp
    wire signed [31:0] sub_out_temp;
    wire signed [31:0] deca_out_temp;
    wire signed [31:0] and_out_temp;
    wire signed [31:0] or_out_temp;
    wire signed [31:0] xor_out_temp;
    wire signed [31:0] coma_out_temp;
    wire signed [31:0] shra_out_temp;
    wire signed [31:0] shla_out_temp;
    
    // --- Intermediate Wires from CORDIC Pipeline ---
    wire [4:0]          opcode_out_temp;
    wire signed [31:0]  a_out_temp;
    wire signed [31:0]  b_out_temp;
    wire signed [31:0]  z_out_temp;
    
    wire signed [31:0]  cordic_add_out_temp;
    wire signed [31:0]  cordic_sub_out_temp;
    wire signed [31:0]  shift_a_out_temp;
    wire signed [31:0]  shift_b_out_temp;
    wire signed [31:0]  comp_a_out_temp;
    wire signed [31:0]  comp_b_out_temp;
    
    // ==========================================================================
    // 1. ALU Pipeline Instantiation
    // ==========================================================================
    alu_pipeline alu_dut(
        .clk(clk),
        .rst(rst),
        .a_in(a_in),
        .b_in(b_in),
        
        // Output port connections mapped to local wires
        .inca_out(inca_out_temp),
        .add_out(add_out_temp),
        .sub_out(sub_out_temp),
        .deca_out(deca_out_temp),
        .and_out(and_out_temp),
        .or_out(or_out_temp),
        .xor_out(xor_out_temp),
        .coma_out(coma_out_temp),
        .shra_out(shra_out_temp),
        .shla_out(shla_out_temp)
    );
    
    // ==========================================================================
    // 2. CORDIC Pipeline Instantiation
    // ==========================================================================
    cordic_pipeline cordic_dut(
        .clk(clk),
        .rst(rst),
        .opcode_in(opcode),
        .a_in(a_in), 
        .b_in(b_in),  
        .z_in(z_in),  
        
        // Output port connections mapped to local wires
        .opcode_out(opcode_out_temp),
        .a_out(a_out_temp), 
        .b_out(b_out_temp), 
        .z_out(z_out_temp), 
        
        .add_out(cordic_add_out_temp),
        .sub_out(cordic_sub_out_temp),
        .shift_a_out(shift_a_out_temp),
        .shift_b_out(shift_b_out_temp),
        .comp_a_out(comp_a_out_temp),
        .comp_b_out(comp_b_out_temp)
    );

    // ==========================================================================
    // TODO: Insert your opcode multiplexer logic down here using the _temp wires
    // ==========================================================================
    always @(*) begin
        case (opcode_out_temp)
            // --- ALU Operations (From Table Encodings) ---
            5'b00000: final_out = a_in;             // TSFA: Transfer A directly
            5'b00001: final_out = inca_out_temp;    // INCA: Increment A
            5'b00010: final_out = add_out_temp;     // ADD: Add A + B
            5'b00101: final_out = sub_out_temp;     // SUB: Subtract A - B
            5'b00110: final_out = deca_out_temp;    // DECA: Decrement A
            5'b01000: final_out = and_out_temp;     // AND: Bitwise AND A and B
            5'b01010: final_out = or_out_temp;      // OR: Bitwise OR A and B
            5'b01100: final_out = xor_out_temp;     // XOR: Bitwise XOR A and B
            5'b01110: final_out = coma_out_temp;    // COMA: Complement A
            5'b10000: final_out = shra_out_temp;    // SHRA: Shift right A
            5'b11000: final_out = shla_out_temp;    // SHLA: Shift left A
            
            // --- CORDIC Operations (Allotted Unused Opcodes) ---
            5'b11110: final_out = a_out_temp;       // CORDIC: Cosine output (X coordinate)
            5'b11111: final_out = b_out_temp;       // CORDIC: Sine output (Y coordinate)
            
            // Safe Catch-All
            default:  final_out = 32'b0;
        endcase
    end

endmodule