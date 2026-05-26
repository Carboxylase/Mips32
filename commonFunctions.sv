function [31:0] signExtend
    (input [31:0] originalBits, [4:0] originalLen);
    reg signBit;
    static reg [31:0] flip = 32'hFFFF_FFFF;; // max value 32 bit
    begin
        signBit = originalBits[originalLen-1];

        flip = flip << originalLen;

        signExtend = flip | originalBits;

    end
endfunction