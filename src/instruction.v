`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 18:09:23
// Design Name: 
// Module Name: instruction
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
module instruction (
    input             clk,
    input             rst,
    input             enI,
    input             systolic_array_done,
    input      [4:0]  dataI,
    input      [1:0]  addrI,
    output reg        ap_done,
    output     [4:0]  instruction
);

    reg  [1:0] addr;
    reg  [4:0] instr_mem [0:3];
    integer i;

    assign instruction = instr_mem[addr];

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1)
                instr_mem[i] <= 5'd0;
        end
        else if (enI) begin
            instr_mem[addrI] <= dataI;
        end
    end

    always @(posedge clk) begin
        if (rst)
            addr <= 2'd0;
        else if (systolic_array_done && instr_mem[addr] != 5'd0)
            addr <= addr + 2'd1;
    end

    always @(posedge clk) begin
        if (rst)
            ap_done <= 1'b0;
        else
            ap_done <= (instr_mem[addr] == 5'd0);
    end

endmodule

