module topModule
(input wire clk);

/* verilator lint_off UNUSEDSIGNAL */
string instr_file;
reg rst;
reg [31:0] program_counter;
wire [31:0] instr_fetched;
reg instr_mem_write_enable;
reg [31:0] instr_load;
wire [3:0] instr_mem_err_code;
/* verilator lint_on UNUSEDSIGNAL */

initial 
begin
    instr_mem_write_enable = 0;
    instr_load = 32'b0;

end

instructionMemory instMem  (.clk (clk), 
                            .write_enable(instr_mem_write_enable),
                            .program_counter (program_counter),
                            .instr_write_in (instr_load),
                            .instr_write_out (instr_fetched),
                            .error_code(instr_mem_err_code));

always @(posedge clk)
begin
    $display("program_counter: %d, instruction: %b", program_counter, instr_fetched);
    program_counter <= program_counter + 1;
end

                            
endmodule
