////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Comparator
// Description: Compares two operands to check equality for branch decision.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module comparator (
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire        equal
);
    assign equal = (a == b);
endmodule