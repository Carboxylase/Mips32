module decoder
(input wire clk,
input wire [31:0] fetched_instruction,
output reg [5:0] opcode,
output reg [5:0] instr_sel,
output reg [4:0] rs,
output reg [4:0] rt,
output reg [4:0] rd,
output reg [4:0] sa,
output reg [19:0] code,
output reg [4:0] base,
output reg [25:0] offset,
output reg [25:0] instr_index,
output reg [18:0] immediate,
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

initial
begin

end

always @(posedge clk)
begin

    opcode <= fetched_instruction[31:26];

    // honestly looks like rs, rt, and rd will always be [25:21], [20:16], and [15:11] respectively
    // so we can just always set those registers to be thosw fields

    rs <= fetched_instruction[25:21];
    rt <= fetched_instruction[20:16];
    rd <= fetched_instruction[15:11];

    case(fetched_instruction[31:26])
        6'b000000: 
        begin
            case(fetched_instruction[5:0])
                6'b100000: // ADD
                begin
                    instr_sel <= 6'b000000;
                end

                6'b100001: // ADDU
                begin
                    instr_sel <= 6'b000001;
                end

                6'b100100: // AND
                begin
                    instr_sel <= 6'b000010;
                end
                6'b001101: // BREAK
                begin
                    instr_sel <= 6'b000011;
                    code <= fetched_instruction[25:6];
                end

                6'b010001: // CLO
                begin
                    instr_sel <= 6'b000100;
                end

                6'b010000: // CLZ
                begin
                    instr_sel <= 6'b000101;
                end

                6'b011010: // DIV, MOD
                begin
                    case(fetched_instruction[10:6])
                        5'b0010: // DIV
                        begin
                            instr_sel <= 6'b000110;
                        end
                        default: // MOD
                        begin
                            instr_sel <= 6'b000111;
                        end
                    endcase
                end

                6'b011011: // DIVU, MODU
                begin
                    case(fetched_instruction[10:6])
                        5'b0010: // DIVU
                        begin
                            instr_sel <= 6'b001000;
                        end
                        default: // MODU
                        begin
                            instr_sel <= 6'b001001;
                        end
                    endcase
                end

                6'b000000: // EHB, NOP, PAUSE, SLL, SSNOP
                begin
                    if (fetched_instruction[10:6] == 5'b00011)
                    begin
                        instr_sel <= 6'b001010;
                        $display("PAUSE - not implemented yet");
                    end
                    else // EHB, NOP, SSNOP are implemented as SLL in hardware
                    begin
                        instr_sel <= 6'b001011;
                        sa <= fetched_instruction[10:6];
                    end

                end

                6'b001001: // JALR, JALR.HB, JR, JR.HB
                begin
                    if (fetched_instruction[15:11] != 5'b00000) // JALR and JALR.HB
                    begin
                        if (fetched_instruction[10] == 1'b1) // JALR.HB
                        begin
                            instr_sel <= 6'b001100;
                            $display("JALR.HB"); 
                        end
                        else // JALR
                        begin
                            instr_sel <= 6'b001101;
                            $display("JALR");
                        end
                    end
                    else // JR and JR.HB
                    begin
                        if (fetched_instruction[10] == 1'b1) // JR.HB
                        begin
                            instr_sel <= 6'b001110;
                            $display("JR.HB");
                        end
                        else // JR
                        begin
                            instr_sel <= 6'b001111;
                            $display("JR");
                        end
                    end
                end

                6'b000101: // LSA
                begin
                    instr_sel <= 6'b010000;
                    sa <= {3'b0, fetched_instruction[7:6]};
                end

                6'b011000: // MUH, MUL
                begin
                    case(fetched_instruction[10:6])
                        5'b00010: // MUL
                        begin
                            instr_sel <= 6'b010001;
                        end
                        default: // MUH
                        begin
                            instr_sel <= 6'b010010;
                        end
                    endcase
                end

                6'b011001: // MUHU, MULU
                begin
                    case(fetched_instruction[10:6])
                        5'b00010: // MULU
                        begin
                            instr_sel <= 6'b010011;
                        end
                        default: // MUHU
                        begin
                            instr_sel <= 6'b010100;
                        end
                    endcase
                end

                6'b100111: // NOR
                begin
                    instr_sel <= 6'b010101;
                end

                6'b000010: // ROTR, SRL
                begin
                    sa <= fetched_instruction[10:6];

                    case(fetched_instruction[21])
                        1'b1: // ROTR
                        begin
                            instr_sel <= 6'b010110;
                        end
                        default: // SRL
                        begin
                            instr_sel <= 6'b010111;
                        end
                    endcase
                end

                6'b000110: // ROTRV, SRLV
                begin
                    case(fetched_instruction[6])
                        1'b1: // ROTRV
                        begin
                            instr_sel <= 6'b011000;
                        end
                        default: // SRLV
                        begin
                            instr_sel <= 6'b011001;
                        end
                    endcase
                end

                6'b001110: // SDBBP
                begin
                    instr_sel <= 6'b011010;
                    code <= fetched_instruction[25:6];
                end

                6'b110101: // SELEQZ
                begin
                    instr_sel <= 6'b011011;
                end

                6'b110111: // SELNEZ
                begin
                    instr_sel <= 6'b011100;
                end

                6'b000100: // SLLV
                begin
                    instr_sel <= 6'b011101;
                end

                6'b101010: // SLT
                begin
                    instr_sel <= 6'b011110;
                end

                6'b101011: // SLTU
                begin
                    instr_sel <= 6'b011111;
                end

                6'b000011: // SRA
                begin
                    instr_sel <= 6'b100000;
                    sa <= fetched_instruction[10:6];
                end

                6'b000111: // SRAV
                begin
                    instr_sel <= 6'b100001;
                end

                6'b100010: // SUB
                begin
                    instr_sel <= 6'b100010;
                end

                6'b100011: // SUBU
                begin
                    instr_sel <= 6'b100011;
                end

                6'b001111: // SYNC
                begin
                    instr_sel <= 6'b100100;
                    $display("SYNC - Not Implemented");
                end

                6'b001100: // SYSCALL
                begin
                    instr_sel <= 6'b100101;
                    code <= fetched_instruction[25:6];
                end

                6'b110100: // TEQ
                begin
                    instr_sel <= 6'b100110;
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b110000: // TGE
                begin
                    instr_sel <= 6'b100111;
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b110001: // TGEU
                begin
                    instr_sel <= 6'b101000;
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b110010: // TLT
                begin
                    instr_sel <= 6'b101001;
                    code <= {10'b0, fetched_instruction[15:6]};
                end 

                6'b110011: // TLTU
                begin
                    instr_sel <= 6'b101010;
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b110110: // TNE
                begin
                    instr_sel <= 6'b101011;
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b100110: // XOR
                begin
                    instr_sel <= 6'b101100;
                end

                default: // OR
                begin
                   instr_sel <= 6'b101101; 
                end

            endcase
        end

        6'b000001:
        begin
            case (fetched_instruction[20:16])
                5'b10111: // SIGRIE
                begin
                    instr_sel <= 6'b000000;
                    code <= {4'b0, fetched_instruction[15:0]};
                end
                5'b10001: // BAL
                begin
                    instr_sel <= 6'b000001;
                    offset <= {10'b0, fetched_instruction[15:0]};
                end
                5'b00001: // BGEZ
                begin
                    instr_sel <= 6'b000010;
                    offset <= {10'b0, fetched_instruction[15:0]};
                end
                5'b00000: // BLTZ
                begin
                    instr_sel <= 6'b000011;
                    offset <= {10'b0, fetched_instruction[15:0]};
                end
                5'b10000: // NAL
                begin
                    instr_sel <= 6'b000100;
                    offset <= {10'b0, fetched_instruction[15:0]};
                end
                default: // SYNCI
                begin
                    instr_sel <= 6'b000101;
                    offset <= {10'b0, fetched_instruction[15:0]};
                end
            endcase
        end

        6'b000010: // J
        begin
            instr_index <= fetched_instruction[25:0];
        end

        6'b000011: // JAL
        begin
            instr_index <= fetched_instruction[25:0];
        end

        6'b000100: // B, BEQ
        begin
            // B is implemented as BEQ
            offset <= {10'b0, fetched_instruction[15:0]};
        end

        6'b000101: // BNE
        begin
            offset <= {10'b0, fetched_instruction[15:0]};
        end

        6'b000110: // BGEUC, BGEZALC, BLEUC, BLEZ, BLEZALC
        begin
            offset <= {10'b0, fetched_instruction[15:0]};

            if (fetched_instruction[25:21] != 5'b0 && fetched_instruction[20:16] != 5'b0) // BGEUC/BLEUC (idiom), BGEZALC
            begin
                if (fetched_instruction[25:21] == fetched_instruction[20:16]) // BGEZALC
                begin
                    instr_sel <= 6'b000000;
                end
                else // BGEUC/BLEUC
                begin
                    instr_sel <= 6'b000001;
                end
            end    
            else if (fetched_instruction[25:21] == 5'b0) // BLEZALC
            begin
                instr_sel <= 6'b000010;
            end
            else // BLEZ
            begin
                instr_sel <= 6'b000011;
            end
        end

        6'b000111: // BGTUC, BGTZ, BGTZALC, BLTUC, BLTZALC
        begin
            offset <= {10'b0, fetched_instruction[15:0]};

            if (fetched_instruction[25:21] != 5'b0 && fetched_instruction[20:16] != 5'b0) // BLTUC/BGTUC(idiom), BLTZALC
            begin
                if (fetched_instruction[25:21] == fetched_instruction[20:16]) // BLTZALC
                begin
                    instr_sel <= 6'b000000;
                end
                else // BLTUC/BGTUC
                begin
                    instr_sel <= 6'b000001;
                end
            end
            else if (fetched_instruction[25:21] == 5'b0) // BGTZALC
            begin
                instr_sel <= 6'b000010;
            end
            else // BGTZ
            begin
                instr_sel <= 6'b000011;
            end
        end

        6'b001000: // BEQC, BEQZALC, BOVC BRO WTF
        begin
            offset <= {10'b0, fetched_instruction[15:0]};

            if (fetched_instruction[25:21] >= fetched_instruction[20:16]) // BOVC
            begin
                instr_sel <= 6'b000000;
            end
            else
            begin
                if (fetched_instruction[25:21] == 5'b0) // BEQZALC
                begin
                    instr_sel <= 6'b000001;
                end
                else // BEQC
                begin
                    instr_sel <= 6'b000010;
                end
            end
        end

        6'b001001: // ADDIU
        begin
            immediate <= {3'b0, fetched_instruction[15:0]};

        end

        6'b001010: // SLTI
        begin
            immediate <= {3'b0, fetched_instruction[15:0]};

        end

        6'b001011: // SLTIU
        begin
            immediate <= {3'b0, fetched_instruction[15:0]};

        end

        6'b001100: // ANDI
        begin
            immediate <= {3'b0, fetched_instruction[15:0]};

        end

        6'b001101: // ORI
        begin
            immediate <= {3'b0, fetched_instruction[15:0]};

        end

        6'b001110: // XORI
        begin
            immediate <= {3'b0, fetched_instruction[15:0]};

        end

        6'b001111: // AUI, LUI - LUI is an assembly idiom of AUI where rs = 0
        begin
            immediate <= {3'b0, fetched_instruction[15:0]};
            
        end

        6'b010000:
        begin
            mc0_sel <= fetched_instruction[2:0];

            case (fetched_instruction[25])
                1'b0:
                begin
                    case (fetched_instruction[25:21])
                        5'b01011:
                        begin
                            case (fetched_instruction[5:0])
                                6'b000000: // DI
                                begin
                                    instr_sel <= 6'b000000;
                                end

                                6'b100100: // DIVP
                                begin
                                    instr_sel <= 6'b000001;
                                end

                                6'b100000: // EI
                                begin
                                    instr_sel <= 6'b000010;
                                end

                                default: // EVP
                                begin
                                    instr_sel <= 6'b000011;
                                end
                            endcase
                            
                        end

                        5'b00000: // MFC0
                        begin
                            instr_sel <= 6'b000100;
                        end

                        5'b00010: // MFHC0
                        begin
                            instr_sel <= 6'b000101;
                        end

                        5'b00100: // MTC0
                        begin
                            instr_sel <= 6'b000110;
                        end

                        5'b00110: // MTHC0
                        begin
                            instr_sel <= 6'b000111;
                        end

                        5'b01010: // RDPGPR
                        begin
                            instr_sel <= 6'b001000;
                        end

                        default: // WRPGPR
                        begin
                            instr_sel <= 6'b001001;
                        end
                    endcase
                end
                default:
                begin
                    case (fetched_instruction[5:0])
                        6'b011111: // DERET
                        begin
                            instr_sel <= 6'b001010;
                        end

                        6'b011000:
                        begin
                            case (fetched_instruction[6])
                                1'b0: // ERET
                                begin
                                    instr_sel <= 6'b001011;
                                end
                                default: // ERETNC
                                begin
                                    instr_sel <= 6'b001100;
                                end
                            endcase
                        end

                        6'b000011: // TLBINV
                        begin
                            instr_sel <= 6'b001101;
                        end

                        6'b000100: // TLBINVF
                        begin
                            instr_sel <= 6'b001110;
                        end

                        6'b001000: // TLBP
                        begin
                            instr_sel <= 6'b001111;
                        end

                        6'b000001: // TLBR
                        begin
                            instr_sel <= 6'b010000;
                        end

                        6'b000010: // TLBWI
                        begin
                            instr_sel <= 6'b010001;
                        end

                        6'b000110: // TLBWR
                        begin
                            instr_sel <= 6'b010010;
                        end

                        default: // WAIT
                        begin
                            instr_sel <= 6'b010011;
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

            offset <= {10'b0, fetched_instruction[15:0]};

            if (fetched_instruction[25:21] != 5'b0 && fetched_instruction[20:16] != 5'b0)
            begin
                if (fetched_instruction[25:21] != fetched_instruction[20:16]) // BGEC/BLEC
                begin
                    instr_sel <= 6'b000000;
                end
                else // BGEZC
                begin
                    instr_sel <= 6'b000001;
                end
            end
            else if (fetched_instruction[25:21] == 5'b0) // BLEZC
            begin
                instr_sel <= 6'b000010;
            end
            else // BLEZL
            begin
                instr_sel <= 6'b000011;
            end
        end

        6'b010111: // BGTC, BGTZC, BGTZL, BLTC, BLTZC
        begin

            offset <= {10'b0, fetched_instruction[15:0]};

            if (fetched_instruction[25:21] != 5'b0 && fetched_instruction[20:16] != 5'b0)
            begin
                if (fetched_instruction[25:21] != fetched_instruction[20:16]) // BLTC/BGTC(idiom)
                begin
                    instr_sel <= 6'b000000;
                end
                else // BLTZC
                begin
                    instr_sel <= 6'b000001;
                end
            end
            else if (fetched_instruction[25:21] == 5'b0) // BGTZC
            begin
                instr_sel <= 6'b000010;
            end
            else // BGTZL
            begin
                instr_sel <= 6'b000011;
            end
        end

        6'b011000: // BNEC, BNEZALC, BNVC
        begin

            offset <= {10'b0, fetched_instruction[15:0]};

            if (fetched_instruction[25:21] < fetched_instruction[20:16])
            begin
                if (fetched_instruction[25:21] != 5'b0) // BNEC
                begin
                    instr_sel <= 6'b000000;
                end
                else // BNEZALC
                begin
                    instr_sel <= 6'b000001;
                end
            end
            else // BNVC
            begin
                instr_sel <= 6'b000010;
            end
        end

        6'b011111:
        begin
            bp <= fetched_instruction[7:6];
            offset <= {17'b0, fetched_instruction[15:7]};
            msdb <= fetched_instruction[15:11];
            lsb <= fetched_instruction[10:6];
            i_type <= fetched_instruction[9:8];


            case (fetched_instruction[5:0])
                6'b000000: // EXT
                begin
                    instr_sel <= 6'b000000;
                end

                6'b000100: // INS
                begin
                    instr_sel <= 6'b000001;
                end

                6'b001111:
                begin
                    case (fetched_instruction[8])
                        1'b0:
                        begin
                            case (fetched_instruction[7:6])
                                2'b00: // CRC32B
                                begin
                                    instr_sel <= 6'b000010; 
                                end

                                2'b01: // CRC32H
                                begin
                                    instr_sel <= 6'b000011;
                                end

                                default: // CRC32W
                                begin
                                    instr_sel <= 6'b000100;
                                end
                            endcase
                        end
                        default:
                        begin
                            case (fetched_instruction[7:6])
                                2'b00: // CRC32CB
                                begin
                                    instr_sel <= 6'b000101;
                                end

                                2'b01: // CRC32CH
                                begin
                                    instr_sel <= 6'b000110;
                                end

                                default: // CRC32CW
                                begin
                                    instr_sel <= 6'b000111;
                                end
                            endcase  
                        end
                    endcase
                end

                6'b011011: // CACHEE
                begin
                    instr_sel <= 6'b001000;
                end

                6'b011100: // SBE
                begin
                    instr_sel <= 6'b001001;
                end

                6'b011101: // SHE
                begin
                    instr_sel <= 6'b001010;
                end

                6'b011110:
                begin
                    case (fetched_instruction[6])
                        1'b0: // SCE
                        begin
                            instr_sel <= 6'b001011;
                        end
                        default: // SCWPE
                        begin
                            instr_sel <= 6'b001100;
                        end
                    endcase
                end

                6'b011111: // SWE
                begin
                    instr_sel <= 6'b001101;
                end

                6'b100000: 
                begin
                    case (fetched_instruction[10:6])
                        5'b00000: // BITSWAP
                        begin
                            instr_sel <= 6'b001110;
                        end

                        5'b10000: // SEB
                        begin
                            instr_sel <= 6'b001111;
                        end

                        5'b11000: // SEH
                        begin
                            instr_sel <= 6'b010000;
                        end

                        5'b00010: // WSBH
                        begin
                            instr_sel <= 6'b010001;
                        end

                        default: // ALIGN
                        begin
                            instr_sel <= 6'b010010;
                        end
                    endcase
                end

                6'b100011: // PREFE
                begin
                    instr_sel <= 6'b010011;
                end

                6'b100101: // CACHE
                begin
                    instr_sel <= 6'b010100;
                end

                6'b100110:
                begin
                    case (fetched_instruction[6])
                        1'b0: // SC
                        begin
                            instr_sel <= 6'b010101;
                        end

                        default: // SCWP
                        begin
                            instr_sel <= 6'b010110;
                        end
                    endcase
                end

                6'b101000: // LBUE
                begin
                    instr_sel <= 6'b010111;
                end

                6'b101001: // LHUE
                begin
                    instr_sel <= 6'b011000;
                end

                6'b101100: // LBE
                begin
                    instr_sel <= 6'b011001;
                end
                
                6'b101101: // LHE
                begin
                    instr_sel <= 6'b011010;
                end
                
                6'b101110:
                begin
                    case (fetched_instruction[6])
                        1'b0: // LLE
                        begin
                            instr_sel <= 6'b011011;
                        end

                        default: // LLWPE
                        begin
                            instr_sel <= 6'b011100;
                        end
                    endcase
                end

                6'b101111: // LWE
                begin
                    instr_sel <= 6'b011101;
                end

                6'b110101: // PREF
                begin
                    instr_sel <= 6'b011110;
                end

                6'b110110:
                begin
                    case (fetched_instruction[6])
                        1'b0: // LL
                        begin
                            instr_sel <= 6'b011111;
                        end

                        default: // LLWP
                        begin
                            instr_sel <= 6'b100000;
                        end
                    endcase
                end

                6'b111011: // RDHWR
                begin
                    instr_sel <= 6'b100001;
                end

                default:
                begin
                    case (fetched_instruction[7])
                        1'b0:
                        begin
                            instr_sel <= 6'b100010;
                        end
                        
                        default:
                        begin
                            instr_sel <= 6'b100011;
                        end
                    endcase
                end
            endcase
        end

        6'b100000: // LB
        begin

            base <= fetched_instruction[25:21];
            offset <= {10'b0, fetched_instruction[15:0]};

        end

        6'b100001: // LH
        begin

            base <= fetched_instruction[25:21];
            offset <= {10'b0, fetched_instruction[15:0]};

        end

        6'b100011: // LW
        begin

            base <= fetched_instruction[25:21];
            offset <= {10'b0, fetched_instruction[15:0]};

        end

        6'b100100: // LBU
        begin

            base <= fetched_instruction[25:21];
            offset <= {10'b0, fetched_instruction[15:0]};

        end

        6'b100101: // LHU
        begin

            base <= fetched_instruction[25:21];
            offset <= {10'b0, fetched_instruction[15:0]};

        end

        6'b101000: // SB
        begin

            base <= fetched_instruction[25:21];
            offset <= {10'b0, fetched_instruction[15:0]};

        end

        6'b101001: // SH
        begin

            base <= fetched_instruction[25:21];
            offset <= {10'b0, fetched_instruction[15:0]};

        end

        6'b101011: // SW
        begin

            base <= fetched_instruction[25:21];
            offset <= {10'b0, fetched_instruction[15:0]};

        end

        6'b110010: // BC
        begin

            offset <= fetched_instruction[25:0];

        end

        6'b110110:
        begin
            case (fetched_instruction[25:21])
                5'b00000: // BEQZC
                begin
                    offset <= {5'b0, fetched_instruction[20:0]};
                end
                default: // JIC
                begin
                    offset <= {10'b0, fetched_instruction[15:0]};
                end
            endcase
        end

        6'b111010: // BALC
        begin

            offset <= fetched_instruction[25:0];

        end

        6'b111011: // ADDIUPC, ALUIPC, AUIPC, LWPC
        begin

            case (fetched_instruction[20:19])
                2'b00: // ADDIUPC
                begin
                    instr_sel <= 6'b000000;
                    immediate <= fetched_instruction[18:0];
                end

                2'b01: // LWPC
                begin
                    instr_sel <= 6'b000001;
                    offset <= {7'b0, fetched_instruction[18:0]};
                end

                default:
                begin

                    immediate <= {3'b0, fetched_instruction[15:0]};

                    case (fetched_instruction[16])
                        1'b0: // AUIPC
                        begin
                            instr_sel <= 6'b000010;
                        end

                        default: // ALUIPC
                        begin
                            instr_sel <= 6'b000011;
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
                    instr_sel <= 6'b000000;
                    offset <= {10'b0, fetched_instruction[15:0]};
                end
                default: // BNEZC
                begin
                    instr_sel <= 6'b000001;
                    offset <= {5'b0, fetched_instruction[20:0]};
                end
            endcase
        end

        default:
        begin
            $display("Invalid Instruction Encoding");
        end
    endcase
end

endmodule
