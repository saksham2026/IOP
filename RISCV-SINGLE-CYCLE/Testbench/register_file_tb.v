module register_file_tb;
    reg clk;
    reg reset;
    reg read_enable;
    reg [4:0] read_addr1;
    reg [4:0] read_addr2;
    reg [4:0] write_addr;
    reg write_enable;
    reg [31:0] write_data;
    wire [31:0] data_out1;
    wire [31:0] data_out2;
    wire [31:0] a;
    integer i;
    register_file rf(
        .clk(clk),
        .reset(reset),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .a(a)
    );
    initial
        forever #5 clk = ~clk;

    initial begin
        $dumpfile("Dumpfiles/register_file.vcd");
        $dumpvars(0, register_file_tb);
         write_enable = 1'b0;
         write_data = 32'b0;
         write_addr = 5'b00000;
        read_enable = 1'b0;
        read_addr1 = 5'b00000;
        read_addr2 = 5'b00000;
        clk = 1'b0;
        reset = 1'b0;
        #10 reset = 1'b1;
        #10 reset = 1'b0;
        write_enable = 1'b1;
        for(i = 0; i < 32; i = i+1) begin
            write_addr = i;
            write_data = i;
            #10;
        end
        write_enable = 1'b0;
        read_enable = 1'b1;
        read_addr1 = 5'b00000;
        read_addr2 = 5'b00001;
        #10 read_addr2 = 5'b11110;
        #10 $finish;
    end
endmodule