`timescale 1 ns/ 10 ps // time unit / time precision

`include "commonFunctions.sv"

module decoder
(
input wire rst,
input wire [31:0] fetched_instruction,
output reg [5:0] opcode,
output reg [5:0] instr_sel,
output reg [4:0] rs,
output reg [4:0] rt,
output reg [4:0] rd,
output reg [4:0] sa,
output reg [19:0] code,
output reg [4:0] base,
output reg [31:0] offset,
output reg [25:0] instr_index,
output reg signed [31:0] immediate,
output reg [2:0] mc0_sel,
output reg [1:0] bp,
output reg [4:0] msdb,
output reg [4:0] lsb,
output reg [1:0] i_type);

// register descriptions
// opcode is the bits [31:26] of the fethed instruction
// instr_sel will be used as a secondary flag (after the opcode) to tell what the execute module needs to do
// rs, rt, rd are the operand registers - this will be a value from 0 - 31
// sa is the shift amount
// signed = 1 => signed, signed = 0 => unsigned
// code is some error code (ie breakpoint exception)

// the output should the be registers used, and some mux selection bits to tell which execution unit need to run

// look into sign extending the immediate value to a 32 bit val instead of 0 extending to 19 bits

initial
begin
    opcode = 6'b000000; // initialize the instruciton as NOP/SLL
    instr_sel = 6'b001010; // initialize the instruction as NOP/SLL
    rs = 5'b0;
    rt = 5'b0;
    rd = 5'b0;
    sa = 5'b0;
    code = 20'b0;
    base = 5'b0;
    offset = 32'b0;
    instr_index = 26'b0;
    immediate = 32'b0;
    mc0_sel = 3'b0;
    bp = 2'b0;
    msdb = 5'b0;
    lsb = 5'b0;
    i_type = 2'b0;
end

always @(*)
begin
    if (!rst)
    begin

        opcode = 6'b0;
        instr_sel = 6'b001011; // NOP
        rs = 5'b0;
        rt = 5'b0;
        rd = 5'b0;
        sa = 5'b0;
        code = 20'b0;
        base = 5'b0;
        offset = 32'b0;
        instr_index = 26'b0;
        immediate = 32'b0;
        mc0_sel = 3'b0;
        bp = 2'b0;
        msdb = 5'b0;
        lsb = 5'b0;
        i_type = 2'b0;

    end
    else
    begin

        opcode = fetched_instruction[31:26];

        // honestly looks like rs, rt, and rd will always be [25:21], [20:16], and [15:11] respectively
        // so we can just always set those registers to be thosw fields

        rs = fetched_instruction[25:21];
        rt = fetched_instruction[20:16];
        rd = fetched_instruction[15:11];

        case(fetched_instruction[31:26])
            6'b000000: 
            begin
                case(fetched_instruction[5:0])
                    6'b100000: // ADD
                    begin
                        instr_sel = 6'b000000;
                        $display("Decoder - ADD");
                    end

                    6'b100001: // ADDU
                    begin
                        instr_sel = 6'b000001;
                        $display("Decoder - ADDU");
                    end

                    6'b100100: // AND
                    begin
                        instr_sel = 6'b000010;
                        $display("Decoder - AND");
                    end
                    6'b001101: // BREAK
                    begin
                        instr_sel = 6'b000011;
                        code = fetched_instruction[25:6];
                        $display("Decoder - BREAK");
                    end

                    6'b010001: // CLO
                    begin
                        instr_sel = 6'b000100;
                        $display("Decoder - CLO");
                    end

                    6'b010000: // CLZ
                    begin
                        instr_sel = 6'b000101;
                        $display("Decoder - CLZ");
                    end

                    6'b011010: // DIV, MOD
                    begin
                        case(fetched_instruction[10:6])
                            5'b0010: // DIV
                            begin
                                instr_sel = 6'b000110;
                                $display("Decoder - DIV");
                            end
                            default: // MOD
                            begin
                                instr_sel = 6'b000111;
                                $display("Decoder - MOD");
                            end
                        endcase
                    end

                    6'b011011: // DIVU, MODU
                    begin
                        case(fetched_instruction[10:6])
                            5'b0010: // DIVU
                            begin
                                instr_sel = 6'b001000;
                                $display("Decoder - DIVU");
                            end
                            default: // MODU
                            begin
                                instr_sel = 6'b001001;
                                $display("Decoder - MODU");
                            end
                        endcase
                    end

                    6'b000000: // EHB, NOP, PAUSE, SLL, SSNOP
                    begin
                        if (fetched_instruction[10:6] == 5'b00011)
                        begin
                            instr_sel = 6'b001010;
                            $display("Decoder - PAUSE - NOT IMPLEMENTED");
                        end
                        else // EHB, NOP, SSNOP are implemented as SLL in hardware
                        begin
                            instr_sel = 6'b001011;
                            sa = fetched_instruction[10:6];
                            $display("Decoder - SLL");
                        end

                    end

                    6'b001001: // JALR, JALR.HB, JR, JR.HB
                    begin
                        if (fetched_instruction[15:11] != 5'b00000) // JALR and JALR.HB
                        begin
                            if (fetched_instruction[10] == 1'b1) // JALR.HB
                            begin
                                instr_sel = 6'b001100;
                                $display("Decoder - JALR.HB");
                            end
                            else // JALR
                            begin
                                instr_sel = 6'b001101;
                                $display("Decoder - JALR");
                            end
                        end
                        else // JR and JR.HB
                        begin
                            if (fetched_instruction[10] == 1'b1) // JR.HB
                            begin
                                instr_sel = 6'b001110;
                                $display("Decoder - JR.HB");
                            end
                            else // JR
                            begin
                                instr_sel = 6'b001111;
                                $display("Decoder - JR");
                            end
                        end
                    end

                    6'b000101: // LSA
                    begin
                        instr_sel = 6'b010000;
                        sa = {3'b0, fetched_instruction[7:6]};
                        $display("Decoder - LSA");
                    end

                    6'b011000: // MUH, MUL
                    begin
                        case(fetched_instruction[10:6])
                            5'b00010: // MUL
                            begin
                                instr_sel = 6'b010001;
                                $display("Decoder - MUL");
                            end
                            default: // MUH
                            begin
                                instr_sel = 6'b010010;
                                $display("Decoder - MUH");
                            end
                        endcase
                    end

                    6'b011001: // MUHU, MULU
                    begin
                        case(fetched_instruction[10:6])
                            5'b00010: // MULU
                            begin
                                instr_sel = 6'b010011;
                                $display("Decoder - MULU");
                            end
                            default: // MUHU
                            begin
                                instr_sel = 6'b010100;
                                $display("Decoder - MUHU");
                            end
                        endcase
                    end

                    6'b100111: // NOR
                    begin
                        instr_sel = 6'b010101;
                        $display("Decoder - NOR");
                    end

                    6'b000010: // ROTR, SRL
                    begin
                        sa = fetched_instruction[10:6];

                        case(fetched_instruction[21])
                            1'b1: // ROTR
                            begin
                                instr_sel = 6'b010110;
                                $display("Decoder - ROTR");
                            end
                            default: // SRL
                            begin
                                instr_sel = 6'b010111;
                                $display("Decoder - SRL");
                            end
                        endcase
                    end

                    6'b000110: // ROTRV, SRLV
                    begin
                        case(fetched_instruction[6])
                            1'b1: // ROTRV
                            begin
                                instr_sel = 6'b011000;
                                $display("Decoder - ROTRV");
                            end
                            default: // SRLV
                            begin
                                instr_sel = 6'b011001;
                                $display("Decoder - SRLV");
                            end
                        endcase
                    end

                    6'b001110: // SDBBP
                    begin
                        instr_sel = 6'b011010;
                        code = fetched_instruction[25:6];
                        $display("Decoder - SDBBP");
                    end

                    6'b110101: // SELEQZ
                    begin
                        instr_sel = 6'b011011;
                        $display("Decoder - SELEQZ");
                    end

                    6'b110111: // SELNEZ
                    begin
                        instr_sel = 6'b011100;
                        $display("Decoder - SELNEZ");
                    end

                    6'b000100: // SLLV
                    begin
                        instr_sel = 6'b011101;
                        $display("Decoder - SLLV");
                    end

                    6'b101010: // SLT
                    begin
                        instr_sel = 6'b011110;
                        $display("Decoder - SLT");
                    end

                    6'b101011: // SLTU
                    begin
                        instr_sel = 6'b011111;
                        $display("Decoder - SLTU");
                    end

                    6'b000011: // SRA
                    begin
                        instr_sel = 6'b100000;
                        sa = fetched_instruction[10:6];
                        $display("Decoder - SRA");
                    end

                    6'b000111: // SRAV
                    begin
                        instr_sel = 6'b100001;
                        $display("Decoder - SRAV");
                    end

                    6'b100010: // SUB
                    begin
                        instr_sel = 6'b100010;
                        $display("Decoder - SUB");
                    end

                    6'b100011: // SUBU
                    begin
                        instr_sel = 6'b100011;
                        $display("Decoder - SUBU");
                    end

                    6'b001111: // SYNC
                    begin
                        instr_sel = 6'b100100;
                        $display("Decoder - SYNC - NOT IMPLEMENTED");
                    end

                    6'b001100: // SYSCALL
                    begin
                        instr_sel = 6'b100101;
                        code = fetched_instruction[25:6];
                        $display("Decoder - SYSCALL");
                    end

                    6'b110100: // TEQ
                    begin
                        instr_sel = 6'b100110;
                        code = {10'b0, fetched_instruction[15:6]};
                        $display("Decoder - TEQ");
                    end

                    6'b110000: // TGE
                    begin
                        instr_sel = 6'b100111;
                        code = {10'b0, fetched_instruction[15:6]};
                        $display("Decoder - TGE");
                    end

                    6'b110001: // TGEU
                    begin
                        instr_sel = 6'b101000;
                        code = {10'b0, fetched_instruction[15:6]};
                        $display("Decoder - TGEU");
                    end

                    6'b110010: // TLT
                    begin
                        instr_sel = 6'b101001;
                        code = {10'b0, fetched_instruction[15:6]};
                        $display("Decoder - TLT");
                    end 

                    6'b110011: // TLTU
                    begin
                        instr_sel = 6'b101010;
                        code = {10'b0, fetched_instruction[15:6]};
                        $display("Decoder - TLTU");
                    end

                    6'b110110: // TNE
                    begin
                        instr_sel = 6'b101011;
                        code = {10'b0, fetched_instruction[15:6]};
                        $display("Decoder - TNE");
                    end

                    6'b100110: // XOR
                    begin
                        instr_sel = 6'b101100;
                        $display("Decoder - XOR");
                    end

                    default: // OR
                    begin
                    instr_sel = 6'b101101; 
                    $display("Decoder - OR");
                    end

                endcase
            end

            6'b000001:
            begin
                case (fetched_instruction[20:16])
                    5'b10111: // SIGRIE
                    begin
                        instr_sel = 6'b000000;
                        code = {4'b0, fetched_instruction[15:0]};
                        $display("Decoder - SIGRIE");
                    end
                    5'b10001: // BAL
                    begin
                        instr_sel = 6'b000001;
                        offset = signExtend({16'b0, fetched_instruction[15:0]}, 16 );
                        $display("Decoder - BAL");
                    end
                    5'b00001: // BGEZ
                    begin
                        instr_sel = 6'b000010;
                        offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                        $display("Decoder - BGEZ");
                    end
                    5'b00000: // BLTZ
                    begin
                        instr_sel = 6'b000011;
                        offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                        $display("Decoder - BLTZ");
                    end
                    5'b10000: // NAL
                    begin
                        instr_sel = 6'b000100;
                        offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                        $display("Decoder - NAL");
                    end
                    default: // SYNCI
                    begin
                        instr_sel = 6'b000101;
                        offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                        $display("Decoder - SYNCI");
                    end
                endcase
            end

            6'b000010: // J
            begin
                instr_index = fetched_instruction[25:0];
                $display("Decoder - J");
            end

            6'b000011: // JAL
            begin
                instr_index = fetched_instruction[25:0];
                $display("Decoder - JAL");
            end

            6'b000100: // B, BEQ
            begin
                // B is implemented as BEQ
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - BEQ");
            end

            6'b000101: // BNE
            begin
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - BNE");
            end

            6'b000110: // BGEUC, BGEZALC, BLEUC, BLEZ, BLEZALC
            begin
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);

                if (fetched_instruction[25:21] != 5'b0 && fetched_instruction[20:16] != 5'b0) // BGEUC/BLEUC (idiom), BGEZALC
                begin
                    if (fetched_instruction[25:21] == fetched_instruction[20:16]) // BGEZALC
                    begin
                        instr_sel = 6'b000000;
                        $display("Decoder - BGEZALC");
                    end
                    else // BGEUC/BLEUC
                    begin
                        instr_sel = 6'b000001;
                        $display("Decoder - BGEUC/BLEUC");
                    end
                end    
                else if (fetched_instruction[25:21] == 5'b0) // BLEZALC
                begin
                    instr_sel = 6'b000010;
                    $display("Decoder - BLEZALC");
                end
                else // BLEZ
                begin
                    instr_sel = 6'b000011;
                    $display("Decoder - BLEZ");
                end
            end

            6'b000111: // BGTUC, BGTZ, BGTZALC, BLTUC, BLTZALC
            begin
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);

                if (fetched_instruction[25:21] != 5'b0 && fetched_instruction[20:16] != 5'b0) // BLTUC/BGTUC(idiom), BLTZALC
                begin
                    if (fetched_instruction[25:21] == fetched_instruction[20:16]) // BLTZALC
                    begin
                        instr_sel = 6'b000000;
                        $display("Decoder - BLTZALC");
                    end
                    else // BLTUC/BGTUC
                    begin
                        instr_sel = 6'b000001;
                        $display("Decoder - BLTUC/BGTUC");
                    end
                end
                else if (fetched_instruction[25:21] == 5'b0) // BGTZALC
                begin
                    instr_sel = 6'b000010;
                    $display("Decoder - BGTZALC");
                end
                else // BGTZ
                begin
                    instr_sel = 6'b000011;
                    $display("Decoder - BGTZ");
                end
            end

            6'b001000: // BEQC, BEQZALC, BOVC
            begin
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);

                if (fetched_instruction[25:21] >= fetched_instruction[20:16]) // BOVC
                begin
                    instr_sel = 6'b000000;
                    $display("Decoder - BOVC");
                end
                else
                begin
                    if (fetched_instruction[25:21] == 5'b0) // BEQZALC
                    begin
                        instr_sel = 6'b000001;
                        $display("Decoder - BEQZALC");
                    end
                    else // BEQC
                    begin
                        instr_sel = 6'b000010;
                        $display("Decoder - BEQC");
                    end
                end
            end

            6'b001001: // ADDIU
            begin
                immediate = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - ADDIU");

            end

            6'b001010: // SLTI
            begin
                immediate = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - SLTI");
            end

            6'b001011: // SLTIU
            begin
                immediate = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - SLTIU");
            end

            6'b001100: // ANDI
            begin
                immediate = {16'b0, fetched_instruction[15:0]}; // ANDI require imm to be zero extended
                $display("Decoder - ANDI");
            end

            6'b001101: // ORI
            begin
                immediate = {16'b0, fetched_instruction[15:0]}; // ORI requires imm to be zero extended
                $display("Decoder - ORI");
            end

            6'b001110: // XORI
            begin
                immediate = {16'b0, fetched_instruction[15:0]}; // XORI requires the imm to be zero extended
                $display("Decoder - XORI");
            end

            6'b001111: // AUI, LUI - LUI is an assembly idiom of AUI where rs = 0
            begin
                immediate = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - AUI");
            end

            6'b010000:
            begin
                mc0_sel = fetched_instruction[2:0];

                case (fetched_instruction[25])
                    1'b0:
                    begin
                        case (fetched_instruction[25:21])
                            5'b01011:
                            begin
                                case (fetched_instruction[5:0])
                                    6'b000000: // DI
                                    begin
                                        instr_sel = 6'b000000;
                                        $display("Decoder - DI");
                                    end

                                    6'b100100: // DIVP
                                    begin
                                        instr_sel = 6'b000001;
                                        $display("Decoder - DIVP");
                                    end

                                    6'b100000: // EI
                                    begin
                                        instr_sel = 6'b000010;
                                        $display("Decoder - EI");
                                    end

                                    default: // EVP
                                    begin
                                        instr_sel = 6'b000011;
                                        $display("Decoder - EVP");
                                    end
                                endcase
                                
                            end

                            5'b00000: // MFC0
                            begin
                                instr_sel = 6'b000100;
                                $display("Decoder - MFC0");
                            end

                            5'b00010: // MFHC0
                            begin
                                instr_sel = 6'b000101;
                                $display("Decoder - MFHC0");
                            end

                            5'b00100: // MTC0
                            begin
                                instr_sel = 6'b000110;
                                $display("Decoder - MTC0");
                            end

                            5'b00110: // MTHC0
                            begin
                                instr_sel = 6'b000111;
                                $display("Decoder - MTHC0");
                            end

                            5'b01010: // RDPGPR
                            begin
                                instr_sel = 6'b001000;
                                $display("Decoder - RDPGPR");
                            end

                            default: // WRPGPR
                            begin
                                instr_sel = 6'b001001;
                                $display("Decoder - WRPGPR");
                            end
                        endcase
                    end
                    default:
                    begin
                        case (fetched_instruction[5:0])
                            6'b011111: // DERET
                            begin
                                instr_sel = 6'b001010;
                                $display("Decoder - DERET");
                            end

                            6'b011000:
                            begin
                                case (fetched_instruction[6])
                                    1'b0: // ERET
                                    begin
                                        instr_sel = 6'b001011;
                                        $display("Decoder - ERET");
                                    end
                                    default: // ERETNC
                                    begin
                                        instr_sel = 6'b001100;
                                        $display("Decoder - ERETNC");
                                    end
                                endcase
                            end

                            6'b000011: // TLBINV
                            begin
                                instr_sel = 6'b001101;
                                $display("Decoder - TLBINV");
                            end

                            6'b000100: // TLBINVF
                            begin
                                instr_sel = 6'b001110;
                                $display("Decoder - TLBINVF");
                            end

                            6'b001000: // TLBP
                            begin
                                instr_sel = 6'b001111;
                                $display("Decoder - TLBP");
                            end

                            6'b000001: // TLBR
                            begin
                                instr_sel = 6'b010000;
                                $display("Decoder - TLBR");
                            end

                            6'b000010: // TLBWI
                            begin
                                instr_sel = 6'b010001;
                                $display("Decoder - TLBWI");
                            end

                            6'b000110: // TLBWR
                            begin
                                instr_sel = 6'b010010;
                                $display("Decoder - TLBWR");
                            end

                            default: // WAIT
                            begin
                                instr_sel = 6'b010011;
                                $display("Decoder - WAIT");
                            end
                        endcase
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

                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);

                if (fetched_instruction[25:21] != 5'b0 && fetched_instruction[20:16] != 5'b0)
                begin
                    if (fetched_instruction[25:21] != fetched_instruction[20:16]) // BGEC/BLEC
                    begin
                        instr_sel = 6'b000000;
                        $display("Decoder - BGEC/BLEC");
                    end
                    else // BGEZC
                    begin
                        instr_sel = 6'b000001;
                        $display("Decoder - BGEZC");
                    end
                end
                else if (fetched_instruction[25:21] == 5'b0) // BLEZC
                begin
                    instr_sel = 6'b000010;
                    $display("Decoder - BLEZC");
                end
                else // BLEZL
                begin
                    instr_sel = 6'b000011;
                    $display("Decoder - BLEZL");
                end
            end

            6'b010111: // BGTC, BGTZC, BGTZL, BLTC, BLTZC
            begin

                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);

                if (fetched_instruction[25:21] != 5'b0 && fetched_instruction[20:16] != 5'b0)
                begin
                    if (fetched_instruction[25:21] != fetched_instruction[20:16]) // BLTC/BGTC(idiom)
                    begin
                        instr_sel = 6'b000000;
                        $display("Decoder - BLTC/BGTC");
                    end
                    else // BLTZC
                    begin
                        instr_sel = 6'b000001;
                        $display("Decoder - BLTZC");
                    end
                end
                else if (fetched_instruction[25:21] == 5'b0) // BGTZC
                begin
                    instr_sel = 6'b000010;
                    $display("Decoder - BGTZC");
                end
                else // BGTZL
                begin
                    instr_sel = 6'b000011;
                    $display("Decoder - BGTZL");
                end
            end

            6'b011000: // BNEC, BNEZALC, BNVC
            begin

                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);

                if (fetched_instruction[25:21] < fetched_instruction[20:16])
                begin
                    if (fetched_instruction[25:21] != 5'b0) // BNEC
                    begin
                        instr_sel = 6'b000000;
                        $display("Decoder - BNEC");
                    end
                    else // BNEZALC
                    begin
                        instr_sel = 6'b000001;
                        $display("Decoder - BNEZALC");
                    end
                end
                else // BNVC
                begin
                    instr_sel = 6'b000010;
                    $display("Decoder - BNVC");
                end
            end

            6'b011111:
            begin
                bp = fetched_instruction[7:6];
                offset = signExtend({23'b0, fetched_instruction[15:7]}, 9);
                msdb = fetched_instruction[15:11];
                lsb = fetched_instruction[10:6];
                i_type = fetched_instruction[9:8];


                case (fetched_instruction[5:0])
                    6'b000000: // EXT
                    begin
                        instr_sel = 6'b000000;
                        $display("Decoder - EXT");
                    end

                    6'b000100: // INS
                    begin
                        instr_sel = 6'b000001;
                        $display("Decoder - INS");
                    end

                    6'b001111:
                    begin
                        case (fetched_instruction[8])
                            1'b0:
                            begin
                                case (fetched_instruction[7:6])
                                    2'b00: // CRC32B
                                    begin
                                        instr_sel = 6'b000010; 
                                        $display("Decoder - CRC32B");
                                    end

                                    2'b01: // CRC32H
                                    begin
                                        instr_sel = 6'b000011;
                                        $display("Decoder - CRC32H");
                                    end

                                    default: // CRC32W
                                    begin
                                        instr_sel = 6'b000100;
                                        $display("Decoder - CRC32W");
                                    end
                                endcase
                            end
                            default:
                            begin
                                case (fetched_instruction[7:6])
                                    2'b00: // CRC32CB
                                    begin
                                        instr_sel = 6'b000101;
                                        $display("Decoder - CRC32CB");
                                    end

                                    2'b01: // CRC32CH
                                    begin
                                        instr_sel = 6'b000110;
                                        $display("Decoder - CRC32CH");
                                    end

                                    default: // CRC32CW
                                    begin
                                        instr_sel = 6'b000111;
                                        $display("Decoder - CRC32CW");
                                    end
                                endcase  
                            end
                        endcase
                    end

                    6'b011011: // CACHEE
                    begin
                        instr_sel = 6'b001000;
                        $display("Decoder - CACHEE");
                    end

                    6'b011100: // SBE
                    begin
                        instr_sel = 6'b001001;
                        $display("Decoder - SBE");
                    end

                    6'b011101: // SHE
                    begin
                        instr_sel = 6'b001010;
                        $display("Decoder - SHE");
                    end

                    6'b011110:
                    begin
                        case (fetched_instruction[6])
                            1'b0: // SCE
                            begin
                                instr_sel = 6'b001011;
                                $display("Decoder - SCE");
                            end
                            default: // SCWPE
                            begin
                                instr_sel = 6'b001100;
                                $display("Decoder - SCWPE");
                            end
                        endcase
                    end

                    6'b011111: // SWE
                    begin
                        instr_sel = 6'b001101;
                        $display("Decoder - SWE");
                    end

                    6'b100000: 
                    begin
                        case (fetched_instruction[10:6])
                            5'b00000: // BITSWAP
                            begin
                                instr_sel = 6'b001110;
                                $display("Decoder - BITSWAP");
                            end

                            5'b10000: // SEB
                            begin
                                instr_sel = 6'b001111;
                                $display("Decoder - SEB");
                            end

                            5'b11000: // SEH
                            begin
                                instr_sel = 6'b010000;
                                $display("Decoder - SEH");
                            end

                            5'b00010: // WSBH
                            begin
                                instr_sel = 6'b010001;
                                $display("Decoder - WSBH");
                            end

                            default: // ALIGN
                            begin
                                instr_sel = 6'b010010;
                                $display("Decoder - ALIGN");
                            end
                        endcase
                    end

                    6'b100011: // PREFE
                    begin
                        instr_sel = 6'b010011;
                        $display("Decoder - PREFE");
                    end

                    6'b100101: // CACHE
                    begin
                        instr_sel = 6'b010100;
                        $display("Decoder - CACHE");
                    end

                    6'b100110:
                    begin
                        case (fetched_instruction[6])
                            1'b0: // SC
                            begin
                                instr_sel = 6'b010101;
                                $display("Decoder - SC");
                            end

                            default: // SCWP
                            begin
                                instr_sel = 6'b010110;
                                $display("Decoder - SCWP");
                            end
                        endcase
                    end

                    6'b101000: // LBUE
                    begin
                        instr_sel = 6'b010111;
                        $display("Decoder - LBUE");
                    end

                    6'b101001: // LHUE
                    begin
                        instr_sel = 6'b011000;
                        $display("Decoder - LHUE");
                    end

                    6'b101100: // LBE
                    begin
                        instr_sel = 6'b011001;
                        $display("Decoder - LBE");
                    end
                    
                    6'b101101: // LHE
                    begin
                        instr_sel = 6'b011010;
                        $display("Decoder - LHE");
                    end
                    
                    6'b101110:
                    begin
                        case (fetched_instruction[6])
                            1'b0: // LLE
                            begin
                                instr_sel = 6'b011011;
                                $display("Decoder - LLE");
                            end

                            default: // LLWPE
                            begin
                                instr_sel = 6'b011100;
                                $display("Decoder - LLWPE");
                            end
                        endcase
                    end

                    6'b101111: // LWE
                    begin
                        instr_sel = 6'b011101;
                        $display("Decoder - LWE");
                    end

                    6'b110101: // PREF
                    begin
                        instr_sel = 6'b011110;
                        $display("Decoder - PREF");
                    end

                    6'b110110:
                    begin
                        case (fetched_instruction[6])
                            1'b0: // LL
                            begin
                                instr_sel = 6'b011111;
                                $display("Decoder - LL");
                            end

                            default: // LLWP
                            begin
                                instr_sel = 6'b100000;
                                $display("Decoder - LLWP");
                            end
                        endcase
                    end

                    6'b111011: // RDHWR
                    begin
                        instr_sel = 6'b100001;
                        $display("Decoder - RDHWR");
                    end

                    default:
                    begin
                        case (fetched_instruction[7])
                            1'b0:
                            begin
                                instr_sel = 6'b100010;
                                $display("Decoder - GINVI");
                            end
                            
                            default:
                            begin
                                instr_sel = 6'b100011;
                                $display("Decoder - GINVT");
                            end
                        endcase
                    end
                endcase
            end

            6'b100000: // LB
            begin

                base = fetched_instruction[25:21];
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - LB");
            end

            6'b100001: // LH
            begin

                base = fetched_instruction[25:21];
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - LH");
            end

            6'b100011: // LW
            begin

                base = fetched_instruction[25:21];
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - LW");
            end

            6'b100100: // LBU
            begin

                base = fetched_instruction[25:21];
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - LBU");
            end

            6'b100101: // LHU
            begin

                base = fetched_instruction[25:21];
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - LHU");
            end

            6'b101000: // SB
            begin

                base = fetched_instruction[25:21];
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - SB");
            end

            6'b101001: // SH
            begin

                base = fetched_instruction[25:21];
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - SH");
            end

            6'b101011: // SW
            begin

                base = fetched_instruction[25:21];
                offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                $display("Decoder - SW");
            end

            6'b110010: // BC
            begin

                offset = signExtend({6'b0, fetched_instruction[25:0]}, 26);
                $display("Decoder - BC");
            end

            6'b110110:
            begin
                case (fetched_instruction[25:21])
                    5'b00000: // BEQZC
                    begin
                        offset = signExtend({11'b0, fetched_instruction[20:0]}, 21);
                        $display("Decoder - BEQZC");
                    end
                    default: // JIC
                    begin
                        offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                        $display("Decoder - JIC");
                    end
                endcase
            end

            6'b111010: // BALC
            begin

                offset = signExtend({6'b0, fetched_instruction[25:0]}, 26);
                $display("Decoder - BALC");
            end

            6'b111011: // ADDIUPC, ALUIPC, AUIPC, LWPC
            begin

                case (fetched_instruction[20:19])
                    2'b00: // ADDIUPC
                    begin
                        instr_sel = 6'b000000;
                        immediate = signExtend({13'b0, fetched_instruction[18:0]}, 19);
                        $display("Decoder - ADDIUPC");
                    end

                    2'b01: // LWPC
                    begin
                        instr_sel = 6'b000001;
                        offset = signExtend({13'b0, fetched_instruction[18:0]}, 19);
                        $display("Decoder - LWPC");
                    end

                    default:
                    begin

                        immediate = signExtend({16'b0, fetched_instruction[15:0]}, 16);

                        case (fetched_instruction[16])
                            1'b0: // AUIPC
                            begin
                                instr_sel = 6'b000010;
                                $display("Decoder - AUIPC");
                            end

                            default: // ALUIPC
                            begin
                                instr_sel = 6'b000011;
                                $display("Decoder - ALUIPC");
                            end
                        endcase
                    end
                endcase
            end

            6'b111110:
            begin

                case (fetched_instruction[25:21])
                    5'b00000: // JIALC
                    begin
                        instr_sel = 6'b000000;
                        offset = signExtend({16'b0, fetched_instruction[15:0]}, 16);
                        $display("Decoder - JIALC");
                    end
                    default: // BNEZC
                    begin
                        instr_sel = 6'b000001;
                        offset = signExtend({11'b0, fetched_instruction[20:0]}, 21);
                        $display("Decoder - BNEZC");
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
