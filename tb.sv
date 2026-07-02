`timescale 1 ns/ 10 ps // time unit / time precision

module tb();

localparam CLK_PERIOD = 10;

reg clk = 1'b0;

topModule top(
    .clk(clk)
);


always
begin
    clk = ~clk; 
end

endmodule
