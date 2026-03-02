//////////////////////////////////
///vaishnavi g h
///////////////////////////


`timescale 1ns / 1ps
module mux3_1 #(
    parameter DATA_WIDTH = 32
)(
    input  wire [DATA_WIDTH-1:0] in0,
    input  wire [DATA_WIDTH-1:0] in1,
    input  wire [DATA_WIDTH-1:0] in2,
    input  wire [1:0]            sel,
    output reg  [DATA_WIDTH-1:0] out
);
    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            default: out = in0;
        endcase
    end
endmodule