////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Fetch_Decode
// Description: Pipeline register between Instruction Fetch (IF)
//              and Instruction Decode (ID) stages. Stores fetched
//              instruction and PC+4 value.
// Notes: Supports stall and flush control from hazard unit.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module fetch_decode (
    input  wire        clk,             // system clock
    input  wire        rst_n,           // active-low reset
    input  wire        stall,           // stall from hazard unit
    input  wire        PCSrcD,          // branch taken signal
    input  wire        flush,           // flush control
    input  wire [31:0] instruction_in,  // instruction from IF
    input  wire [31:0] pc_plus4_in,     // PC + 4 value from IF
    output reg  [31:0] instruction_out, // instruction to ID
    output reg  [31:0] pc_plus4_out     // PC + 4 to ID
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            instruction_out <= 32'b0;
            pc_plus4_out    <= 32'b0;
        end 
        else if (flush) begin
            // Flush on branch/jump misprediction
            instruction_out <= 32'b0;
            pc_plus4_out    <= 32'b0;
        end 
        else if (!stall) begin
            instruction_out <= instruction_in;
            pc_plus4_out    <= pc_plus4_in;
        end
        // if stalled, hold current values
    end
endmodule