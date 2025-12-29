`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2025 21:38:17
// Design Name: 
// Module Name: memory_tb
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


module memory_tb;
    logic                clk;
    logic                rst;
    logic                en_data;
    logic                A_or_B;
    logic                start_compute;
    logic                stop;
    logic signed [15:0]  data_in;
    logic [5:0]          addr;
    logic [4:0]          instruction;
    logic mem_done;
    logic release_output;
    logic clear;
    logic signed [15:0]  data_o_0, data_o_1, data_o_2, data_o_3;
    logic [4:0] cnt;
     logic [3:0] current_iteration_debug;

    integer k;

    memory dut (
        .clk(clk),
        .rst(rst),
        .en_data(en_data),
        .A_or_B(A_or_B),
        .start_compute(start_compute),
        .stop(stop),
        .data_in(data_in),
        .addr(addr),
        .instruction(instruction),
        .data_o_0(data_o_0),
        .data_o_1(data_o_1),
        .data_o_2(data_o_2),
        .data_o_3(data_o_3),
        .mem_done(mem_done),
        .release_output(release_output),
        .clear(clear),
        .cnt(cnt), //DEBUG SIGNAL
        .current_iteration_debug(current_iteration_debug)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task write_mem(input logic [5:0] a, input logic signed [15:0] d);
        begin
            @(posedge clk);
            en_data <= 1'b1;
            addr    <= a;
            data_in <= d;
            @(posedge clk);
            en_data <= 1'b0;
            addr    <= '0;
            data_in <= '0;
        end
    endtask

    task tick(input int n);
        int t;
        begin
            for (t = 0; t < n; t++) @(posedge clk);
        end
    endtask

    initial begin
        // init
        rst           = 1'b1;
        en_data       = 1'b0;
        A_or_B        = 1'b1;      // drive B
        start_compute = 1'b0;
        stop          = 1'b0;
        data_in       = '0;
        addr          = '0;

        instruction   = 5'd8;     // try 4 / 8 / 16 here

        tick(3);
        rst = 1'b0;

        // optional stop pulse to clear counters
        @(posedge clk); stop <= 1'b1;
        @(posedge clk); stop <= 1'b0;

        // load memory 0..63 with 1..64
        for (k = 0; k < 64; k++) begin
            write_mem(k[5:0], (k+1));
        end

        // start
        @(posedge clk);
        start_compute <= 1'b1;

        // run some cycles and print
        for (k = 0; k < 120; k++) begin
            @(posedge clk);
            $display("t=%0t  k=%0d  counter=%0d  iter=%0d  base=%0d  o0=%0d o1=%0d o2=%0d o3=%0d",
                $time, k, dut.counter, dut.current_iteration, dut.base_used,
                data_o_0, data_o_1, data_o_2, data_o_3
            );
        end

        @(posedge clk);
        start_compute <= 1'b0;

        @(posedge clk); stop <= 1'b1;
        @(posedge clk); stop <= 1'b0;

        $finish;
    end
endmodule
