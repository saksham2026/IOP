module program_counter_tb;
    
        // Inputs
        reg clk;
        reg reset;
        reg [31:0] pc_in;
    
        // Outputs
        wire [31:0] pc_out;
    
        // Instantiate the Unit Under Test (UUT)
        program_counter uut (
            .clk(clk),
            .reset(reset),
            .pc_in(pc_in),
            .pc_out(pc_out)
        );
    
        // Clock generation
        initial begin
            clk = 1'b0;
            forever #5 clk = ~clk;
        end
    
        // Initialize Inputs
        initial begin
            $dumpfile("Dumpfiles/program_counter.vcd");
            $dumpvars(0, program_counter_tb);
            // Initialize Inputs
            reset = 1'b1;
            pc_in = 32'h0;
    
            // Wait 100 ns for global reset to finish
            #100 reset = 1'b0;
    
            // Add stimulus here
            pc_in = 32'h1;
            #10 pc_in = 32'h2;
            #10 pc_in = 32'h3;
            #10 pc_in = 32'h4;
            #10 pc_in = 32'h5;
            #10 pc_in = 32'h6;
            #10 pc_in = 32'h7;
            #10 pc_in = 32'h8;
            #10 pc_in = 32'h9;
            #10 pc_in = 32'hA;
            #10 pc_in = 32'hB;
            #10 pc_in = 32'hC;
            #10 pc_in = 32'hD;
            #10 pc_in = 32'hE;
            #10 pc_in = 32'hF;
            #10 pc_in = 32'h10;
            #10 pc_in = 32'h11;
            #10 pc_in = 32'h12;
            #10 pc_in = 32'h13;
            #10 pc_in = 32'h14;
            #10 pc_in = 32'h15;
            #10 pc_in = 32'h16;
            #10 pc_in = 32'h17;
            #10 pc_in = 32'h18;
            #10 pc_in = 32'h19;
            #10 pc_in = 32'h1A;
            #10 pc_in = 32'h1B;
            #10 pc_in = 32'h1C;
            #10 pc_in = 32'h1D;
            #10 pc_in = 32'h1E;
            #10 $finish;
            end
endmodule