//##################################################################################################
/*
Project / Module    : tb_hexcb
File name           : tb_hexcb.sv
Version             : 1-0
Date created        : 12 APRIL 2025
Author              : Liew Jia Xin
Code type           : Behavioural (System Verilog)
Description         : Testbench for hexcb keypad decoder. Simulates number and operator keypresses 
                      with reset handling.
*/
//##################################################################################################
`define PERIOD_CLK 5

module tb_hexcb ();
    
// Inputs of hexcb
    logic               tb_clk, tb_reset;
    logic [3:0]         tb_nurow, tb_oprow;
    
//**************************************************************************************************
// Output of hexcb
    wire [1:0]          tb_key_pressed;
    wire [3:0]          tb_nucol, tb_opcol;
    wire [7:0]          tb_hex_num, tb_hex_opc;

//**************************************************************************************************
// Module instantiation

    hexcb 
    dut_hexcb 
    (
        .ip_sys_clk(tb_clk),
        .ip_sys_reset(tb_reset),
        .ip_b_hexcb_nurow(tb_nurow),
        .ip_b_hexcb_oprow(tb_oprow),
        .op_b_hexcb_key_pressed(tb_key_pressed),
        .op_b_hexcb_nucol(tb_nucol),
        .op_b_hexcb_opcol(tb_opcol),
        .op_b_hexcb_hex_num(tb_hex_num),
        .op_b_hexcb_hex_opc(tb_hex_opc)
    );
    
//**************************************************************************************************
// Clock waveform generation
    initial tb_clk = 0;
    always #(`PERIOD_CLK)   tb_clk <= ~tb_clk; 
    
    
    initial begin
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Signal initializaiton
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        tb_reset = 1'b0;
        tb_oprow = 4'b1111;
        tb_nurow = 4'b1111;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 1: System Reset
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        #(`PERIOD_CLK * 2)
        tb_reset = 1'b1;
        #(`PERIOD_CLK * 2)
        tb_reset = 1'b0;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 2: Valid Number Key Press '1'
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
        #(`PERIOD_CLK * 8)
        tb_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_nurow = 4'b1111;
        #(`PERIOD_CLK * 3)
        tb_reset = 1'b1;
        #(`PERIOD_CLK * 2)
        tb_reset = 1'b0;
       
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 3: Valid Operator Key Press '+'
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
        #(`PERIOD_CLK * 7)
        tb_oprow = 4'b1110;
        #(`PERIOD_CLK *2)
        tb_oprow = 4'b1111;
        #(`PERIOD_CLK * 3)
        tb_reset = 1'b1;
        #(`PERIOD_CLK * 2)
        tb_reset = 1'b0;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 4: Invalid Key Press ''
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        #(`PERIOD_CLK * 13)
        tb_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_nurow = 4'b1111;
        #(`PERIOD_CLK * 3)
        tb_reset = 1'b1;
        #(`PERIOD_CLK * 2)
        tb_reset = 1'b0;
    
       #200 $stop;
    end
endmodule
