module dataMemory
#(parameter MEM_SIZE = 32)
(
    input wire clk,
    input wire [1:0] memAccessEnable,
    input wire [31:0] memAddr,
    input wire [1:0] accessLength,
    input wire [31:0] writeData,
    output reg [31:0] readData    
);

reg [31:0] dmem [2**MEM_SIZE-1:0]; 

// maybe make the write/read enable signal a 2 bit value
// where do nothing = 0 or 3 , write = 1, read = 2

// accessLength = 0 (Byte), accessLength = 1 (half), accesslength = 2/3 (word)

initial
begin
    integer i;
    for (i = 0; i < 2**MEM_SIZE; i = i + 1)
    begin
        dmem[i] = 32'b0;
    end
end

always @(posedge clk)
begin
    if (memAccessEnable == 1)
    begin
        if (accessLength == 0)
        begin
            dmem[memAddr][7:0] <= writeData[7:0]; 
            $display("Mem Access - Writing byte %h to data memory address %h", writeData[7:0], memAddr);
        end
        else if (accessLength == 1)
        begin
            dmem[memAddr][15:0] <= writeData[15:0];
            $display("Mem Access - Writing halfword %h to data memory address %h", writeData[15:0], memAddr);
        end
        else
        begin
            dmem[memAddr] <= writeData;
            $display("Mem Access - Writing word %h to data memory address %h", writeData, memAddr);
        end
    end
    else if (memAccessEnable == 2)
    begin
        if (accessLength == 0)
        begin
            readData <= {24'b0, dmem[memAddr][7:0]};
            $display("Mem Access - Reading byte %h from data memory address %h", dmem[memAddr][7:0], memAddr);
        end
        else if (accessLength == 1)
        begin
            readData <= {16'b0, dmem[memAddr][15:0]};
            $display("Mem Access - Reading halfword %h from data memory address %h", dmem[memAddr][15:0], memAddr);
        end
        else
        begin
            readData <= dmem[memAddr];
            $display("Mem Access - Reading word %h from data memory address %h", dmem[memAddr], memAddr);
        end
    end
    else
    begin
        $display("Mem Access - No memory access");
        ;
    end
end

endmodule
