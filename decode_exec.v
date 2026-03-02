////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Decode_Execute
// Description: Pipeline register between Decode (ID) and Execute (EX)
//              stages. Stores register data, control signals, and
//              sign-extended immediate values for the ALU stage.
// Notes: Includes flush logic to clear control signals on hazards.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module decode_execute (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        flush,          // control from hazard unit

    // From Decode (D) stage
    input  wire [31:0] RD1_D,
    input  wire [31:0] RD2_D,
    input  wire [4:0]  RsD,
    input  wire [4:0]  RtD,
    input  wire [4:0]  RdD,
    input  wire [31:0] sign_imm_outD,
    input  wire        RegWriteD,
    input  wire        MemtoRegD,
    input  wire        MemWriteD,
    input  wire [2:0]  alu_controlD,
    input  wire        alu_srcD,
    input  wire        RegDstD,

    // To Execute (E) stage
    output reg [31:0]  RD1_E,
    output reg [31:0]  RD2_E,
    output reg [4:0]   RsE,
    output reg [4:0]   RtE,
    output reg [4:0]   RdE,
    output reg [31:0]  sign_imm_outE,
    output reg         RegWriteE,
    output reg         MemtoRegE,
    output reg         MemWriteE,
    output reg [2:0]   alu_controlE,
    output reg         alu_srcE,
    output reg         RegDstE
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            RD1_E         <= 32'b0;
            RD2_E         <= 32'b0;
            RsE           <= 5'b0;
            RtE           <= 5'b0;
            RdE           <= 5'b0;
            sign_imm_outE <= 32'b0;
            RegWriteE     <= 1'b0;
            MemtoRegE     <= 1'b0;
            MemWriteE     <= 1'b0;
            alu_controlE  <= 3'b000;
            alu_srcE      <= 1'b0;
            RegDstE       <= 1'b0;
        end 
        else if (flush) begin
            // On hazard or branch misprediction, clear control signals
            RegWriteE <= 1'b0;
            MemtoRegE <= 1'b0;
            MemWriteE <= 1'b0;
            alu_srcE  <= 1'b0;
            RegDstE   <= 1'b0;
        end 
        else begin
            RD1_E         <= RD1_D;
            RD2_E         <= RD2_D;
            RsE           <= RsD;
            RtE           <= RtD;
            RdE           <= RdD;
            sign_imm_outE <= sign_imm_outD;
            RegWriteE     <= RegWriteD;
            MemtoRegE     <= MemtoRegD;
            MemWriteE     <= MemWriteD;
            alu_controlE  <= alu_controlD;
            alu_srcE      <= alu_srcD;
            RegDstE       <= RegDstD;
        end
    end
endmodule