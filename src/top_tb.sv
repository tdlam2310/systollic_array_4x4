`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2025 21:19:59
// Design Name: 
// Module Name: top_tb
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

module top_tb;

  logic clk, rst;

  // Memory A
  logic [5:0]          addrA;
  logic                enA;
  logic signed [15:0]  dataA;

  // Memory B
  logic [5:0]          addrB;
  logic                enB;
  logic signed [15:0]  dataB;

  // Instruction memory
  logic [1:0]          addrI;
  logic                enI;
  logic [4:0]          dataI;

  // Output memory
  logic signed [15:0]  dataO;
  logic [7:0]          addrO;

  // Control
  logic                ap_start;
  logic                ap_done;
  logic                stop;

  // Debug taps
  logic signed [15:0] r_00, r_01, r_02, r_03;
  logic signed [15:0] r_10, r_11, r_12, r_13;
  logic signed [15:0] r_20, r_21, r_22, r_23;
  logic signed [15:0] r_30, r_31, r_32, r_33;

  logic signed [15:0] data_o_0_A, data_o_1_A, data_o_2_A, data_o_3_A;
  logic signed [15:0] data_o_0_B, data_o_1_B, data_o_2_B, data_o_3_B;

  logic [3:0] current_iteration_debug_A, current_iteration_debug_B;
  logic [4:0] cnt;
  logic [2:0] curr_state;
  logic [4:0] instruction;

  // DUT
  top dut (
    .clk(clk), .rst(rst),
    .addrA(addrA), .enA(enA), .dataA(dataA),
    .addrB(addrB), .enB(enB), .dataB(dataB),
    .addrI(addrI), .enI(enI), .dataI(dataI),
    .dataO(dataO), .addrO(addrO),
    .ap_start(ap_start), .ap_done(ap_done),
    .stop(stop),

    .r_00(r_00), .r_01(r_01), .r_02(r_02), .r_03(r_03),
    .r_10(r_10), .r_11(r_11), .r_12(r_12), .r_13(r_13),
    .r_20(r_20), .r_21(r_21), .r_22(r_22), .r_23(r_23),
    .r_30(r_30), .r_31(r_31), .r_32(r_32), .r_33(r_33),

    .data_o_0_A(data_o_0_A), .data_o_1_A(data_o_1_A),
    .data_o_2_A(data_o_2_A), .data_o_3_A(data_o_3_A),
    .data_o_0_B(data_o_0_B), .data_o_1_B(data_o_1_B),
    .data_o_2_B(data_o_2_B), .data_o_3_B(data_o_3_B),

    .current_iteration_debug_A(current_iteration_debug_A),
    .current_iteration_debug_B(current_iteration_debug_B),
    .cnt(cnt),
    .curr_state(curr_state), .instruction_wave(instruction)
  );

  // Clock
  always #5 clk = ~clk;

  // -------------------------
  // Helper tasks
  // -------------------------
  task write_memA(input [5:0] a, input signed [15:0] d);
    @(posedge clk);
    addrA <= a; dataA <= d; enA <= 1;
    @(posedge clk);
    enA <= 0;
  endtask

  task write_memB(input [5:0] a, input signed [15:0] d);
    @(posedge clk);
    addrB <= a; dataB <= d; enB <= 1;
    @(posedge clk);
    enB <= 0;
  endtask

  task write_instr(input [1:0] a, input [4:0] d);
    @(posedge clk);
    addrI <= a; dataI <= d; enI <= 1;
    @(posedge clk);
    enI <= 0;
  endtask

  // -------------------------
  // Test flow
  // -------------------------
  initial begin
    clk = 0;
    rst = 1;
    enA = 0; enB = 0; enI = 0;
    ap_start = 0;
    stop = 0;
    addrO = 0;

    repeat (5) @(posedge clk);
    rst = 0;

    // Load memory A
    for (int i = 0; i < 16; i++)
      write_memA(i, i + 1);

    // Load memory B
    for (int i = 0; i < 16; i++)
      write_memB(i, i + 17);

    // Instructions: [4, 8, 16, 0]
    write_instr(0, 5'd4);
    write_instr(1, 5'd8);
    write_instr(2, 5'd16);
    write_instr(3, 5'd0);

    // Start
    @(posedge clk);
    ap_start <= 1;
    @(posedge clk);
    ap_start <= 0;

    // Wait for done
    wait (ap_done);
    $display("ap_done asserted at time %0t", $time);

    $display("Simulation finished");
    $finish;
  end

endmodule

