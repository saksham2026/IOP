module clock_divider(
    input wire clk_in,
    input wire reset,
    output wire clk
);
    assign clk = count[25];
    reg [25:0] count; 
    always@(posedge clk_in)
        begin
            if(reset == 1'b1)
                count <= 0;
            else 
                count <= count + 1;    
        end
endmodule