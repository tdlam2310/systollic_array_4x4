`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 18:00:48
// Design Name: 
// Module Name: array_with_mem_wrapper
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


module array_with_mem_wrapper(
    input              clk, rst,
    input              enA, enB,
    input              start_compute,
   // input logic clear,
    input              stop,
    input      signed [15:0]  data_A_in, data_B_in,
    input      [5:0]          addrA, addrB,
    input      [4:0]          instruction,
    //input logic done,
    output     signed [15:0]  data_o_0_A, data_o_1_A, data_o_2_A, data_o_3_A,
    output     signed [15:0]  data_o_0_B, data_o_1_B, data_o_2_B, data_o_3_B,

    output     signed [15:0] r_00, r_01, r_02, r_03,
    output     signed [15:0] r_10, r_11, r_12, r_13,
    output     signed [15:0] r_20, r_21, r_22, r_23,
    output     signed [15:0] r_30, r_31, r_32, r_33,
    //output [4:0] cnt,
    //output [3:0] current_iteration_debug_A, current_iteration_debug_B,
    output              done,
    output reg  [7:0]   base_addr,
    output              save_into_memory
    );
//    logic signed [15:0]  data_o_0_A, data_o_1_A, data_o_2_A, data_o_3_A;
//    logic signed [15:0]  data_o_0_B, data_o_1_B, data_o_2_B, data_o_3_B;
    wire [4:0] cnt;
    wire [3:0] current_iteration_debug_A;
    wire mem_done_A;
    wire A_or_B;
    wire clearA, clear;
    assign A_or_B = 1'b1;

    wire release_output, release_output_A;

    assign clear = clearA;
    assign release_output = release_output_A;
    assign done = mem_done_A;
    //assign base_addr = current_iteration_debug_A << 4;
    assign save_into_memory = (cnt == 5'd10);

    always @(posedge clk) begin
        base_addr <= current_iteration_debug_A << 4;
    end

    memory memA (
        .clk(clk),
        .rst(rst),
        .en_data(enA),
        .A_or_B(!A_or_B),
        .start_compute(start_compute),
        .stop(stop),
        .data_in(data_A_in),
        .addr(addrA),
        .instruction(instruction),
        .data_o_0(data_o_0_A),
        .data_o_1(data_o_1_A),
        .data_o_2(data_o_2_A),
        .data_o_3(data_o_3_A),
        .mem_done(mem_done_A),
        .release_output(release_output_A),
        .clear(clear),
        .cnt(cnt), //DEBUG SIGNAL
        .current_iteration_debug(current_iteration_debug_A)
    );

    memory memB (
        .clk(clk),
        .rst(rst),
        .en_data(enB),
        .A_or_B(A_or_B),
        .start_compute(start_compute),
        .stop(stop),
        .data_in(data_B_in),
        .addr(addrB),
        .instruction(instruction),
        .data_o_0(data_o_0_B),
        .data_o_1(data_o_1_B),
        .data_o_2(data_o_2_B),
        .data_o_3(data_o_3_B),
        .mem_done(),
        .release_output(),
        .clear(),
        .cnt(),
        .current_iteration_debug()
    );

    array_four_x_four systolic_array(
        .clk(clk), .rst(rst),
        .valid_i(start_compute),
        .done(release_output),
        .clear(clear),
        .a_00(data_o_0_A), .a_10(data_o_1_A), .a_20(data_o_2_A), .a_30(data_o_3_A),
        .b_00(data_o_0_B), .b_01(data_o_1_B), .b_02(data_o_2_B), .b_03(data_o_3_B),

        .r_00(r_00), .r_01(r_01), .r_02(r_02), .r_03(r_03),
        .r_10(r_10), .r_11(r_11), .r_12(r_12), .r_13(r_13),
        .r_20(r_20), .r_21(r_21), .r_22(r_22), .r_23(r_23),
        .r_30(r_30), .r_31(r_31), .r_32(r_32), .r_33(r_33)
    );
endmodule

