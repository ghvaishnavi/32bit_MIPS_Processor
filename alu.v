////////////////////////
///vaishnvai g h/////////
//////////////////////
`timescale 1ns / 1ps
module ALU (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [2:0]  control,
    output reg  [31:0] result
);
    always @(*) begin
        case (control)
            3'b000: result = A & B;       // AND
            3'b001: result = A | B;       // OR
            3'b010: result = A + B;       // ADD
            3'b110: result = A - B;       // SUB
            3'b111: result = (A < B) ? 1 : 0; // SLT
            default: result = 32'b0;
        endcase
    end
endmodule