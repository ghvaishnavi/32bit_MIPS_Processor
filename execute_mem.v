////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Execute_Mem
// Description: Pipeline register between Execute and Memory stages.
//              Stores ALU result, write register index, and control signals.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module Execute_Mem (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        RegWriteE,
    input  wire        MemtoRegE,
    input  wire        MemWriteE,
    input  wire [31:0] alu_resultE,
    input  wire [31:0] write_dataE,
    input  wire [4:0]  write_regE,

    output reg         RegWriteM,
    output reg         MemtoRegM,
    output reg         MemWriteM,
    output reg [31:0]  alu_resultM,
    output reg [31:0]  write_dataM,
    output reg [4:0]   write_regM
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            RegWriteM   <= 0;
            MemtoRegM   <= 0;
            MemWriteM   <= 0;
            alu_resultM <= 0;
            write_dataM <= 0;
            write_regM  <= 0;
        end else begin
            RegWriteM   <= RegWriteE;
            MemtoRegM   <= MemtoRegE;
            MemWriteM   <= MemWriteE;
            alu_resultM <= alu_resultE;
            write_dataM <= write_dataE;
            write_regM  <= write_regE;
        end
    end
endmodule