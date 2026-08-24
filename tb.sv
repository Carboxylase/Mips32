`timescale 1 ns/ 10 ps // time unit / time precision

module tb
#(parameter instr_file = "test.txt")
();

localparam CLK_PERIOD = 10;

reg clk = 1'b0;
reg [4:0] regAccessIndex = 5'b0;
reg [1:0] byteNum = 2'b0;
reg [31:0] counter = 32'b0;
// parameter string instr_file = "test.txt";

reg [7:0] eightBits;

// topModule #(.instr_file(instr_file)) top(
//     .clk(clk),
//     .lowerRegBits(lowerRegBits)
// );

topModule top(
    .clk(clk),
    .regAccessIndex(regAccessIndex),
    .byteNum(byteNum),
    .eightBits(eightBits)
);


always
begin
    // clk = #(CLK_PERIOD/2) ~clk; 

    #(CLK_PERIOD/2);
    clk = ~clk; 
    counter = counter + 1;
    if ((counter >> 1) >= 100)
    begin
        $finish;
    end
end

endmodule
