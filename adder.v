////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Adder
// Description: Performs 32-bit addition operation.
//              Used to compute PC + 4 and branch target addresses
//              in the MIPS pipeline.
////////////////////////////////////////////////



`timescale 1ns / 1ps
module adder (
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] sum
);
    assign sum = a + b;
endmodule