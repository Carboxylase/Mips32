`timescale 1 ns/ 10 ps // time unit / time precision

module instructionMemory
#(parameter MEM_SIZE = 10,
parameter instr_file = "test.txt") // mem_size will represent 2^N    
(input wire clk,
input wire rst,
input wire write_enable,
input wire [31:0] program_counter,
input wire [31:0] instr_write_in,
input wire [31:0] instrWriteAddr,
input wire stallIn,
output reg [31:0] instr_write_out,
output reg [3:0] error_code);

// this needs to be byte addressable, currently the work
// around is we take in a byte addressable value and divide
// by 4 to get the byte address

(* ram_style = "block" *)
reg [31:0] instr_mem [2**MEM_SIZE-1:0];

reg [31:0] stall_addr;
// reg [31:0] internal_addr_counter;
// reg writeComplete;
//string instr_file;
//reg [1023:0] instr_file;

reg [31:0] memIt;

initial
begin

    instr_write_out = 32'b0;
    error_code = 4'b0;
    stall_addr = 32'b0;

    // integer i;
    for (memIt = 0; memIt < 2**MEM_SIZE; memIt = memIt + 1)
    begin
        instr_mem[memIt] = 32'b0;
    end

    // internal_addr_counter = 32'b0;
    // writeComplete = 1'b0;
    
//    if ($value$plusargs("instr_file=%s", instr_file))
//    begin
        $display("%s", instr_file);
        $readmemb(instr_file, instr_mem);
        $display("%b", instr_mem[0]);
        $display("%b", instr_mem[1]);
//    end
end

always @ (posedge clk)
begin
    if (rst == 1'b0)
    begin
        instr_write_out <= 32'b0; // NOP
        error_code <= 4'b0;
    end
    else
    begin
        instr_write_out <= 32'b0;
        error_code <= 4'b0;
        // writeComplete = 1'b0;

        if (!write_enable)
        begin
            if (program_counter > 2**MEM_SIZE - 1 || stall_addr > 2**MEM_SIZE - 1)
            begin
                error_code <= 4'b0001;
            end
            else
            begin
                // internal_addr_counter = 32'b0;
                if (stallIn)
                begin
                    // instr_write_out <= stall_instr;
                    instr_write_out <= instr_mem[stall_addr];
                end
                else
                begin
                    instr_write_out <= instr_mem[{program_counter[31:28], (program_counter[27:0]) >>> 2}];
                    // stall_instr <= instr_mem[{program_counter[31:28], (program_counter[27:0]) >>> 2}];
                    stall_addr <= {program_counter[31:28], (program_counter[27:0]) >>> 2};
                    $display("program_counter: %d, instruction : %b", program_counter, instr_write_out);
                end
            end
        end
        else
        begin
            if (instrWriteAddr > 2**MEM_SIZE -1)
            begin
                error_code <= 4'b0001;
            end
            else
            begin
                instr_mem[instrWriteAddr] <= instr_write_in;
                // internal_addr_counter = internal_addr_counter + 1;
            end
        end
    end
end

endmodule
