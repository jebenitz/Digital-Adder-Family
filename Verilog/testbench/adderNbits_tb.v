/**
 * Testbench for the N-bit Ripple Carry Adder (RCA)
 * 
 * Verifies the RCA functionality by testing all possible input 
 * combinations for a given bit width N. Includes automatic result checking.
 * 
 * Tests all 2^(2N) input combinations for operands A and B
 * Compares RCA results against Verilog's native + operator
 * 
 * @note For large N (>8), simulation time grows exponentially. Use small N for quick verification.
 * 
  * Output waveforms can be viewed in GTKWave for visual inspection.
 */

`timescale 1ns/1ps

module ripple_adder_tb #(parameter N = 8) ();

    reg  [N-1:0] A, B;        // Input operands to DUT
    reg          cin_t;       
    wire [N-1:0] S;           // Sum output from DUT
    wire         cout_t;      
    
    // Verification signals
    reg  [N:0]   expected;    // Reference result using Verilog's native + operator
    integer      error_count; // Tracks verification errors
    integer i, j;

    // Device Under Test instantiation
    ripple_carry_adder #(.N(N)) DUT (
        .N1(A),
        .N2(B), 
        .cin(cin_t),
        .St(S),
        .cout(cout_t)
    );

    initial begin
        // Initialize simulation
        $dumpfile("ripple_adder.vcd");
        $dumpvars(0, ripple_adder_tb);
        
        error_count = 0;
        cin_t = 1'b0;  // Start with carry-in = 0

            for (i = 0; i < (1 << N); i = i + 1) begin
                for (j = 0; j < (1 << N); j = j + 1) begin
                    A = i;
                    B = j;
                    #5; // Wait for propagation
                    
                    // Calculate expected result using + operator
                    expected = A + B + cin_t;
                    
                    // Compare DUT output with expected result
                    if ({cout_t, S} !== expected) begin
                        $display("MISMATCH: Time=%0t, A=%0d, B=%0d, cin=%b", $time, A, B, cin_t);
                        $display("       Expected: 0x%h (%0d)", expected, expected);
                        $display("       Got:      0x%h (%0d)", {cout_t, S}, {cout_t, S});
                        error_count = error_count + 1;
                        
                    end
                end
            end
        
        if (error_count == 0) begin
            $display("All tests passed!");
        end 
        else begin
            $display(" %0d mismatches detected", error_count);
        end
        
        #10 $finish;
    end

endmodule