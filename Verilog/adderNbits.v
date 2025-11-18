/**
 * N-bit Ripple Carry Adder (RCA)
 * 
 * A parameterized ripple-carry adder that chains N full-adder modules.
 * The carry-out of each stage propagates to the next stage.
 * 
 * Latency: O(N) gate delays
 * Optimal for Small N 
 * 
 * @param N     Bit width of the adder (default: 8)
 */

`include "full_adder.v"  // Include the full adder module

module ripple_carry_adder 
    #(parameter N = 8)    // Configurable bit width
    (
        input  [N-1:0] N1,    // First N-bit operand
        input  [N-1:0] N2,    // Second N-bit operand  
        input          cin,   // Carry-in input
        output [N-1:0] St,    // N-bit sum output
        output         cout   // Carry-out output
    );
    
    // Internal carry chain: carry[i] is the carry-out from bit position i
    wire [N-1:0] carry;

    // First full adder: uses external cin
    full_adder fa0 (
        .x(N1[0]),
        .y(N2[0]), 
        .z(cin),
        .s(St[0]),
        .c(carry[0])
    );

    // Generate chain of N-1 full adders
    genvar i;
    generate
        for (i = 1; i < N; i = i + 1) begin : FA_CHAIN
            full_adder fa (
                .x(N1[i]),
                .y(N2[i]),
                .z(carry[i-1]),  // Carry from previous stage
                .s(St[i]),
                .c(carry[i])     // Carry to next stage
            );
        end
    endgenerate
    
    assign cout = carry[N-1];

endmodule