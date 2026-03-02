////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Sign Extend
// Description: Extends 16-bit immediate to 32-bit signed value.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module sign_extend (
    input  wire [15:0] in,
    output wire [31:0] out
);
    assign out = {{16{in[15]}}, in};
endmodule