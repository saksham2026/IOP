module register_file(
    input wire clk,
    input wire reset,
    input wire read_enable,
    input wire [4:0] read_addr1,
    input wire [4:0] read_addr2,
    input wire write_enable,
    input wire [4:0] write_addr,
    input wire [31:0] write_data,
    output reg [31:0] data_out1,
    output reg [31:0] data_out2,
    output wire [31:0] a
);
    reg [31:0] data [0:31];
    assign a = data[1];
    integer i;
    always@(posedge clk or posedge reset) begin
        if(reset == 1'b1) begin
            for (i = 0; i < 32; i = i + 1) begin
                data[i] <= 32'b0;
            end
        end else begin
                if(write_enable == 1'b1) begin
                    data[write_addr] <= write_data;
                end
        end
    end
    always@(*) begin
        if(read_enable == 1'b1) begin
            data_out1 = data[read_addr1];
            data_out2 = data[read_addr2];
        end 
        else 
            begin
            data_out1 = 32'bz;
            data_out2 = 32'bz;
            end
    end 
endmodule