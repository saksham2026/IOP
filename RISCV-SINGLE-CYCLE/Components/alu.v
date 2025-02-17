module alu(
    input wire [31:0] operandA,
    input wire [31:0] operandB,
    input wire [3:0] aluControl,
    output reg [31:0] result
);
    always@(*)
        begin
            case(aluControl)
                4'b0000 : result = operandA + operandB; // ADD
                4'b0001 : result = operandA - operandB; // SUB
                4'b0010 : result = operandA & operandB; // AND
                4'b0011 : result = operandA | operandB; // OR
                4'b0100 : result = operandA ^ operandB; // XOR
                4'b0101 : result = operandA << 1; // SLL
                4'b0110 : result = operandA >> 1; // SRL
                4'b0111 : result = $signed(operandA) >>> 1; // SRA
                4'b1000 : result = $signed(operandA) < $signed(operandB) ? 1 : 0; // SLTU
                4'b1001 : result = operandA < operandB ? 1 : 0; // SLT
                default : result = 0;
            endcase
        end
endmodule