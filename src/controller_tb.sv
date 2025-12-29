`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2025 15:02:01
// Design Name: 
// Module Name: controller_tb
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

module controller_tb;

  // DUT signals
  logic clk, rst;
  logic ap_start, systolic_array_done;
  logic en;

  logic [2:0] instruction_i;
  logic start_compute;
  logic [2:0] instruction_o;
  logic [1:0] curr_state;

  // DUT
  controller dut (
    .clk(clk),
    .rst(rst),
    .ap_start(ap_start),
    .systolic_array_done(systolic_array_done),
    .en(en),
    .instruction_i(instruction_i),
    .start_compute(start_compute),
    .instruction_o(instruction_o),
    .curr_state(curr_state)
  );

  // Clock: 100 MHz (10 ns period)
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // Simple task to step N cycles
  task automatic step(input int n);
    repeat (n) @(posedge clk);
  endtask

  // Monitor
  initial begin
    $display(" time  rst en ap_start done  instr_i  state  start_compute instr_o");
    $monitor("%4t   %0b  %0b    %0b      %0b     %0d      %0d        %0b          %0d",
              $time, rst, en, ap_start, systolic_array_done, instruction_i,
              dut.current_state, start_compute, instruction_o);
  end

  initial begin
    // init
    rst = 1'b1;
    en  = 1'b0;
    ap_start = 1'b0;
    systolic_array_done = 1'b0;

    // instruction_i is an OUTPUT in your module, so the DUT "owns" it.
    // We'll force it in TB only when needed.
    force instruction_i = 3'd1;

    step(3);
    rst = 1'b0;

    // -----------------------
    // Test 1: IDLE -> LOAD
    // -----------------------
    $display("\nTEST1: en=1 should move IDLE->LOAD");
    en = 1'b1;
    step(2);

    // -----------------------
    // Test 2: LOAD -> COMPUTE (ap_start pulse)
    // -----------------------
    $display("\nTEST2: ap_start pulse should move LOAD->COMPUTE");
    ap_start = 1'b1;
    step(1);
    ap_start = 1'b0;
    step(2);

    // Check: start_compute should be 1 in COMPUTE
    if (start_compute !== 1'b1) $error("Expected start_compute=1 in COMPUTE!");

    // -----------------------
    // Test 3: COMPUTE -> DONE (done pulse)
    // -----------------------
    $display("\nTEST3: systolic_array_done pulse should move COMPUTE->DONE");
    systolic_array_done = 1'b1;
    step(1);
    systolic_array_done = 1'b0;
    step(1);

    // -----------------------
    // Test 4a: DONE -> IDLE when instruction_i == 0
    // -----------------------
    $display("\nTEST4a: In DONE, instruction_i==0 should go DONE->IDLE");
    force instruction_i = 3'd0;
    step(2);

    // -----------------------
    // Test 4b: DONE -> COMPUTE when instruction_i != 0
    // -----------------------
    $display("\nTEST4b: In DONE, instruction_i!=0 should go DONE->COMPUTE");
    // Get back to DONE quickly: IDLE->LOAD->COMPUTE->DONE
    force instruction_i = 3'd2;

    en = 1'b1; step(1);          // IDLE->LOAD (if not already)
    ap_start = 1'b1; step(1); ap_start = 1'b0; step(1);  // LOAD->COMPUTE
    systolic_array_done = 1'b1; step(1); systolic_array_done = 1'b0; step(1); // COMPUTE->DONE

    // Now in DONE: instruction_i != 0 should go to COMPUTE
    step(2);

    $display("\nAll tests completed.");
    release instruction_i;
    $finish;
  end

endmodule

