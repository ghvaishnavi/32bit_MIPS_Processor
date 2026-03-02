////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Data Memory
// Description: 32-bit wide data memory (256 words).
//              Supports synchronous write and asynchronous read.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module data_memory (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        MemWriteM,
    input  wire [31:0] write_dataM,
    input  wire [31:0] addr,
    output wire [31:0] read_data
);
    reg [31:0] data_mem [0:255];
    integer i;

    // Reset memory
    always @(negedge rst_n) begin
        for (i = 0; i < 256; i = i + 1)
            data_mem[i] <= 32'b0;
    end

    // Write operation
    always @(posedge clk) begin
        if (MemWriteM)
            data_mem[addr[9:2]] <= write_dataM;
    end

    // Read operation (combinational)
    assign read_data = data_mem[addr[9:2]];
endmodule