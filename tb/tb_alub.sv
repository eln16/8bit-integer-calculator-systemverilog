//##################################################
/*
Project/Module    : tb_alub
File name         : tb_alub.sv
Version           : 1.0
Date created      : 12 APRIL 2025
Author            : Ong Yee Hong
Code type         : Behavioural (System Verilog)
Description       : Testbench for ALU module 'alub'.
                    Applies corner-case, functional, and random tests.
*/
//##################################################
`define PERIOD_CLK 5

module alub_tb;

    logic tb_reset;
    logic tb_compute;
    logic [7:0] tb_alub_a;
    logic [7:0] tb_alub_b;
    logic [3:0] tb_alub_opcode;
    wire [7:0] tb_alu_result;
    wire tb_neg;
    wire tb_overflow;

    // Instantiate DUT
    alub dut (
        .ip_sys_reset(tb_reset),
        .ip_b_alub_compute(tb_compute),
        .ip_b_alub_a(tb_alub_a),
        .ip_b_alub_b(tb_alub_b),
        .ip_b_alub_opcode(tb_alub_opcode),
        .op_b_alub_result(tb_alu_result),
        .op_b_alub_neg(tb_neg),
        .op_b_alub_aluoverflow(tb_overflow)
    );



    // Test procedure
    initial begin
        
        //Initialize inputs
        tb_alub_a = 0;
        tb_alub_b = 0;
        tb_alub_opcode = 0;
        tb_reset = 0;   //may be error
        tb_compute = 0;
        
        // Reset sequence
        #(`PERIOD_CLK);
        tb_reset = 1;
        #(`PERIOD_CLK);
        tb_reset = 0;       

        // Test 2: Addition without Overflow     
        tb_alub_a = 8'd15;       
        tb_alub_b = 8'd10;
        tb_alub_opcode = 4'h2;
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;
        
        // Test 3: Addition with Overflow
        tb_alub_a = 8'd255;       
        tb_alub_b = 8'd02;
        tb_alub_opcode = 4'h2;
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Test 4: Subtraction with Negative Result
        tb_alub_a = 8'd10;       
        tb_alub_b = 8'd15;
        tb_alub_opcode = 4'h3;
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Test 5: Subtraction without Negative Result
        tb_alub_a = 8'd20;       
        tb_alub_b = 8'd10;
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Test 6: Multiplication without Overflow
        tb_alub_a = 8'd05;       
        tb_alub_b = 8'd02;
        tb_alub_opcode = 4'h4;
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Test 7: Multiplication with Overflow
        tb_alub_a = 8'd90;      
        tb_alub_b = 8'd04;
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Test 8: Division by Non-Zero
        tb_alub_a = 8'd20;       
        tb_alub_b = 8'd04;
        tb_alub_opcode = 4'h5;
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;
        
        // Test 9: Division by Zero
        tb_alub_b = 8'd00;       
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Test 10: Bitwise AND
        tb_alub_a = 8'hF0;      
        tb_alub_b = 8'h0F;
        tb_alub_opcode = 4'h6;
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Test 11: Bitwise OR
        tb_alub_opcode = 4'h7; 
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Test 12: Bitwise XOR
        tb_alub_opcode = 4'h8;   
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Test 13: Bitwise NOT
        tb_alub_a = 8'h00; 
        tb_alub_opcode = 4'h9;
        tb_compute = 1;
        #(`PERIOD_CLK*2);
        tb_compute = 0;

        // Finish simulation
        $finish;
    end

endmodule
