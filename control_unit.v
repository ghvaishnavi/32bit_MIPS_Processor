////////////////////////////////////////////////
// By: Vaishnavi G H
// Block Name: Control Unit
// Description: Decodes opcode and funct fields to generate control signals.
//              Supports basic R-type, LW, SW, BEQ, and JUMP.
////////////////////////////////////////////////
`timescale 1ns / 1ps

module control_unit (
    input  wire [5:0] opcode,
    input  wire [5:0] funct,
    output reg        MemtoRegD,
    output reg        MemWriteD,
    output reg        branchD,
    output reg [2:0]  alu_controlD,
    output reg        alu_srcD,
    output reg        RegDstD,
    output reg        RegWriteD,
    output reg        jumpD
);
    always @(*) begin
        // default values
        MemtoRegD   = 0;
        MemWriteD   = 0;
        branchD     = 0;
        alu_controlD= 3'b010; // ADD
        alu_srcD    = 0;
        RegDstD     = 0;
        RegWriteD   = 0;
        jumpD       = 0;

        case (opcode)
            6'b000000: begin  // R-type
                RegWriteD   = 1;
                RegDstD     = 1;
                alu_srcD    = 0;
                case (funct)
                    6'b100000: alu_controlD = 3'b010; // ADD
                    6'b100010: alu_controlD = 3'b110; // SUB
                    6'b100100: alu_controlD = 3'b000; // AND
                    6'b100101: alu_controlD = 3'b001; // OR
                    6'b101010: alu_controlD = 3'b111; // SLT
                    default:   alu_controlD = 3'b010;
                endcase
            end

            6'b100011: begin // LW
                RegWriteD   = 1;
                MemtoRegD   = 1;
                alu_srcD    = 1;
                alu_controlD= 3'b010;
            end

            6'b101011: begin // SW
                MemWriteD   = 1;
                alu_srcD    = 1;
                alu_controlD= 3'b010;
            end

            6'b000100: begin // BEQ
                branchD     = 1;
                alu_controlD= 3'b110; // SUB
            end

            6'b000010: begin // JUMP
                jumpD       = 1;
            end
        endcase
    end
endmodule