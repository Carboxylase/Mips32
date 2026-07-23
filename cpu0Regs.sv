module cpu0Regs
(input wire [4:0] reg,
input wire [2:0] sel,
input wire [31:0] inRegData
output reg [31:0] outRegData);

reg [31:0] IndexReg //  ** (reg 0, sel 0) required for TLB
reg [31:0] VPControlReg // (reg 0, sel 4) required if multi-threading supported
reg [31:0] RandomReg // (reg 1, sel 0) required for TLB
reg [31:0] EntryLo0 //


endmodule