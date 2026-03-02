////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Memory_Writeback
// Description: Pipeline register between Memory and Writeback stages.
//              Passes ALU results or memory data and write register index.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module Memory_Writeback (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        RegWriteM,
    input  wire        MemtoRegM,
    input  wire [31:0] alu_resultM,
    input  wire [31:0] RD_M,
    input  wire [4:0]  write_regM,

    output reg         RegWriteW,
    output reg         MemtoRegW,
    output reg [31:0]  alu_resultW,
    output reg [31:0]  RD_W,
    output reg [4:0]   write_regW
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            RegWriteW   <= 0;
            MemtoRegW   <= 0;
            alu_resultW <= 0;
            RD_W        <= 0;
            write_regW  <= 0;
        end else begin
            RegWriteW   <= RegWriteM;
            MemtoRegW   <= MemtoRegM;
            alu_resultW <= alu_resultM;
            RD_W        <= RD_M;
            write_regW  <= write_regM;
        end
    end
endmodule