`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 17:52:20
// Design Name: 
// Module Name: pe
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
module pe(
    input              clk, rst,
    input              valid_i,
    input              done, clear,
    input      signed [15:0] a_i, b_i,
    output reg signed [15:0] a_o, b_o,
    output reg signed [15:0] acc_o
);
    reg  signed [39:0] acc, acc_nxt;
    wire signed [31:0] prod32;
    wire signed [39:0] term_ext;
    wire signed [39:0] sum;


    assign prod32   = $signed(a_i) * $signed(b_i);
    assign term_ext = {{(40-32){prod32[31]}}, prod32};

    assign sum = (clear ? 40'sd0 : acc) + term_ext;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 40'd0;
            a_o <= 16'd0;
            b_o <= 16'd0;
        end else begin
            if (valid_i) acc <= acc_nxt;
            a_o <= a_i;
            b_o <= b_i;
        end
    end

    always @(*) begin
        acc_nxt = acc;
        if (valid_i) acc_nxt = sum;
    end

    always @(*) begin
        if (!done) begin
            acc_o = 16'sd0;
        end else begin
            if (acc > 40'sd32767)        acc_o = 16'sd32767;
            else if (acc < -40'sd32768)  acc_o = -16'sd32768;
            else                         acc_o = acc[15:0];
        end
    end

endmodule

