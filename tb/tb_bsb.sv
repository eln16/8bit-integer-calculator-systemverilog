//##################################################################################################
/*
Project  Module     :tb_bsb
File name           :tb_bsb.sv
Version             :1-0
Date created        :12 APRIL 2025
Author              : Wong Carman             
Code type           : Behavioural (System Verilog)       
Description         :  This is a testbench for the `bsb` (Barrel Shifter) module, used to verify its 
                       functionality by applying a series of test cases, including left and right shifts,
                        pattern shifts, and edge cases.
*/
//##################################################################################################

`define PERIOD_CLK 5

module tb_bsb;

    // Inputs
    logic               ip_sys_reset;
    logic               ip_b_bsb_direction;
    logic [7:0]         ip_b_bsb_data;
    logic [2:0]         ip_b_bsb_shift_amount;

    // Outputs
    wire [7:0]        op_b_bsb_shifted_data;

    // Instantiate DUT
    bsb dut (
        .ip_sys_reset(ip_sys_reset),
        .ip_b_bsb_direction(ip_b_bsb_direction),
        .ip_b_bsb_data(ip_b_bsb_data),
        .ip_b_bsb_shift_amount(ip_b_bsb_shift_amount),
        .op_b_bsb_shifted_data(op_b_bsb_shifted_data)
    );
        
    // Reset generation
    initial begin
        ip_sys_reset = 1'b1;  // Assert reset
        #(`PERIOD_CLK *5);
        ip_sys_reset = 1'b0;  // Release reset
    end

    // Test stimulus
    
    
    initial begin
        
        //--------------------------------------------------
        // Initialize inputs
        //--------------------------------------------------
        ip_b_bsb_direction = 0;
        ip_b_bsb_data = 8'h00;
        ip_b_bsb_shift_amount = 3'b000;

        //--------------------------------------------------
        // Test Sequence
        //--------------------------------------------------
        // Reset test
        #(`PERIOD_CLK *3);
        ip_b_bsb_data = 8'hFF;
        #(`PERIOD_CLK *2);
        
        //--------------------------------------------------
        // Left shift tests
        //--------------------------------------------------
        #(`PERIOD_CLK *4);
        ip_b_bsb_direction = 0;
        ip_b_bsb_data = 8'b00000001;
        ip_b_bsb_shift_amount = 3'b001;
        #(`PERIOD_CLK *2);

        #(`PERIOD_CLK *4);
        ip_b_bsb_data = 8'b00000001;
        ip_b_bsb_shift_amount = 3'b111;
        #(`PERIOD_CLK *2);
        
        //--------------------------------------------------
        // Right shift tests
        //--------------------------------------------------
        #(`PERIOD_CLK *4);
        ip_b_bsb_direction = 1;
        ip_b_bsb_data = 8'b10000000;
        ip_b_bsb_shift_amount = 3'b001;
        #(`PERIOD_CLK *2);

        #(`PERIOD_CLK *4);
        ip_b_bsb_data = 8'b10000000;
        ip_b_bsb_shift_amount = 3'b111;
        #(`PERIOD_CLK *2);
        
        //--------------------------------------------------
        // Pattern tests
        //--------------------------------------------------
        #(`PERIOD_CLK *4);
        ip_b_bsb_direction = 0;
        ip_b_bsb_data = 8'b10101010;
        ip_b_bsb_shift_amount = 3'b010;
        #(`PERIOD_CLK *2);

        #(`PERIOD_CLK *4);
        ip_b_bsb_direction = 1;
        ip_b_bsb_shift_amount = 3'b011;
        #(`PERIOD_CLK *2);
        
        //--------------------------------------------------
        // Zero shift test
        //--------------------------------------------------
        #(`PERIOD_CLK *4);
        ip_b_bsb_shift_amount = 3'b000;
        ip_b_bsb_data = 8'hFF;
        #(`PERIOD_CLK *2);

     $finish;
    end
