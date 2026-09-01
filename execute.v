`timescale 1 ns/ 10 ps // time unit / time precision

// `include "commonFunctions.vh"

module execute
(
/* verilator lint_off UNUSEDSIGNAL */
input wire rst,
input wire [5:0] opcode,
input wire [5:0] instr_sel,
input wire [4:0] rs,
input wire [4:0] rt,
input wire [4:0] rd,
input wire signed [31:0] rs_data,
input wire signed [31:0] rt_data,
input wire signed [31:0] rd_data,
input wire [4:0] sa,
input wire [19:0] code,
input wire signed [31:0] base_data,
input wire signed [31:0] offset,
input wire [25:0] instr_index,
input wire signed [31:0] immediate,
input wire [2:0] mc0_sel,
input wire [1:0] bp,
input wire [4:0] msdb,
input wire [4:0] lsb,
input wire [1:0] i_type,
input wire [31:0] program_counter,
input wire [31:0] mulDivNumItIn,
input wire [63:0] mulDivResultIn,
input wire [64:0] boothOpIn,
input wire [5:0] boothNIn,
output reg [1:0] memAccessEnable,
output reg [31:0] memAddr,
output reg [1:0] accessLength,
output reg memAccessUnsigned,
output reg signed [31:0] executeOutput,
output reg [4:0] writebackReg,
output reg [31:0] program_counter_overwrite,
output reg overwritePcEnable,
output reg flush_decode,
output reg flush_execute,
output reg disableStall,
output reg [31:0] mulDivNumItOut,
output reg [63:0] mulDivResultOut,
output reg [64:0] boothOpOut,
output reg [5:0] boothNOut,
output reg exit
/* verilator lint_off UNUSEDSIGNAL */
);

`include "commonFunctions.vh"

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

reg signed [31:0] temp32BitVal1; // a temporary value for computations
reg signed [31:0] temp32BitVal2;
reg signed [32:0] temp33BitVal;
reg signed [63:0] mulDivResultTemp;
reg signed [31:0] mulDivMaxIt;
reg signed [31:0] mulDivIterator;
reg signed [64:0] boothOpTemp;
reg [5:0] boothNTemp;
// reg signed [31:0] mulDivNumIt;

initial
begin
    memAccessEnable = 2'b0;
    memAddr = 32'b0;
    accessLength = 2'b0;
    memAccessUnsigned = 1'b0;
    executeOutput = 32'b0;
    writebackReg = 5'b0;
    program_counter_overwrite = 32'b0;
    overwritePcEnable = 1'b0;
    flush_decode = 1'b1;
    flush_execute = 1'b1;
    disableStall = 1'b0;
    mulDivNumItOut = 32'b0;
    mulDivResultOut = 64'b0;
    boothOpOut = 65'b0;
    boothNOut = 6'b0;
    exit = 1'b1;

    temp32BitVal1 = 32'b0;
    temp32BitVal2 = 32'b0;
    temp33BitVal = 33'b0;
    boothOpTemp = 65'b0;
    boothNTemp = 6'b0;

    mulDivResultTemp = 64'b0;
    mulDivMaxIt = 32'b0;
    mulDivIterator = 32'b0;
    
    // mulDivNumIt = 32'b0;
end

always @(*)
begin
    if (!rst)
    begin
        memAccessEnable = 2'b0;
        memAddr = 32'b0;
        accessLength = 2'b0;
        memAccessUnsigned = 1'b0;
        executeOutput = 32'b0;
        writebackReg = 5'b0;
        program_counter_overwrite = 32'b0;
        overwritePcEnable = 1'b0;
        flush_decode = 1'b1; // reset the rst signal 
        flush_execute = 1'b1; // reset the rst signal 
        disableStall = 1'b0;
        mulDivNumItOut = 32'b0;
        mulDivResultOut = 64'b0;
        boothOpOut = 65'b0;
        boothNOut = 6'b0;
        exit = 1'b1;

        temp32BitVal1 = 32'b0;
        temp32BitVal2 = 32'b0;
        temp33BitVal = 33'b0;
        boothOpTemp = 65'b0;
        boothNTemp = 6'b0;

        mulDivResultTemp = 64'b0;
        mulDivMaxIt = 32'b0;
        mulDivIterator = 32'b0;
        
    end
    else
    begin
        memAccessEnable = 2'b0;
        memAddr = 32'b0;
        accessLength = 2'b0;
        executeOutput = 32'b0;
        writebackReg = 5'b0;
        // original reset ---------------------------------
        program_counter_overwrite = 32'b0;
        overwritePcEnable = 1'b0;
        flush_decode = 1'b1; // reset the rst signal
        flush_execute = 1'b1; // reset the rst signal 
        // ------------------------------------------------
        disableStall = 1'b0;
        mulDivNumItOut = 32'b0;
        mulDivResultOut = 64'b0;
        boothOpOut = 65'b0;
        boothNOut = 6'b0;
        exit = 1'b1;

        temp32BitVal1 = 32'b0;
        temp32BitVal2 = 32'b0;
        temp33BitVal = 33'b0;
        boothOpTemp = 65'b0;
        boothNTemp = 6'b0;

        mulDivResultTemp = 64'b0;
        mulDivMaxIt = 32'b0;
        mulDivIterator = 32'b0;

        case(opcode)
            6'b000000: 
            begin
                case(instr_sel)
                    6'b000000: // ADD
                    begin
                        $display("Execute - ADD");
                        temp32BitVal1 = rs_data + rt_data;
                        temp33BitVal = rs_data + rt_data;
                        if (temp32BitVal1 != temp33BitVal[31:0])
                        begin
                            // signal exception
                        end
                        else
                        begin
                            executeOutput = temp32BitVal1;
                            writebackReg = rd;
                        end
                    end

                    6'b000001: // ADDU
                    begin
                        $display("Execute - ADDU");
                        executeOutput = rs_data + rt_data;
                        writebackReg = rd;
                    end

                    6'b000010: // AND
                    begin
                        $display("Execute - AND");
                        executeOutput =  rs_data & rt_data;
                        writebackReg = rd;
                    end
                    6'b000011: // BREAK
                    begin
                        $display("Execute - BREAK");
                    end

                    6'b000100: // CLO
                    begin
                        $display("Execute - CLO");
                        executeOutput = countLeadingOnes(rs_data);
                        writebackReg = rd;
                    end

                    6'b000101: // CLZ
                    begin
                        $display("Execute - CLZ");
                        executeOutput = countLeadingZeros(rs_data);
                        writebackReg = rd;
                    end

// ----- BELOW IS PROBLEM -----

                    // 6'b000110: // DIV
                    // begin
                    //     $display("Execute - DIV");
                    //     executeOutput = rs_data / rt_data;
                    //     writebackReg = rd;
                    // end
                                
                    // 6'b000111: // MOD
                    // begin
                    //     $display("Execute - MOD");
                    //     executeOutput = rs_data % rt_data;
                    //     writebackReg = rd;
                    // end

                    // 6'b001000: // DIVU
                    // begin
                    //     $display("Execute - DIVU");
                    //     executeOutput = $unsigned(rs_data) / $unsigned(rt_data);
                    //     writebackReg = rd;
                    // end

                    // 6'b001001: // MODU
                    // begin
                    //     $display("Execute - MODU");
                    //     executeOutput = $unsigned(rs_data) / $unsigned(rt_data);
                    //     writebackReg = rd;
                    // end

// ----- ABOVE IS PROBLEM

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

                    6'b001100: // JALR.HB
                    begin
                        $display("Execute - JALR.HB");
                    end

                    6'b001101: // JALR
                    begin
                        $display("Execute - JALR");
                        executeOutput = program_counter + 8;
                        writebackReg = 31;

                        if (rs_data % 4 == 32'b0)
                        begin
                            program_counter_overwrite = rs_data;
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
                        else
                        begin
                            // trigger misaligned address exception
                        end
                    end
                    
                    6'b001110: // JR.HB
                    begin
                        $display("Execute - JR.HB");
                    end

                    6'b001111: // JR
                    begin
                        $display("Execute - JR");
                        if (rs_data%4 != 0)
                        begin
                            // throw exception
                            $display("Adress Misaligned Exception");
                        end
                        else
                        begin
                            executeOutput = program_counter + 8;
                            writebackReg = rd;

                            program_counter_overwrite = rs_data;
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
                    end

                    6'b010000: // LSA
                    begin
                        $display("Execute - LSA");
                        executeOutput = ((rs_data << sa) + rt_data);
                        writebackReg = rd;
                    end

                    6'b010001: // MUL
                    begin
                        $display("Execute - MUL");

                        // boothOpTemp = boothOpIn;
                        
                        // if (boothOpIn[1] == 1'b1 && boothOpIn[0] == 1'b0)
                        // begin
                        //     boothOpTemp[64:33] = boothOpIn[64:33] - rs_data;
                        //     boothOpOut = boothOpTemp >>> 1;
                        //     boothNOut = boothNIn - 1;
                        // end
                        // else if (boothOpIn[1] == 1'b0 && boothOpIn[0] == 1'b1)
                        // begin
                        //     boothOpTemp[64:33] = boothOpIn[64:33] + rs_data;
                        //     boothOpOut = boothOpTemp >>> 1;
                        //     boothNOut = boothNIn - 1;
                        // end
                        // else
                        // begin
                        //     boothOpOut = boothOpTemp >>> 1;
                        //     boothNOut = boothNIn - 1;
                        // end

                        // if (boothNOut == 6'b0)
                        // begin
                        //     executeOutput = boothOpOut[32:1];
                        //     writebackReg = rd;
                        //     boothOpOut = 65'b0;
                        //     disableStall = 1'b1;
                        // end
                        // else
                        // begin
                        //     disableStall = 1'b0;
                        // end

                        boothOpTemp = boothOpIn;
                        boothNTemp = boothNIn;

                        if (boothOpIn[1] == 1'b1 && boothOpIn[0] == 1'b0)
                        begin
                            boothOpTemp[64:33] = boothOpIn[64:33] - rs_data;
                            boothOpOut = boothOpTemp >>> 1;
                            boothNTemp = boothNIn - 1;
                        end
                        else if (boothOpIn[1] == 1'b0 && boothOpIn[0] == 1'b1)
                        begin
                            boothOpTemp[64:33] = boothOpIn[64:33] + rs_data;
                            boothOpOut = boothOpTemp >>> 1;
                            boothNTemp = boothNIn - 1;
                        end
                        else
                        begin
                            boothOpOut = boothOpTemp >>> 1;
                            boothNTemp = boothNIn - 1;
                        end

                        if (boothNTemp == 6'b0)
                        begin
                            executeOutput = boothOpOut[32:1];
                            writebackReg = rd;
                            boothOpOut = 65'b0;
                            disableStall = 1'b1;
                        end
                        else
                        begin
                            disableStall = 1'b0;
                        end

                        boothNOut = boothNTemp;

                    end

                    6'b010010: // MUH
                    begin
                        $display("Execute - MUH");

                        boothOpTemp = boothOpIn;
                        boothNTemp = boothNIn;

                        if (boothOpIn[1] == 1'b1 && boothOpIn[0] == 1'b0)
                        begin
                            boothOpTemp[64:33] = boothOpIn[64:33] - rs_data;
                            boothOpOut = boothOpTemp >>> 1;
                            boothNTemp = boothNIn - 1;
                        end
                        else if (boothOpIn[1] == 1'b0 && boothOpIn[0] == 1'b1)
                        begin
                            boothOpTemp[64:33] = boothOpIn[64:33] + rs_data;
                            boothOpOut = boothOpTemp >>> 1;
                            boothNTemp = boothNIn - 1;
                        end
                        else
                        begin
                            boothOpOut = boothOpTemp >>> 1;
                            boothNTemp = boothNIn - 1;
                        end

                        if (boothNTemp == 6'b0)
                        begin
                            executeOutput = boothOpOut[64:33];
                            writebackReg = rd;
                            boothOpOut = 65'b0;
                            disableStall = 1'b1;
                        end
                        else
                        begin
                            disableStall = 1'b0;
                        end

                        boothNOut = boothNTemp;
                        
                    end

//                     6'b010011: // MULU
//                     begin
//                         $display("Execute - MULU");
//                         executeOutput = $unsigned(rs_data) * $unsigned(rt_data);
//                         writebackReg = rd;
//                     end

//                     6'b010100: // MUHU
//                     begin
//                         $display("Execute - MUHU");
//                         executeOutput = $unsigned(rs_data) * $unsigned(rt_data);
//                         writebackReg = rd;
//                     end

                    6'b010101: // NOR
                    begin
                        $display("Execute - NOR");
                        executeOutput = ~(rs_data | rt_data);
                        writebackReg = rd;
                    end

                    6'b010110: // ROTR
                    begin
                        $display("Execute - ROTR");
                        temp32BitVal1 = rt_data >> sa;
                        temp32BitVal2 = rt_data << (32 - sa);
                        executeOutput = temp32BitVal1 + temp32BitVal2;
                        
                        writebackReg = rd;
                    end

                    6'b010111: // SRL
                    begin
                        $display("Execute - SRL");
                        executeOutput = rt_data >> sa;
                        writebackReg = rd;
                    end

                    6'b011000: // ROTRV
                    begin
                        $display("Execute - ROTRV");
                        temp32BitVal1 = rt_data >> rs_data[4:0];
                        temp32BitVal2 = rt_data << (32 - rs_data[4:0]);
                        executeOutput = temp32BitVal1 + temp32BitVal2;
                        
                        writebackReg = rd;
                    end

                    6'b011001: // SRLV
                    begin
                        $display("Execute - SRLV");
                        executeOutput = rt_data >> rs_data;
                        writebackReg = rd;
                    end

                    6'b011010: // SDBBP
                    begin
                        $display("Execute - SDBBP");
                    end

                    6'b011011: // SELEQZ
                    begin
                        $display("Execute - SELEQZ");
                        if (rt_data == 32'b0)
                        begin
                            executeOutput = rs_data;
                        end
                        else
                        begin
                            executeOutput = 32'b0;
                        end
                        
                        writebackReg = rd;
                    end

                    6'b011100: // SELNEZ
                    begin
                        $display("Execute - SELNEZ");
                        if (rt_data != 32'b0)
                        begin
                            executeOutput = rs_data;
                        end
                        else
                        begin
                            executeOutput = 32'b0;
                        end
                        
                        writebackReg = rd;
                    end

                    6'b011101: // SLLV
                    begin
                        $display("Execute - SLLV");

                        executeOutput = rt_data << rs_data[4:0]; // GPR[rt][31-s]->0 || 0^s
                        writebackReg = rd;
                        
                    end

                    6'b011110: // SLT
                    begin
                        $display("Execute - SLT");
                        if (rs_data < rt_data)
                        begin
                            executeOutput = 32'b1;
                        end
                        else
                        begin
                            executeOutput = 32'b0;
                        end
                        writebackReg = rd;
                        
                    end

                    6'b011111: // SLTU
                    begin
                        $display("Execute - SLTU");
                        if ($unsigned(rs_data) < $unsigned (rt_data))
                        begin
                            executeOutput = 32'b1;
                        end
                        else
                        begin
                            executeOutput = 32'b0;
                        end
                        writebackReg = rd;
                        
                    end

                    6'b100000: // SRA
                    begin
                        $display("Execute - SRA");
                        if (rt_data[31] == 1'b1)
                        begin
                            temp32BitVal1 = 32'hFFFF_FFFF;
                        end
                        else
                        begin
                            temp32BitVal1 = 32'b0;
                        end
                        
                       executeOutput = (temp32BitVal1 << (32 - sa)) + (rt_data >> sa);
                       writebackReg = rd;
                       
                    end

                    6'b100001: // SRAV
                    begin
                        $display("Execute - SRAV");
                        if (rt_data[31] == 1'b1)
                        begin
                            temp32BitVal1 = 32'hFFFF_FFFF;
                        end
                        else
                        begin
                            temp32BitVal1 = 32'b0;
                        end
                        
                       executeOutput = (temp32BitVal1 << (32 - rs_data[4:0])) + (rt_data >> rs_data[4:0]);
                       writebackReg = rd;
                       
                    end

                    6'b100010: // SUB
                    begin
                        $display("Execute - SUB");
                        temp32BitVal1 = rs_data - rt_data;
                        temp33BitVal = rs_data - rt_data;
                        if (temp32BitVal1 != temp33BitVal[31:0])
                        begin
                            // signal exception
                        end
                        else
                        begin
                            executeOutput = temp32BitVal1;
                            writebackReg = rd;
                        end
                    end

                    6'b100011: // SUBU
                    begin
                        $display("Execute - SUBU");
                        executeOutput = rs_data - rt_data; // Unsigned is misnomer
                        writebackReg = rd;
                    end

                    6'b100100: // SYNC
                    begin
                        $display("Execute - SYNC - NOT IMPLEMENTED");
                    end

                    6'b100101: // SYSCALL
                    begin
                        $display("Execute - SYSCALL");

                        // v0 will be rs_data
                        // a0 will be rt_data
                        // a1 will be rd_data

                        if (rs_data == 10)
                        begin
                            exit = 1'b0;
                        end
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
                        executeOutput = rs_data ^ rt_data;
                        writebackReg = rd;
                    end

                    default: // OR
                    begin
                        $display("Execute - OR");
                        executeOutput = rs_data | rt_data;
                        writebackReg = rd;
                    end

                endcase
            end

// ----- ^^ PROBLEM -----

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
                        program_counter_overwrite = program_counter + 4 + (offset << 2);
                        overwritePcEnable = 1'b1;
                        flush_decode = 1'b0;

                        executeOutput = program_counter + 8;
                        writebackReg = 5'b11111; // reg 31
                    end
                    6'b000010: // BGEZ
                    begin
                        $display("Execute - BGEZ");
                        if (rs_data >= $signed(32'b0))
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    6'b000011: // BLTZ
                    begin
                        $display("Execute - BLTZ");
                        if (rs_data < $signed(32'b0))
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
                    end
                    6'b000100: // NAL
                    begin
                        $display("Execute - NAL");
                        executeOutput = program_counter + 8;
                        writebackReg = 31;
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
                program_counter_overwrite = {program_counter[31:28], {2'b0, instr_index} << 2};
                overwritePcEnable = 1'b1;
                flush_decode = 1'b0;
            end

            6'b000011: // JAL
            begin
                $display("Execute - JAL");
                executeOutput = program_counter + 8;
                writebackReg = 31;

                program_counter_overwrite = {program_counter[31:28], {2'b0, instr_index} << 2};
                overwritePcEnable = 1'b1;
                flush_decode = 1'b0;
            end

            6'b000100: // B, BEQ
            begin
                // B is implemented as BEQ
                $display("Execute - BEQ");
                if (rs_data == rt_data)
                begin
                    $display("rt and rs are equal - branching");
                    program_counter_overwrite = program_counter + 4 + (offset << 2);
                    overwritePcEnable = 1;
                    flush_decode = 0; // 0 = flush instruction
                end
                else
                begin
                    // set the PC increment to zero
                    $display("rt and rs are not equal - not branching");
                    program_counter_overwrite = 32'b0;
                    overwritePcEnable = 0;
                end
            end

            6'b000101: // BNE
            begin
                $display("Execute - BNE");
                if (rs_data != rt_data)
                begin
                    program_counter_overwrite = program_counter + 4 + (offset << 2);
                    overwritePcEnable = 1'b1;
                    flush_decode = 1'b0;
                end
            end

            6'b000110: // BGEUC, BGEZALC, BLEUC, BLEZ, BLEZALC
            begin
                case (instr_sel)
                    6'b000000:
                    begin
                        $display("Execute - BGEZALC");
                        executeOutput = program_counter + 4;
                        writebackReg = 31;

                        if (rt_data >= $signed(32'b0))
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end

                    6'b000001: // BGEUC/BLEUC
                    begin
                        $display("Execute - BGEUC/BLEUC");
                        if ($unsigned(rs_data) >= $unsigned(rt_data))
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end

                    end

                    6'b000010:
                    begin
                        $display("Execute - BLEZALC");
                        executeOutput = program_counter + 4;
                        writebackReg = 31;

                        if (rt_data <= 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end

                    default: // BLEZ
                    begin
                        $display("Execute - BLEZ");
                        if (rs_data <= 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
                        else
                        begin

                        end
                    end
                endcase
            end

            6'b000111: // BGTUC, BGTZ, BGTZALC, BLTUC, BLTZALC
            begin
                case (instr_sel)
                    6'b000000:
                    begin
                        $display("Execute - BLTZALC");
                        executeOutput = program_counter + 4;
                        writebackReg = 31;

                        if (rt_data < $signed(32'b0))
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    6'b000001: // BLTUC/BGTUC
                    begin
                        $display("Execute - BLTUC/BGTUC");
                        if ($unsigned(rs_data) < $unsigned(rt_data))
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    6'b000010:
                    begin
                        $display("Execute - BGTZALC");
                        executeOutput = program_counter + 4;
                        writebackReg = 31;

                        if (rt_data > 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    default: // BGTZ
                    begin
                        $display("Execute - BGTZ");
                        if (rs_data > 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4  + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                endcase
            end

            6'b001000: // BEQC, BEQZALC, BOVC
            begin
                case (instr_sel)
                    6'b000000: // BOVC
                    begin
                        $display("Execute - BOVC");
                        temp32BitVal1 = rs_data + rt_data;
                        temp33BitVal = rs_data + rt_data;

                        if (temp32BitVal1 != temp33BitVal[31:0])
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
                    end
                    6'b000001: // BEQZALC
                    begin
                        $display("Execute - BEQZALC");
                        executeOutput = program_counter + 4;
                        writebackReg = 31;

                        if (rt_data == 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    default: // BEQC
                    begin
                        $display("Execute - BEQC");
                        if (rs_data == rt_data)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                endcase
            end

            6'b001001: // ADDIU
            begin
                $display("Execute - ADDIU");

                executeOutput = rs_data + immediate;
                writebackReg = rt;

            end

            6'b001010: // SLTI
            begin
                $display("Execute - SLTI");
                writebackReg = rt;
                if (rs_data < immediate)
                begin
                    executeOutput = 32'b1;
                end
                else
                begin
                    executeOutput = 32'b0;
                end
            end

            6'b001011: // SLTIU
            begin
                $display("Execute - SLTIU");
                writebackReg = rt;
                if($unsigned(rs_data) < $unsigned(immediate))
                begin
                    executeOutput = 32'b1;
                end
                else
                begin
                    executeOutput = 32'b0;
                end
            end

            6'b001100: // ANDI
            begin
                $display("Execute - ANDI");
                executeOutput = rs_data & immediate;
                writebackReg = rt;
            end

            6'b001101: // ORI
            begin
                $display("Execute - ORI");
                executeOutput = rs_data | immediate;
                writebackReg = rt;
            end

            6'b001110: // XORI
            begin
                $display("Execute - XORI");
                executeOutput = rs_data ^ immediate;
                writebackReg = rt;
            end

            6'b001111: // AUI, LUI - LUI is an assembly idiom of AUI where rs = 0
            begin
                $display("Execute - AUI");
                executeOutput = rs_data + (immediate << 16);
                writebackReg = rt;
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
                        if (rs_data >= rt_data)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                        
                    end
                    6'b000001: // BGEZC
                    begin
                        $display("Execute - BGEZC");
                        if (rt_data >= $signed(32'b0))
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    6'b000010:
                    begin
                        $display("Execute - BLEZC");
                        if (rt_data <= 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    default: // BLEZL
                    begin
                        $display("Execute - BLEZL");
                        if (rs_data <= 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 4);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                            flush_execute = 1'b0; // for some reason if the branch is NOT taken then the delay slot is not executed
                        end
                    end
                endcase
            end

            6'b010111: // BGTC, BGTZC, BGTZL, BLTC, BLTZC
            begin
                case (instr_sel)
                    6'b000000:
                    begin
                        $display("Execute - BLTC/BGTC");
                        if (rs_data < rt_data)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    6'b000001: // BLTZC
                    begin
                        $display("Execute - BLTZC");
                        if (rt_data < $signed(32'b0))
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    6'b000010:
                    begin
                        $display("Execute - BGTZC");
                        if (rt_data > 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    default: // BGTZL
                    begin
                        $display("Execute - BGTZL");
                        if (rs_data > 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 4);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                            flush_execute = 1'b0; // for some reason if the branch is NOT taken then the delay slot is not executed
                        end
                    end
                endcase
            end

            6'b011000: // BNEC, BNEZALC, BNVC
            begin
                case (instr_sel)
                    6'b000000:
                    begin
                        $display("Execute - BNEC");
                        if (rs_data != rt_data)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    6'b000001:
                    begin
                        $display("Execute - BNEZALC");
                        executeOutput = program_counter + 4;
                        writebackReg = 31;

                        if (rt_data != 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
                    end
                    default: // BNVC
                    begin
                        $display("Execute - BNVC");
                        temp32BitVal1 = rs_data + rt_data;
                        temp33BitVal = rs_data + rt_data;

                        if (temp32BitVal1 == temp33BitVal[31:0])
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                        end
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
                        executeOutput = CRC32(rt_data, rs_data, 1, 32'hEDB8_8320);
//                        writebackReg = rt;

                    end

                    6'b000011: // CRC32H
                    begin
                        $display("Execute - CRC32H");
                        executeOutput = CRC32(rt_data, rs_data, 2, 32'hEDB8_8320);
                        writebackReg = rt;
                    end

                    6'b000100: // CRC32W
                    begin
                        $display("Execute - CRC32W");
                        executeOutput = CRC32(rt_data, rs_data, 4, 32'hEDB8_8320);
                        writebackReg = rt;
                    end

                    6'b000101: // CRC32CB
                    begin
                        $display("Execute - CRC32CB");
                        executeOutput = CRC32(rt_data, rs_data, 1, 32'h82F6_3B78);
                        writebackReg = rt;
                    end

                    6'b000110: // CRC32CH
                    begin
                        $display("Execute - CRC32CH");
                        executeOutput = CRC32(rt_data, rs_data, 2, 32'h82F6_3B78);
                        writebackReg = rt;
                    end

                    6'b000111: // CRC32CW
                    begin
                        $display("Execute - CRC32CW");
                        executeOutput = CRC32(rt_data, rs_data, 4, 32'h82F6_3B78);
                        writebackReg = rt;
                    end

                    6'b001000: // CACHEE
                    begin
                        $display("Execute - CACHEE");
                    end

                    6'b001001: // SBE
                    begin
                        // to update
                        $display("Execute - SBE");
                        memAddr = offset + base_data; // vAddr
                        // maybe later do vAddr -> pAddr translation

                        accessLength = 0;
                        memAccessEnable = 1;
                        executeOutput = rt_data;
                    end

                    6'b001010: // SHE
                    begin
                        // to update
                        $display("Execute - SHE");
                        memAddr = offset + base_data;
                        accessLength = 1;
                        memAccessEnable = 1;
                        executeOutput = rt_data;
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
                        // to update
                        $display("Execute - SWE");
                        memAddr = offset + base_data;
                        accessLength = 2;
                        memAccessEnable = 1;
                        executeOutput = rt_data;
                    end

                    6'b001110: // BITSWAP
                    begin
                        $display("Execute - BITSWAP");
                        executeOutput = bitswap(rt_data);
                        writebackReg = rd;
                    end

                    6'b001111: // SEB
                    begin
                        $display("Execute - SEB");
                        executeOutput = signExtend({24'b0,rt_data[7:0]},8);
                        writebackReg = rd;
                    end

                    6'b010000: // SEH
                    begin
                        $display("Execute - SEH");
                        executeOutput = signExtend({16'b0,rt_data[15:0]},16);
                        writebackReg = rd;
                    end

                    6'b010001: // WSBH
                    begin
                        $display("Execute - WSBH");
                        executeOutput = swapHalfWords(rt_data);
                        writebackReg = rd;
                    end

                    6'b010010: // ALIGN
                    begin
                        $display("Execute - ALIGN");
                        executeOutput = (rt_data << (8*bp)) | (rs_data >> (32 - 8*bp));
                        writebackReg = rd;
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
                        // to update
                        memAddr = offset + base_data;
                        accessLength = 0;
                        memAccessEnable = 2;
                        memAccessUnsigned = 1;
                        writebackReg = rt;
                    end

                    6'b011000: // LHUE
                    begin
                        $display("Execute - LHUE");        
                        accessLength = 1;
                        memAccessEnable = 2;
                        memAccessUnsigned = 1;
                        writebackReg = rt;
                    end

                    6'b011001: // LBE
                    begin
                        $display("Execute - LBE");
                        memAddr = offset + base_data;
                        accessLength = 0;
                        memAccessEnable = 2;
                        memAccessUnsigned = 0;
                        writebackReg = rt;
                    end
                    
                    6'b011010: // LHE
                    begin
                        $display("Execute - LHE");
                        memAddr = offset + base_data;
                        accessLength = 1;
                        memAccessEnable = 2;
                        memAccessUnsigned = 0;
                        writebackReg = rt;
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
                        memAddr = offset + base_data;
                        accessLength = 2;
                        memAccessEnable = 2;
                        memAccessUnsigned = 0;
                        writebackReg = rt;
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
                memAccessUnsigned = 0;
                writebackReg = rt;

            end

            6'b100001: // LH
            begin
                $display("Execute - LH");

                memAddr = offset + base_data;
                accessLength = 1;
                memAccessEnable = 2;
                memAccessUnsigned = 0;
                writebackReg = rt;
            end

            6'b100011: // LW
            begin
                $display("Execute - LW");

                memAddr = offset + base_data;
                accessLength = 2;
                memAccessEnable = 2;
                memAccessUnsigned = 0;
                writebackReg = rt;
            end

            6'b100100: // LBU
            begin
                $display("Execute - LBU");
                memAddr = offset + base_data;
                accessLength = 0;
                memAccessEnable = 2;
                memAccessUnsigned = 1;
                writebackReg = rt;
            end

            6'b100101: // LHU
            begin
                $display("Execute - LHU");
                memAddr = offset + base_data;
                accessLength = 1;
                memAccessEnable = 2;
                memAccessUnsigned = 1;
                writebackReg = rt;
            end

            6'b101000: // SB
            begin
                $display("Execute - SB");
                memAddr = offset + base_data; // vAddr
                // maybe later do vAddr -> pAddr translation

                accessLength = 0;
                memAccessEnable = 1;
                executeOutput = rt_data;
            end

            6'b101001: // SH
            begin
                $display("Execute - SH");

                memAddr = offset + base_data;
                accessLength = 1;
                memAccessEnable = 1;
                executeOutput = rt_data;
            end

            6'b101011: // SW
            begin
                $display("Execute - SW");

                memAddr = offset + base_data;
                accessLength = 2;
                memAccessEnable = 1;
                executeOutput = rt_data;
            end

            6'b110010: // BC
            begin
                $display("Execute - BC");
                program_counter_overwrite = program_counter + 4 + (offset << 2);
                overwritePcEnable = 1'b1;
                flush_decode = 1'b0;
                flush_execute = 1'b0;
            end

            6'b110110:
            begin
                case (instr_sel)
                    6'b000000: // BEQZC
                    begin
                        $display("Execute - BEQZC");
                        if (rt_data == 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
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
                program_counter_overwrite = program_counter + 4 + (offset << 2);
                overwritePcEnable = 1'b1;
                flush_decode = 1'b0;
                flush_execute = 1'b0;

                executeOutput = program_counter + 4;
                writebackReg = 5'b11111; // reg 31

            end

            6'b111011: // ADDIUPC, ALUIPC, AUIPC, LWPC
            begin

                case (instr_sel)
                    6'b000000: // ADDIUPC
                    begin
                        $display("Execute - ADDIUPC");
                        executeOutput = program_counter + (immediate << 2);
                        writebackReg = rs;
                    end

                    6'b000001: // LWPC
                    begin
                        $display("Execute - LWPC");
                        memAddr = program_counter + (offset << 2);
                        accessLength = 2;
                        memAccessEnable = 2;
                        memAccessUnsigned = 0;
                        writebackReg = rt;

                    end

                    6'b000010: // AUIPC
                    begin
                        $display("Execute - AUIPC");
                        executeOutput = program_counter + (immediate << 16);
                        writebackReg = rs;
                    end

                    default: // ALUIPC
                    begin
                        $display("Execute - ALUIPC");
                        executeOutput = (~32'h0000_FFFF) & (program_counter + (immediate << 16));
                        writebackReg = rs;
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
                        if (rt_data != 32'b0)
                        begin
                            program_counter_overwrite = program_counter + 4 + (offset << 2);
                            overwritePcEnable = 1'b1;
                            flush_decode = 1'b0;
                            flush_execute = 1'b0;
                        end
                        else
                        begin
                            program_counter_overwrite = 32'b0;
                            overwritePcEnable = 1'b0;
                        end
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
