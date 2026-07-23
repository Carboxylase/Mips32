module cache
#(  parameter SET_SIZE_LEN = 2,
    parameter NUM_SETS_LEN = 10)
(   input wire [1:0] accessType,
    input wire [31:0] inData,
    input wire [9:0] vaOffset,
    input wire [7:0] inAsid,
    output reg [21:0] tag [SET_SIZE_LEN-1:0],
    output reg [31:0] outData [SET_SIZE_LEN-1:0]
    output reg [7:0] outAsid [SET_SIZE_LEN-1:0]);

// index the cache with vaOffset
// accessType: 00 = do nothing, 01 = write, 10 = read ,11 = update refCount

reg [21:0] cacheTag [NUM_SETS_LEN-1:0][SET_SIZE_LEN-1:0];
reg [31:0] cacheData [NUM_SETS_LEN-1:0][SET_SIZE_LEN-1:0];
reg [31:0] refCount [NUM_SETS_LEN-1:0][SET_SIZE_LEN-1:0]; // number of times an item is read
reg [7:0] asid [NUM_SETS_LEN-1:0][SET_SIZE_LEN-1:0];
reg valid [NUM_SETS_LEN-1:0][SET_SIZE_LEN-1:0];
reg dirty [NUM_SETS_LEN-1:0][SET_SIZE_LEN-1:0];
// reg [SET_SIZE_LEN-1:0] newestIndex [NUM_SETS_LEN-1:0]; // most recently placed item in cache

reg [SET_SIZE_LEN-1:0] setIndex;
reg [NUM_SETS_LEN-1:0] groupIndex;

reg [SET_SIZE_LEN-1:0] setIterator;

initial
begin
    setIndex = 0;
    groupIndex = 0;
    setIterator = 0;

    for (groupIndex = 0; groupIndex < ~(NUM_SETS_LEN'b0); groupIndex = groupIndex + 1)
    begin
        for (setIndex = 0; setIndex < ~(NUM_SIZE_LEN'b0); setIndex = setIndex + 1)
        begin
            cacheTag[groupIndex][setIndex] = 22'b0;
            cacheData[groupIndex][setIndex] = 32'b0;
            refCount[groupIndex][setIndex] = 32'b0;
            asid[groupIndex][setIndex] = 8'b0;
            valid[groupIndex][setIndex] = 1'b0;
            dirty[groupIndex][setIndex] = 1'b0;
        end
    end
end

always @ (*)
begin
    if (accessType == 1'b00) // do nothing
    begin
        tag = 21'b0;
        outData = 32'b0;
    end
    else if (accessType == 2'b01)
    begin
        // write data to cache

        // using the offset to selection the set-associative block, see if there is any line with
        // no valid data and write there
        // if all data is valid, kick out the data that is the least used
        setIterator = SET_SIZE_LEN'b0;
        foundInvalid = 1'b0;
        leastUsed = SET_SIZE_LEN'b0;

        for (setIndex = 0; setIndex <= ~(SET_SIZE_LEN'b0); setIndex = setIndex + 1)
        begin
            if (valid[vaOffset][setIterator] == 1'b0 && foundInvalid != 1'b1)
            begin
                cacheData[vaOffset][setIterator] = inData;
                foundInvalid = 1'b1;
            end
            if (setIterator != SET_SIZE_LEN'b0)
            begin
                if (refCount[vaOffset][setIterator] < refcount[vaOffset][setIterator - 1])
                begin
                    leastUsed = refCount[vaOffset][setIterator];
                end
                else
                begin
                    leastUsed = refCount[vaOffset][setIterator - 1];
                end
            end

            setIterator = setIterator + 1;
        end

        if (foundInvalid == 1'b0)
        begin
            cacheData[vaOffset][leastUsed] = inData;
        end
    end
    else if ()
    begin
        for (setIndex = 0; setIndex < SET_SIZE; setIndex = setIndex + 1) // send out all the data for tag matching
        begin
            tag[setIndex] = cacheTag[vaOffset][setIndex];
            outData[setIndex] = cacheData[vaOffset][setIndex];
            outAsid[setIndex] = outAsid[vaOffset][setIndex];
        end
    end
    else
    begin
        
    end

end

endmodule
