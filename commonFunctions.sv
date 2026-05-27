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
