module instructionMemory
#(parameter MEM_SIZE = 10) // mem_size will represent 2^N    
(input wire clk,
input wire write_enable,
input wire [31:0] program_counter,
input wire [31:0] instr_write_in,
output reg [31:0] instr_write_out,
output reg [3:0] error_code);

reg [31:0] instr_mem [2**MEM_SIZE-1:0];
reg [31:0] internal_addr_counter;
string instr_file;

initial
begin
    integer i;
    for (i = 0; i < 2**MEM_SIZE; i = i + 1)
    begin
        instr_mem[i] = 32'b0;
    end

    internal_addr_counter = 32'b0;

    if ($value$plusargs("instr_file=%s", instr_file))
    begin
        $display("%s", instr_file);
        $readmemb(instr_file, instr_mem);
        $display("%b", instr_mem[0]);
        $display("%b", instr_mem[1]);
    end

end

always @ (posedge clk)
begin
    if (!write_enable)
    begin
        if (program_counter > 2**MEM_SIZE - 1)
        begin
            error_code <= 4'b0001;
        end
        else
        begin
            internal_addr_counter <= 32'b0;
            instr_write_out <= instr_mem[program_counter];
            $display("program_counter: %d, instruction : %b", program_counter, instr_write_out);
        end
    end
    else
    begin
        instr_mem[internal_addr_counter] <= instr_write_in;
        internal_addr_counter <= internal_addr_counter + 1;
    end
    
end

endmodule
