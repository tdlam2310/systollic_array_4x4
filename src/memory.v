`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 17:56:00
// Design Name: 
// Module Name: memory
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


module memory (
    input               clk,
    input               rst,
    input               en_data,
    input               A_or_B,          // 0 = A, 1 = B (B not implemented yet)
    input               start_compute,
    input               stop,
    input      signed [15:0] data_in,
    input      [5:0]    addr,
    input      [4:0]    instruction,    // 4, 8, 16
    output reg signed [15:0] data_o_0,
    output reg signed [15:0] data_o_1,
    output reg signed [15:0] data_o_2,
    output reg signed [15:0] data_o_3,
    output reg          mem_done,
    output              release_output,
    output              clear,
    output     [4:0]    cnt, //debug signal
    output     [3:0]    current_iteration_debug
);
    reg                 clear_temp;
    reg  signed [15:0]  data [0:63];
    reg  [3:0]          current_iteration;   // 0..15
    reg  [4:0]          total_iteration;
    reg  [4:0]          counter;             // 0..6
    reg  [5:0]          base_A, base_B;
    integer             i;
    wire                done_iteration;

    assign current_iteration_debug = current_iteration;
    assign cnt  = counter;
    assign clear = clear_temp;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 64; i = i + 1) begin
                data[i] <= 15'd0;
            end
        end else if (en_data) begin
            data[addr] <= data_in;
        end
    end

    wire [5:0] base_used;
    assign base_used = (A_or_B == 1'b0) ? base_A : base_B;

    assign release_output = (counter == 5'd10);

    always @(posedge clk) begin
        mem_done <= (counter == 5'd9) && (current_iteration == total_iteration - 1);
    end

    //assign done =(counter == 3'd6) && (current_iteration == total_iteration - 1);
    always @(*) begin
        case (instruction)
            5'd4:  total_iteration = 5'd1;
            5'd8:  total_iteration = 5'd4;
            5'd16: total_iteration = 5'd16;
            default: total_iteration = 5'd1;
        endcase
    end

    always @(*) begin
        case (instruction)
             5'd4:  base_A = 6'd0;
             5'd8:  base_A = (current_iteration >> 1) << 4; // each tile x2 ties
             5'd16: base_A = (current_iteration >> 2) << 4; // each tile 4 times
             default: base_A = 6'd0;
        endcase
    end

    always @(*) begin
        case (instruction)
             5'd4:  base_B = 6'd0;
             5'd8:  base_B = ((current_iteration & 4'd1) << 4); // each tile x2 ties
             5'd16: base_B = ((current_iteration & 4'd3) << 4); // each tile 4 times
             default: base_B = 6'd0;
        endcase
    end

    assign done_iteration = (counter == 5'd9);

    always @(posedge clk) begin
        if (rst || stop)
            current_iteration <= 4'd0;
        else if (done_iteration) begin
            if (current_iteration == total_iteration - 1)
                current_iteration <= 4'd0;
            else
                current_iteration <= current_iteration + 1'b1;
        end
    end

    always @(posedge clk) begin
        clear_temp <= (counter == 5'd9);
    end

    always @(posedge clk) begin
        if (rst || stop)
            counter <= 5'd0;
        else if (start_compute) begin
            if (counter == 5'd10)
                counter <= 5'd0;
            else
                counter <= counter + 1'b1;
        end
    end

    always @(*) begin
        data_o_0 = 15'd0;
        data_o_1 = 15'd0;
        data_o_2 = 15'd0;
        data_o_3 = 15'd0;

        if (start_compute && counter < 5'd7) begin
            case (counter)
                5'd0: data_o_0 = data[base_used + 6'd0];
                5'd1: begin
                    data_o_0 = data[base_used + 6'd1];
                    data_o_1 = data[base_used + 6'd4];
                end
                5'd2: begin
                    data_o_0 = data[base_used + 6'd2];
                    data_o_1 = data[base_used + 6'd5];
                    data_o_2 = data[base_used + 6'd8];
                end
                5'd3: begin
                    data_o_0 = data[base_used + 6'd3];
                    data_o_1 = data[base_used + 6'd6];
                    data_o_2 = data[base_used + 6'd9];
                    data_o_3 = data[base_used + 6'd12];
                end
                5'd4: begin
                    data_o_1 = data[base_used + 6'd7];
                    data_o_2 = data[base_used + 6'd10];
                    data_o_3 = data[base_used + 6'd13];
                end
                5'd5: begin
                    data_o_2 = data[base_used + 6'd11];
                    data_o_3 = data[base_used + 6'd14];
                end
                5'd6: begin
                    data_o_3 = data[base_used + 6'd15];
                end
                default: ;
            endcase
        end
    end
endmodule

