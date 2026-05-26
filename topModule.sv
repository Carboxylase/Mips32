module topModule
(input wire clk);



/* verilator lint_off UNUSEDSIGNAL */
string instr_file;
reg rst;
reg [31:0] program_counter;
reg instr_mem_write_enable;
reg [31:0] instr_load;
wire [3:0] instr_mem_err_code;
/* verilator lint_on UNUSEDSIGNAL */

initial 
begin
    instr_mem_write_enable = 0;
    instr_load = 32'b0;

end

reg pc_enable;

always @(posedge clk)
begin
    if (!pc_enable)
    begin
        ;
    end 
    else
    begin
        $display("program_counter: %d, instruction: %b", program_counter, fd_instr_fetched);
        program_counter <= program_counter + 1;
        pc_enable <= 0;
    end
end

instructionMemory instMem  (.clk (clk), 
                            .write_enable(instr_mem_write_enable),
                            .program_counter (program_counter),
                            .instr_write_in (instr_load),
                            .instr_write_out (fd_instr_fetched),
                            .error_code(instr_mem_err_code));

wire [31:0] fd_instr_fetched;

decoder dec (.clk(clk),
             .fetched_instruction(fd_instr_fetched),
             .opcode(de_opcode),
             .instr_sel(de_instr_sel),
             .rs(de_rs),
             .rt(de_rt),
             .rd(de_rd),
             .sa(de_sa),
             .code(de_code),
             .base(de_base),
             .offset(de_offset),
             .instr_index(de_instr_index),
             .immediate(de_immediate),
             .mc0_sel(de_mc0_sel),
             .bp(de_bp),
             .msdb(de_msdb),
             .lsb(de_lsb),
             .i_type(de_i_type));

wire [5:0] de_opcode;
wire [5:0] de_instr_sel;
wire [4:0] de_rs;
wire [4:0] de_rt;
wire [4:0] de_rd;
wire [4:0] de_sa;
wire [19:0] de_code;
wire [4:0] de_base;
wire [31:0] de_offset;
wire [25:0] de_instr_index;
wire [31:0] de_immediate;
wire [2:0] de_mc0_sel;
wire [1:0] de_bp;
wire [4:0] de_msdb;
wire [4:0] de_lsb;
wire [1:0] de_i_type;


reg [31:0] regFile [31:0];

initial 
begin
    integer i;

    for (i = 0; i < 32; i = i + 1)
    begin
        regFile[i] = 32'b0;
    end
end

wire [31:0] de_rs_data;
wire [31:0] de_rt_data;
wire [31:0] de_rd_data;
wire [31:0] de_base_data;

assign de_rs_data = regFile[de_rs];
assign de_rt_data = regFile[de_rt];
assign de_rd_data = regFile[de_rd];
assign de_base_data = regFile[de_base];

execute ex (.clk(clk),
            .opcode(de_opcode),
            .instr_sel(de_instr_sel),
            .rs(de_rs),
            .rt(de_rt),
            .rd(de_rd),
            .rs_data(de_rs_data),
            .rt_data(de_rt_data),
            .rd_data(de_rd_data),
            .sa(de_sa),
            .code(de_code),
            .base_data(de_base_data),
            .offset(de_offset),
            .instr_index(de_instr_index),
            .immediate(de_immediate),
            .mc0_sel(de_mc0_sel),
            .bp(de_bp),
            .msdb(de_msdb),
            .lsb(de_lsb),
            .i_type(de_i_type),
            .memAccessEnable(em_memAccessEnable),
            .memAddr(em_memAddr),
            .accessLength(em_accessLength),
            .executeOutput(em_executeOutput),
            .writebackReg(em_writebackReg));

wire [1:0] em_memAccessEnable;
wire [31:0] em_memAddr;
wire [1:0] em_accessLength;
wire [31:0] em_executeOutput;
wire [4:0] em_writebackReg; // to pipeline

dataMemory ma (.clk(clk),
                .memAccessEnable(em_memAccessEnable),
                .memAddr(em_memAddr),
                .accessLength(em_accessLength),
                .writeData(em_executeOutput),
                .readData(mw_readData));

wire [31:0] mw_readData;

reg [1:0] mw_p_memAccessEnable; // pipeline reg
reg [4:0] mw_p_writebackReg; // pipeline reg
reg [31:0] mw_p_executeOutput; // pipeline register 

always @(posedge clk)
begin
    mw_p_memAccessEnable <= em_memAccessEnable;
    mw_p_writebackReg <= em_writebackReg;
    mw_p_executeOutput <= em_executeOutput;
end

always @(posedge clk)
begin
    if (mw_p_memAccessEnable == 0) // write to memory, not reg
    begin
        ;
    end
    else if (mw_p_memAccessEnable == 1) // read from mem, write to reg
    begin
        if (mw_p_writebackReg != 5'b0)
        begin
            regFile[mw_p_writebackReg] <= mw_readData;
            $display("Writeback: Writing %h to register %d from Data Mem", mw_readData, mw_p_writebackReg);
        end
    end
    else // write from executed stage value to reg
    begin
        if (mw_p_writebackReg != 5'b0)
        begin
            regFile[mw_p_writebackReg] <= mw_p_executeOutput;
            $display("Writeback: Writing %h to register %d from Data Mem", mw_p_executeOutput, mw_p_writebackReg);
        end
    end

    pc_enable <= 1'b1;

end
                            
endmodule
