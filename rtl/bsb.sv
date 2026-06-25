//##################################################################################################
/*
Project  Module     :bsb
File name           :bsb.sv
Version             :1-0
Date created        : 7 APRIL 2025
Author              : Wong Carman             
Code type           : RTL Level (System Verilog)        
Description         :  This module implements a barrel shifter that performs logical left and right 
                       shifts based on the direction and shift amount inputs.       
*/
//##################################################################################################

module bsb (
    input               ip_sys_reset,
    input               ip_b_bsb_direction, // 0 = Left, 1 = Right
    input [7:0]         ip_b_bsb_data,
    input [2:0]         ip_b_bsb_shift_amount,
    output logic [7:0]  op_b_bsb_shifted_data
);

    logic [7:0] temp_left [0:3];
    logic [7:0] temp_right [0:3];

    // Left shift logic (logical)
    assign temp_left[0] = ip_b_bsb_data;
    always_comb begin
    
        if (ip_sys_reset) begin
        
            for (int i = 0; i < 4; i = i + 1) begin
            
                temp_left[i] <= 8'h0;
                temp_right[i] <= 8'h0;
                
            end
            op_b_bsb_shifted_data <= 8'h00;
            
        end
        else begin
            for (int col = 0; col < 3; col++) begin
                for (int row = 0; row < 8; row++) begin
                    if (row < (2 ** col)) begin
                        temp_left[col+1][row] = ip_b_bsb_shift_amount[col] ? 1'b0 : temp_left[col][row];
                    end else begin
                        temp_left[col+1][row] = ip_b_bsb_shift_amount[col] ?  temp_left[col][row - (2 ** col)] : temp_left[col][row];
                    end
                end
            end
        end
    end

    // Right shift logic (now logical)
    assign temp_right[0] = ip_b_bsb_data;
    always_comb begin
    
        if (ip_sys_reset) begin
                
            for (int i = 0; i < 4; i = i + 1) begin
            
                temp_left[i] <= 8'h0;
                temp_right[i] <= 8'h0;
                
            end
            op_b_bsb_shifted_data <= 8'h00;

        end
        else begin
            for (int col = 0; col < 3; col++) begin
                for (int row = 0; row < 8; row++) begin
                    if (ip_b_bsb_shift_amount[col]) begin
                        if ((row + (2 ** col)) < 8) begin
                            temp_right[col+1][row] = temp_right[col][row + (2 ** col)];
                        end else begin
                            temp_right[col+1][row] = 1'b0; // Changed from sign bit to 0
                        end
                    end else begin
                        temp_right[col+1][row] = temp_right[col][row];
                    end
                end
            end
        end
    end

    assign op_b_bsb_shifted_data = ip_b_bsb_direction ? temp_right[3] : temp_left[3];

endmodule