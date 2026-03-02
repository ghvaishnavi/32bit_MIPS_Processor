////////////////////////////////////
///////vaishnvai g h///////////
////////////////////////////
`timescale 1ns / 1ps
module register_file (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [4:0]  rs,
    input  wire [4:0]  rt,
    input  wire [4:0]  rd,
    input  wire        we,          // write enable
    input  wire [31:0] wd,          // write data
    output wire [31:0] rd1,
    output wire [31:0] rd2
);
    reg [31:0] reg_array [0:31];
    integer i;

    // Initialize registers
    initial begin
        for (i = 0; i < 32; i = i + 1)
            reg_array[i] = 32'b0;
    end

    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                reg_array[i] <= 32'b0;
        end
        else if (we && (rd != 5'b00000))
            reg_array[rd] <= wd;
    end

    // Read operation
    assign rd1 = reg_array[rs];
    assign rd2 = reg_array[rt];
endmodule