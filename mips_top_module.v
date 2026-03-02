`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:   Vaishnavi G H
// 
// Create Date: 02/03/2026
// Module Name: MIPS_Top
// Project Name: Pipelined MIPS Processor
// Description: Top-level wrapper connecting all five pipeline stages
//              (Fetch, Decode, Execute, Memory, Writeback) along with
//              forwarding and hazard units.
// 
// Notes: Renamed ports and signals for GitHub clarity and readability.
//
//////////////////////////////////////////////////////////////////////////////////

module MIPS_Top #(
    parameter DATA_WIDTH = 32
)(
    input  wire                     i_clk,          // System clock
    input  wire                     i_reset_n,      // Active-low reset
    output wire [DATA_WIDTH-1:0]    o_instructionF  // Current fetched instruction
);

    //----------------------------------------------
    // Internal Signals and Control Wires
    //----------------------------------------------
    // Register indices
    wire [4:0] w_writeRegE, w_writeRegM, w_writeRegW;
    wire [4:0] w_rsD, w_rtD, w_rdD, w_rsE, w_rtE, w_rdE;

    // PC and instruction buses
    wire [DATA_WIDTH-1:0] w_pcNext, w_pcBranchD, w_pcPlus4F, w_pcCurrent;
    wire [DATA_WIDTH-1:0] w_instD, w_pcPlus4D, w_pcSrcDMuxOut;

    // Data buses
    wire [DATA_WIDTH-1:0] w_writeDataE, w_writeDataM;
    wire [DATA_WIDTH-1:0] w_signImmD, w_signImmShiftedD;
    wire [DATA_WIDTH-1:0] w_rd2D, w_rd1D, w_rd1E, w_rd2E;
    wire [DATA_WIDTH-1:0] w_rd1D_muxOut, w_rd2D_muxOut;
    wire [DATA_WIDTH-1:0] w_srcAE, w_forwardB_muxOut, w_srcBE;
    wire [DATA_WIDTH-1:0] w_rdM, w_rdW, w_signImmE;
    wire [DATA_WIDTH-1:0] w_aluResultE, w_aluResultM, w_aluResultW, w_resultW;

    // Control and flags
    wire w_regWriteD, w_memToRegD, w_memWriteD, w_branchD, w_aluSrcD, w_regDstD, w_jumpD;
    wire [2:0] w_aluCtrlD, w_aluCtrlE;

    // Pipeline controls
    wire w_regWriteE, w_memToRegE, w_memWriteE, w_aluSrcE, w_regDstE;
    wire w_regWriteM, w_memToRegM, w_memWriteM, w_branchM, w_pcSrcD;
    wire w_regWriteW, w_memToRegW;

    // Hazard / Forwarding
    wire w_stallF, w_stallD, w_flushD, w_flushE;
    wire w_forwardAD, w_forwardBD, w_equalD;
    wire [1:0] w_forwardAE, w_forwardBE;

    //----------------------------------------------
    // Combinational Assignments
    //----------------------------------------------
    assign w_writeDataE = w_forwardB_muxOut;
    assign w_pcSrcD     = w_branchD & w_equalD;
    assign w_rsD        = w_instD[25:21];
    assign w_rtD        = w_instD[20:16];
    assign w_rdD        = w_instD[15:11];

    //----------------------------------------------
    // Program Counter and Next-PC Logic
    //----------------------------------------------
    mux u_pcSelect (
        .in0(w_pcPlus4F),
        .in1(w_pcBranchD),
        .sel(w_pcSrcD),
        .out(w_pcSrcDMuxOut)
    );

    wire [27:0] w_jumpAddress;
    shift_left_jump u_jumpShift (
        .in(w_instD[25:0]),
        .out(w_jumpAddress)
    );

    mux u_jumpMux (
        .in0(w_pcSrcDMuxOut),
        .in1({w_pcPlus4F[31:28], w_jumpAddress}),
        .sel(w_jumpD),
        .out(w_pcNext)
    );

    PC u_pc (
        .clk(i_clk),
        .rst_n(i_reset_n),
        .stall(w_stallF),
        .pc_in(w_pcNext),
        .pc_out(w_pcCurrent)
    );

    adder u_pcAdd4 (
        .a(w_pcCurrent),
        .b(32'd4),
        .sum(w_pcPlus4F)
    );

    //----------------------------------------------
    // Instruction Fetch Stage
    //----------------------------------------------
    instruction_memory u_instrMem (
        .clk(i_clk),
        .rst_n(i_reset_n),
        .pc_addr(w_pcCurrent),
        .instruction(o_instructionF)
    );

    //----------------------------------------------
    // Fetch ? Decode Register
    //----------------------------------------------
    fetch_decode u_FD (
        .clk(i_clk),
        .rst_n(i_reset_n),
        .stall(w_stallD),
        .PCSrcD(w_pcSrcD),
        .flush(w_flushD),
        .instruction_in(o_instructionF),
        .pc_plus4_in(w_pcPlus4F),
        .instruction_out(w_instD),
        .pc_plus4_out(w_pcPlus4D)
    );

    //----------------------------------------------
    // Decode Stage
    //----------------------------------------------
    sign_extend u_signExt (
        .in(w_instD[15:0]),
        .out(w_signImmD)
    );

    shift_left_2 u_shiftLeft2 (
        .in(w_signImmD),
        .out(w_signImmShiftedD)
    );

    adder u_branchAdder (
        .a(w_signImmShiftedD),
        .b(w_pcPlus4D),
        .sum(w_pcBranchD)
    );

    register_file u_regFile (
        .clk(i_clk),
        .rst_n(i_reset_n),
        .rs(w_instD[25:21]),
        .rt(w_instD[20:16]),
        .rd(w_writeRegW),
        .we(w_regWriteW),
        .wd(w_resultW),
        .rd1(w_rd1D),
        .rd2(w_rd2D)
    );

    //----------------------------------------------
    // Branch Comparator & Forwarding (Decode)
    //----------------------------------------------
    mux u_forwardAD (
        .in0(w_rd1D),
        .in1(w_aluResultM),
        .sel(w_forwardAD),
        .out(w_rd1D_muxOut)
    );

    mux u_forwardBD (
        .in0(w_rd2D),
        .in1(w_aluResultM),
        .sel(w_forwardBD),
        .out(w_rd2D_muxOut)
    );

    comparator u_comparator (
        .a(w_rd1D_muxOut),
        .b(w_rd2D_muxOut),
        .equal(w_equalD)
    );

    control_unit u_ctrl (
        .opcode(w_instD[31:26]),
        .funct(w_instD[5:0]),
        .MemtoRegD(w_memToRegD),
        .MemWriteD(w_memWriteD),
        .branchD(w_branchD),
        .alu_controlD(w_aluCtrlD),
        .alu_srcD(w_aluSrcD),
        .RegDstD(w_regDstD),
        .RegWriteD(w_regWriteD),
        .jumpD(w_jumpD)
    );

    //----------------------------------------------
    // Decode ? Execute Register
    //----------------------------------------------
    decode_execute u_DE (
        .clk(i_clk),
        .rst_n(i_reset_n),
        .flush(w_flushE),
        .RD1_D(w_rd1D),
        .RD2_D(w_rd2D),
        .RsD(w_rsD),
        .RtD(w_rtD),
        .RdD(w_rdD),
        .sign_imm_outD(w_signImmD),
        .RegWriteD(w_regWriteD),
        .MemtoRegD(w_memToRegD),
        .MemWriteD(w_memWriteD),
        .alu_controlD(w_aluCtrlD),
        .alu_srcD(w_aluSrcD),
        .RegDstD(w_regDstD),
        .RegWriteE(w_regWriteE),
        .MemtoRegE(w_memToRegE),
        .MemWriteE(w_memWriteE),
        .alu_controlE(w_aluCtrlE),
        .alu_srcE(w_aluSrcE),
        .RegDstE(w_regDstE),
        .RD1_E(w_rd1E),
        .RD2_E(w_rd2E),
        .RsE(w_rsE),
        .RtE(w_rtE),
        .RdE(w_rdE),
        .sign_imm_outE(w_signImmE)
    );

    //----------------------------------------------
    // Execute Stage
    //----------------------------------------------
    mux #(.DATA_WIDTH(5)) u_regDst (
        .in0(w_rtE),
        .in1(w_rdE),
        .sel(w_regDstE),
        .out(w_writeRegE)
    );

    mux3_1 u_forwardAE (
        .in0(w_rd1E),
        .in1(w_resultW),
        .in2(w_aluResultM),
        .sel(w_forwardAE),
        .out(w_srcAE)
    );

    mux3_1 u_forwardBE (
        .in0(w_rd2E),
        .in1(w_resultW),
        .in2(w_aluResultM),
        .sel(w_forwardBE),
        .out(w_forwardB_muxOut)
    );

    mux u_aluSrc (
        .in0(w_forwardB_muxOut),
        .in1(w_signImmE),
        .sel(w_aluSrcE),
        .out(w_srcBE)
    );

    ALU u_ALU (
        .A(w_srcAE),
        .B(w_srcBE),
        .control(w_aluCtrlE),
        .result(w_aluResultE)
    );

    //----------------------------------------------
    // Execute ? Memory Register
    //----------------------------------------------
    Execute_Mem u_EM (
        .clk(i_clk),
        .rst_n(i_reset_n),
        .RegWriteE(w_regWriteE),
        .MemtoRegE(w_memToRegE),
        .MemWriteE(w_memWriteE),
        .alu_resultE(w_aluResultE),
        .write_dataE(w_writeDataE),
        .write_regE(w_writeRegE),
        .RegWriteM(w_regWriteM),
        .MemtoRegM(w_memToRegM),
        .MemWriteM(w_memWriteM),
        .alu_resultM(w_aluResultM),
        .write_dataM(w_writeDataM),
        .write_regM(w_writeRegM)
    );

    //----------------------------------------------
    // Memory Stage
    //----------------------------------------------
    data_memory u_dataMem (
        .clk(i_clk),
        .rst_n(i_reset_n),
        .MemWriteM(w_memWriteM),
        .write_dataM(w_writeDataM),
        .addr(w_aluResultM),
        .read_data(w_rdM)
    );

    //----------------------------------------------
    // Memory ? Writeback Register
    //----------------------------------------------
    Memory_Writeback u_MW (
        .clk(i_clk),
        .rst_n(i_reset_n),
        .RegWriteM(w_regWriteM),
        .MemtoRegM(w_memToRegM),
        .alu_resultM(w_aluResultM),
        .RD_M(w_rdM),
        .write_regM(w_writeRegM),
        .RegWriteW(w_regWriteW),
        .MemtoRegW(w_memToRegW),
        .alu_resultW(w_aluResultW),
        .RD_W(w_rdW),
        .write_regW(w_writeRegW)
    );

    //----------------------------------------------
    // Writeback Stage
    //----------------------------------------------
    mux u_memToReg (
        .in0(w_aluResultW),
        .in1(w_rdW),
        .sel(w_memToRegW),
        .out(w_resultW)
    );

    //----------------------------------------------
    // Forwarding & Hazard Units
    //----------------------------------------------
    forward_unit u_forward (
        .RsD(w_rsD),
        .RtD(w_rtD),
        .RsE(w_rsE),
        .RtE(w_rtE),
        .write_regM(w_writeRegM),
        .RegWriteM(w_regWriteM),
        .write_regW(w_writeRegW),
        .RegWriteW(w_regWriteW),
        .forwardAE(w_forwardAE),
        .forwardBE(w_forwardBE),
        .forwardAD(w_forwardAD),
        .forwardBD(w_forwardBD)
    );

    hazard_unit u_hazard (
        .RsD(w_rsD),
        .RtD(w_rtD),
        .RtE(w_rtE),
        .MemtoRegE(w_memToRegE),
        .MemtoRegM(w_memToRegM),
        .branchD(w_branchD),
        .RegWriteE(w_regWriteE),
        .write_regE(w_writeRegE),
        .write_regM(w_writeRegM),
        .jumpD(w_jumpD),
        .stallF(w_stallF),
        .stallD(w_stallD),
        .flushD(w_flushD),
        .flushE(w_flushE)
    );

endmodule