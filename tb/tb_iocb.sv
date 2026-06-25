//##################################################################################################
/*
Project / Module    : tb_iocb
File name           : tb_iocb.sv
Version             : 1-0
Date created        : 12 APRIL 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : This Testbench verifies the behaviour of the iocb module by applying various 
                      test cases, including reset, data display, computation, shifting, negative 
                      results, and overflow conditions.
*/
//##################################################################################################
//Parameters
`define PERIOD_CLK 10

module tb_iocb ();

//Signals (Input)
logic tb_clk;
logic tb_reset;
logic tb_neg;
logic tb_compute;
logic tb_inpoverflow;
logic tb_aluoverflow;
logic tb_display_sel;
logic tb_use_shifter;
logic [7:0] tb_a;
logic [7:0] tb_b;
logic [7:0] tb_result;
logic [7:0] tb_shifted_data;

//Signals (Output)
logic [6:0] tb_seg;
logic [3:0] tb_sel;

//Module instantiation
iocb
dut_iocb 
(
.ip_sys_clk(tb_clk),
.ip_sys_reset(tb_reset),
.ip_b_iocb_neg(tb_neg),
.ip_b_iocb_compute(tb_compute),
.ip_b_iocb_inpoverflow(tb_inpoverflow),
.ip_b_iocb_aluoverflow(tb_aluoverflow),
.ip_b_iocb_display_sel(tb_display_sel),
.ip_b_iocb_use_shifter(tb_use_shifter),
.ip_b_iocb_a(tb_a),
.ip_b_iocb_b(tb_b),
.ip_b_iocb_result(tb_result),
.ip_b_iocb_shifted_data(tb_shifted_data),
.op_b_iocb_seg(tb_seg),
.op_b_iocb_sel(tb_sel)
);

//Clock waveform generation
initial tb_clk=0;
always #(`PERIOD_CLK / 2) tb_clk <= ~tb_clk;

initial begin 
//---------------------------------------------------------------------
    //Signal initialization
    tb_reset = 0;
    tb_display_sel = 0;
    tb_compute = 0;
    tb_use_shifter = 0;
    tb_neg=0;
    tb_inpoverflow = 0;
    tb_aluoverflow = 0;
    tb_a = 8'h00;
    tb_b = 8'h00;
    tb_result = 8'h00;
    tb_shifted_data = 8'h00;
    #(`PERIOD_CLK);
    
//---------------------------------------------------------------------
//Test case 1: System reset
    tb_reset = 1;
    #(`PERIOD_CLK * 2);
    tb_reset = 0;
    #(`PERIOD_CLK * 4);

//---------------------------------------------------------------------
//Test case 2: Display Operand A
    tb_compute = 0;
    tb_display_sel = 1;
    tb_a = 8'h05;
    #(`PERIOD_CLK * 4);

//---------------------------------------------------------------------
//Test case 3: Display Operand B
    tb_compute = 0;
    tb_display_sel = 0;
    tb_b = 8'h03;
    #(`PERIOD_CLK * 4);
    
//---------------------------------------------------------------------
//Test case 4: Display ALUB result
    tb_compute = 1;
    tb_use_shifter = 0;
    tb_result = 8'h08;
    #(`PERIOD_CLK * 4);
    tb_compute = 0;
    #(`PERIOD_CLK / 2);

//---------------------------------------------------------------------
//Test case 5: Display Shifted Data
    //Re-initialized input before another operation
    tb_reset = 0;
    tb_a = 8'h00;
    tb_b = 8'h00;
    tb_result = 8'h00;
    
    
    tb_compute = 1;
    tb_use_shifter = 1;
    tb_shifted_data = 8'h04;
    #(`PERIOD_CLK * 3);
    tb_compute = 0;
    tb_use_shifter = 0;
    #(`PERIOD_CLK / 2);

//---------------------------------------------------------------------
//Test case 6: Negative Result
    //Re-initialized input before another operation
    tb_reset = 0;
    tb_a = 8'h00;
    tb_b = 8'h00;
    tb_result = 8'h00;
    tb_shifted_data = 8'h00;
    
    tb_compute = 1;
    tb_neg = 1;
    tb_result = 8'h05;
    #(`PERIOD_CLK * 3.5);
    tb_compute = 0;
    tb_neg = 0;
    #(`PERIOD_CLK / 2);

//---------------------------------------------------------------------
//Test case 7: Positive Result
    //Re-initialized input before another operation
    tb_reset = 0;
    tb_a = 8'h00;
    tb_b = 8'h00;
    tb_result = 8'h00;
    tb_shifted_data = 8'h00;
    
    
    tb_neg = 0;
    tb_compute = 1;
    tb_result = 8'h05;
    #(`PERIOD_CLK * 3.5);
    tb_compute = 0;
    #(`PERIOD_CLK / 2);
 
//---------------------------------------------------------------------
//Test case 8: Input Overflow
     //Re-initialized input before another operation
    tb_reset = 0;
    tb_a = 8'h00;
    tb_b = 8'h00;
    tb_result = 8'h00;
    tb_shifted_data = 8'h00;
    
    
    tb_inpoverflow = 1;
    #(`PERIOD_CLK * 5);
    tb_inpoverflow = 0;
    #(`PERIOD_CLK / 2);
    
//---------------------------------------------------------------------
//Test case 9: ALUB Overflow
     //Re-initialized input before another operation
    tb_reset = 0;
    tb_a = 8'h00;
    tb_b = 8'h00;
    tb_result = 8'h00;
    tb_shifted_data = 8'h00;
    
    tb_aluoverflow = 1;
    #(`PERIOD_CLK * 4);
    tb_aluoverflow = 0;
    #(`PERIOD_CLK);
 
        
//---------------------------------------------------------------------
//End simulation
    $finish;    
end
endmodule
