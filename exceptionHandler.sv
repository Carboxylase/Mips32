module exceptionHandler
(input wire [31:0] causeReg
input wire statusReg,
input wire [31:0] eBaseReg,
input wire hardwareHandle,
input wire [2:0] hardwareHandleCode,
output reg [31:0] epc);

reg [31:0] offset;
reg [31:0] base;

// need to add EPC

// general exception handling when status_EXL = 1 (involves hardware handling before going to new PC)
// general exceptions go into kernel mode

// other exceptions do not need to be in kernal mode
// however, exceptions can be triggered in kernel mode and may have different handling

//hardwareHandleCode: 000 = reset, 001 = soft reset, 010 = NMI, 011 = ejtag, 100 <= cache error

always @ (*)
begin
    
    // offset calc
    if (hardwareHandle)
    begin
        // handle the reset, soft reset, ejtag, cache error
        if (hardwareHandleCode >= 3'b100) // cache error
        begin
            offset = 32'h100;
        end
        else
        begin
            offset = 32'h000;
        end
    end
    else
    begin
        if (causeReg[6:2] == 5'h00)
        begin
            if (causeReg[23] == 1'b0)
            begin
                offset = 32'h180;
            end
            else
            begin
                offset = 32'h200;
            end
        end
        else if (causeReg[6:2] == 5'h02)
        begin
            if (stausReg[EXL] == 1'b0)
            begin
                offset = 32'h000;
            end
            else
            begin
                offset = 32'h180;
            end
        end
        else if (causeReg[6:2] == 5'h03)
        begin
            if (stausReg[EXL] == 1'b0)
            begin
                offset = 32'h000;
            end
            else
            begin
                offset = 32'h180;
            end
        end
        else // general exception handling
        begin
            offset = 32'h180;
        end
    end

    // base calc
    if (hardwareHandle)
    begin
        if (hardwareHandleCode <= 3'b010) // reset, soft reset, NMI
        begin
            base = 32'hBFC0_0000;
        end
        else if (hardwareHandleCode == 1'b011) // EJTAG
        begin
            // should add check for probe trap
            base = 32'hBFC0_0480;
        end
        else // Cache Error
        begin
            if (statusReg[22] == 1'b0) // BEV val
            begin
                base = {eBaseReg[31:30], 1'b1, eBaseReg[28:12], 12'b0};
            end
            else
            begin
                base = 32'hBFC0_0200;
            end
        end
    end
    else // General
    begin
        if (statusReg[22] == 1'b0) // BEV val
        begin
            base = {eBaseReg[31:12], 12'b0};
        end
        else
        begin
            base = 32'hBFC0_0200;
        end
    end

    // handle hardware handling
    if (hardwareHandle)
    begin
        if (hardwareHandleCode == 3'b000) // reset
        begin

        end
        else if (hardwareHandleCode == 3'b001) // soft rest
        begin

        end
        else if (hardwareHandleCode == 3'b010) // NMI
        begin

        end
        else if (hardwareHandleCode == 3'b011) // ejtag 
        begin

        end
        else // cache error
        begin

        end
    end

    // reassign the program counter
end
endmodule
