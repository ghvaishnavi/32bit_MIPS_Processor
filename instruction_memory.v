//////////////////////////////////////
///vaishnavi g h////////////
///////////////////////////
`timescale 1ns / 1ps
module instruction_memory (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] pc_addr,
    output reg  [31:0] instruction
);
    reg [31:0] inst_mem [0:255];  // 256 x 32-bit

    initial begin
        $readmemh("instructions.mem", inst_mem);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            instruction <= 32'b0;
        else
            instruction <= inst_mem[pc_addr[9:2]]; // word-aligned
    end
endmodule