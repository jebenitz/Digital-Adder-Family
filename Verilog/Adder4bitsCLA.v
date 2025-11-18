/**
 * 4-bit Carry Lookahead Adder (CLA)
 * 
 * Implements a 4-bit carry lookahead adder with group propagate/generate outputs
 * for hierarchical expansion. All carry bits are computed in parallel from the 
 * input operands and carry-in.
 *
 */

module carry_lookahead_4bit (
    input  [3:0] A,        
    input  [3:0] B,         
    input        cin,      
    output [3:0] S,        
    output       Pg,       // Group Propagate (for hierarchical expansion)
    output       Gg        // Group Generate (for hierarchical expansion)
);

    wire [3:0] P, G;       // Internal propagate/generate  
    wire [3:0] C;          // Internal carry signals

    
    assign P = A ^ B;      
    assign G = A & B;      

    assign C[0] = cin;     // External carry-in
    
    genvar i;
    generate 
        for (i = 1; i < 4; i = i + 1) begin : carry_lookahead_chain
            // Carry equation: C[i] = G[i-1] | (P[i-1] & C[i-1])
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate

    
    assign S = P ^ C;

    // Group signals for hierarchical expansion
    assign Pg = &P;  // &P = P[3]&P[2]&P[1]&P[0];
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);

endmodule
