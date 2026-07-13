module alu_bypass(
    input signed [31:0] a_in,
    input signed [31:0] b_in,
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
    
    always @(*) begin
        inca_out = a_in + 1'b1;
        add_out  = a_in + b_in;
        sub_out  = a_in - b_in;
        deca_out = a_in - 1'b1;
        
        // Corrected bitwise operations:
        and_out  = a_in & b_in; 
        or_out   = a_in | b_in;
        xor_out  = a_in ^ b_in;
        coma_out = ~a_in;
        
        // Arithmetic shifts (use low 5 bits of b_in to prevent massive shift bounds)
        shra_out = a_in >>> b_in[4:0]; 
        shla_out = a_in <<< b_in[4:0];
    end
endmodule