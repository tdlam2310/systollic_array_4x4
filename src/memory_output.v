`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 18:07:38
// Design Name: 
// Module Name: memory_output
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

module memory_output (
    input              clk,
    input              rst,
    input              save_into_memory,
    input      [7:0]   save_base_memory,

    input signed [15:0] data0,
    input signed [15:0] data1,
    input signed [15:0] data2,
    input signed [15:0] data3,
    input signed [15:0] data4,
    input signed [15:0] data5,
    input signed [15:0] data6,
    input signed [15:0] data7,
    input signed [15:0] data8,
    input signed [15:0] data9,
    input signed [15:0] data10,
    input signed [15:0] data11,
    input signed [15:0] data12,
    input signed [15:0] data13,
    input signed [15:0] data14,
    input signed [15:0] data15,

    input      [7:0]   addrO,
    output reg signed [15:0] dataO
);

    reg signed [15:0] memory [0:255];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1)
                memory[i] <= 16'd0;
        end
        else if (save_into_memory && save_base_memory <= 8'd240) begin
            memory[save_base_memory + 8'd0]  <= data0;
            memory[save_base_memory + 8'd1]  <= data1;
            memory[save_base_memory + 8'd2]  <= data2;
            memory[save_base_memory + 8'd3]  <= data3;
            memory[save_base_memory + 8'd4]  <= data4;
            memory[save_base_memory + 8'd5]  <= data5;
            memory[save_base_memory + 8'd6]  <= data6;
            memory[save_base_memory + 8'd7]  <= data7;
            memory[save_base_memory + 8'd8]  <= data8;
            memory[save_base_memory + 8'd9]  <= data9;
            memory[save_base_memory + 8'd10] <= data10;
            memory[save_base_memory + 8'd11] <= data11;
            memory[save_base_memory + 8'd12] <= data12;
            memory[save_base_memory + 8'd13] <= data13;
            memory[save_base_memory + 8'd14] <= data14;
            memory[save_base_memory + 8'd15] <= data15;
        end
    end

    always @(posedge clk) begin
        dataO <= memory[addrO];
    end

endmodule

