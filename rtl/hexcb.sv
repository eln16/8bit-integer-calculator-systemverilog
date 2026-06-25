//##################################################################################################
/*
Project / Module    : hexcb
File name           : hexcb.sv
Version             : 1-0
Date created        : 7 APRIL 2025
Author              : Elveis Ng Kai Wei
Code type           : RTL Level (System Verilog)
Description         :  4x4 keypad scanner and decoder for numbers (0-9) and operators 
                       (+, -, *, /, etc.). Outputs hex code and key type.
*/
//##################################################################################################

module hexcb (
    input               ip_sys_clk,
    input               ip_sys_reset,
    input [3:0]         ip_b_hexcb_nurow,          // Active-low rows (0 = pressed)
    input [3:0]         ip_b_hexcb_oprow,  
    output logic [1:0]  op_b_hexcb_key_pressed,
    output logic [3:0]  op_b_hexcb_nucol,          // Active-low columns (0 = activated)
    output logic [3:0]  op_b_hexcb_opcol,
    output logic [7:0]  op_b_hexcb_hex_num,
    output logic [7:0]  op_b_hexcb_hex_opc);
    
    logic [3:0] delayed_nurow, delayed_oprow;
    logic [3:0] cur_num_col;        // Start with column 0 (active-low)
    logic [3:0] cur_opc_col;
    logic       valid_opc_press;
    logic       valid_num_press;
    
    
    // Number (4 x 4)       // Operator (4 x 4)
    // RC  0   1   2   3    // RC  0   1   2   3
    // 0   1   2   3        // 0   +   &   <<
    // 1   4   5   6        // 1   -   |   >> 
    // 2   7   8   9        // 2   *   ^   
    // 3       0            // 3   /   ~   =
    
    // Column Scanning Logic 
    always_ff @(posedge ip_sys_clk, posedge ip_sys_reset) begin
    
        if (ip_sys_reset) begin
            
            cur_num_col <= 4'b1110;
            cur_opc_col <= 4'b1110;
            op_b_hexcb_nucol <= 4'b1110;
            op_b_hexcb_opcol <= 4'b1110;
            
        end 
        else begin

            cur_num_col <= {cur_num_col[2:0], cur_num_col[3]};
            cur_opc_col <= {cur_opc_col[2:0], cur_opc_col[3]};

            op_b_hexcb_nucol <= cur_num_col;
            op_b_hexcb_opcol <= cur_opc_col;

        end
    end

    assign valid_num_press = (delayed_nurow != 4'b1111);
    assign valid_opc_press = (delayed_oprow != 4'b1111);
    
    always_ff @(posedge ip_sys_clk or posedge ip_sys_reset) begin
        if (ip_sys_reset) begin
            delayed_nurow <= 4'b1111;
            delayed_oprow <= 4'b1111;
        end else begin
            delayed_nurow <= ip_b_hexcb_nurow;
            delayed_oprow <= ip_b_hexcb_oprow;
        end
    end

    
    // Key Decoding
    always_ff @(posedge ip_sys_clk, posedge ip_sys_reset) begin
        if (ip_sys_reset) begin
            op_b_hexcb_hex_num <= 8'hFF;
            op_b_hexcb_hex_opc <= 8'hFF;
            op_b_hexcb_key_pressed <= 2'b00;
            
        end 
        else begin
        
            op_b_hexcb_key_pressed <= 2'b00;
            
            if (valid_num_press && !valid_opc_press) begin
                op_b_hexcb_hex_num <= num_decode(delayed_nurow, op_b_hexcb_nucol);
                op_b_hexcb_key_pressed <= 2'b01; // Number Press
            end
            if (valid_opc_press && !valid_num_press) begin
                op_b_hexcb_hex_opc <= opc_decode(delayed_oprow, op_b_hexcb_opcol);
                op_b_hexcb_key_pressed <= 2'b10; // Operator Press
            end
        end
    end

    
    function logic [7:0] num_decode (input logic [3:0] row, input logic [3:0] col);
    //function to convert row and column read into hex decoded key
        case ({row, col})
            {4'b1110, 4'b1110}: num_decode = 8'h01; // 1
            {4'b1101, 4'b1110}: num_decode = 8'h04; // 4
            {4'b1011, 4'b1110}: num_decode = 8'h07; // 7
            {4'b1110, 4'b1101}: num_decode = 8'h02; // 2
            {4'b1101, 4'b1101}: num_decode = 8'h05; // 5
            {4'b1011, 4'b1101}: num_decode = 8'h08; // 8
            {4'b0111, 4'b1101}: num_decode = 8'h00; // 0
            {4'b1110, 4'b1011}: num_decode = 8'h03; // 3
            {4'b1101, 4'b1011}: num_decode = 8'h06; // 6
            {4'b1011, 4'b1011}: num_decode = 8'h09; // 9
            default: num_decode = 8'hFF;
        endcase
    endfunction
                    
    function logic [7:0] opc_decode (input logic [3:0] row, input logic [3:0] col);
    //function to convert row and column read into hex decoded key
        case ({row, col})
            {4'b1110, 4'b1110}: opc_decode = 8'h00; // +
            {4'b1101, 4'b1110}: opc_decode = 8'h01; // -
            {4'b1011, 4'b1110}: opc_decode = 8'h02; // *
            {4'b0111, 4'b1110}: opc_decode = 8'h03; // /
            {4'b1110, 4'b1101}: opc_decode = 8'h04; // &
            {4'b1101, 4'b1101}: opc_decode = 8'h05; // |
            {4'b1011, 4'b1101}: opc_decode = 8'h06; // ^
            {4'b0111, 4'b1101}: opc_decode = 8'h07; // ~
            {4'b1110, 4'b1011}: opc_decode = 8'h08; // <<
            {4'b1101, 4'b1011}: opc_decode = 8'h09; // >>
            {4'b0111, 4'b1011 }: opc_decode = 8'h0A; // =
            default: opc_decode = 8'hFF;
        endcase
    endfunction
endmodule