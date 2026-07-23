`timescale 1 ns/ 10 ps // time unit / time precision

module topModule
(input wire clk);

initial begin
    $dumpfile("testbench.vcd");
    $dumpvars();
end

// ------------------------- CPU0 REGISTERS ----------------------------------
/* verilator lint_off UNUSEDSIGNAL */
reg [31:0] Index; //  ** (reg 0, sel 0) required for TLB
reg [31:0] VPControl; // (reg 0, sel 4) required if multi-threading supported
reg [31:0] Random; // ** (reg 1, sel 0) required for TLB
reg [63:0] EntryLo0; // ** (reg 2, sel 0) required for TLB
reg [63:0] EntryLo1; // ** (reg 3, sel 0) reqired for TLB
reg [31:0] GlobalNumber; // (reg 3, sel 1) optional
reg [31:0] Context; // ** (reg 4, sel 0) required for TLB
reg [31:0] ContextConfig; // (reg 4, sel 1) optional
reg [31:0] UserLocal; // ** (reg 4, sel 2) required, not interpreted by hardware
reg [31:0] DebugContextId; // (reg 4, sel 4) optional
reg [31:0] PageMask; // ** (reg 5, sel 0) required for TLB
reg [31:0] PageGain; // ** (reg 5, sel 1) requird for 1kb pages
reg [31:0] SegCtl0; // (reg 5, sel 2) optional
reg [31:0] SegCtl1; // (reg 5, sel 3) optional
reg [31:0] SegCtl2; // (reg 5, sel 4) optional
reg [31:0] PWBase; // ** (reg 5, sel 5) required for Page Walking
reg [31:0] PWField; // ** (reg 5, sel 6) requird for Page Walking
reg [31:0] PWSize; // ** (reg 5, sel 7) requird for Page Walking
reg [31:0] Wired; // ** (reg 6, sel 0) required for TLB
reg [31:0] PWCtl; // ** (reg 6, sel 6) required for Page Walking
reg [31:0] HWREna; // ** (reg 7, sel 0)
reg [31:0] BadVAddr; // ** (reg 8, sel 0) required for TLB
reg [31:0] BadInstr; // ** (reg 8, sel 1)
reg [31:0] BadInstrP; // ** (reg 8, sel 2)
reg [31:0] Count; // ** (reg 9, sel 0) required
reg [31:0] EntryHi; // ** (reg 10, sel 0) required for TLB
reg [31:0] Compare; // ** (reg 11, sel 0) required
reg [31:0] Status; // ** (reg 12, sel 0) required
reg [31:0] IntCtl; // ** (reg 12, sel 1)
reg [31:0] SRSCtl; // ** (reg 12, sel 2)
reg [31:0] SRSMap; // (reg 12, 3) required if shadow set and vectored interrupt mode is implemented
reg [31:0] Cause; // ** (reg 13, sel 0)
reg [31:0] NestedExc; // (reg 13, sel 5) optional
reg [31:0] ExceptionPC; // ** (reg 14, sel 0)
reg [31:0] NestedEPC; // (reg 14, sel 2) optional
reg [31:0] ProcessorID; // ** (reg 15, sel 0)
reg [31:0] EBase; // ** (reg 15, sel 1)
reg [31:0] CDMMBase; // (reg 15, sel 2)
reg [31:0] CMGCRBase; // (reg 15, sel 3)
reg [31;0] BEVVa; // (reg 15, sel 4)
reg [31:0] Configuration; // ** (reg 16, sel 0)
reg [31:0] Configuration1; // ** (reg 16, sel 1)
reg [31:0] Configuration2; // ** (reg 16, sel 2)
reg [31:0] Configuration3; // ** (reg 16, sel 3)
reg [31:0] Configuration4; // ** (reg 16, sel 4)
reg [31:0] Configuration5; // ** (reg 16, sel 5)
reg [31:0] LLAddress; // ** (reg 17, sel 0)
reg [31:0] TagLo; // ** (reg 28, sel 0,2)
reg [31:0] DataLo; // ** (reg 28 sel 1,3)
reg [31:0] TagHi; // ** (reg 29, sel 0,2)
reg [31:0] DataHi; // ** (reg29, sel 1,3)
reg [31:0] ErrorEPC; // ** (reg 30, sel 0)

/* verilator lint_on UNUSEDSIGNAL */

reg [2:0] eout_cpu0_sel;
reg [4:0] eout_cpu0_reg;

initial
begin
    Index = 32'b0;
    VPControl = 32'b0;
    Random = 32'b0; 
    EntryLo0 = 63'b0; 
    EntryLo1  = 63'b0; 
    GlobalNumber = 32'b0;
    Context = 32'b0;
    ContextConfig = 32'b0;
    UserLocal = 32'b0;
    DebugContextId = 32'b0;
    PageMask = 32'b0;
    PageGain = 32'b0;
    SegCtl0 = 32'b0;
    SegCtl1 = 32'b0;
    SegCtl2 = 32'b0;
    PWBase = 32'b0;
    PWField = 32'b0;
    PWSize = 32'b0;
    Wired = 32'b0;
    PWCtl = 32'b0;
    HWREna = 32'b0;
    BadVAddr = 32'b0;
    BadInstr = 32'b0;
    BadInstrP = 32'b0;
    Count = 32'b0;
    EntryHi = 32'b0;
    Compare = 32'b0;
    Status = 32'b0;
    IntCtl = 32'b0;
    SRSCtl = 32'b0;
    SRSMap = 32'b0;
    Cause = 32'b0;
    NestedExc = 32'b0;
    ExceptionPC = 32'b0;
    NestedEPC = 32'b0;
    ProcessorID = 32'b0;
    EBase = 32'b0;
    CDMMBase = 32'b0;
    CMGCRBase = 32'b0;
    BEVVa = 32'b0;
    Configuration = 32'b0; 
    Configuration1 = 32'b0;
    Configuration2 = 32'b0;
    Configuration3 = 32'b0;
    Configuration4 = 32'b0;
    Configuration5 = 32'b0;
    LLAddress = 32'b0;
    TagLo = 32'b0;
    DataLo = 32'b0;
    TagHi = 32'b0;
    DataHi = 32'b0;
    ErrorEPC = 32'b0;
end



always @(*)
begin
    case (eout_cpu0_reg)
        0:
        begin
            case (sel)
                0:
                begin
                    Index = eout_cpu0RegData;
                end
                
                4:
                begin
                    VPControl = eout_cpu0RegData;
                end

                default:
                begin
                    ;
                end
            endcase
        end

        1:
        begin
            case (sel)
                0:
                begin
                    Random = eout_cpu0RegData;
                end

                default:
                begin
                    ;
                end
            endcase
        end

        2:
        begin
            case (sel)
                0:
                begin
                    EntryLo0 = eout_cpu0RegData;
                end

                default:
                begin
                    ;
                end
            endcase
        end

        3:
        begin
            case (sel)
                0:
                begin
                    EntryLo1 = eout_cpu0RegData;
                end

                1:
                begin
                    GlobalNumber = eout_cpu0RegData
                end

                default:
                begin

                end
            endcase
        end

        4:
        begin
            case (sel)

            endcase
        end
        
        5:
        begin
            case (sel)

            endcase
        end
        
        6:
        begin
            case (sel)

            endcase
        end
        
        7:
        begin
            case (sel)

            endcase
        end

        8:
        begin
            case (sel)

            endcase
        end

        9:
        begin
            case (sel)

            endcase
        end

        10:
        begin
            case (sel)

            endcase
        end

        11:
        begin
            case (sel)

            endcase
        end

        12:
        begin
            case (sel)

            endcase
        end

        13:
        begin
            case (sel)

            endcase
        end

        14:
        begin
            case (sel)

            endcase
        end 

        17:
        begin
            case (sel)

            endcase
        end

        28:
        begin
            case (sel)

            endcase
        end

        29:
        begin
            case (sel)

            endcase
        end

        30:
        begin
            case (sel)

            endcase
        end

        default:
        begin
            ;
        end
    endcase
end


// ------------------------------- END ----------------------------------------

// ------------------------- instMem input -----------------------------------
/* verilator lint_off UNUSEDSIGNAL */
//string instr_file;
// reg rst;
reg [31:0] fin_program_counter;
reg instr_mem_write_enable;
reg [31:0] instr_load;
wire [3:0] instr_mem_err_code;
/* verilator lint_on UNUSEDSIGNAL */

initial 
begin
    instr_mem_write_enable = 0;
    instr_load = 32'b0;
    fin_program_counter = 32'b0;
end

wire [31:0] ef_program_counter_overwrite;
wire ef_overwritePcEnable;

always @(posedge clk)
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

// ------------------------- instMem output-----------------------------------
wire [31:0] fd_instr_fetched;

instructionMemory instMem  (
                            .clk (clk),
                            .write_enable(instr_mem_write_enable),
                            .program_counter (fin_program_counter),
                            .instr_write_in (instr_load),
                            .instr_write_out (fd_instr_fetched),
                            .error_code(instr_mem_err_code));

// ------------------------------ decode input ------------------------------------
reg din_rst;
reg [31:0] fd_p_program_counter;

wire eout_flush_decode;

initial
begin
    din_rst = 1'b1;
    fd_p_program_counter = 32'b0;
end

always @(posedge clk)
begin
    din_rst <= eout_flush_decode;
    fd_p_program_counter <= fin_program_counter;
end

// ------------------------------ decode output -------------------------------------
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



// regfile 31 GPR
reg signed [31:0] regFile [31:0];

initial 
begin
    integer i;

    for (i = 0; i < 32; i = i + 1)
    begin
        regFile[i] = 32'b0;
    end
end

// retreive register values automatically
reg signed [31:0] de_rs_data;
reg signed [31:0] de_rt_data;
reg signed [31:0] de_rd_data;
reg signed [31:0] de_base_data;

// defining pipeline registers
wire [4:0] em_writebackReg;
wire signed [31:0] em_executeOutput;

reg signed [31:0] em_p_executeOutput;
reg [4:0] em_p_writebackReg;

reg [4:0] mw_p_writebackReg; // pipeline reg
reg signed [31:0] mw_p_executeOutput; // pipeline register 

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

reg ein_rst;

wire eout_flush_execute;

initial
begin
    de_p_opcode = 6'b000000; // initialize the instruciton as NOP/SLL
    de_p_instr_sel = 6'b001010; // initialize the instruction as NOP/SLL
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
end

always @(posedge clk)
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

    // ein_rst <= eout_flush_instr;
    ein_rst <= eout_flush_execute; // just to prevent the reset signal from triggering
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
            .memAccessEnable(em_memAccessEnable),
            .memAddr(em_memAddr),
            .accessLength(em_accessLength),
            .memAccessUnsigned(em_memAccessUnsigned),
            .executeOutput(em_executeOutput),
            .writebackReg(em_writebackReg),
            .program_counter_overwrite(ef_program_counter_overwrite),
            .overwritePcEnable(ef_overwritePcEnable),
            .flush_decode(eout_flush_decode),
            .flush_execute(eout_flush_execute));

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
        ;
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
            ;
        end
    end
    else // write from executed stage value to reg
    begin
        if (mw_p_writebackReg != 5'b0)
        begin
            regFile[mw_p_writebackReg] <= mw_p_executeOutput;
            $display("Writeback: Writing %h to register %d from Execute Stage", mw_p_executeOutput, mw_p_writebackReg);
        end
        else
        begin
            $display("Writeback: Attempting to write to ZERO Reg - Blocked");
            ;
        end
    end
end
                            
endmodule
