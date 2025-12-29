`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 18:02:27
// Design Name: 
// Module Name: controller
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
module controller(
    input        clk,
    input        rst,
    input        ap_start,
    input        systolic_array_done,
    input        en,
    input  [4:0] instruction_i,

    output       start_compute,
    output [4:0] instruction_o,
    output [2:0] curr_state
);

    localparam IDLE    = 2'b00;
    localparam LOAD    = 2'b01;
    localparam COMPUTE = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    assign instruction_o = instruction_i;
    assign start_compute = (current_state == COMPUTE);
    assign curr_state    = current_state;

    always @(posedge clk) begin
        if (rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next-state logic
    always @(*) begin
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (en)
                    next_state = LOAD;
            end

            LOAD: begin
                if (ap_start)
                    next_state = COMPUTE;
            end

            COMPUTE: begin
                if (systolic_array_done)
                    next_state = DONE;
            end

            DONE: begin
                if (instruction_i == 5'b00000)
                    next_state = IDLE;
                else
                    next_state = COMPUTE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule

