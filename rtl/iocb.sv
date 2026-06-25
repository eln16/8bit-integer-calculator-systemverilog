//##################################################################################################
/*
Project / Module    : iocb
File name           : iocb.sv
Version             : 1-0
Date created        : 7 APRIL 2025
Author              : Elveis Ng Kai Wei
Code type           : RTL Level (System Verilog)
Description         : This module handles arithmetic computation, overflow detection, and displays 
                    the result on a 7-segment display, including error handling and sign formatting.
*/
//##################################################################################################


module iocb (
    input               ip_sys_clk,
    input               ip_sys_reset,
    input               ip_b_iocb_neg,
    input               ip_b_iocb_compute,
    input               ip_b_iocb_inpoverflow,  
    input               ip_b_iocb_aluoverflow,
    input               ip_b_iocb_display_sel,
    input               ip_b_iocb_use_shifter,
    input [7:0]         ip_b_iocb_a,
    input [7:0]         ip_b_iocb_b,
    input [7:0]         ip_b_iocb_result,
    input [7:0]         ip_b_iocb_shifted_data,
    output logic [6:0]  op_b_iocb_seg,
    output logic [3:0]  op_b_iocb_sel
);
    // Internal signals

    logic           display_blank;
    logic [7:0]     selected_input;
    logic [16:0]    refresh_counter;
    logic [1:0]     digit_select;
    logic [7:0]     final_result, load_value;
    logic [3:0]     bcd_digits [0:3]; // [3]=Sign, [2-0]=Digits
    logic [3:0]     hundreds, tens, units;
    logic [7:0]     temp_bcd;
    logic [1:0]     digit_count = 2'b00;

    logic [7:0] latched_result;
    logic       compute_flag;
    
    always_ff @(posedge ip_sys_clk or posedge ip_sys_reset) begin
        if (ip_sys_reset) begin
            compute_flag    <= 1'b0;
            latched_result  <= 8'h00;
        end
        else if (ip_b_iocb_compute) begin
            compute_flag    <= 1'b1;
            latched_result  <= ip_b_iocb_use_shifter ? ip_b_iocb_shifted_data : ip_b_iocb_result;
        end
    end
    
    always_comb begin
        if (compute_flag)
            load_value = latched_result;
        else
            load_value = ip_b_iocb_display_sel ? ip_b_iocb_a : ip_b_iocb_b;
    end
    
    always_ff @(posedge ip_sys_clk or posedge ip_sys_reset) begin
        if (ip_sys_reset) begin
            bcd_digits[0] <= 4'h0;
            bcd_digits[1] <= 4'hA;
            bcd_digits[2] <= 4'hA;
            bcd_digits[3] <= 4'hA;
        end else begin
            temp_bcd = load_value;
    
            if ( ip_b_iocb_inpoverflow || ip_b_iocb_aluoverflow) begin
                bcd_digits[3] <= 4'hA;
                bcd_digits[2] <= 4'hE; // 'E'
                bcd_digits[1] <= 4'hF; // 'r'
                bcd_digits[0] <= 4'hF; // 'r'
            end 
            else begin
                hundreds = temp_bcd / 100;
                temp_bcd = temp_bcd % 100;
                tens = temp_bcd / 10;
                units = temp_bcd % 10;
    
                bcd_digits[3] <= ip_b_iocb_neg ? 4'hD : 4'hA; // Negative Sign
                bcd_digits[2] <= (hundreds != 0) ? hundreds : 4'hA; // Blank
                bcd_digits[1] <= ((tens != 0) || (hundreds != 0)) ? tens : 4'hA; // Blank
                bcd_digits[0] <= units;
    
                // Leading zero blanking
                if (hundreds == 0 && tens == 0) begin
                    bcd_digits[2] <= 4'hA; 
                    bcd_digits[1] <= 4'hA;
                end else if (hundreds == 0) begin
                    bcd_digits[2] <= 4'hA;
                end
            end
        end
    end



    // 1 - 2 - 4 - 8
    always_ff @(posedge ip_sys_clk, posedge ip_sys_reset) begin
        
        if (ip_sys_reset) begin
        
            op_b_iocb_seg <= display_code(bcd_digits[3]);
            op_b_iocb_sel <= 4'b0001;
            
        end
        else begin
            case(digit_count)
                3'b000: begin
                    op_b_iocb_sel <= 4'b0001;
                    op_b_iocb_seg <= display_code(bcd_digits[0]);
                    
                    
                end
                3'b001: begin
                    op_b_iocb_sel <= 4'b0010;
                    op_b_iocb_seg <= display_code(bcd_digits[1]);
                    
                end
                3'b010: begin
                    op_b_iocb_sel <= 4'b0100;
                    op_b_iocb_seg <= display_code(bcd_digits[2]);
                end
                3'b011: begin
                    op_b_iocb_sel <= 4'b1000;
                    op_b_iocb_seg <= display_code(bcd_digits[3]);

                end
                default: begin
                    op_b_iocb_sel <= 4'b1000;
                    op_b_iocb_seg <= display_code(bcd_digits[3]);
                end
            endcase
            
            digit_count <= digit_count + 1;
            
            if (digit_count == 3) 
                digit_count <= 0;
        end
    end
    
    
    //function to convert binary to correct value for display
    function [6:0] display_code(input [3:0] num);
        case(num)
            4'h0: display_code = 7'b0111111; // 0
            4'h1: display_code = 7'b0000110; // 1
            4'h2: display_code = 7'b1011011; // 2
            4'h3: display_code = 7'b1001111; // 3
            4'h4: display_code = 7'b1100110; // 4
            4'h5: display_code = 7'b1101101; // 5
            4'h6: display_code = 7'b1111101; // 6
            4'h7: display_code = 7'b0000111; // 7
            4'h8: display_code = 7'b1111111; // 8
            4'h9: display_code = 7'b1100111; // 9
            4'hA: display_code = 7'b0000000; // Blank
            4'hD: display_code = 7'b1000000; // '-'
            4'hE: display_code = 7'b1111001; // 'E'
            4'hF: display_code = 7'b1010000; // 'r'
            default: display_code = 7'b0000000; // OFF
        endcase
    endfunction
endmodule
