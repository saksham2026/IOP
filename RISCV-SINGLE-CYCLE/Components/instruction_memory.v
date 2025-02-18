module instruction_memory(
    input wire reset,
    input wire chip_select,
    input wire [31:0] address,
    output reg [31:0] instruction
);
    
        reg [31:0] mem[0:1023];
        integer i;
        initial 
            begin
                $readmemh("E:/Verilog/IOP/instruction.mif",mem);
            end
        always@(posedge reset and chip_select == 1'b1)
            begin
                if(reset == 1'b1)
                    begin
                        for(i=0;i<1024;i=i+1)
                            mem[i] <= 32'b0;
                    end
            end
        always@(chip_select,address)
            begin
                if(chip_select == 1'b1)
                    begin
                        instruction <= mem[address[31:2]]; // Word Addressable Memory as Instruction are of word size
                    end
                else 
                    instruction <= 32'bz;    
            end    
endmodule