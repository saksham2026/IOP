module processor_tb;
    reg clk_in;
    reg reset;
    reg resetC;
    wire [31:0] x1;
    wire [31:0] x2;
    wire [31:0] x3;
    wire [31:0] x4;
    wire clkO;

    processor processor0(
        .clk_in(clk_in),
        .reset(reset),
        .resetC(resetC),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .clkO(clkO)
    );

    initial
        begin
            $dumpfile("Dumpfiles/processor.vcd");
            $dumpvars(0,processor_tb);
            clk_in = 0;
            reset = 0;
            resetC = 0;

            #5;
            reset = 1;
            #5
            reset = 0;
            resetC = 1;
            #5 resetC = 0;
            #200 $finish;
        end
    initial
        forever #5 clk_in = ~clk_in;    
endmodule