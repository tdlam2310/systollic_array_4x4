`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 18:28:08
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

  //stuff in the top
  reg clk, rst;

  reg  [5:0] addrA, addrB;
  reg        enA, enB;
  reg signed [15:0] dataA, dataB;

  reg  [1:0] addrI;
  reg        enI;
  reg  [4:0] dataI;

  reg  [7:0] addrO;
  wire signed [15:0] dataO;

  reg ap_start;
  wire ap_done;

  wire signed [15:0] r_00, r_01, r_02, r_03;
  wire signed [15:0] r_10, r_11, r_12, r_13;
  wire signed [15:0] r_20, r_21, r_22, r_23;
  wire signed [15:0] r_30, r_31, r_32, r_33;

  wire signed [15:0] data_o_0_A, data_o_1_A, data_o_2_A, data_o_3_A;
  wire signed [15:0] data_o_0_B, data_o_1_B, data_o_2_B, data_o_3_B;

  wire [4:0] instruction_wave;

  // =================================================
  // instantiate
  // =================================================
  top dut (
    .clk(clk), .rst(rst),

    .addrA(addrA), .enA(enA), .dataA(dataA),
    .addrB(addrB), .enB(enB), .dataB(dataB),

    .addrI(addrI), .enI(enI), .dataI(dataI),

    .addrO(addrO), .dataO(dataO),

    .ap_start(ap_start),
    .ap_done(ap_done),

    .r_00(r_00), .r_01(r_01), .r_02(r_02), .r_03(r_03),
    .r_10(r_10), .r_11(r_11), .r_12(r_12), .r_13(r_13),
    .r_20(r_20), .r_21(r_21), .r_22(r_22), .r_23(r_23),
    .r_30(r_30), .r_31(r_31), .r_32(r_32), .r_33(r_33),

    .data_o_0_A(data_o_0_A), .data_o_1_A(data_o_1_A), .data_o_2_A(data_o_2_A), .data_o_3_A(data_o_3_A),
    .data_o_0_B(data_o_0_B), .data_o_1_B(data_o_1_B), .data_o_2_B(data_o_2_B), .data_o_3_B(data_o_3_B),

    .instruction_wave(instruction_wave)
  );

  always #5 clk = ~clk;

  // =================================================
  // File handles
  // =================================================
  integer fd_A, fd_B, fd_C;
  integer r;
  integer val;
  integer i;

  // =================================================
  // Tasks 
  // =================================================
  task write_memA;
    input [5:0] a;
    input signed [15:0] d;
    begin
      @(posedge clk);
      addrA <= a; dataA <= d; enA <= 1'b1;
      @(posedge clk);
      enA <= 1'b0;
    end
  endtask

  task write_memB;
    input [5:0] a;
    input signed [15:0] d;
    begin
      @(posedge clk);
      addrB <= a; dataB <= d; enB <= 1'b1;
      @(posedge clk);
      enB <= 1'b0;
    end
  endtask

  task write_instr;
    input [1:0] a;
    input [4:0] d;
    begin
      @(posedge clk);
      addrI <= a; dataI <= d; enI <= 1'b1;
      @(posedge clk);
      enI <= 1'b0;
    end
  endtask

  // =================================================
  // Testbench
  // =================================================
  initial begin
    // Init
    clk = 1'b0;
    rst = 1'b1;

    addrA = 6'd0; enA = 1'b0; dataA = 16'sd0;
    addrB = 6'd0; enB = 1'b0; dataB = 16'sd0;
    addrI = 2'd0; enI = 1'b0; dataI = 5'd0;
    addrO = 8'd0;
    ap_start = 1'b0;

    for (i = 0; i < 5; i = i + 1) @(posedge clk);
    rst = 1'b0;

    // ---------------------------------------------
    // Open input files
    // ---------------------------------------------
    fd_A = $fopen("a_file.txt", "r");
    fd_B = $fopen("b_file.txt", "r");
    fd_C = $fopen("c_out_file.txt", "w");

    if (fd_A == 0 || fd_B == 0 || fd_C == 0) begin
      $display("ERROR: could not open A/B/C files");
      $finish;
    end

    // ---------------------------------------------
    // load memory A from a_file.txt
    // ---------------------------------------------
    for (i = 0; i < 64; i = i + 1) begin
      r = $fscanf(fd_A, "%d\n", val);
      if (r != 1) begin
        $display("ERROR reading a_file.txt at line %0d", i);
        $finish;
      end
      write_memA(i[5:0], val[15:0]);
    end

    // ---------------------------------------------
    // load memory B from b_file.txt
    // ---------------------------------------------
    for (i = 0; i < 64; i = i + 1) begin
      r = $fscanf(fd_B, "%d\n", val);
      if (r != 1) begin
        $display("ERROR reading b_file.txt at line %0d", i);
        $finish;
      end
      write_memB(i[5:0], val[15:0]);
    end

    $fclose(fd_A);
    $fclose(fd_B);

    // ---------------------------------------------
    // load into instuction mem
    // ---------------------------------------------
    write_instr(2'd0, 5'd4);
    write_instr(2'd1, 5'd8);
    write_instr(2'd2, 5'd16);
    write_instr(2'd3, 5'd0);

    // ---------------------------------------------
    // Start
    // ---------------------------------------------
    @(posedge clk);
    ap_start <= 1'b1;
    @(posedge clk);
    ap_start <= 1'b0;

    // ---------------------------------------------
    // Wait for done
    // ---------------------------------------------
    wait (ap_done == 1'b1);
    $display("ap_done asserted at %0t", $time);

    // ---------------------------------------------
    // put output memory c_out_file.txt
    // ---------------------------------------------
    for (i = 0; i < 256; i = i + 1) begin
      @(posedge clk);
      addrO <= i[7:0];
      @(posedge clk);
      @(posedge clk);
      $fwrite(fd_C, "%0d\n", dataO);
    end

    $fclose(fd_C);

    $display("Simulation finished.");
    $display("Generated: c_out_file.txt");

    $finish;
  end

endmodule

