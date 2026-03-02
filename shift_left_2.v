//////////////////////////////////
///vaishnavi g h
///////////////////////////
// Shift left by 2 bits for branch offset
`timescale 1ns / 1ps
module shift_left_2 (
    input  wire [31:0] in,
    output wire [31:0] out
);
    assign out = {in[29:0], 2'b00};
endmodule

// Shift left by 2 bits for jump address (26?28)
`timescale 1ns / 1ps
module shift_left_jump (
    input  wire [25:0] in,
    output wire [27:0] out
);
    assign out = {in, 2'b00};
endmodule