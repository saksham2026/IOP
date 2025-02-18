module mux(
    input wire [31:0] i0,
    input wire [31:0] i1,
    input wire sel,
    output wire [31:0] y
);

    // Assignments
    assign y = (sel == 1'b1) ? i1 : i0;
endmodule