`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2025 18:52:25
// Design Name: 
// Module Name: array_with_mem_with_controller_tb
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


`timescale 1ns/1ps

module array_with_mem_with_controller_tb;

  // ----------------------------
  // DUT I/O
  // ----------------------------
  logic clk, rst;
  logic ap_start;
  logic enA, enB;
  logic stop;

  logic signed [15:0] data_A_in, data_B_in;
  logic [5:0] addrA, addrB;
  logic [4:0] instruction_i;

  logic [7:0] base_addr;
  logic save_into_memory;

  logic signed [15:0] data_o_0_A, data_o_1_A, data_o_2_A, data_o_3_A;
  logic signed [15:0] data_o_0_B, data_o_1_B, data_o_2_B, data_o_3_B;

  logic signed [15:0] r_00, r_01, r_02, r_03;
  logic signed [15:0] r_10, r_11, r_12, r_13;
  logic signed [15:0] r_20, r_21, r_22, r_23;
  logic signed [15:0] r_30, r_31, r_32, r_33;

  logic done;
  logic [3:0] current_iteration_debug_A, current_iteration_debug_B;
  logic [4:0] cnt;
  logic [2:0] curr_state;

  // ----------------------------
  // DUT instance
  // ----------------------------
  array_wtih_mem_with_controller dut (
    .clk(clk),
    .rst(rst),
    .ap_start(ap_start),
    .enA(enA),
    .enB(enB),
    .stop(stop),
    .data_A_in(data_A_in),
    .data_B_in(data_B_in),
    .addrA(addrA),
    .addrB(addrB),
    .instruction_i(instruction_i),
    .base_addr(base_addr),
    .save_into_memory(save_into_memory),
    .data_o_0_A(data_o_0_A), .data_o_1_A(data_o_1_A), .data_o_2_A(data_o_2_A), .data_o_3_A(data_o_3_A),
    .data_o_0_B(data_o_0_B), .data_o_1_B(data_o_1_B), .data_o_2_B(data_o_2_B), .data_o_3_B(data_o_3_B),
    .r_00(r_00), .r_01(r_01), .r_02(r_02), .r_03(r_03),
    .r_10(r_10), .r_11(r_11), .r_12(r_12), .r_13(r_13),
    .r_20(r_20), .r_21(r_21), .r_22(r_22), .r_23(r_23),
    .r_30(r_30), .r_31(r_31), .r_32(r_32), .r_33(r_33),
    .done(done),
    .current_iteration_debug_A(current_iteration_debug_A),
    .current_iteration_debug_B(current_iteration_debug_B),
    .cnt(cnt),
    .curr_state(curr_state)
  );

  // ----------------------------
  // Clock
  // ----------------------------
  initial clk = 1'b0;
  always #5 clk = ~clk; // 100 MHz

  task automatic step(input int n);
    repeat (n) @(posedge clk);
  endtask

  // ----------------------------
  // Memory write tasks (assumes DUT writes when enA/enB asserted)
  // ----------------------------
  task automatic write_A(input logic [5:0] a, input logic signed [15:0] d);
    @(posedge clk);
    enA      <= 1'b1;
    addrA    <= a;
    data_A_in<= d;
    @(posedge clk);
    enA      <= 1'b0;
    addrA    <= '0;
    data_A_in<= '0;
  endtask

  task automatic write_B(input logic [5:0] a, input logic signed [15:0] d);
    @(posedge clk);
    enB      <= 1'b1;
    addrB    <= a;
    data_B_in<= d;
    @(posedge clk);
    enB      <= 1'b0;
    addrB    <= '0;
    data_B_in<= '0;
  endtask

  // ----------------------------
  // Debug monitor
  // ----------------------------
  initial begin
    $display("time rst ap_start stop instr state cnt iterA iterB base save done | oA[0..3] oB[0..3]");
    $monitor("%4t  %0b    %0b     %0b   %0d    %0d   %0d   %0d    %0d   %0d   %0b   %0b  | %0d %0d %0d %0d   %0d %0d %0d %0d",
      $time, rst, ap_start, stop, instruction_i, curr_state, cnt,
      current_iteration_debug_A, current_iteration_debug_B, base_addr, save_into_memory, done,
      data_o_0_A, data_o_1_A, data_o_2_A, data_o_3_A,
      data_o_0_B, data_o_1_B, data_o_2_B, data_o_3_B
    );
  end

  // ----------------------------
  // Stimulus
  // ----------------------------
  initial begin
    // init
    rst = 1'b1;
    ap_start = 1'b0;
    enA = 1'b0; enB = 1'b0;
    stop = 1'b0;
    data_A_in = '0; data_B_in = '0;
    addrA = '0; addrB = '0;
    instruction_i = 5'd4;

    step(5);
    rst = 1'b0;
    step(2);

    // -----------------------------------------
    // Load A memory (example: 0..63 = 1..64)
    // -----------------------------------------
    for (int i = 0; i < 64; i++) begin
      write_A(i[5:0], (i+1));
    end

    // -----------------------------------------
    // Load B memory (example: 0..63 = 17..80)
    // -----------------------------------------
    for (int i = 0; i < 64; i++) begin
      write_B(i[5:0], (i+17));
    end

    // -----------------------------------------
    // Start controller/compute
    // -----------------------------------------
    @(posedge clk);
    ap_start <= 1'b1;
    @(posedge clk);
    ap_start <= 1'b0;

    // Let it run for a while (instruction=8 => 4 iterations; your design may be ~40-50 cycles)
    wait(done);
    $finish;
  end

endmodule
