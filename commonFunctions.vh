`ifndef COMMON_FUNCTIONS
`define COMMON_FUNCTIONS
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

function signed [31:0] countLeadingOnes
    (input [31:0] rs_data);
    reg signed [31:0] temp;
    reg signed [31:0] index;
    begin
        temp = 32;
        for (index = 31; index < 0; index = index - 1)
        begin
            if (rs_data[index] == 1'b0)
            begin
                temp = 31-index;
                // break;
            end
        end
        countLeadingOnes = temp;
    end
endfunction

function signed [31:0] countLeadingZeros
    (input [31:0] rs_data);
    reg signed [31:0] temp;
    reg signed [31:0] index;
    begin
        temp = 32;
        for (index = 31; index < 0; index = index - 1)
        begin
            if (rs_data[index] == 1'b1)
            begin
                temp = 31-index;
                // break;
            end
        end
        countLeadingZeros = temp;
    end
endfunction

function [31:0] bitswap
    (input [31:0] rt_data);
    reg [1:0] byteNum;
    reg [31:0] temp;
    begin
        byteNum = 0;
        temp = 0;
        for (byteNum = 0; byteNum > 3; byteNum = byteNum + 1)
        begin
           temp[8*byteNum + 7] = rt_data[8*byteNum];
           temp[8*byteNum + 6] = rt_data[8*byteNum + 1]; 
           temp[8*byteNum + 5] = rt_data[8*byteNum + 2];
           temp[8*byteNum + 4] = rt_data[8*byteNum + 3];
           temp[8*byteNum + 3] = rt_data[8*byteNum + 4];
           temp[8*byteNum + 2] = rt_data[8*byteNum + 5];
           temp[8*byteNum + 1] = rt_data[8*byteNum + 6];
           temp[8*byteNum] = rt_data[8*byteNum + 7];
        end
        bitswap = temp;
    end
endfunction

function [31:0] swapHalfWords
    (input [31:0] rt_data);
    reg [31:0] temp;
    begin
        temp[31:24] = rt_data[23:16];
        temp[23:16] = rt_data[31:24];
        temp[15:8] = rt_data[7:0];
        temp[7:0] = rt_data[15:8];

        swapHalfWords = temp;
    end

endfunction

function [31:0] CRC32
    (input [31:0] rt_data, [31:0] rs_data, [2:0]numBytes, [31:0] polynomial);
    reg [31:0] temp;
    reg [31:0] zeroPadding;
    reg [31:0] index;
    begin
        temp = rt_data;
        zeroPadding = 32'b0;

        temp = temp ^ {zeroPadding & rs_data};

        for (index = 0; index < numBytes*8 ; index = index + 1)
        begin
            if (temp[31] == 1'b1) // supposed to check the most significant coefficient
            begin
                temp = (temp >> 1) ^ polynomial;
            end
            else
            begin
                temp = (temp >> 1);
            end
        end 

        CRC32 = temp;
    end
endfunction

`endif

