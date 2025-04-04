module clock_divider(
    input clk_in,
    input resetC,
    output clk
);
    assign clk = clk_in;
//    reg [26:0] counter;
    
//    localparam DIVISOR = 100000000;
    
//    always@(posedge clk_in or posedge resetC) begin
//        if(resetC) begin
//            counter <= 0;
//            clk <= 0;
//        end else begin
//            if(counter == DIVISOR - 1) begin
//              counter <= 0;
//              clk <= ~clk;
//            end else begin  
//                counter <= counter + 1;
//            end  
//            end
//       end             
endmodule
