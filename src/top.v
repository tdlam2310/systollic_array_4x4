`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 18:16:33
// Design Name: 
// Module Name: top
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


module top(
    input               clk,
    input               rst,

    // WRITE TO MEMORY A
    input      [5:0]    addrA,
    input               enA,
    input signed [15:0] dataA,

    // WRITE TO MEMORY B
    input      [5:0]    addrB,
    input               enB,
    input signed [15:0] dataB,

    // INSTRUCTION MEMORY
    input      [1:0]    addrI,
    input               enI,
    input      [4:0]    dataI,

    // OUTPUT MEMORY
    output signed [15:0] dataO,
    input      [7:0]    addrO,

    // PULSE SIGNAL
    input               ap_start,
    output              ap_done,

    // WAVEFORM
    output signed [15:0] r_00, r_01, r_02, r_03,
    output signed [15:0] r_10, r_11, r_12, r_13,
    output signed [15:0] r_20, r_21, r_22, r_23,
    output signed [15:0] r_30, r_31, r_32, r_33,

    output signed [15:0] data_o_0_A, data_o_1_A, data_o_2_A, data_o_3_A,
    output signed [15:0] data_o_0_B, data_o_1_B, data_o_2_B, data_o_3_B,

    output     [4:0]    instruction_wave
);

    wire        save_into_memory;
    wire [7:0]  save_base_memory;
    wire        systolic_array_done;

    wire [4:0]  instruction_i;

    assign instruction_wave = instruction_i;

    array_wtih_mem_with_controller dut (
        .clk(clk), .rst(rst),
        .ap_start(ap_start),
        .enA(enA), .enB(enB),
        .stop(),
        .data_A_in(dataA),
        .data_B_in(dataB),
        .addrA(addrA),
        .addrB(addrB),
        .instruction_i(instruction_i),
        .base_addr(save_base_memory),
        .save_into_memory(save_into_memory),

        .data_o_0_A(data_o_0_A), .data_o_1_A(data_o_1_A), .data_o_2_A(data_o_2_A), .data_o_3_A(data_o_3_A),
        .data_o_0_B(data_o_0_B), .data_o_1_B(data_o_1_B), .data_o_2_B(data_o_2_B), .data_o_3_B(data_o_3_B),

        .r_00(r_00), .r_01(r_01), .r_02(r_02), .r_03(r_03),
        .r_10(r_10), .r_11(r_11), .r_12(r_12), .r_13(r_13),
        .r_20(r_20), .r_21(r_21), .r_22(r_22), .r_23(r_23),
        .r_30(r_30), .r_31(r_31), .r_32(r_32), .r_33(r_33),

        .done(systolic_array_done)
    );

    memory_output memO (
        .clk(clk),
        .rst(rst),
        .save_into_memory(save_into_memory),
        .save_base_memory(save_base_memory),

        .data0(r_00), .data1(r_01), .data2(r_02), .data3(r_03),
        .data4(r_10), .data5(r_11), .data6(r_12), .data7(r_13),
        .data8(r_20), .data9(r_21), .data10(r_22), .data11(r_23),
        .data12(r_30), .data13(r_31), .data14(r_32), .data15(r_33),

        .addrO(addrO),
        .dataO(dataO)
    );

    instruction instr (
        .clk(clk),
        .rst(rst),
        .enI(enI),
        .systolic_array_done(systolic_array_done),
        .dataI(dataI),
        .addrI(addrI),
        .ap_done(ap_done),
        .instruction(instruction_i)
    );

endmodule

