////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Forwarding Unit
// Description: Resolves data hazards by forwarding results
//              from later pipeline stages to earlier ones.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module forward_unit (
    input  wire [4:0] RsD, RtD, RsE, RtE,
    input  wire [4:0] write_regM,
    input  wire        RegWriteM,
    input  wire [4:0] write_regW,
    input  wire        RegWriteW,
    output reg  [1:0]  forwardAE,
    output reg  [1:0]  forwardBE,
    output reg         forwardAD,
    output reg         forwardBD
);
    always @(*) begin
        // default
        forwardAE = 2'b00;
        forwardBE = 2'b00;
        forwardAD = 1'b0;
        forwardBD = 1'b0;

        // Execute stage forwarding
        if (RegWriteM && (write_regM != 0) && (write_regM == RsE))
            forwardAE = 2'b10;
        else if (RegWriteW && (write_regW != 0) && (write_regW == RsE))
            forwardAE = 2'b01;

        if (RegWriteM && (write_regM != 0) && (write_regM == RtE))
            forwardBE = 2'b10;
        else if (RegWriteW && (write_regW != 0) && (write_regW == RtE))
            forwardBE = 2'b01;

        // Decode stage forwarding (for branch)
        if (RegWriteM && (write_regM != 0) && (write_regM == RsD))
            forwardAD = 1'b1;
        if (RegWriteM && (write_regM != 0) && (write_regM == RtD))
            forwardBD = 1'b1;
    end
endmodule