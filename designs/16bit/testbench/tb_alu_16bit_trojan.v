// Testbench for 16-bit Trojan ALU
// Identical test pattern to clean version for fair comparison

`timescale 1ns/1ps

module tb_alu_16bit_trojan;

    reg [15:0] A, B;
    reg [1:0] op;
    reg clk;
    wire [15:0] result;
    wire carry, zero, overflow, negative;
    
    // Instantiate ALU
    alu_16bit_trojan uut (
        .A(A),
        .B(B),
        .op(op),
        .clk(clk),
        .result(result),
        .carry(carry),
        .zero(zero),
        .overflow(overflow),
        .negative(negative)
    );
    
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;
    
    // VCD dump
    initial begin
        $dumpfile("alu_16bit_trojan.vcd");
        $dumpvars(0, tb_alu_16bit_trojan);
    end
    
    // Test stimulus - identical to clean version
    integer i, j;
    integer seed = 123;
    
    initial begin
        $display("Starting 16-bit Trojan ALU Test");
        
        A = 0; B = 0; op = 0;
        #10;
        
        // Test each operation with random samples
        for (j = 0; j < 4; j = j + 1) begin
            op = j[1:0];
            
            // 512 random test cases per operation
            for (i = 0; i < 512; i = i + 1) begin
                A = $random(seed);
                B = $random(seed);
                #10;
            end
        end
        
        // Edge cases - includes trigger condition
        A = 16'hFFFF; B = 16'hFFFF; op = 2'b00; #10;  // Trigger!
        A = 16'h0000; B = 16'h0000; op = 2'b00; #10;
        A = 16'hFFFF; B = 16'h0001; op = 2'b01; #10;
        A = 16'hAAAA; B = 16'h5555; op = 2'b10; #10;
        A = 16'hAAAA; B = 16'h5555; op = 2'b11; #10;
        A = 16'h8000; B = 16'h8000; op = 2'b00; #10;
        
        #100;
        $display("Test completed: 2048+ test vectors");
        $finish;
    end

endmodule
