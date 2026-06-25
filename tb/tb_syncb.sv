//##################################################################################################
/*
Project / Module    : tb_syncb
File name           : tb_syncb.sv
Version             : 1-0
Date created        : 12 APRIL 2025
Author              : Liew Jia Xin
Code type           : Behavioural (System Verilog)
Description         :  Verifies the functionality of the `syncb` RTL module by simulating input 
                       changes under reset and normal operating conditions. 
*/
//##################################################################################################
//Parameters
`define PERIOD_CLK 5

module tb_syncb ();

//Signals (input)
logic tb_clk, tb_reset;
logic [3:0] tb_i_nurow, tb_i_oprow;

//Signals (output)
logic [3:0] tb_o_nurow, tb_o_oprow;
//Module instantiation
syncb 
dut_syncb
(
.ip_sys_clk(tb_clk),
.ip_sys_reset(tb_reset),
.ip_b_syncb_nurow(tb_i_nurow),
.ip_b_syncb_oprow(tb_i_oprow),
.op_b_syncb_nurow(tb_o_nurow),
.op_b_syncb_oprow(tb_o_oprow)
);

//Clock waveform generation
initial tb_clk=0;
always #(`PERIOD_CLK) tb_clk <= ~tb_clk;

initial begin 
//---------------------------------------------------------------------
//Signal initialization (not default or reset case to show system reset)
    tb_reset = 0;
    tb_i_nurow = 4'b1111; 
    tb_i_oprow = 4'b1111;
    tb_o_nurow = 4'b1110;
    tb_o_oprow = 4'b1110;
    #(`PERIOD_CLK);

//---------------------------------------------------------------------
//Test case 1: System reset
    tb_reset = 1;
    #(`PERIOD_CLK*2.5);
    tb_reset = 0;
    #(`PERIOD_CLK*10);
    
//---------------------------------------------------------------------
//Test case 2: Key '1' Press (Number)
    tb_i_nurow = 4'b1110; //"Key '1' 
    #(`PERIOD_CLK*8);  
    tb_i_nurow = 4'b1111; //Release
    #(`PERIOD_CLK*10); 

//---------------------------------------------------------------------
//Test case 3: Key '/' Press (Opcode)
    tb_i_oprow = 4'b0111; //"Key '/' 
    #(`PERIOD_CLK*8);  
    tb_i_oprow = 4'b1111; //Release
    #(`PERIOD_CLK*10); 

//---------------------------------------------------------------------
//Test case 4: Rapid key changes
    tb_i_nurow = 4'b1101; //Key '5'
    #(`PERIOD_CLK*8); 
    tb_i_nurow = 4'b1110; //Key '1'
    #(`PERIOD_CLK*8); 
    tb_i_nurow = 4'b1111; //Release
    #(`PERIOD_CLK*10); 
    
//---------------------------------------------------------------------
//End simulation
    #(`PERIOD_CLK*10);
    $finish;    
end
endmodule
