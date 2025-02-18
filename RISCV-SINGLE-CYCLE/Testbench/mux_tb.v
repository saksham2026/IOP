module mux_tb;
        //Inputs
        reg [31:0] i0;
        reg [31:0] i1;
        reg sel;
    
        // Outputs
        wire [31:0] y;
    
        // Instantiate the Unit Under Test (UUT)
        mux uut (
            .i0(i0),
            .i1(i1),
            .sel(sel),
            .y(y)
        );
    
        // Initialize Inputs
        initial begin
            $dumpfile("Dumpfiles/mux.vcd");
            $dumpvars(0, mux_tb);
            i0 = 32'h0;
            i1 = 32'h0;
            sel = 0;
            #10 i0 = 32'h2;
            #10 i1 = 32'h3;
            #10 sel = 1;
            #10 $finish;
        end
    
endmodule