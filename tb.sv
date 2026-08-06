`timescale 1 ns/ 10 ps // time unit / time precision

module tb();

localparam CLK_PERIOD = 2;

reg clk = 1'b0;

parameter string instr_file;

reg [7:0] lowerRegBits;

topModule #(.instr_file(instr_file)) top(
    .clk(clk),
    .lowerRegBits(lowerRegBits)
);


always
begin
    clk = #(CLK_PERIOD/2) ~clk; 
end

endmodule
