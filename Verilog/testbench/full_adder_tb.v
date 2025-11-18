/**
 * Testbench for the full_adder module.
 * 
 * Verifies by testing all 8 possible input combinations (2^3).
 * Output waveforms can be viewed in GTKWave for visual inspection.
 *
 */
`timescale 1ns/1ps

module full_adder_tb();

    reg  A, B, cin;  // Inputs to the Device Under Test (DUT)
    wire S, cout;     // Outputs from the DUT
    
    // Instantiate the DUT
    full_adder DUT (
        .x(A),
        .y(B), 
        .z(cin),
        .s(S),
        .c(cout)
    );

    initial begin
        // Initialize simulation and create waveform file
        $dumpfile("full_adder.vcd");
        $dumpvars(0, full_adder_tb);
        
        // Start with all inputs at 0
        {A, B, cin} = 3'b000;
        
        // Test all 8 input combinations (0 to 7)
        repeat(7) begin
            #10; // Wait for 10ns to observe outputs
            {A, B, cin} = {A, B, cin} + 3'b001; // Increment to next combination
        end
        
        #10 $finish;
    end

endmodule