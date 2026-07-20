module TLB
#(  parameter TLB_SIZE = 16,
    parameter PABITS = 34) 
(   input wire [1:0] accessType,
    input wire [31:0] EntryHi,
    output reg [63:0] EntryLo0,
    output reg [63:0] EntryLo1);

// accessType: 0 = do nothing, 1 = read, 2 = write

// PABITS = 34 bits (not usi ng P)

reg [15:0] Mask [TLB_SIZE - 1:0];
reg [1:0] MaskX [TLB_SIZE - 1:0];

reg [] R [TLB_SIZE - 1:0];
reg [18:0] VPN2 [TLB_SIZE - 1:0];
reg [1:0] VPN2X [TLB_SIZE - 1:0];
reg [] G [TLB_SIZE - 1:0];
reg [7:0] ASID [TLB_SIZE - 1:0];

reg [22:0] PFNX [TLB_SIZE - 1:0];

reg RI0 [TLB_SIZE - 1:0];
reg XI0 [TLB_SIZE - 1:0];
reg [23:0] PFN0 [TLB_SIZE - 1:0];
reg [2:0] C0 [TLB_SIZE - 1:0];
reg D0 [TLB_SIZE - 1:0];
reg V0 [TLB_SIZE - 1:0];

reg RI1 [TLB_SIZE - 1:0];
reg XI1 [TLB_SIZE - 1:0];
reg [23:0] PFN1 [TLB_SIZE - 1:0];
reg [2:0] C1 [TLB_SIZE - 1:0];
reg D1 [TLB_SIZE - 1:0];
reg V1 [TLB_SIZE - 1:0];


//  31:13   12:11   10      9:8     7:0
//  VPN2    VPN2X   EHINV   ASIDX   ASID
// reg [31:0] EntryHi;

//  63:55   54:32   31  30  29:6    5:3     2   1   0
//  Fill    PFNX    RI  XI  PFN     C       D   V   G
// reg [63:0] EntryLo0;
// reg [63:0] EntryLo1;

//  31:29   28:13   12:11   10:0
//  0       Mask    MaskX   0
reg [31:0] PageMask;

reg found;
reg [31:0] tlbIndex;
reg [4:0] evenOddBit; 

initial
begin
    found = 1'b0;
    tlbIndex = 32'b0;
end

always @(*)
begin
    found = 1'b0;

    for (tlbIndex = 32'b0; tlbIndex < TLB_SIZE; tlbIndex = tlbIndex + 1)
    begin
        // supporting 1kb pages
        if ( ( {VPN2[tlbIndex], VPN2X[tlbIndex]} & ( ~ {3'b0, Mask[tlbIndex], MaskX[tlbIndex]} ) ) == ( EntryHi[31:11] & ( ~ {3'b0, Mask[tlbIndex], MaskX[tlbIndex]} ) ) )
        begin
            if ({Mask[tlbIndex],MaskX[tlbIndex]}[17:16] == 2'b11)
            begin
                evenOddBit = 28;
            end
            else if ({Mask[tlbIndex],MaskX[tlbIndex]}[15:14] == 2'b11)
            begin
                evenOddBit = 26;
            end
            else if ({Mask[tlbIndex],MaskX[tlbIndex]}[13:12] == 2'b11)
            begin
                evenOddBit = 24;
            end
            else if ({Mask[tlbIndex],MaskX[tlbIndex]}[11:10] == 2'b11)
            begin
                evenOddBit = 22;
            end
            else if ({Mask[tlbIndex],MaskX[tlbIndex]}[9:8] == 2'b11)
            begin
                evenOddBit = 20;
            end
            else if ({Mask[tlbIndex],MaskX[tlbIndex]}[7:6] == 2'b11)
            begin
                evenOddBit = 18;
            end
            else if ({Mask[tlbIndex],MaskX[tlbIndex]}[5:4] == 2'b11)
            begin
                evenOddBit = 16;
            end
            else if ({Mask[tlbIndex],MaskX[tlbIndex]}[3:2] == 2'b11)
            begin
                evenOddBit = 14;
            end
            else if ({Mask[tlbIndex],MaskX[tlbIndex]}[1:0] == 2'b11)
            begin
                evenOddBit = 12;
            end
            else if ({Mask[tlbIndex],MaskX[tlbIndex]}[1:0] == 2'b00)
            begin
                evenOddBit = 10;
            end
            else
            begin
                // SIGNAL EXCEPTION
            end

            if (EntryHi[evenOddBit] == 1'b0)
            begin
                EntryLo0[29:6] = PFN0[tlbIndex];
                EntryLo0[1] = V0[tlbIndex];
                EntryLo0[5:3] = C0[tlbIndex];
                EntryLo0[2] = D0[tlbIndex];
                // optionally add in XI and RI if some config regs are set

                if (V0[tlbIndex] == 1'b0)
                begin
                    // SIGNAL TLBINVALID EXCEPTION
                end
                if (D0[tlbIndex] == 1'b0 && accessType == 2'b10)
                begin
                    // SIGNAL TLBMODIFIED EXCEPTION
                end

                EntryLo0[29:6] = PFN0[tlbIndex];
                found = 1'b1; 
            end
            else
            begin
                EntryLo1[29:6] = PFN1[tlbIndex];
                EntryLo1[1] = V1[tlbIndex];
                EntryLo1[5:3] = C1[tlbIndex];
                EntryLo1[2] = D1[tlbIndex];
                // optionally add in XI and RI if some config regs are set

                if (V1[tlbIndex] == 1'b0)
                begin
                    // SIGNAL TLBINVALID EXCEPTION
                end
                if (D1[tlbIndex] == 1'b0 && accessType == 2'b10)
                begin
                    // SIGNAL TLBMODIFIED EXCEPTION
                end

                EntryLo1[29:6] = PFN1[tlbIndex];
                found = 1'b1;
                break;
            end
        end
    end
    if (found == 1'b0)
    begin
        // SIGNAL EXCEPTION
    end
end

endmodule
