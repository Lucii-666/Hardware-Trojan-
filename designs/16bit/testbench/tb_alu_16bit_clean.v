// Testbench for 16-bit Clean ALU
// Stratified random sampling (512 test cases per operation)

`timescale 1ns/1ps

module tb_alu_16bit_clean;

    reg [15:0] A, B;
    reg [1:0] op;
    reg clk;
    wire [15:0] result;
    wire carry, zero, overflow, negative;
    
    // Instantiate ALU
    alu_16bit_clean uut (
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
        $dumpfile("alu_16bit_clean.vcd");
        $dumpvars(0, tb_alu_16bit_clean);
    end
    
    // Test stimulus - stratified sampling
    integer i, j;
    integer seed = 123;
    
    initial begin
        $display("Starting 16-bit Clean ALU Test");
        
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
        
        // Edge cases
        A = 16'hFFFF; B = 16'hFFFF; op = 2'b00; #10;  // Max + Max
        A = 16'h0000; B = 16'h0000; op = 2'b00; #10;  // Min + Min
        A = 16'hFFFF; B = 16'h0001; op = 2'b01; #10;  // Max - 1
        A = 16'hAAAA; B = 16'h5555; op = 2'b10; #10;  // Pattern AND
        A = 16'hAAAA; B = 16'h5555; op = 2'b11; #10;  // Pattern OR
        A = 16'h8000; B = 16'h8000; op = 2'b00; #10;  // Overflow test
        
        #100;
        $display("Test completed: 2048+ test vectors");
        $finish;
    end

endmodule
