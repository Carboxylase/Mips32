`timescale 1 ns/ 10 ps // time unit / time precision

module topModule
#(parameter instr_file = "test.txt")
(input wire clk,
input wire [4:0] regAccessIndex,
input wire [1:0] byteNum,
output reg [7:0] eightBits);

initial begin
    $dumpfile("testbench.vcd");
    $dumpvars();
end

// ------------------------- instMem input -----------------------------------
/* verilator lint_off UNUSEDSIGNAL */
//string instr_file;
// reg rst;
reg [31:0] fin_program_counter;
reg instr_mem_write_enable;
reg [31:0] instr_load;
wire [3:0] instr_mem_err_code;
reg [31:0] instrWriteAddr;
/* verilator lint_on UNUSEDSIGNAL */

initial 
begin
    instr_mem_write_enable = 0;
    instr_load = 32'b0;
    fin_program_counter = 32'b0;
    instrWriteAddr = 32'b0;
end

wire ef_overwritePcEnable;
wire [31:0] ef_program_counter_overwrite;
wire eout_stall;
reg df_stall;

always @(posedge clk)
begin
    if (eout_stall)
    begin
        fin_program_counter <= fin_program_counter;
    end
    else
        begin
        if (ef_overwritePcEnable)
        begin
            fin_program_counter <= ef_program_counter_overwrite;
        end
        else
        begin
            fin_program_counter <= fin_program_counter + 4;
        end
    end
end
// ---------------------------------------------------------------------------

// ------------------------- instMem output-----------------------------------
// ---------------------------------------------------------------------------
wire [31:0] fd_instr_fetched;

instructionMemory #(.instr_file(instr_file)) instMem  (
                            .clk(clk),
                            .write_enable(instr_mem_write_enable),
                            .program_counter (fin_program_counter),
                            .instr_write_in (instr_load),
                            .instrWriteAddr(instrWriteAddr),
                            .stallIn(eout_stall),
                            .instr_write_out (fd_instr_fetched),
                            .error_code(instr_mem_err_code));

// ------------------------------ decode input ------------------------------------
reg din_rst;

reg [31:0] fd_p_program_counter;
// reg [31:0] fd_p_instr_fetched;

// reg [31:0] fd_stall_instr_fetched;

wire eout_flush_decode;

initial
begin
    din_rst = 1'b1;
    fd_p_program_counter = 32'b0;
    // fd_stall_instr_fetched = 32'b0;
    // fd_p_instr_fetched = 32'b0;
end

always @(posedge clk)
begin
    // if (eout_stall)
    // begin
    //     fd_p_instr_fetched <= fd_stall_instr_fetched;
    // end
    // else
    // begin
    //     fd_stall_instr_fetched <= fd_instr_fetched;
    //     fd_p_instr_fetched <= fd_instr_fetched;

    //     fd_p_program_counter <= fin_program_counter;
    // end
    
    fd_p_program_counter <= fin_program_counter;
    din_rst <= eout_flush_decode;
end

// --------------------------------------------------------------------------------

// ------------------------------ decode output -----------------------------------
wire [5:0] de_opcode;
wire [5:0] de_instr_sel;
wire [4:0] de_rs;
wire [4:0] de_rt;
wire [4:0] de_rd;
wire [4:0] de_sa;
wire [19:0] de_code;
wire [4:0] de_base;
wire signed [31:0] de_offset;
wire [25:0] de_instr_index;
wire signed [31:0] de_immediate;
wire [2:0] de_mc0_sel;
wire [1:0] de_bp;
wire [4:0] de_msdb;
wire [4:0] de_lsb;
wire [1:0] de_i_type;
// --------------------------------------------------------------------------------

// shoudl probably make the modules combinational
// have an always block save the data in some "shadow" registers
// if there is a stall signal, then use the shadow registers as input instead
// of the output from the previous module

// can have different stall signals so only one module can stall at a time 
// and there can be a hierarchy

decoder dec (
             .rst(din_rst),
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
// ----------------------------------------------------------------------------


// regfile 31 GPR
reg signed [31:0] regFile [31:0];
reg [5:0] regFileIterator;

initial 
begin
    for (regFileIterator = 0; regFileIterator < 32; regFileIterator = regFileIterator + 1)
    begin
        regFile[regFileIterator[4:0]] = 32'b0;
    end
end

// -------------------------- Execute Input --------------------------------

// retreive register values automatically
reg signed [31:0] de_rs_data;
reg signed [31:0] de_rt_data;
reg signed [31:0] de_rd_data;
reg signed [31:0] de_base_data;

// pipeline registers [decode -> execute]
// ensures execute module receives input 1 clk cycle after decode module received input
// reg de_p_pc_enable;
reg [5:0] de_p_opcode;
reg [5:0] de_p_instr_sel;
reg [4:0] de_p_rs;
reg [4:0] de_p_rt;
reg [4:0] de_p_rd;
reg [4:0] de_p_sa;
reg [19:0] de_p_code;
reg signed [31:0] de_p_offset;
reg [25:0] de_p_instr_index;
reg signed [31:0] de_p_immediate;
reg [2:0] de_p_mc0_sel;
reg [1:0] de_p_bp;
reg [4:0] de_p_msdb;
reg [4:0] de_p_lsb;
reg [1:0] de_p_i_type;
reg signed [31:0] de_p_rs_data;
reg signed [31:0] de_p_rt_data;
reg signed [31:0] de_p_rd_data;
reg signed [31:0] de_p_base_data;

reg [5:0] de_stall_opcode;
reg [5:0] de_stall_instr_sel;
reg [4:0] de_stall_rs;
reg [4:0] de_stall_rt;
reg [4:0] de_stall_rd;
reg [4:0] de_stall_sa;
reg [19:0] de_stall_code;
reg signed [31:0] de_stall_offset;
reg [25:0] de_stall_instr_index;
reg signed [31:0] de_stall_immediate;
reg [2:0] de_stall_mc0_sel;
reg [1:0] de_stall_bp;
reg [4:0] de_stall_msdb;
reg [4:0] de_stall_lsb;
reg [1:0] de_stall_i_type;
reg signed [31:0] de_stall_rs_data;
reg signed [31:0] de_stall_rt_data;
reg signed [31:0] de_stall_rd_data;
reg signed [31:0] de_stall_base_data;

reg [31:0] ein_mulDivNumIt;
reg [63:0] ein_mulDivResult;

reg [64:0] ein_boothOp;
reg [5:0] ein_boothN;

reg ein_rst;

// ---------------------------------------------------------------------------

// ------------------------- Execute Output -----------------------------------

// defining pipeline registers
wire [4:0] em_writebackReg;
wire signed [31:0] em_executeOutput;

reg signed [31:0] em_p_executeOutput;
reg [4:0] em_p_writebackReg;

wire eout_flush_execute;

wire [31:0] eout_mulDivNumIt;
wire [63:0] eout_mulDivResult;

wire [64:0] eout_boothOp;
wire [5:0] eout_boothN;

reg [4:0] mw_p_writebackReg; // pipeline reg
reg signed [31:0] mw_p_executeOutput; // pipeline register 

// -----------------------------------------------------------------------------

initial
begin
    de_rs_data = 32'b0;
    de_rt_data = 32'b0;
    de_rd_data = 32'b0;
    de_base_data = 32'b0;

    em_p_writebackReg = 5'b0;
    em_p_executeOutput = 32'b0;

    mw_p_writebackReg = 5'b0;
    mw_p_executeOutput = 32'b0;
end

always @(*)
begin
    if (de_rs == em_writebackReg)
    begin
        de_rs_data = em_executeOutput;
    end
    else if(de_rs == em_p_writebackReg)
    begin
        de_rs_data = em_p_executeOutput;
    end
    else if (de_rs == mw_p_writebackReg)
    begin
        de_rs_data = mw_p_executeOutput;
    end
    else
    begin
        de_rs_data = regFile[de_rs];
    end
end

always @(*)
begin
    if (de_rt == em_writebackReg)
    begin
        de_rt_data = em_executeOutput;
    end
    else if(de_rt == em_p_writebackReg)
    begin
        de_rt_data = em_p_executeOutput;
    end
    else if (de_rt == mw_p_writebackReg)
    begin
        de_rt_data = mw_p_executeOutput;
    end
    else
    begin
        de_rt_data = regFile[de_rt];
    end
end

always @(*)
begin
    if (de_rd == em_writebackReg)
    begin
        de_rd_data = em_executeOutput;
    end
    else if(de_rd == em_p_writebackReg)
    begin
        de_rd_data = em_p_executeOutput;
    end
    else if (de_rd == mw_p_writebackReg)
    begin
        de_rd_data = mw_p_executeOutput;
    end
    else
    begin
        de_rd_data = regFile[de_rd];
    end
end

always @(*)
begin
    if (de_base == em_writebackReg)
    begin
        de_base_data = em_executeOutput;
    end
    else if(de_base == em_p_writebackReg)
    begin
        de_base_data = em_p_executeOutput;
    end
    else if (de_base == mw_p_writebackReg)
    begin
        de_base_data = mw_p_executeOutput;
    end
    else
    begin
        de_base_data = regFile[de_base];
    end
end


reg [31:0] de_p_program_counter;

initial 
begin
    de_p_program_counter = 32'b0;
end

always @(posedge clk)
begin
    de_p_program_counter <= fd_p_program_counter;
end

initial
begin
    de_p_opcode = 6'b000000; // initialize the instruciton as NOP/SLL
    de_p_instr_sel = 6'b001011; // initialize the instruction as NOP/SLL
    de_p_rs = 5'b0;
    de_p_rt = 5'b0;
    de_p_rd = 5'b0;
    de_p_sa = 5'b0;
    de_p_code = 20'b0;
    de_p_offset = 32'b0;
    de_p_instr_index = 26'b0;
    de_p_immediate = 32'b0;
    de_p_mc0_sel = 3'b0;
    de_p_bp = 2'b0;
    de_p_msdb = 5'b0;
    de_p_lsb = 5'b0;
    de_p_i_type = 2'b0;
    de_p_rs_data = 32'b0;
    de_p_rt_data = 32'b0;
    de_p_rd_data = 32'b0;
    de_p_base_data = 32'b0;

    ein_rst = 1'b1;

    ein_mulDivNumIt = 32'b0;

    ein_boothN = 6'b0;
    ein_boothOp = 65'b0;
end

// always @(*)
// begin
//     if (de_opcode == 6'b0 && 
//         (de_instr_sel == 6'b010001 || 
//          de_instr_sel == 6'b010010 ||
//          de_instr_sel == 6'b010011 ||
//          de_instr_sel == 6'b010100))

//     begin

//     else
//     begin
//         df_stall = 1'b0;
//     end
// end

always @(posedge clk)
begin
    if (eout_stall)
    begin
        de_p_opcode <= de_stall_opcode;
        de_p_instr_sel <= de_stall_instr_sel;
        de_p_rs <= de_stall_rs;
        de_p_rt <= de_stall_rt;
        de_p_rd <= de_stall_rd;
        de_p_sa <= de_stall_sa;
        de_p_code <= de_stall_code;
        de_p_offset <= de_stall_offset;
        de_p_instr_index <= de_stall_instr_index;
        de_p_immediate <= de_stall_immediate;
        de_p_mc0_sel <= de_stall_mc0_sel;
        de_p_bp <= de_stall_bp;
        de_p_msdb <= de_stall_msdb;
        de_p_lsb <= de_stall_lsb;
        de_p_i_type <= de_stall_i_type;
        de_p_rs_data <= de_stall_rs_data;
        de_p_rt_data <= de_stall_rt_data;
        de_p_rd_data <= de_stall_rd_data;
        de_p_base_data <= de_stall_base_data;
        
    end
    else
    begin
        de_p_opcode <= de_opcode;
        de_p_instr_sel <= de_instr_sel;
        de_p_rs <= de_rs;
        de_p_rt <= de_rt;
        de_p_rd <= de_rd;
        de_p_sa <= de_sa;
        de_p_code <= de_code;
        de_p_offset <= de_offset;
        de_p_instr_index <= de_instr_index;
        de_p_immediate <= de_immediate;
        de_p_mc0_sel <= de_mc0_sel;
        de_p_bp <= de_bp;
        de_p_msdb <= de_msdb;
        de_p_lsb <= de_lsb;
        de_p_i_type <= de_i_type;
        de_p_rs_data <= de_rs_data;
        de_p_rt_data <= de_rt_data;
        de_p_rd_data <= de_rd_data;
        de_p_base_data <= de_base_data;

        de_stall_opcode <= de_opcode;
        de_stall_instr_sel <= de_instr_sel;
        de_stall_rs <= de_rs;
        de_stall_rt <= de_rt;
        de_stall_rd <= de_rd;
        de_stall_sa <= de_sa;
        de_stall_code <= de_code;
        de_stall_offset <= de_offset;
        de_stall_instr_index <= de_instr_index;
        de_stall_immediate <= de_immediate;
        de_stall_mc0_sel <= de_mc0_sel;
        de_stall_bp <= de_bp;
        de_stall_msdb <= de_msdb;
        de_stall_lsb <= de_lsb;
        de_stall_i_type <= de_i_type;
        de_stall_rs_data <= de_rs_data;
        de_stall_rt_data <= de_rt_data;
        de_stall_rd_data <= de_rd_data;
        de_stall_base_data <= de_base_data;

    end

    if ((eout_stall == 1'b0 && (de_opcode == 6'b0 && 
        (de_instr_sel == 6'b010001 || 
         de_instr_sel == 6'b010010 ||
         de_instr_sel == 6'b010011 ||
         de_instr_sel == 6'b010100))) || 

         (eout_stall == 1'b1 && (de_stall_opcode == 6'b0 &&
         (de_stall_instr_sel == 6'b010001 || 
          de_stall_instr_sel == 6'b010010 ||
          de_stall_instr_sel == 6'b010011 ||
          de_stall_instr_sel == 6'b010100)))
        )
    begin
        ein_mulDivNumIt <= eout_mulDivNumIt;
        ein_mulDivResult <= eout_mulDivResult;
        if (eout_stall == 1'b0) // ein_boothN == 6'b0
        begin
            ein_boothN <= 32;
            ein_boothOp <= {32'b0,de_rt_data,1'b0};
        end
        else
        begin
            ein_boothN <= eout_boothN;
            ein_boothOp <= eout_boothOp;
        end
    end
    else
    begin
        ein_mulDivNumIt <= 32'b0;
        ein_mulDivResult <= 64'b0;
        ein_boothOp <= 65'b0;
        ein_boothN <= 6'b0;
    end

    ein_rst <= eout_flush_execute;
end

// ---------------------------execute output ------------------------------
wire [1:0] em_memAccessEnable;
wire [31:0] em_memAddr;
wire [1:0] em_accessLength;
wire em_memAccessUnsigned;

// the rest of the execute output are above the modules that require the output as input


execute ex (
            .rst(ein_rst),
            .opcode(de_p_opcode),
            .instr_sel(de_p_instr_sel),
            .rs(de_p_rs),
            .rt(de_p_rt),
            .rd(de_p_rd),
            .rs_data(de_p_rs_data),
            .rt_data(de_p_rt_data),
            .rd_data(de_p_rd_data),
            .sa(de_p_sa),
            .code(de_p_code),
            .base_data(de_p_base_data),
            .offset(de_p_offset),
            .instr_index(de_p_instr_index),
            .immediate(de_p_immediate),
            .mc0_sel(de_p_mc0_sel),
            .bp(de_p_bp),
            .msdb(de_p_msdb),
            .lsb(de_p_lsb),
            .i_type(de_p_i_type),
            .program_counter(de_p_program_counter),
            .mulDivNumItIn(ein_mulDivNumIt),
            .mulDivResultIn(ein_mulDivResult),
            .boothOpIn(ein_boothOp),
            .boothNIn(ein_boothN),
            .memAccessEnable(em_memAccessEnable),
            .memAddr(em_memAddr),
            .accessLength(em_accessLength),
            .memAccessUnsigned(em_memAccessUnsigned),
            .executeOutput(em_executeOutput),
            .writebackReg(em_writebackReg),
            .program_counter_overwrite(ef_program_counter_overwrite),
            .overwritePcEnable(ef_overwritePcEnable),
            .flush_decode(eout_flush_decode),
            .flush_execute(eout_flush_execute),
            .stall(eout_stall),
            .mulDivNumItOut(eout_mulDivNumIt),
            .mulDivResultOut(eout_mulDivResult),
            .boothOpOut(eout_boothOp),
            .boothNOut(eout_boothN));

// ------------------- data memory input --------------------------------
reg [1:0] em_p_memAccessEnable;
reg [31:0] em_p_memAddr;
reg [1:0] em_p_accessLength;
reg em_p_memAccessUnsigned;

initial
begin
    em_p_memAccessEnable = 2'b0;
    em_p_memAddr = 32'b0;
    em_p_accessLength = 2'b0;
    em_p_memAccessUnsigned = 1'b0;
end

always @(posedge clk)
begin
    // em_p_pc_enable <= de_p_pc_enable;
    em_p_memAccessEnable <= em_memAccessEnable;
    em_p_memAddr <= em_memAddr;
    em_p_accessLength <= em_accessLength;
    em_p_executeOutput <= em_executeOutput;
    em_p_writebackReg <= em_writebackReg;
    em_p_memAccessUnsigned <= em_memAccessUnsigned;
end

// ----------------- data memory output --------------------------------
wire [31:0] mw_readData;

dataMemory ma (
                .clk(clk),
                .memAccessEnable(em_p_memAccessEnable),
                .memAddr(em_p_memAddr),
                .accessLength(em_p_accessLength),
                .writeData(em_p_executeOutput),
                .memAccessUnsigned(em_p_memAccessUnsigned),
                .readData(mw_readData));



reg [1:0] mw_p_memAccessEnable; // pipeline reg

initial
begin
    mw_p_memAccessEnable = 2'b0;
end
// reg mw_p_pc_enable;

always @(posedge clk)
begin
    mw_p_memAccessEnable <= em_p_memAccessEnable;
    mw_p_writebackReg <= em_p_writebackReg;
    mw_p_executeOutput <= em_p_executeOutput;
    // mw_p_pc_enable <= em_p_pc_enable;
end

always @(posedge clk)
begin
    if (mw_p_memAccessEnable == 1) // write to memory, not reg
    begin
        $display("Writeback: nothing to writeback");
    end
    else if (mw_p_memAccessEnable == 2) // read from mem, write to reg
    begin
        if (mw_p_writebackReg != 5'b0)
        begin
            regFile[mw_p_writebackReg] <= mw_readData;
            $display("Writeback: Writing %h to register %d from Data Mem", mw_readData, mw_p_writebackReg);
        end
        else
        begin
            $display("Writeback: Attempting to write to ZERO Reg - Blocked");
            // eightBits <= mw_readData[7:0];
        end
    end
    else // write from executed stage value to reg
    begin
        if (mw_p_writebackReg != 5'b0)
        begin
            regFile[mw_p_writebackReg] <= mw_p_executeOutput;
            $display("Writeback: Writing %h to register %d from Data Mem", mw_p_executeOutput, mw_p_writebackReg);
        end
        else
        begin
            $display("Writeback: Attempting to write to ZERO Reg - Blocked");
            // eightBits <= mw_p_executeOutput[7:0];
        end
    end
end

always @ (*)
begin
    if (byteNum == 2'b0)
    begin
        eightBits = regFile[regAccessIndex][7:0];
    end
    else if (byteNum == 2'b01)
    begin
        eightBits = regFile[regAccessIndex][15:8];
    end
    else if (byteNum == 2'b10)
    begin
        eightBits = regFile[regAccessIndex][23:16];
    end
    else
    begin
        eightBits = regFile[regAccessIndex][31:24];
    end

end
                            
endmodule
