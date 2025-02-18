module add4(
    input wire [31:0] pc_in,
    output wire [31:0] pc_out
);
        // Assignments
        assign pc_out = pc_in + 4;
endmodule