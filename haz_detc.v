////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Hazard Unit
// Description: Detects data hazards and controls pipeline stalls and flushes.
//              Handles load-use and branch hazards.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module hazard_unit (
    input  wire [4:0] RsD, RtD, RtE,
    input  wire        MemtoRegE,
    input  wire        MemtoRegM,
    input  wire        branchD,
    input  wire        RegWriteE,
    input  wire [4:0]  write_regE,
    input  wire [4:0]  write_regM,
    input  wire        jumpD,
    output reg         stallF,
    output reg         stallD,
    output reg         flushD,
    output reg         flushE
);
    always @(*) begin
        // defaults
        stallF = 0;
        stallD = 0;
        flushD = 0;
        flushE = 0;

        // Load-use hazard
        if (MemtoRegE && ((RtE == RsD) || (RtE == RtD))) begin
            stallF = 1;
            stallD = 1;
            flushE = 1;
        end

        // Branch hazard
        if (branchD) begin
            flushD = 1;
        end

        // Jump hazard
        if (jumpD)
            flushD = 1;
    end
endmodule