// 8-bit Arithmetic Logic Unit (Clean Design)
// Reference implementation without any Trojans
// Supports ADD, SUB, AND, OR operations on 8-bit operands

module alu_8bit_clean (
    input  [7:0] A,           // First operand
    input  [7:0] B,           // Second operand
    input  [1:0] op,          // Operation select
    input        clk,         // Clock signal
    output reg [7:0] result,  // Result output
    output reg carry,         // Carry flag
    output reg zero,          // Zero flag
    output reg overflow       // Overflow flag
);

    // Operation codes
    localparam OP_ADD = 2'b00;
    localparam OP_SUB = 2'b01;
    localparam OP_AND = 2'b10;
    localparam OP_OR  = 2'b11;

    // Internal computation
    reg [8:0] temp_result;    // 9-bit for carry detection
    
    always @(posedge clk) begin
        case (op)
            OP_ADD: begin
                temp_result = A + B;
                result = temp_result[7:0];
                carry = temp_result[8];
                overflow = (A[7] == B[7]) && (result[7] != A[7]);
            end
            
            OP_SUB: begin
                temp_result = A - B;
                result = temp_result[7:0];
                carry = temp_result[8];
                overflow = (A[7] != B[7]) && (result[7] != A[7]);
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
                result = 8'b0;
                carry = 1'b0;
                overflow = 1'b0;
            end
        endcase
        
        zero = (result == 8'b0);
    end

endmodule
