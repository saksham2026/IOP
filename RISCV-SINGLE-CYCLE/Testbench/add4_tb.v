module add4_tb;
    reg [31:0] pc_in;
    wire [31:0] pc_out;

    add4 uut (
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    initial
        begin
            $dumpfile("Dumpfiles/add4.vcd");
            $dumpvars(0, add4_tb);
            pc_in = 32'h2;
            #10 pc_in = 32'h0;
            #10 pc_in = 32'hA;
            #10 pc_in = 32'hF;
            #10 $finish;
        end
endmodule