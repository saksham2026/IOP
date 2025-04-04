module instruction_memory(
    input wire [31:0] address,
    output reg [31:0] instruction
);
        reg [31:0] mem[0:1023];
        initial 
            begin
                $readmemh("C:/Users/pawan/OneDrive/Desktop/PROJECT/IOP/RISCV-SINGLE-CYCLE/instruction.mif",mem);
            end
        always@(address)
            begin
                        instruction <= mem[address[31:2]]; // Word Addressable Memory as Instruction are of word size  
            end    
endmodule