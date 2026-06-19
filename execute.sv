module execute
(
/* verilator lint_off UNUSEDSIGNAL */
input wire rst,
input wire [5:0] opcode,
input wire [5:0] instr_sel,
input wire [4:0] rs,
input wire [4:0] rt,
input wire [4:0] rd,
input wire [31:0] rs_data,
input wire [31:0] rt_data,
input wire [31:0] rd_data,
input wire [4:0] sa,
input wire [19:0] code,
input wire [31:0] base_data,
input wire [31:0] offset,
input wire [25:0] instr_index,
input wire [31:0] immediate,
input wire [2:0] mc0_sel,
input wire [1:0] bp,
input wire [4:0] msdb,
input wire [4:0] lsb,
input wire [1:0] i_type,
output reg [1:0] memAccessEnable,
output reg [31:0] memAddr,
output reg [1:0] accessLength,
output reg [31:0] executeOutput,
output reg [4:0] writebackReg,
output reg [31:0] pc_offset,
output reg flush_instr
/* verilator lint_off UNUSEDSIGNAL */
);

// register descriptions
// opcode is the bits [31:26] of the fethed instruction
// instr_sel will be used as a secondary flag (after the opcode) to tell what the execute module needs to do
// rs, rt, rd are the operand registers - this will be a value from 0 - 31
// sa is the shift amount
// code is some error code (ie breakpoint exception)

// For branches that take two cycles, we will compute the the 

// regWrite is for the writeback stage
// memWrite is likely going to be rs_data, rt_data, or rd_data

// execute output should be for results that will be writted to a register***********
// PLEASE CHECK THIS OVER

reg [31:0] temp32BitVal; // a temporary value for computations
reg [32:0] temp33BitVal;

initial
begin

end

always @(*)
begin
    if (!rst)
    begin
        memAccessEnable = 2'b0;
        memAddr = 32'b0;
        accessLength = 2'b0;
        executeOutput = 32'b0;
        writebackReg = 5'b0;
        pc_offset = 32'b0;
        flush_instr = 1'b1; // reset the rst signal 
    end
    else
    begin
        pc_offset = 32'b0;
        flush_instr = 1'b1; // reset the rst signal
        case(opcode)
            6'b000000: 
            begin
                case(instr_sel)
                    6'b000000: // ADD
                    begin
                        $display("Execute - ADD");
                        temp32BitVal = rs_data + rt_data;
                        temp33BitVal = rs_data + rt_data;
                        if (temp32BitVal != temp33BitVal[31:0])
                        begin
                            // signal exception
                        end
                        else
                        begin
                            executeOutput = rs_data + rt_data;
                            writebackReg = rd;
                        end
                    end

                    6'b000001: // ADDU
                    begin
                        $display("Execute - ADDU");
                        temp32BitVal = rs_data + rt_data;
                    end

                    6'b000010: // AND
                    begin
                        $display("Execute - AND");
                    end
                    6'b000011: // BREAK
                    begin
                        $display("Execute - BREAK");
                    end

                    6'b000100: // CLO
                    begin
                        $display("Execute - CLO");
                    end

                    6'b000101: // CLZ
                    begin
                        $display("Execute - CLZ");
                    end

                    6'b000110: // DIV
                    begin
                        $display("Execute - DIV");
                    end
                                
                    6'b000111: // MOD
                    begin
                        $display("Execute - MOD");
                    end

                    6'b001000: // DIVU
                    begin
                        $display("Execute - DIVU");
                    end

                    6'b001001: // MODU
                    begin
                        $display("Execute - MODU");
                    end

                    6'b001010: //PAUSE
                    begin
                        $display("Execute - PAUSE - NOT IMPLEMENTED");
                    end

                    6'b001011: // EHB, NOP, SSNOP are implemented as SLL in hardware
                    begin
                        $display("Execute - SLL (NOP)");

                        memAccessEnable = 0;
                        executeOutput = 0;
                        writebackReg = 0;

                    end

                    6'b001100: // JALR, JALR.HB, JR, JR.HB
                    begin
                        $display("Execute - JALR.HB");
                    end

                    6'b001101: // JALR
                    begin
                        $display("Execute - JALR");
                    end
                    
                    6'b001110:
                    begin
                        $display("Execute - JR.HB");
                    end

                    6'b001111: // JR
                    begin
                        $display("Execute - JR");
                    end

                    6'b010000: // LSA
                    begin
                        $display("Execute - LSA");
                    end

                    6'b010001: // MUL
                    begin
                        $display("Execute - MUL");
                    end

                    6'b010010: // MUH
                    begin
                        $display("Execute - MUH");
                    end

                    6'b010011: // MULU
                    begin
                        $display("Execute - MULU");
                    end

                    6'b010100: // MUHU
                    begin
                        $display("Execute - MUHU");
                    end

                    6'b010101: // NOR
                    begin
                        $display("Execute - NOR");
                    end

                    6'b010110: // ROTR, SRL
                    begin
                        $display("Execute - ROTR");
                    end

                    6'b010111: // SRL
                    begin
                        $display("Execute - SRL");
                    end

                    6'b011000: // ROTRV
                    begin
                        $display("Execute - ROTRV");
                    end

                    6'b011001: // SRLV
                    begin
                        $display("Execute - SRLV");
                    end

                    6'b011010: // SDBBP
                    begin
                        $display("Execute - SDBBP");
                    end

                    6'b011011: // SELEQZ
                    begin
                        $display("Execute - SELEQZ");
                    end

                    6'b011100: // SELNEZ
                    begin
                        $display("Execute - SELNEZ");
                    end

                    6'b011101: // SLLV
                    begin
                        $display("Execute - SLLV");

                        memAccessEnable = 0;
                        executeOutput = 0;
                        writebackReg = 0;
                        
                    end

                    6'b011110: // SLT
                    begin
                        $display("Execute - SLT");
                    end

                    6'b011111: // SLTU
                    begin
                        $display("Execute - SLTU");
                    end

                    6'b100000: // SRA
                    begin
                        $display("Execute - SRA");
                    end

                    6'b100001: // SRAV
                    begin
                        $display("Execute - SRAV");
                    end

                    6'b100010: // SUB
                    begin
                        $display("Execute - SUB");
                    end

                    6'b100011: // SUBU
                    begin
                        $display("Execute - SUBU");
                    end

                    6'b100100: // SYNC
                    begin
                        $display("Execute - SYNC - NOT IMPLEMENTED");
                    end

                    6'b100101: // SYSCALL
                    begin
                        $display("Execute - SYSCALL");
                    end

                    6'b100110: // TEQ
                    begin
                        $display("Execute - TEQ");
                    end

                    6'b100111: // TGE
                    begin
                        $display("Execute - TGE");
                    end

                    6'b101000: // TGEU
                    begin
                        $display("Execute - TGEU");
                    end

                    6'b101001: // TLT
                    begin
                        $display("Execute - TLT");
                    end 

                    6'b101010: // TLTU
                    begin
                        $display("Execute - TLTU");
                    end

                    6'b101011: // TNE
                    begin
                        $display("Execute - TNE");
                    end

                    6'b101100: // XOR
                    begin
                        $display("Execute - XOR");
                    end

                    default: // OR
                    begin
                    $display("Execute - OR");
                    end

                endcase
            end

            6'b000001:
            begin
                case (instr_sel)
                    6'b000000: // SIGRIE
                    begin
                        $display("Execute - SIGRIE");
                    end
                    6'b000001: // BAL
                    begin
                        $display("Execute - BAL");
                    end
                    6'b000010: // BGEZ
                    begin
                        $display("Execute - BGEZ");
                    end
                    6'b000011: // BLTZ
                    begin
                        $display("Execute - BLTZ");
                    end
                    6'b000100: // NAL
                    begin
                        $display("Execute - NAL");
                    end
                    default: // SYNCI
                    begin
                        $display("Execute - SYNCI");
                    end
                endcase
            end

            6'b000010: // J
            begin
                $display("Execute - J");
            end

            6'b000011: // JAL
            begin
                $display("Execute - JAL");
            end

            6'b000100: // B, BEQ
            begin
                // B is implemented as BEQ
                $display("Execute - BEQ");
                if (rs_data == rt_data)
                begin
                    $display("rt and rs are equal - branching");
                    pc_offset = offset;
                    flush_instr = 0; // 0 = flush instruction
                end
                else
                begin
                    // set the PC increment to zero
                    $display("rt and rs are not equal - not branching");
                    pc_offset = 32'b0;
                end
            end

            6'b000101: // BNE
            begin
                $display("Execute - BNE");
            end

            6'b000110: // BGEUC, BGEZALC, BLEUC, BLEZ, BLEZALC
            begin
                case (instr_sel)
                    6'b000000:
                    begin
                        $display("Execute - BGEZALC");
                    end

                    6'b000001: // BGEUC/BLEUC
                    begin
                        $display("Execute - BGEUC/BLEUC");
                    end

                    6'b000010:
                    begin
                        $display("Execute - BLEZALC");
                    end

                    default: // BLEZ
                    begin
                        $display("Execute - BLEZ");
                    end
                endcase
            end

            6'b000111: // BGTUC, BGTZ, BGTZALC, BLTUC, BLTZALC
            begin
                case (instr_sel)
                    6'b000000:
                    begin
                        $display("Execute - BLTZALC");
                    end
                    6'b000001: // BLTUC/BGTUC
                    begin
                        $display("Execute - BLTUC/BGTUC");
                    end
                    6'b000010:
                    begin
                        $display("Execute - BGTZALC");
                    end
                    default: // BGTZ
                    begin
                        $display("Execute - BGTZ");
                    end
                endcase
            end

            6'b001000: // BEQC, BEQZALC, BOVC BRO WTF
            begin
                case (instr_sel)
                    6'b000000: // BOVC
                    begin
                        $display("Execute - BOVC");
                    end
                    6'b000001: // BEQZALC
                    begin
                        $display("Execute - BEQZALC");
                    end
                    default: // BEQC
                    begin
                        $display("Execute - BEQC");
                    end
                endcase
            end

            6'b001001: // ADDIU
            begin
                $display("Execute - ADDIU");

                executeOutput = rs_data + immediate;

                memAccessEnable = 0;
                writebackReg = rt;

            end

            6'b001010: // SLTI
            begin
                $display("Execute - SLTI");
            end

            6'b001011: // SLTIU
            begin
                $display("Execute - SLTIU");
            end

            6'b001100: // ANDI
            begin
                $display("Execute - ANDI");
            end

            6'b001101: // ORI
            begin
                $display("Execute - ORI");
            end

            6'b001110: // XORI
            begin
                $display("Execute - XORI");
            end

            6'b001111: // AUI, LUI - LUI is an assembly idiom of AUI where rs = 0
            begin
                $display("Execute - AUI");
            end

            6'b010000:
            begin

                case (instr_sel)

                    6'b000000: // DI
                    begin
                        $display("Execute - DI");
                    end

                    6'b000001: // DIVP
                    begin
                        $display("Execute - DIVP");
                    end

                    6'b000010: // EI
                    begin
                        $display("Execute - EI");
                    end

                    6'b000011: // EVP
                    begin
                        $display("Execute - EVP");
                    end

                    6'b000100: // MFC0
                    begin
                        $display("Execute - MFC0");
                    end

                    6'b000101: // MFHC0
                    begin
                        $display("Execute - MFHC0");
                    end

                    6'b000110: // MTC0
                    begin
                        $display("Execute - MTC0");
                    end

                    6'b000111: // MTHC0
                    begin
                        $display("Execute - MTHC0");
                    end

                    6'b001000: // RDPGPR
                    begin
                        $display("Execute - RDPGPR");
                    end

                    6'b001001: // WRPGPR
                    begin
                        $display("Execute - WRPGPR");
                    end

                    6'b001010: // DERET
                    begin
                        $display("Execute - DERET");
                    end

                    6'b001011: // ERET
                    begin
                        $display("Execute - ERET");
                    end

                    6'b001100: // ERETNC
                    begin
                        $display("Execute - ERETNC");
                    end

                    6'b001101: // TLBINV
                    begin
                        $display("Execute - TLBINV");
                    end

                    6'b001110: // TLBINVF
                    begin
                        $display("Execute - TLBINVF");
                    end

                    6'b001111: // TLBP
                    begin
                        $display("Execute - TLBP");
                    end

                    6'b010000: // TLBR
                    begin
                        $display("Execute - TLBR");
                    end

                    6'b010001: // TLBWI
                    begin
                        $display("Execute - TLBWI");
                    end

                    6'b010010: // TLBWR
                    begin
                        $display("Execute - TLBWR");
                    end

                    default: // WAIT
                    begin
                        $display("Execute - WAIT");
                    end
                endcase
            end 

            6'b010001:
            begin
                $display("C1 Instructions - Not Implemented");
            end

            6'b010010:
            begin
                $display("C2 Instructions - Not Implemented");
            end

            6'b010110: // BGEC/BLEC(idiom), BGEZC, BLEZC, BLEZL
            begin
                case (instr_sel)
                    6'b000000:
                    begin
                        $display("Execute - BGEC/BLEC");
                    end
                    6'b000001: // BGEZC
                    begin
                        $display("Execute - BGEZC");
                    end
                    6'b000010:
                    begin
                        $display("Execute - BLEZC");
                    end
                    default: // BLEZL
                    begin
                        $display("Execute - BLEZL");
                    end
                endcase
            end

            6'b010111: // BGTC, BGTZC, BGTZL, BLTC, BLTZC
            begin
                case (instr_sel)
                    6'b000000:
                    begin
                        $display("Execute - BLTC/BGTC");
                    end
                    6'b000001: // BLTZC
                    begin
                        $display("Execute - BLTZC");
                    end
                    6'b000010:
                    begin
                        $display("Execute - BGTZC");
                    end
                    default: // BGTZL
                    begin
                        $display("Execute - BGTZL");
                    end
                endcase
            end

            6'b011000: // BNEC, BNEZALC, BNVC
            begin
                case (instr_sel)
                    6'b000000:
                    begin
                        $display("Execute - BNEC");
                    end
                    6'b000001:
                    begin
                        $display("Execute - BNEZALC");
                    end
                    default: // BNVC
                    begin
                        $display("Execute - BNVC");
                    end
                endcase
            end

            6'b011111:
            begin
                case (instr_sel)
                    6'b000000: // EXT
                    begin
                        $display("Execute - EXT");
                    end

                    6'b000001: // INS
                    begin
                        $display("Execute - INS");
                    end

                    6'b000010: // CRC32B
                    begin
                        $display("Execute - CRC32B");
                    end

                    6'b000011: // CRC32H
                    begin
                        $display("Execute - CRC32H");
                    end

                    6'b000100: // CRC32W
                    begin
                        $display("Execute - CRC32W");
                    end

                    6'b000101: // CRC32CB
                    begin
                        $display("Execute - CRC32CB");
                    end

                    6'b000110: // CRC32CH
                    begin
                        $display("Execute - CRC32CH");
                    end

                    6'b000111: // CRC32CW
                    begin
                        $display("Execute - CRC32CW");
                    end

                    6'b001000: // CACHEE
                    begin
                        $display("Execute - CACHEE");
                    end

                    6'b001001: // SBE
                    begin
                        $display("Execute - SBE");
                    end

                    6'b001010: // SHE
                    begin
                        $display("Execute - SHE");
                    end

                    6'b001011: // SCE
                    begin
                        $display("Execute - SCE");
                    end

                    6'b001100: // SCWPE
                    begin
                        $display("Execute - SCWPE");
                    end

                    6'b001101: // SWE
                    begin
                        $display("Execute - SWE");
                    end

                    6'b001110: // BITSWAP
                    begin
                        $display("Execute - BITSWAP");
                    end

                    6'b001111: // SEB
                    begin
                        $display("Execute - SEB");
                    end

                    6'b010000: // SEH
                    begin
                        $display("Execute - SEH");
                    end

                    6'b010001: // WSBH
                    begin
                        $display("Execute - WSBH");
                    end

                    6'b010010: // ALIGN
                    begin
                        $display("Execute - ALIGN");
                    end


                    6'b010011: // PREFE
                    begin
                        $display("Execute - PREFE");
                    end

                    6'b010100: // CACHE
                    begin
                        $display("Execute - CACHE");
                    end

                    6'b010101: // SC
                    begin
                        $display("Execute - SC");
                    end

                    6'b010110: // SCWP
                    begin
                        $display("Execute - SCWP");
                    end

                    6'b010111: // LBUE
                    begin
                        $display("Execute - LBUE");
                    end

                    6'b011000: // LHUE
                    begin
                        $display("Execute - LHUE");
                    end

                    6'b011001: // LBE
                    begin
                        $display("Execute - LBE");
                    end
                    
                    6'b011010: // LHE
                    begin
                        $display("Execute - LHE");
                    end
                    
                    6'b011011: // LLE
                    begin
                        $display("Execute - LLE");
                    end

                    6'b011100: // LLWPE
                    begin
                        $display("Execute - LLWPE");
                    end

                    6'b011101: // LWE
                    begin
                        $display("Execute - LWE");
                    end

                    6'b011110: // PREF
                    begin
                        $display("Execute - PREF");
                    end

                    6'b011111: // LL
                    begin
                        $display("Execute - LL");
                    end

                    6'b100000: // LLWP
                    begin
                        $display("Execute - LLWP");
                    end

                    6'b100001: // RDHWR
                    begin
                        $display("Execute - RDHWR");
                    end

                    6'b100010:
                    begin
                        $display("Execute - GINVI");
                    end
                    
                    default:
                    begin
                        $display("Execute - GINVT");
                    end
                endcase
            end

            6'b100000: // LB
            begin
                $display("Execute - LB");

                memAddr = offset + base_data;
                accessLength = 0;
                memAccessEnable = 2;
                writebackReg = rt;

            end

            6'b100001: // LH
            begin
                $display("Execute - LH");

                memAddr = offset + base_data;
                accessLength = 1;
                memAccessEnable = 2;
                writebackReg = rt;
            end

            6'b100011: // LW
            begin
                $display("Execute - LW");

                memAddr = offset + base_data;
                accessLength = 2;
                memAccessEnable = 2;
                writebackReg = rt;
            end

            6'b100100: // LBU
            begin
                $display("Execute - LBU");
            end

            6'b100101: // LHU
            begin
                $display("Execute - LHU");
            end

            6'b101000: // SB
            begin
                memAddr = offset + base_data; // vAddr
                // maybe later do vAddr -> pAddr translation

                accessLength = 0;
                memAccessEnable = 1;
                executeOutput = rt_data;

                $display("Execute - SB");
            end

            6'b101001: // SH
            begin
                $display("Execute - SH");

                memAddr = offset + base_data;
                accessLength = 1;
                memAccessEnable = 1;
                executeOutput = rt_data;
                writebackReg = 0;
            end

            6'b101011: // SW
            begin
                $display("Execute - SW");

                memAddr = offset + base_data;
                accessLength = 2;
                memAccessEnable = 1;
                executeOutput = rt_data;
                writebackReg = 0;
            end

            6'b110010: // BC
            begin
                $display("Execute - BC");
            end

            6'b110110:
            begin
                case (instr_sel)
                    6'b000000: // BEQZC
                    begin
                        $display("Execute - BEQZC");
                    end
                    default: // JIC
                    begin
                        $display("Execute - JIC");
                    end
                endcase
            end

            6'b111010: // BALC
            begin
                $display("Execute - BALC");
            end

            6'b111011: // ADDIUPC, ALUIPC, AUIPC, LWPC
            begin

                case (instr_sel)
                    6'b000000: // ADDIUPC
                    begin
                        $display("Execute - ADDIUPC");
                    end

                    6'b000001: // LWPC
                    begin
                        $display("Execute - LWPC");
                    end

                    6'b000010: // AUIPC
                    begin
                        $display("Execute - AUIPC");
                    end

                    default: // ALUIPC
                    begin;
                        $display("Execute - ALUIPC");
                    end
                endcase
            end

            6'b111110:
            begin

                case (instr_sel)
                    6'b000000: // JIALC
                    begin
                        $display("Execute - JIALC");
                    end
                    default: // BNEZC
                    begin
                        $display("Execute - BNEZC");
                    end
                endcase
            end

            default:
            begin
                $display("Invalid Instruction Encoding");
            end
        endcase
    end
end

endmodule
