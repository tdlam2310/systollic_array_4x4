`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 17:54:22
// Design Name: 
// Module Name: array_four_x_four
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

module array_four_x_four(
    input              clk, rst,
    input              valid_i, 
    input              done,
    input              clear,
    input      signed [15:0] a_00, a_10, a_20, a_30, 
    input      signed [15:0] b_00, b_01, b_02, b_03,
    
    output     signed [15:0] r_00, r_01, r_02, r_03,
    output     signed [15:0] r_10, r_11, r_12, r_13,
    output     signed [15:0] r_20, r_21, r_22, r_23,
    output     signed [15:0] r_30, r_31, r_32, r_33
);
    wire signed [15:0] a_00_o, a_01_o, a_02_o;
    wire signed [15:0] a_10_o, a_11_o, a_12_o;
    wire signed [15:0] a_20_o, a_21_o, a_22_o;
    wire signed [15:0] a_30_o, a_31_o, a_32_o;

    wire signed [15:0] b_00_o, b_01_o, b_02_o, b_03_o;
    wire signed [15:0] b_10_o, b_11_o, b_12_o, b_13_o;
    wire signed [15:0] b_20_o, b_21_o, b_22_o, b_23_o;
   
    pe pe_00 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_00), .b_i(b_00), .a_o(a_00_o), .b_o(b_00_o), .acc_o(r_00));

    pe pe_01 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_00_o), .b_i(b_01), .a_o(a_01_o), .b_o(b_01_o), .acc_o(r_01));

    pe pe_02 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done),.clear(clear),
              .a_i(a_01_o), .b_i(b_02), .a_o(a_02_o), .b_o(b_02_o), .acc_o(r_02));

    pe pe_03 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_02_o), .b_i(b_03), .a_o(),     .b_o(b_03_o), .acc_o(r_03));


    pe pe_10 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_10), .b_i(b_00_o), .a_o(a_10_o), .b_o(b_10_o), .acc_o(r_10));

    pe pe_11 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done),  .clear(clear),
              .a_i(a_10_o), .b_i(b_01_o), .a_o(a_11_o), .b_o(b_11_o), .acc_o(r_11));

    pe pe_12 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done),  .clear(clear),
              .a_i(a_11_o), .b_i(b_02_o), .a_o(a_12_o), .b_o(b_12_o), .acc_o(r_12));

    pe pe_13 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_12_o), .b_i(b_03_o), .a_o(),      .b_o(b_13_o), .acc_o(r_13));

    pe pe_20 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_20), .b_i(b_10_o), .a_o(a_20_o), .b_o(b_20_o), .acc_o(r_20));

    pe pe_21 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done),  .clear(clear),
              .a_i(a_20_o), .b_i(b_11_o), .a_o(a_21_o), .b_o(b_21_o), .acc_o(r_21));

    pe pe_22 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_21_o), .b_i(b_12_o), .a_o(a_22_o), .b_o(b_22_o), .acc_o(r_22));

    pe pe_23 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_22_o), .b_i(b_13_o), .a_o(),      .b_o(b_23_o), .acc_o(r_23));

    pe pe_30 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_30), .b_i(b_20_o), .a_o(a_30_o), .b_o(), .acc_o(r_30));

    pe pe_31 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_30_o), .b_i(b_21_o), .a_o(a_31_o), .b_o(), .acc_o(r_31));

    pe pe_32 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_31_o), .b_i(b_22_o), .a_o(a_32_o), .b_o(), .acc_o(r_32));

    pe pe_33 (.clk(clk), .rst(rst), .valid_i(valid_i), .done(done), .clear(clear),
              .a_i(a_32_o), .b_i(b_23_o), .a_o(),      .b_o(), .acc_o(r_33));

endmodule

