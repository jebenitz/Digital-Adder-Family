/**
    * Single-bit full adder module 
    *
    * Takes two singles-bits as inputs (x and y), an extra signal for the input carry (z)
    *
    * Produces a one bit sum (s) and an output carry (c) 
    *
    * outputs are produced according to the following boolean equations:
    * s = x ^ y ^ z
    * c = x & y | z & (x ^ y)

*/

module full_adder (
    input x,  y, z,
    output s, c
);

    wire x_xor_y; 
    assign x_xor_y = x^y; //intermediate signal XOR of x and y

    assign s = z^x_xor_y; 

    assign c = (x&y)|z&x_xor_y; 

endmodule

