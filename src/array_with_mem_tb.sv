`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2025 23:30:36
// Design Name: 
// Module Name: array_with_mem_tb
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


module array_with_mem_tb;
    logic clk;
    logic rst;
    logic enA;
    logic enB;
    //logic clear;
    logic start_compute;
    logic stop;
    logic [4:0]cnt;    
    logic signed [15:0] data_A_in;
    logic signed [15:0] data_B_in;
    
    logic [5:0] addrA;
    logic [5:0] addrB;
    
    logic [4:0] instruction;
    
    logic done;
    logic [7:0] base_addr;
    logic save_into_memory;
    
    logic signed [15:0] r_00;
    logic signed [15:0] r_01;
    logic signed [15:0] r_02;
    logic signed [15:0] r_03;
    
    logic signed [15:0] r_10;
    logic signed [15:0] r_11;
    logic signed [15:0] r_12;
    logic signed [15:0] r_13;
    
    logic signed [15:0] r_20;
    logic signed [15:0] r_21;
    logic signed [15:0] r_22;
    logic signed [15:0] r_23;
    
    logic signed [15:0] r_30;
    logic signed [15:0] r_31;
    logic signed [15:0] r_32;
    logic signed [15:0] r_33;
    
    logic signed [15:0]  data_o_0_A;
    logic signed [15:0]  data_o_1_A;
    logic signed [15:0]  data_o_2_A;
    logic signed [15:0]  data_o_3_A;
     logic signed [15:0] data_o_0_B;
    logic signed [15:0]  data_o_1_B;
    logic signed [15:0]  data_o_2_B;
    logic signed [15:0]  data_o_3_B;
    logic [3:0] current_iteration_debug_B;
     logic [3:0] current_iteration_debug_A;
    
    
    array_with_mem_wrapper dut (
    .clk(clk),
    .rst(rst),

    .enA(enA),
    .enB(enB),
   // .clear(clear),
    .start_compute(start_compute),
    .stop(stop),

    .data_A_in(data_A_in),
    .data_B_in(data_B_in),

    .addrA(addrA),
    .addrB(addrB),

    .instruction(instruction),
    .data_o_0_A(data_o_0_A), .data_o_1_A(data_o_1_A), 
        .data_o_2_A(data_o_2_A), .data_o_3_A(data_o_3_A),
        .data_o_0_B(data_o_0_B), .data_o_1_B(data_o_1_B), 
        .data_o_2_B(data_o_2_B), .data_o_3_B(data_o_3_B),

    .r_00(r_00), .r_01(r_01), .r_02(r_02), .r_03(r_03),
    .r_10(r_10), .r_11(r_11), .r_12(r_12), .r_13(r_13),
    .r_20(r_20), .r_21(r_21), .r_22(r_22), .r_23(r_23),
    .r_30(r_30), .r_31(r_31), .r_32(r_32), .r_33(r_33), .cnt(cnt),  .current_iteration_debug_A(current_iteration_debug_A),  .current_iteration_debug_B(current_iteration_debug_B), .done(done),
    .base_addr(base_addr), .save_into_memory(save_into_memory)
    );
    
    initial clk = 1'b0;
    always #5 clk = ~clk;
    
    task write_memA(input logic [5:0] a, input logic signed [15:0] d);
        begin
            @(posedge clk);
            enA <= 1'b1;
            addrA    <= a;
            data_A_in <= d;
            @(posedge clk);
            enA <= 1'b0;
            addrA   <= '0;
            data_A_in <= '0;
        end
    endtask
    
    task write_memB(input logic [5:0] a, input logic signed [15:0] d);
        begin
            @(posedge clk);
            enB <= 1'b1;
            addrB    <= a;
            data_B_in <= d;
            @(posedge clk);
            enB <= 1'b0;
            addrB   <= '0;
            data_B_in <= '0;
        end
    endtask
    
    initial begin
        rst = 1'b1;
        enA = 0; enB = 0;
        //clear = '0;
        start_compute = 0; stop = 0;
        data_A_in = 0; data_B_in = 0;
        addrA = 0; addrB = 0;
        instruction = 5'd16;
        //done= '0;
        
        

        // 2. Hold Reset for multiple cycles
        repeat (5) @(posedge clk);
        #1 rst = 1'b0; // Release reset slightly AFTER the clock edge
        repeat (2) @(posedge clk);
        
        write_memA(6'd0,  16'd1);
        write_memA(6'd1,  16'd2);
        write_memA(6'd2,  16'd3);
        write_memA(6'd3,  16'd4);
    
        write_memA(6'd4,  16'd5);
        write_memA(6'd5,  16'd6);
        write_memA(6'd6,  16'd7);
        write_memA(6'd7,  16'd8);
    
        write_memA(6'd8,  16'd9);
        write_memA(6'd9,  16'd10);
        write_memA(6'd10, 16'd11);
        write_memA(6'd11, 16'd12);
    
        write_memA(6'd12, 16'd13);
        write_memA(6'd13, 16'd14);
        write_memA(6'd14, 16'd15);
        write_memA(6'd15, 16'd16);
        write_memA(6'd16, 16'd17);
    write_memA(6'd17, 16'd18);
    write_memA(6'd18, 16'd19);
    write_memA(6'd19, 16'd20);
    
    write_memA(6'd20, 16'd21);
    write_memA(6'd21, 16'd22);
    write_memA(6'd22, 16'd23);
    write_memA(6'd23, 16'd24);
    
    write_memA(6'd24, 16'd25);
    write_memA(6'd25, 16'd26);
    write_memA(6'd26, 16'd27);
    write_memA(6'd27, 16'd28);
    
    write_memA(6'd28, 16'd29);
    write_memA(6'd29, 16'd30);
    write_memA(6'd30, 16'd31);
    write_memA(6'd31, 16'd32);
    
    write_memA(6'd32, 16'd33);
    write_memA(6'd33, 16'd34);
    write_memA(6'd34, 16'd35);
    write_memA(6'd35, 16'd36);
    
    write_memA(6'd36, 16'd37);
    write_memA(6'd37, 16'd38);
    write_memA(6'd38, 16'd39);
    write_memA(6'd39, 16'd40);
    
    write_memA(6'd40, 16'd41);
    write_memA(6'd41, 16'd42);
    write_memA(6'd42, 16'd43);
    write_memA(6'd43, 16'd44);
    
    write_memA(6'd44, 16'd45);
    write_memA(6'd45, 16'd46);
    write_memA(6'd46, 16'd47);
    write_memA(6'd47, 16'd48);
    
    write_memA(6'd48, 16'd49);
    write_memA(6'd49, 16'd50);
    write_memA(6'd50, 16'd51);
    write_memA(6'd51, 16'd52);
    
    write_memA(6'd52, 16'd53);
    write_memA(6'd53, 16'd54);
    write_memA(6'd54, 16'd55);
    write_memA(6'd55, 16'd56);
    
    write_memA(6'd56, 16'd57);
    write_memA(6'd57, 16'd58);
    write_memA(6'd58, 16'd59);
    write_memA(6'd59, 16'd60);
    
    write_memA(6'd60, 16'd61);
    write_memA(6'd61, 16'd62);
    write_memA(6'd62, 16'd63);
    write_memA(6'd63, 16'd64);
//===============================================        
        write_memB(6'd0,  16'd17);
        write_memB(6'd1,  16'd18);
        write_memB(6'd2,  16'd19);
        write_memB(6'd3,  16'd20);
        write_memB(6'd4,  16'd21);
        write_memB(6'd5,  16'd22);
        write_memB(6'd6,  16'd23);
        write_memB(6'd7,  16'd24);
        write_memB(6'd8,  16'd25);
        write_memB(6'd9,  16'd26);
        write_memB(6'd10, 16'd27);
        write_memB(6'd11, 16'd28);
        write_memB(6'd12, 16'd29);
        write_memB(6'd13, 16'd30);
        write_memB(6'd14, 16'd31);
        write_memB(6'd15, 16'd32);
        write_memB(6'd16, 16'd33);
        write_memB(6'd17, 16'd34);
        write_memB(6'd18, 16'd35);
        write_memB(6'd19, 16'd36);
        write_memB(6'd20, 16'd37);
        write_memB(6'd21, 16'd38);
        write_memB(6'd22, 16'd39);
        write_memB(6'd23, 16'd40);
        write_memB(6'd24, 16'd41);
        write_memB(6'd25, 16'd42);
        write_memB(6'd26, 16'd43);
        write_memB(6'd27, 16'd44);
        write_memB(6'd28, 16'd45);
        write_memB(6'd29, 16'd46);
        write_memB(6'd30, 16'd47);
        write_memB(6'd31, 16'd48);
        write_memB(6'd32, 16'd49);
        write_memB(6'd33, 16'd50);
        write_memB(6'd34, 16'd51);
        write_memB(6'd35, 16'd52);
        write_memB(6'd36, 16'd53);
        write_memB(6'd37, 16'd54);
        write_memB(6'd38, 16'd55);
        write_memB(6'd39, 16'd56);
        write_memB(6'd40, 16'd57);
        write_memB(6'd41, 16'd58);
        write_memB(6'd42, 16'd59);
        write_memB(6'd43, 16'd60);
        write_memB(6'd44, 16'd61);
        write_memB(6'd45, 16'd62);
        write_memB(6'd46, 16'd63);
        write_memB(6'd47, 16'd64);
        write_memB(6'd48, 16'd65);
        write_memB(6'd49, 16'd66);
        write_memB(6'd50, 16'd67);
        write_memB(6'd51, 16'd68);
        write_memB(6'd52, 16'd69);
        write_memB(6'd53, 16'd70);
        write_memB(6'd54, 16'd71);
        write_memB(6'd55, 16'd72);
        write_memB(6'd56, 16'd73);
        write_memB(6'd57, 16'd74);
        write_memB(6'd58, 16'd75);
        write_memB(6'd59, 16'd76);
        write_memB(6'd60, 16'd77);
        write_memB(6'd61, 16'd78);
        write_memB(6'd62, 16'd79);
        write_memB(6'd63, 16'd80);
        
        @(posedge clk);
        start_compute <= 1'b1;
//        @(posedge clk);
//        @(posedge clk);
//        @(posedge clk);
//        @(posedge clk);
//        @(posedge clk);
//        @(posedge clk);      
//        @(posedge clk);      
//        @(posedge clk);   
//        @(posedge clk);      
//        @(posedge clk);    
//        @(posedge clk);
        
        
//        @(posedge clk);
       
        
//        @(posedge clk);
       
        
//        @(posedge clk);
       
        
//        @(posedge clk);
        
        
//        @(posedge clk);
        
        
//        @(posedge clk);
       
        
//        @(posedge clk);
       
        
//        @(posedge clk);
       
//        //done <= 1'b1;
//        //start_compute <= '0;
        
//        @(posedge clk);
//        //done <= 1'b0;
//        repeat (26) @(posedge clk);
        //clear <= 1'b1;
         wait(done ==1);
         @(posedge clk);
         start_compute <='0;      
         repeat (2) @(posedge clk);
         $finish;   

    end
endmodule
