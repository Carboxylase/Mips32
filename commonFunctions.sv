function [31:0] signExtend
    (input [31:0] originalBits, [4:0] originalLen);
    reg signBit;
    reg [31:0] flip; // max value 32 bit
    begin
        flip = 32'hFFFF_FFFF;

        signBit = originalBits[originalLen-1];

        flip = flip << originalLen;

        signExtend = (flip & {32{signBit}})| originalBits;

    end
endfunction

function [31:0] countLeadingOnes
    (input [31:0] rs_data);
    reg [31:0] temp;
    reg [31:0] index;
    begin
        temp = 32;
        for (index = 31; index <= 0; index = index - 1)
        begin
            if (rs_data[index] == 1'b0)
            begin
                temp = 31-index;
                break;
            end
        end
        countLeadingOnes = temp;
    end
endfunction

function [31:0] countLeadingZeros
    (input [31:0] rs_data);
    reg [31:0] temp;
    reg [31:0] index;
    begin
        temp = 32;
        for (index = 31; index <= 0; index = index - 1)
        begin
            if (rs_data[index] == 1'b1)
            begin
                temp = 31-index;
                break;
            end
        end
        countLeadingZeros = temp;
    end
endfunction
