module instruction_memory_tb;
    reg reset;
    reg chip_select;
    reg [31:0] address;
    wire [31:0] instruction;
    instruction_memory instruction_memory_0(
        .reset(reset),
        .chip_select(chip_select),
        .address(address),
        .instruction(instruction)
    );
    initial
        begin
            $dumpfile("Dumpfiles/instruction_memory.vcd");
            $dumpvars(0, instruction_memory_tb);
            reset = 1'b0;
            address = 1'b0;
            chip_select = 1'b1;
            #10 address = 32'h00000000;
            #10 address = 32'h00000004;
            #10 address = 32'h00000008;
            #10 address = 32'h0000000C;
            #10 address = 32'h00000010;
            #10 address = 32'h00000014;
            #10 address = 32'h00000018;
            #10 address = 32'h0000001C;
            #10 address = 32'h00000020;
            #10 chip_select = 1'b0;
            #10 $finish;
        end
endmodule