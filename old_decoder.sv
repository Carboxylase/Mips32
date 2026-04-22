module decoder
(input wire clk,
input wire [5:0] opcode,
input wire [5:0] b5_0,
input wire [5:0] b10_6,
input wire [4:0] rs,fetched_instruction[5:0]
input wire [4:0] rt,
input wire [4:0] rd,
input wire [4:0] sa,
input wire [19:0] code,
input wire [5:0] base,
input wire [15:0] offset);

// register descriptions
// opcode is the bits [31:26] of the fethed instruction
// b5_0 is the bits [5:0] of the fetched instruction
// b10_6 is the bits [10:6] of the fetched instruction
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

    opcode <= opcode;
    l6 <= fetched_instruction[5:0];

    // honestly looks like rs, rt, and rd will always be [25:21], [20:16], and [15:11] respectively
    // so we can just always set those registers to be thosw fields

    case(opcode)
        6'b000000: 
        begin
            case(b5_0)
                6'b100000: // ADD
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b100001: // ADDU
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b100100: // AND
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b001101: // BREAK
                begin
                    code <= fetched_instruction[25:6];
                end

                6'b010001: // CLO
                begin
                    rs <= fetched_instruction[25:21];
                    rd <= fetched_instruction[15:11];
                end

                6'b010000: // CLZ
                begin
                    rs <= fetched_instruction[25:21];
                    rd <= fetched_instruction[15:11];
                end

                6'b011010: // DIV, MOD
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b011011: // DIVU, MODU
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b000000: // EHB, NOP, PAUSE, SLL, SSNOP
                begin
                    if (fetched_instruction[10:6] == 5'b00011)
                    begin
                        $$display("PAUSE - not implemented yet");
                    end
                    else // EHB, NOP, SSNOP are implemented as SLL in hardware
                    begin
                        rt <= fetched_instruction[20:16];
                        rd <= fetched_instruction[15:11];
                        sa <= fetched_instruction[10:6];
                    end

                end

                6'b001001: // JALR, JALR.HB, JR, JR.HB
                begin
                    if (fetched_instruction[15:11] != 5'b00000) // JALR and JALR.HB
                    begin
                        if (fetched_instruction[10] == 1'b1) // JALR.HB
                        begin
                            $display("JALR.HB"); 
                        end
                        else // JALR
                        begin
                            $display("JALR");
                        end
                    end
                    else // JR and JR.HB
                    begin
                        if (fetched_instruction[10] == 1'b1) // JR.HB
                        begin
                            $display("JR.HB");
                        end
                        else // JR
                        begin
                            $display("JR");
                        end
                    end
                end

                6'b000101: // LSA
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                    sa <= {3'b0, fetched_instruction[7:6]};
                end

                6'b011000: // MUH, MUL
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b011001: // MUHU, MULU
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b100111: // NOR
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b000010: // ROTR, SRL
                begin
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                    sa <= fetched_instruction[10:6];
                end

                6'b000110: // ROTRV, SRLV
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b001110: // SDBBP
                begin
                    code <= [25:6];
                end

                6'b110101: // SELEQZ
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b110111: // SELNEZ
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b000100: // SLLV
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b101010: // SLT
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b101011: // SLTU
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b000011: // SRA
                begin
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                    sa <= fetched_instruction[10:6];
                end

                6'b000111: // SRAV
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b100010: // SUB
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b100011: // SUBU
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b001111: // SYNC
                begin
                    $display("SYNC - Not Implemented");
                end

                6'b001100: // SYSCALL
                begin
                    code <= fetched_instruction[25:6];
                end

                6'b110100: // TEQ
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b110000: // TGE
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b110001: // TGEU
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b110010: // TLT
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    code <= {10'b0, fetched_instruction[15:6]};
                end 

                6'b110011: // TLTU
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b110110: // TNE
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    code <= {10'b0, fetched_instruction[15:6]};
                end

                6'b100110: // XOR
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

                6'b100101: // OR
                begin
                    rs <= fetched_instruction[25:21];
                    rt <= fetched_instruction[20:16];
                    rd <= fetched_instruction[15:11];
                end

            endcase
        end

        6'b000001:
        begin

        end

        6'b000010:
        begin

        end

        6'b000011:
        begin

        end

        6'b000100:
        begin

        end

        6'b000101:
        begin

        end

        6'b000110:
        begin

        end

        6'b000111:
        begin

        end

        6'b001000:
        begin

        end

        6'b001001:
        begin

        end

        6'b001010:
        begin

        end

        6'b001011:
        begin

        end

        6'b001100:
        begin

        end

        6'b001101:
        begin

        end

        6'b001110:
        begin

        end

        6'b001111:
        begin

        end

        6'b010000:
        begin

        end

        6'b010001:
        begin

        end

        6'b010010:
        begin

        end

        6'b010110:
        begin

        end

        6'b010111:
        begin

        end

        6'b011000:
        begin

        end

        6'b011111:
        begin

        end

        6'b100000:
        begin

        end

        6'b100001:
        begin

        end

        6'b100011:
        begin

        end

        6'b100100:
        begin

        end

        6'b100101:
        begin

        end

        6'b101000:
        begin
            
        end

        6'b101001:
        begin

        end

        6'b101011:
        begin

        end

        6'b110001:
        begin

        end

        6'b110010:
        begin

        end

        6'b110101:
        begin

        end

        6'b110110:
        begin

        end

        6'b111001:
        begin

        end

        6'b111010:
        begin

        end

        6'b111011:
        begin

        end

        6'b111101:
        begin

        end

        6'b111110:
        begin

        end

        default:
        begin

        end
    endcase
end

endmodule
