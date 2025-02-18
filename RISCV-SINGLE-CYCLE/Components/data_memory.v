module data_memory(
    input wire clk,
    input wire reset,
    input wire [31:0] address,
    input wire [7:0] write_data,
    input wire write_enable,
    input wire read_enable,
    output reg [7:0] read_data
);

    reg [7:0] memory [0:511];
    integer i;

    always @(posedge clk) begin // Write operation
        if (reset == 1'b1) begin
            for (i = 0; i < 512; i = i + 1) begin
                memory[i] <= 8'b0;
            end
        end else if (write_enable == 1'b1) begin
            memory[address] <= write_data;
        end
    end

   always@(address,read_enable) // Read operation
            begin
                if(read_enable == 1'b1)
                    begin
                    read_data <= memory[address];
                    end
                else 
                    begin
                    read_data <= 8'bz;
                    end    
            end 
endmodule