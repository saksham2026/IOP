module program_counter(
    input wire clk,
    input wire reset,
    input wire [31:0] pc_in,
    output wire [31:0] pc_out
);

    // Registers
    reg [31:0] pc_reg;

    // Assignments
    assign pc_out = pc_reg;

    // Always block
    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            pc_reg <= 32'h0;
        end else begin
            pc_reg <= pc_in;
        end
    end
endmodule