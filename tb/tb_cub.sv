//##################################################################################################
/*
Project / Module    : tb_cub
File name           : tb_cub.sv
Version             : 1-0
Date created        : 12 APRIL 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : Testbench for Control Unit Block (CUB) simulating operand input, operator 
                      selection, compute trigger, and special operations.
*/
//##################################################################################################
//Parameters
`define PERIOD_CLK 5

module tb_cub();

    //Signals Input
    logic        tb_clk;
    logic        tb_reset;
    logic [1:0]  tb_key_pressed;
    logic [7:0]  tb_hex_num;
    logic [7:0]  tb_hex_opc;
    
    //Signals Output
    logic [3:0]  tb_opcode;
    logic [7:0]  tb_a;
    logic [7:0]  tb_b;
    logic        tb_inpoverflow;
    logic        tb_compute;
    logic        tb_use_shifter;
    logic        tb_display_sel;

    cub dut
    (
    .ip_sys_clk(tb_clk),
    .ip_sys_reset(tb_reset),
    .ip_b_cub_key_pressed(tb_key_pressed),
    .ip_b_cub_hex_num(tb_hex_num),
    .ip_b_cub_hex_opc(tb_hex_opc),
    .op_b_cub_opcode(tb_opcode),
    .op_b_cub_a(tb_a),
    .op_b_cub_b(tb_b),
    .op_b_cub_inpoverflow (tb_inpoverflow),
    .op_b_cub_compute(tb_compute),
    .op_b_cub_use_shifter(tb_use_shifter),
    .op_b_cub_display_sel(tb_display_sel)
    );

    // Clock wave generation
   initial tb_clk = 0;
   always #(`PERIOD_CLK) tb_clk <= ~tb_clk;
   
   initial begin
   //Signal Initialization (not default or reset case to show system reset)
   tb_reset = 0;
   tb_opcode = 4'hF;
   tb_a = 8'h06;
   tb_b = 8'h09;
   tb_compute = 0;
   tb_use_shifter = 0;
   tb_display_sel = 1;
   tb_inpoverflow = 1'b0;
   tb_hex_num = 8'hFF;
   tb_hex_opc = 8'hFF;
   tb_key_pressed = 2'b01;
   #(`PERIOD_CLK);
   
   //Test Case 1: System Reset
   tb_reset = 1;
   #(`PERIOD_CLK*6);
   tb_reset = 0;
   #(`PERIOD_CLK*2);
   
   //Test Case 2: Load Operand A (5)
   tb_hex_num = 8'h05;
   tb_key_pressed = 2'b01;
   #(`PERIOD_CLK*4);
   
   //Test Case 3: Load Operand operator (+)
   tb_hex_opc = 8'h00;
   tb_key_pressed = 2'b10;
   #(`PERIOD_CLK*4);
   
   //Test Case 4: Load Operand B (7)
    tb_hex_num = 8'h07;
    tb_key_pressed = 2'b01;
    #(`PERIOD_CLK*4);
    
    //Test Case 5: Trigger Compute by Loading ("=")
    tb_hex_opc = 8'h0A;
    tb_key_pressed = 2'b10;
    #(`PERIOD_CLK*7);
   
    //Reset
    tb_reset = 1;
    tb_key_pressed = 2'b00;
    #(`PERIOD_CLK*1);
    tb_reset = 0;
    #(`PERIOD_CLK*1);
    
   
   //Test Case 6: Trigger Barrel Shifter by Loading ("<<")
    tb_hex_opc = 8'h08;
    tb_key_pressed = 2'b10;
    #(`PERIOD_CLK*4);
   
   
   // End simulation
   #(`PERIOD_CLK*5);
    $finish;
   end
 endmodule
