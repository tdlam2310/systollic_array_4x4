`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 18:06:19
// Design Name: 
// Module Name: array_wtih_mem_with_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module array_wtih_mem_with_controller (
    input               clk,
    input               rst,
    input               ap_start,
    input               enA,
    input               enB,
    input               stop,
    input signed [15:0] data_A_in,
    input signed [15:0] data_B_in,
    input       [5:0]   addrA,
    input       [5:0]   addrB,
    input       [4:0]   instruction_i,

    output      [7:0]   base_addr,
    output              save_into_memory,

    output signed [15:0] data_o_0_A,
    output signed [15:0] data_o_1_A,
    output signed [15:0] data_o_2_A,
    output signed [15:0] data_o_3_A,

    output signed [15:0] data_o_0_B,
    output signed [15:0] data_o_1_B,
    output signed [15:0] data_o_2_B,
    output signed [15:0] data_o_3_B,

    output signed [15:0] r_00, r_01, r_02, r_03,
    output signed [15:0] r_10, r_11, r_12, r_13,
    output signed [15:0] r_20, r_21, r_22, r_23,
    output signed [15:0] r_30, r_31, r_32, r_33,

    output              done
);

    wire        start_compute;
    wire [4:0]  instruction;

    array_with_mem_wrapper array_and_data_feeder (
        .clk(clk),
        .rst(rst),
        .enA(enA),
        .enB(enB),
        .start_compute(start_compute),
        .stop(stop),
        .data_A_in(data_A_in),
        .data_B_in(data_B_in),
        .addrA(addrA),
        .addrB(addrB),
        .instruction(instruction),

        .data_o_0_A(data_o_0_A),
        .data_o_1_A(data_o_1_A),
        .data_o_2_A(data_o_2_A),
        .data_o_3_A(data_o_3_A),

        .data_o_0_B(data_o_0_B),
        .data_o_1_B(data_o_1_B),
        .data_o_2_B(data_o_2_B),
        .data_o_3_B(data_o_3_B),

        .r_00(r_00), .r_01(r_01), .r_02(r_02), .r_03(r_03),
        .r_10(r_10), .r_11(r_11), .r_12(r_12), .r_13(r_13),
        .r_20(r_20), .r_21(r_21), .r_22(r_22), .r_23(r_23),
        .r_30(r_30), .r_31(r_31), .r_32(r_32), .r_33(r_33),

        .done(done),
        .base_addr(base_addr),
        .save_into_memory(save_into_memory)
    );

    controller ctlr (
        .clk(clk),
        .rst(rst),
        .ap_start(ap_start),
        .systolic_array_done(done),
        .en(enA || enB),
        .instruction_i(instruction_i),
        .start_compute(start_compute),
        .instruction_o(instruction)
    );

endmodule
