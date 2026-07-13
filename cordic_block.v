`timescale 1ns / 1ps

module cordic_block(
    input  wire        clk, 
    input  wire        rst,
    input  wire [4:0]  counter_in, 
    input  wire [2:0]  opcode_in,
    input  wire signed [31:0] a_in,
    input  wire signed [31:0] b_in,
    input  wire signed [31:0] z_in,
    
    output reg  [2:0]  opcode_out,
    output reg  signed [31:0] a_out, 
    output reg  signed [31:0] b_out, 
    output reg  signed [31:0] z_out,
    output reg signed [31:0] add_out,
    output reg signed [31:0] sub_out,
    output reg signed [31:0] shift_a_out,
    output reg signed [31:0] shift_b_out,
    output reg signed [31:0] comp_a_out,
    output reg signed [31:0] comp_b_out
);

    wire signed [31:0] lut_angle;
    cordic_lut lut (.address(counter_in), .lut_angle(lut_angle));


    
    reg signed [31:0] comp_a_temp;
    reg signed [31:0] comp_b_temp;
    reg signed [31:0] comp_a;
    reg signed [31:0] comp_b;
   
    reg signed [31:0] next_a;
    reg signed [31:0] next_b;
    reg signed [31:0] next_z;
    reg signed [31:0] add_temp;
    reg signed [31:0] sub_temp;
    reg signed [31:0] shift_temp_ain;   
    reg signed [31:0] shift_temp_bin;
    reg signed [31:0] comp_temp_ain;     
    reg signed [31:0] comp_temp_bin;
    
    reg d_present;

    // Corrected Decision Logic (di evaluation)
    always @(*) begin
        // Check the sign bit (MSB) of the INCOMING angle z_in
        if (z_in[31] == 1'b0) begin
            d_present = 1'b1;  // z_in is positive or zero -> Rotate Counter-Clockwise
        end else begin
            d_present = 1'b0;  // z_in is negative -> Rotate Clockwise
        end
    end

    // Core CORDIC Cross-Coupled Structural Math
    always @(*) begin
        add_temp       = 32'sd0;
        sub_temp       = 32'sd0;
        shift_temp_ain = 32'sd0;
        shift_temp_bin = 32'sd0;
        comp_temp_ain  = 32'sd0;
        comp_temp_bin  = 32'sd0;
        
        comp_a_temp = a_in >>> counter_in;
        comp_b_temp = b_in >>> counter_in;
        
        comp_a = $signed(-comp_a_temp); 
        comp_b = $signed(-comp_b_temp);

        case (d_present)
            1'b1: begin
                // z_in was >= 0: Subtract angle to bring it toward zero
                next_a = a_in + comp_b;      // X_next = X - Y >>> i
                next_b = b_in + comp_a_temp; // Y_next = Y + X >>> i
                next_z = z_in - lut_angle;   // Z_next = Z - atan(2^-i)          
            end
            1'b0: begin
                // z_in was < 0: Add angle to bring it toward zero
                next_a = a_in + comp_b_temp; // X_next = X + Y >>> i
                next_b = b_in + comp_a;      // Y_next = Y - X >>> i
                next_z = z_in + lut_angle;   // Z_next = Z + atan(2^-i)
            end
        endcase 
        if (counter_in == 5'd0) begin
            add_temp = a_in + b_in;
            sub_temp = a_in * b_in;
            shift_temp_ain = a_in >>> 1;   
            shift_temp_bin = b_in >>> 1;
            comp_temp_ain = -a_in;     
            comp_temp_bin = -b_in;
        end        
    end

    // Clock Edge Sequential Register Update
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            a_out      <= 32'sd0;
            b_out      <= 32'sd0;
            z_out      <= 32'sd0;
            opcode_out <= 3'b000;
            add_out <= 32'sd0;
            sub_out <= 32'sd0;
            shift_a_out <= 32'sd0;
            shift_b_out <= 32'sd0;
            comp_a_out <= 32'sd0;
            comp_b_out <= 32'sd0;
        end else begin
            opcode_out <= opcode_in;
            a_out      <= next_a;
            b_out      <= next_b;
            z_out      <= next_z;
            add_out <= add_temp;
            sub_out <= sub_temp;
            shift_a_out <= shift_temp_ain;
            shift_b_out <= shift_temp_bin;
            comp_a_out <= comp_temp_ain;
            comp_b_out <= comp_temp_bin;
        end
    end

endmodule