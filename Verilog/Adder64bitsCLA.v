/*
*
* 64-bit Carry Lookahead Adder (CLA)
*
* Performs 64-bit addition by instantiating sixteen 4-bit CLA modules
* in a hierarchical structure. The first level creates four 16-bit blocks,
* each containing four 4-bit CLA modules with a carry generator that
* processes group propagate (Pg) and generate (Gg) signals.
*
* The second level combines four 16-bit blocks using the same auxiliary
* module to form the complete 64-bit CLA.
*
* Hierarchy levels:
* 64 bits → 4 blocks of 16 bits → each block has 4 sub-blocks of 4 bits
*
*NOTE: This adder treats operands as UNSIGNED integers.
*/

`include "Adder4bitsCLA.v"

module add64CLA #(parameter N = 64)(
    input  [N-1:0] A, B,  
    input  carry_in,
    output [N-1:0] S, 
    output carry_out
);

    localparam BLOCKS_16B = N / 16;
    localparam BLOCKS_4B  = N / 4;

    // 4-bit level signals (level 3)
    wire [BLOCKS_4B-1:0] prop_4b_blocks, gen_4b_blocks;
    wire [BLOCKS_4B-1:0] carry_4b_blocks;

    // 16-bit level signals (level 2)
    wire [BLOCKS_16B-1:0] prop_16b_blocks, gen_16b_blocks, carry_16b_blocks;

    // Global level (64 bits) signals
    wire prop_global_64b, gen_global_64b;

    genvar i, j;
    generate 
        for (j = 0; j < BLOCKS_16B; j = j + 1) begin : group16
            // Instantiate four 4-bit CLAs for each 16-bit block
            for (i = 0; i < 4; i = i + 1) begin : group4
                carry_lookahead_4bit add4_inst (
                    .A   (A[((16*j)+(i+1)*4) -1 : (16*j)+(i*4)]),
                    .B   (B[((16*j)+(i+1)*4) -1 : (16*j)+(i*4)]),
                    .cin (carry_4b_blocks[(4*j)+i]),
                    .S   (S[((16*j)+(i+1)*4) -1 : (16*j)+(i*4)]),
                    .Pg  (prop_4b_blocks[(4*j)+i]),
                    .Gg  (gen_4b_blocks[(4*j)+i])
                );
            end

            // Second level Carry Lookahead (16 bits)
            // Generates carry signals for the 4-bit blocks within this 16-bit group
            CLA4 cla16_inst (
                .P   (prop_4b_blocks[(j+1)*4 - 1 : j*4]),
                .G   (gen_4b_blocks[(j+1)*4 - 1 : j*4]), 
                .cin (carry_16b_blocks[j]),
                .C   (carry_4b_blocks[(j+1)*4 - 1 : j*4]),
                .Pg  (prop_16b_blocks[j]),
                .Gg  (gen_16b_blocks[j])
            );
        end
    endgenerate 

    // Third level Carry Lookahead (64 bits)
    // Generates carry signals for the 16-bit blocks
    CLA4 cla64_inst (
        .P   (prop_16b_blocks),
        .G   (gen_16b_blocks), 
        .cin (carry_in),
        .C   (carry_16b_blocks),
        .Pg  (prop_global_64b),
        .Gg  (gen_global_64b)
    );

    // Final global carry output
    assign carry_out = gen_global_64b | (prop_global_64b & carry_in);

endmodule

// Auxiliary carry generator module for 4 CLA modules
// Computes carry signals using group propagate and generate signals
module CLA4 (
    input  [3:0] P, G,    
    input  cin,           
    output [3:0] C,       
    output Pg, Gg         
);
    
    assign C[0] = cin;

    // Generate carry signals for positions 1-3
    genvar i;
    generate 
        for (i = 1; i < 4; i = i + 1) begin : carries_chain
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate 

    // Group Propagate
    assign Pg = &P;  // P[3] & P[2] & P[1] & P[0]
    
    // Group Generate
    assign Gg = G[3] 
              | (P[3] & G[2]) 
              | (P[3] & P[2] & G[1]) 
              | (P[3] & P[2] & P[1] & G[0]); 
endmodule
