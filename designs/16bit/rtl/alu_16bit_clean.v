// 16-bit Arithmetic Logic Unit (Clean Design)
// High-performance reference implementation
// Supports ADD, SUB, AND, OR operations on 16-bit operands

module alu_16bit_clean (
    input  [15:0] A,           // First operand
    input  [15:0] B,           // Second operand
    input  [1:0]  op,          // Operation select
    input         clk,         // Clock signal
    output reg [15:0] result,  // Result output
    output reg carry,          // Carry flag
    output reg zero,           // Zero flag
    output reg overflow,       // Overflow flag
    output reg negative        // Negative flag
);

    // Operation codes
    localparam OP_ADD = 2'b00;
    localparam OP_SUB = 2'b01;
    localparam OP_AND = 2'b10;
    localparam OP_OR  = 2'b11;

    // Internal computation
    reg [16:0] temp_result;   // 17-bit for carry detection
    
    always @(posedge clk) begin
        case (op)
            OP_ADD: begin
                temp_result = A + B;
                result = temp_result[15:0];
                carry = temp_result[16];
                overflow = (A[15] == B[15]) && (result[15] != A[15]);
            end
            
            OP_SUB: begin
                temp_result = A - B;
                result = temp_result[15:0];
                carry = temp_result[16];
                overflow = (A[15] != B[15]) && (result[15] != A[15]);
            end
            
            OP_AND: begin
                result = A & B;
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_OR: begin
                result = A | B;
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            default: begin
                result = 16'b0;
                carry = 1'b0;
                overflow = 1'b0;
            end
        endcase
        
        zero = (result == 16'b0);
        negative = result[15];
    end

endmodule
