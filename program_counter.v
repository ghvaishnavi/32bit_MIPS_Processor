////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Program Counter (PC)
// Description: Holds the address of the next instruction.
//              Active-low asynchronous reset, updates when stall = 0.
////////////////////////////////////////////////
module PC (
    input  wire        clk,
    input  wire        rst_n,     // active-low reset
    input  wire        stall,     // 0 = update, 1 = hold
    input  wire [31:0] pc_in,
    output reg  [31:0] pc_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc_out <= 32'b0;
        else if (!stall)
            pc_out <= pc_in;
    end
endmodule