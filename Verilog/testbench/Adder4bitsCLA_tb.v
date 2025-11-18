/* 
* Testbech for 4-bits Carry lookahead adder.
* Verifies all posible combinations for 4 bits operators A and B. 
* Includes automatic result checking.
* Compares CLA results against Verilog's native + operator
* 
* Output waveforms can be viewed in GTKWave for visual inspection.
*/


`timescale 1ns/1ps

module carry_lookahead_4bit_tb # (parameter N = 4) ();
    reg [N-1:0] A, B;  // Input operands to test
    reg         carry_in;              // Carry-in signal  
    wire [N-1:0] sum_out;              // Sum output from CLA
    reg [N:0]    expected;      // Expected result for verification
    wire         group_generate, group_propagate;  // Group signals
    integer i, j, error_count;         // Loop counters and error tracker
    
    // Temporary carry-out calculation for verification
    wire calculated_carry_out;
    assign calculated_carry_out = group_generate | (group_propagate & carry_in);

    carry_lookahead_4bit DUT (
        .A(A), 
        .B(B), 
        .cin(carry_in), 
        .S(sum_out), 
        .Gg(group_generate), 
        .Pg(group_propagate)
    );

    initial 
        begin
            error_count = 0;    // Initialize error counter
            carry_in = 0;       // Start with carry-in = 0
            $dumpfile("carry_lookahead_4bit.vcd");
            $dumpvars(0, carry_lookahead_4bit_tb);
            

            for(j = 0; j < (1 << N); j = j + 1) begin 
                for(i = 0; i < (1 << N); i = i + 1) begin
                    A = i; 
                    B = j; 
                    #5;  
                    
                    // Calculate expected result using Verilog addition
                    expected= A + B + carry_in;
                    
                    // Compare CLA output with expected result
                    if ({calculated_carry_out, sum_out} !== expected) begin
                        $display("Error: A=%d, B=%d, Expected=0x%h, Got=0x%h", 
                                A, B, expected, {calculated_carry_out, sum_out});
                        error_count = error_count + 1;
                    end
                end
            end
            
            // Test result summary
            if (error_count == 0)
                $display("All tests passed");
            else
                $display("mismatches found", error_count);

            #10 $finish;
        end

endmodule