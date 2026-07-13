`timescale 1ns / 1ps

module wrapper_tb;

    // --- Inputs to the DUT ---
    reg clk;
    reg rst;
    reg signed [31:0] a_in;
    reg signed [31:0] b_in;
    reg signed [31:0] z_in;
    reg [4:0] opcode;

    // --- Outputs from the DUT ---
    wire [31:0] final_out;

    // --- Instantiate the DUT ---
    wrapper uut (
        .clk(clk),
        .rst(rst),
        .a_in(a_in),
        .b_in(b_in),
        .z_in(z_in),
        .opcode(opcode),
        .final_out(final_out)
    );

    // --- Clock Generation (10ns period) ---
    always #5 clk = ~clk;

    // --- Pipelined Streaming Stimulus ---
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        a_in = 32'sb0;
        b_in = 32'sb0;
        z_in = 32'sb0;
        opcode = 5'b0;

        // Apply Reset and release synchronously
        #20;
        @(posedge clk);
        rst = 1;
        
        // =====================================================================
        // STREAMING PHASE: Feed a new instruction on EVERY SINGLE CLOCK EDGE
        // =====================================================================
        
        // Cycle 1
        @(posedge clk);
        a_in = 32'sd10; b_in = 32'sd5; opcode = 5'b00010; // ADD (will out 15)
        
        // Cycle 2
        @(posedge clk);
        a_in = 32'sd20; b_in = 32'sd4; opcode = 5'b00101; // SUB (will out 16)
        
        // Cycle 3
        @(posedge clk);
        a_in = 32'sd100; b_in = 32'sd0; opcode = 5'b00001; // INCA (will out 101)
        
        // Cycle 4
        @(posedge clk);
        a_in = 32'h00FF_00FF; b_in = 32'hFFFF_0000; opcode = 5'b01000; // AND
        
        // Cycle 5 (CORDIC calculation setup)
        @(posedge clk);
        a_in = 32'h26DD3B66; b_in = 32'sd0; z_in = 32'h3243F6A9; opcode = 5'b11110; // COS

        // Cycle 6 (Stream next CORDIC vector component directly behind it)
        @(posedge clk);
        opcode = 5'b11111; // SINE

        // =====================================================================
        // FLUSHING PHASE: Clear inputs, wait for data to cascade out the end
        // =====================================================================
        @(posedge clk);
        a_in = 32'b0; b_in = 32'b0; z_in = 32'b0; opcode = 5'b0;
        
        // Wait exactly 32 clock cycles for Cycle 1's ADD result to exit final_out
        repeat(32) @(posedge clk);
        $display("First pipelined data (ADD result) is now appearing at final_out!");
        
        // Wait another 10 cycles to watch the remaining streamed values exit back-to-back
        repeat(10) @(posedge clk);

        $display("Streaming simulation completed.");
        $finish;
    end

endmodule