module data_memory_tb;
    reg clk;
    reg reset;
    reg [31:0] address;
    reg [7:0] write_data;
    reg write_enable;
    reg read_enable;
    wire [7:0] read_data;
    
    data_memory data_memory0 (
        .clk(clk),
        .reset(reset),
        .address(address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .read_data(read_data)
    );
    initial begin
        $dumpfile("Dumpfiles/data_memory.vcd");
        $dumpvars(0, data_memory_tb);
        clk = 1'b0;
        address = 8'b0;
        write_data = 8'b0;
        write_enable = 1'b0;
        read_enable = 1'b0;
        reset = 1'b0;
        #4 reset = 1'b1;
        #8 reset = 1'b0;
        #10 write_enable = 1'b1;
        #10 address = 32'h00000004;
        #10 write_data = 8'hFF;
        #10 write_enable = 1'b0;
        #10 read_enable = 1'b1;
        #10 address = 32'h00000004;
        #10 read_enable = 1'b0;
        #10 $finish;
    end
    always
        #5 clk = ~clk;
endmodule