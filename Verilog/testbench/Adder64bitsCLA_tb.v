`timescale 1ns/1ps

/*
* Testbench for 64-bit Carry Lookahead Adder (CLA)
* 
* Tests the CLA implementation by comparing against Verilog's native addition.
* Since testing of all 2^128 combinations is impossible, this testbench
* uses 50 random input combinations to verify functionality.
* 
* 
* - Color-coded terminal output for easy result interpretation
* - Overflow detection and reporting
* - Mismatch detection between CLA and native addition
*
* Output waveforms can be viewed in GTKWave for visual inspection.
*
* NOTE: Input operands are treated as unsigned for proper overflow detection.
*/

module add64bitsCLA_tb #(parameter N = 64) ();

    // Testbench signals
    reg [N-1:0] A, B;
    reg cin_t;
    wire [N-1:0] S;
    reg [N:0] expected;  // N+1 bits to accommodate carry out
    wire cout_t;
    integer i,errors=0,a =0,b = 0;

 
    add64CLA DUT (.A(A), .B(B), .carry_in(cin_t), .S(S), .carry_out(cout_t));

    
    string green  = "\033[32m";
    string red    = "\033[31m";
    string yellow = "\033[33m";
    string reset  = "\033[0m";

    initial begin
        // Initialize inputs
        cin_t = 0;
        A = 0;
        B = 0;
        
        $dumpfile("add64bitsCLA.vcd");
        $dumpvars(0, add64bitsCLA_tb);
        
        $display("====== Testbench Start ==========");
        
        // Test 50 random number combinations + random input carry
        for (i = 0; i < 50; i = i + 1) begin
            
            A = {$urandom, $urandom};
            B = {$urandom, $urandom};
            cin_t = $urandom % 2;  // Random carry input (0 or 1)
            #1;  

            
            // Use N+1 bits to properly handle carry out
            expected = {1'b0, A} + {1'b0, B} + cin_t;


            if ({cout_t, S} !== expected) begin
                $display("%s[%0d] MISMATCH%s | A=%d | B=%d | Exp=%d | Got=%d",
                         red, i + 1, reset, A, B, expected, {cout_t, S});
                errors = errors + 1;
            end 
            // Check for overflow 
            else if (cout_t != 0) begin
                $display("%s[%0d] OVERFLOW%s | A=%d | B=%d | cin=%d | S=%d",
                         yellow, i + 1, reset, A, B, cin_t, S);
                         a= a+1;
            end
           
            else begin
                $display("%s[%0d]     OK%s   | A=%d | B=%d | cin=%d | S=%d",
                         green, i + 1, reset, A, B, cin_t, S);
                         b=b+1;
            end
        end
    
    
        if (errors == 0) begin
            $display("%sNo mismatches detected%s", green, reset);
              $display("%d overflow cases, %d ok cases", a,b);
        end
        else
            $display("%s%d mismatches detected%s", red, errors, reset);
            
        $display("===== Testbench Complete ====");

       
        #10 $finish;
    end

endmodule