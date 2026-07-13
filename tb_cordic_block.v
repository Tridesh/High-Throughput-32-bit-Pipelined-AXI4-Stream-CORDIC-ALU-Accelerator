`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 16:31:57
// Design Name: 
// Module Name: tb_cordic_block
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

//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_cordic_block
// Description: Testbench to verify a SINGLE instance of your cordic_block module.
//              Tests a single rotation iteration stage (Stage 0).
//////////////////////////////////////////////////////////////////////////////////

module tb_cordic_block();

    // 1. Declare inputs to the UUT (Unit Under Test) as registers
    reg         clk;
    reg         rst;
    reg  [4:0]  counter_in;
    reg  [2:0]  opcode_in;
    reg  signed [31:0] a_in;
    reg  signed [31:0] b_in;
    reg  signed [31:0] z_in;

    // Declare outputs from the UUT as wires
    wire [2:0]  opcode_out;
    wire signed [31:0] a_out;
    wire signed [31:0] b_out;
    wire signed [31:0] z_out;

    // 2. Instantiate the single CORDIC block module
    cordic_block uut (
        .clk(clk),
        .rst(rst),
        .counter_in(counter_in),
        .opcode_in(opcode_in),
        .a_in(a_in),
        .b_in(b_in),
        .z_in(z_in),
        .opcode_out(opcode_out),
        .a_out(a_out),
        .b_out(b_out),
        .z_out(z_out)
    );

    // 3. Clock Generator: 100 MHz clock (10ns period)
    always begin
        #5 clk = ~clk;
    end

    // 4. Stimulus Logic
    initial begin
        // Initialize all inputs
        clk = 0;
        rst = 0; // Assert active-low reset
        counter_in = 5'd0;
        opcode_in  = 3'b000;
        a_in = 32'h0;
        b_in = 32'h0;
        z_in = 32'h0;

        // Release reset after 2 cycles
        #20;
        rst = 1;
        #10;

        // =================================================================
        // STIMULUS: Test Stage 0 (Shift index = 0, LUT angle = 45 degrees)
        // Let's pass:
        // X_in     = 1.0 (32'h40000000)
        // Y_in     = 0.0 (32'h00000000)
        // Z_in     = 45 degrees (32'h3243F6A8)
        //
        // What your code should do combinationally for Stage 0:
        // 1. lut_angle = 32'h3243F6A8 (45 deg)
        // 2. sub_out = z_in - lut_angle = 0 -> d_present = 1'b1 (positive/zero)
        // 3. comp_a_temp = a_in >>> 0 = 32'h40000000
        // 4. comp_b_temp = b_in >>> 0 = 32'h00000000
        // 5. comp_b = -comp_b_temp = 0
        // 6. Case 1'b1 evaluates: 
        //    next_a = a_in + comp_b      = 32'h40000000 + 0 = 32'h40000000
        //    next_b = b_in + comp_a_temp = 0 + 32'h40000000 = 32'h40000000
        //    next_z = sub_out            = 32'h00000000
        // =================================================================
        $display("[TB] Single Block Test Started: Driving Stage 0");
        
        counter_in = 5'd0;         // Emulate the very first stage (Stage 0)
        a_in       = 32'h26DD3B66; // X = 1/A
        b_in       = 32'h00000000; // Y = 0.0
        z_in       = 32'h3243F6A8; // Z = 45 degrees
        opcode_in  = 3'd1;

        // Wait exactly ONE clock edge for the block to latch the calculated results
        @(posedge clk);
        #2; // Tiny delay to let the outputs settle in simulation

        // 5. Verify and Print out Single Block Results
        $display("==================================================");
        $display("[TB] SINGLE BLOCK OUTCOME REPORT (STAGE 0)");
        $display("==================================================");
        $display("a_out Hex (Expected 40000000): %h", a_out);
        $display("b_out Hex (Expected 40000000): %h", b_out);
        $display("z_out Hex (Expected 00000000): %h", z_out);
        $display("opcode_out (Expected 1)      : %d", opcode_out);
        $display("==================================================");

        // Terminate simulation cleanly
        #30;
        $finish;
    end

endmodule
