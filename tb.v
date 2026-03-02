////////////////////////////////////////////////
// Engineer:   Vaishnavi G H
// 
// Create Date:  02/03/2026
// Module Name:  MIPS_Top_tb
// Project Name: Pipelined MIPS Processor
// Description:  Testbench for verifying MIPS_Top module.
//               Generates clock, applies reset, and observes
//               instruction fetch sequence.
// 
// Notes:
//   - Uses 10 ns clock period.
//   - Active-low asynchronous reset.
//   - Simulation stops after sufficient instruction cycles.
//
////////////////////////////////////////////////
`timescale 1ns / 1ps

module MIPS_Top_tb;

    //----------------------------------------------
    // Parameters and Signals
    //----------------------------------------------
    parameter DATA_WIDTH = 32;

    reg  i_clk;                   // Clock
    reg  i_reset_n;               // Active-low reset
    wire [DATA_WIDTH-1:0] o_instructionF;  // Fetched instruction output

    //----------------------------------------------
    // DUT (Device Under Test)
    //----------------------------------------------
    MIPS_Top #(.DATA_WIDTH(DATA_WIDTH)) DUT (
        .i_clk(i_clk),
        .i_reset_n(i_reset_n),
        .o_instructionF(o_instructionF)
    );

    //----------------------------------------------
    // Clock Generation: 100 MHz (10 ns period)
    //----------------------------------------------
    initial begin
        i_clk = 1'b0;
        forever #5 i_clk = ~i_clk; // toggle every 5 ns
    end

    //----------------------------------------------
    // Reset and Simulation Control
    //----------------------------------------------
    initial begin
        // Apply reset
        i_reset_n = 1'b0;     // Assert reset (active low)
        #20;                  // hold reset for 20 ns
        i_reset_n = 1'b1;     // Deassert reset

        // Run simulation for some time
        #1000;

        // Finish simulation
        $stop;
    end

    //----------------------------------------------
    // Optional: Monitor output for debugging
    //----------------------------------------------
    initial begin
        $display("Time(ns)\tInstructionF");
        $monitor("%0t\t%h", $time, o_instructionF);
    end

endmodule