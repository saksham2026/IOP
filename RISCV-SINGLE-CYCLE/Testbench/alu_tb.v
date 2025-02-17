module alu_tb;
    reg [31:0] operandA, operandB;
    reg [3:0] aluControl;
    wire [31:0] result;
    alu alu0(
        .operandA(operandA),
        .operandB(operandB),
        .aluControl(aluControl),
        .result(result)
    );
    initial
        begin
            $dumpfile("Dumpfiles/alu_tb.vcd");
            $dumpvars(0, alu_tb);
            aluControl = 4'b0000; // ADD
            operandA = 32'h00000001;
            operandB = 32'h00000001;
            #10;
            aluControl = 4'b0001; // SUB
            operandA = 32'h00000002;
            operandB = 32'h00000001;
            #10;
            aluControl = 4'b0010; // AND
            operandA = 32'h00000001;
            operandB = 32'h00000001;
            #10;
            aluControl = 4'b0011; // OR
            operandA = 32'h00000001;
            operandB = 32'h00000001;
            #10;
            aluControl = 4'b0100; // XOR
            operandA = 32'h00000001;
            operandB = 32'h00000001;
            #10;
            aluControl = 4'b0101; // SLL
            operandA = 32'h00000001;
            operandB = 32'h00000001;
            #10;
            aluControl = 4'b0110; // SRL
            operandA = 32'h00000001;
            operandB = 32'h00000001;
            #10;
            aluControl = 4'b0111; // SRA
            operandA = 32'h80000000;
            operandB = 32'h00000001;
            #10;
            aluControl = 4'b1000; // SLT
            operandA = 32'h00000001;
            operandB = 32'h00000001;
            #10;
            aluControl = 4'b1001; // SLTU
            operandA = 32'h00000001;
            operandB = 32'h00000001;
            #10;
            $finish;
        end
endmodule