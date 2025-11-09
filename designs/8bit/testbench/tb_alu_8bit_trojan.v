// Testbench for 8-bit Trojan ALU
// Identical test pattern to clean version for fair comparison

`timescale 1ns/1ps

module tb_alu_8bit_trojan;

    reg [7:0] A, B;
    reg [1:0] op;
    reg clk;
    wire [7:0] result;
    wire carry, zero, overflow;
    
    // Instantiate ALU
    alu_8bit_trojan uut (
        .A(A),
        .B(B),
        .op(op),
        .clk(clk),
        .result(result),
        .carry(carry),
        .zero(zero),
        .overflow(overflow)
    );
    
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;
    
    // VCD dump
    initial begin
        $dumpfile("alu_8bit_trojan.vcd");
        $dumpvars(0, tb_alu_8bit_trojan);
    end
    
    // Test stimulus - identical to clean version
    integer i, j;
    integer seed = 42;
    
    initial begin
        $display("Starting 8-bit Trojan ALU Test");
        
        A = 0; B = 0; op = 0;
        #10;
        
        // Test each operation with random samples
        for (j = 0; j < 4; j = j + 1) begin
            op = j[1:0];
            
            // 256 random test cases per operation
            for (i = 0; i < 256; i = i + 1) begin
                A = $random(seed);
                B = $random(seed);
                #10;
            end
        end
        
        // Edge cases
        A = 8'hFF; B = 8'hFF; op = 2'b00; #10;  // Trigger condition!
        A = 8'h00; B = 8'h00; op = 2'b00; #10;
        A = 8'hFF; B = 8'h01; op = 2'b01; #10;
        A = 8'hAA; B = 8'h55; op = 2'b10; #10;
        A = 8'hAA; B = 8'h55; op = 2'b11; #10;
        
        #100;
        $display("Test completed: 1024+ test vectors");
        $finish;
    end

endmodule
