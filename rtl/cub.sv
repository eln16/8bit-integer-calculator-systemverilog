//##################################################################################################
/*
Project / Module    : cub
File name           : cub.sv
Version             : 1-0
Date created        : 7 APRIL 2025
Author              : Elveis Ng Kai Wei
Code type           : RTL Level (System Verilog)
Description         : Control Unit Block (CUB) FSM handling keypad input, operand storage, operator 
                      selection, and compute control for a simple calculator system.
*/
//##################################################################################################

module cub (
    input               ip_sys_clk,
    input               ip_sys_reset,
    input [1:0]         ip_b_cub_key_pressed,
    input [7:0]         ip_b_cub_hex_num,
    input [7:0]         ip_b_cub_hex_opc,   
    output logic [3:0]  op_b_cub_opcode,
    output logic [7:0]  op_b_cub_a, 
    output logic [7:0]  op_b_cub_b,
    output logic        op_b_cub_inpoverflow,
    output logic        op_b_cub_compute,
    output logic        op_b_cub_use_shifter,
    output logic        op_b_cub_display_sel);// 1 display A , 0 display B
    
    logic       opc_load = 1'b0;
    logic [1:0] a_count = 2'b00;
    logic [1:0] b_count = 2'b00;
    logic [2:0] state = 3'b000;
    logic [8:0] operand_reg_a = 9'b000000000;
    logic [8:0] operand_reg_b = 9'b000000000;
    logic [8:0] next_operand_a;
    logic [8:0] next_operand_b;
    logic [7:0] prev_key_a;
    logic [7:0] prev_key_b;
    logic [7:0] prev_key_opc;
    logic [7:0] track_key_opc;
    logic       overflow_handle;
    
    always_ff @(posedge ip_sys_clk, posedge ip_sys_reset) begin
    
        if (ip_sys_reset) begin
        
            // reset all outputs and state
            op_b_cub_opcode <= 4'hF;
            op_b_cub_a <= 8'h00;
            op_b_cub_b <= 8'h00;
            op_b_cub_compute <= 0;
            op_b_cub_use_shifter <= 0;
            op_b_cub_display_sel <= 1;
            op_b_cub_inpoverflow <= 1'b0;
            
            opc_load <= 0;
            state <= 3'b000;
            a_count <= 0;
            b_count <= 0;
            operand_reg_a <= 9'h000;
            operand_reg_b <= 9'h000;
            
        end 
        else begin
        
            op_b_cub_compute <= 0;
               
            case (state)
    
                3'b000: begin // Free Press IDLE

                    overflow_handle <= 0;
                    
                    if ((ip_b_cub_key_pressed == 2'b10) && (ip_b_cub_hex_opc <= 8'h09)) begin
                        state <= 3'b010;
                        track_key_opc <= ip_b_cub_hex_opc;
                    end
                    
                    else if ((!opc_load) && (ip_b_cub_key_pressed == 2'b01) && (a_count < 3) && (ip_b_cub_hex_num <= 8'h09)) begin
                        next_operand_a   = (operand_reg_a * 10) + ip_b_cub_hex_num;
                        operand_reg_a    <= next_operand_a;
                        op_b_cub_a       <= next_operand_a[7:0];
                        a_count          <= a_count + 1;
                        prev_key_a       <= ip_b_cub_hex_num;
                        state <= 3'b001;
                    end 
                    
                    else if (opc_load && (ip_b_cub_key_pressed == 2'b01) && (b_count < 3) && (ip_b_cub_hex_num <= 8'h09)) begin
                        next_operand_b   = (operand_reg_b * 10) + ip_b_cub_hex_num;
                        operand_reg_b    <= next_operand_b;
                        op_b_cub_b       <= next_operand_b[7:0];
                        b_count          <= b_count + 1;
                        prev_key_b       <= ip_b_cub_hex_num;
                        state <= 3'b011;
                    end 
                    
                    else if ((ip_b_cub_hex_opc == 8'h0A) && (ip_b_cub_key_pressed == 2'b10) && (ip_b_cub_hex_opc != prev_key_opc)) begin // '='
                        state <= 3'b100;
                    end
                    
                end
    
                3'b001: begin // Load Operand A
                
                    op_b_cub_display_sel <= 1; // Display A
                    overflow_handle <= 1'b0;
                    
                    if ((ip_b_cub_key_pressed == 2'b01) && (ip_b_cub_hex_num <= 8'h09) && (ip_b_cub_hex_num != prev_key_a) && (a_count < 3)) begin
        
                        next_operand_a   = (operand_reg_a * 10) + ip_b_cub_hex_num;
                        operand_reg_a    <= next_operand_a;
                        op_b_cub_a       <= next_operand_a[7:0];
                        a_count          <= a_count + 1;
                        prev_key_a       <= ip_b_cub_hex_num;
                
                        if (next_operand_a > 9'd255) begin
                            overflow_handle <= 1'b1;
                        end else begin
                            overflow_handle <= 1'b0;
                        end
                
                    end 
                    else if (ip_b_cub_key_pressed != 2'b01) begin
                        prev_key_a <= 8'hFF; // reset key latch when no key is pressed
                    end
                    
                    state <= 3'b000;
                    
                end
    
                3'b010: begin // Load Operator
                        
                        overflow_handle <= 1'b0;
                        op_b_cub_display_sel <= 1;// Display A
                        op_b_cub_b <= 8'h00;
                        opc_load <= 1'b1;
                        a_count <= 0;
                        
                        if (track_key_opc != prev_key_opc) begin
                        
                             prev_key_opc <= ip_b_cub_hex_opc;

                            case (track_key_opc)
                                8'h00: begin
                                    op_b_cub_opcode <= 4'h2; // +
                                    op_b_cub_use_shifter <= 0;
                                end
                                8'h01: begin
                                    op_b_cub_opcode <= 4'h3; // -
                                    op_b_cub_use_shifter <= 0;
                                end
                                8'h02: begin
                                    op_b_cub_opcode <= 4'h4; // *
                                    op_b_cub_use_shifter <= 0;
                                end
                                8'h03: begin
                                    op_b_cub_opcode <= 4'h5; // /
                                    op_b_cub_use_shifter <= 0;
                                end
                                8'h04: begin
                                    op_b_cub_opcode <= 4'h6; // &
                                    op_b_cub_use_shifter <= 0;
                                end
                                8'h05: begin
                                    op_b_cub_opcode <= 4'h7; // |
                                    op_b_cub_use_shifter <= 0;
                                end
                                8'h06: begin
                                    op_b_cub_opcode <= 4'h8; // ^
                                    op_b_cub_use_shifter <= 0;
                                end
                                8'h07: begin
                                    op_b_cub_opcode <= 4'h9; // ~
                                    op_b_cub_use_shifter <= 0;
                                end
                                8'h08: begin
                                    op_b_cub_opcode <= 4'h0; // <<
                                    op_b_cub_use_shifter <= 1;
                                end
                                8'h09: begin
                                    op_b_cub_opcode <= 4'h1; // >>
                                    op_b_cub_use_shifter <= 1;
                                end
                                default: op_b_cub_opcode <= 4'hF;
                            endcase
                            
                            state <= 3'b000;
                            op_b_cub_b <= 8'h00;
                            opc_load <= 1'b1;
                            a_count <= 0;
                        end
                        else if (ip_b_cub_key_pressed != 2'b10) begin
                            prev_key_opc <= 8'hFF;
                        end

                end
    
                3'b011: begin // Load Operand B
                
                    op_b_cub_display_sel <= 0; // Display B
                    overflow_handle <= 1'b0;
                    
                    if ((ip_b_cub_key_pressed == 2'b01) && (ip_b_cub_hex_num <= 8'h09) && (ip_b_cub_hex_num != prev_key_b) && (b_count < 3)) begin
        
                        next_operand_b   = (operand_reg_b * 10) + ip_b_cub_hex_num;
                        operand_reg_b    <= next_operand_b;
                        op_b_cub_b       <= next_operand_b[7:0];
                        b_count          <= b_count + 1;
                        prev_key_b       <= ip_b_cub_hex_num;
                
                        if (next_operand_b > 9'd255) begin
                            overflow_handle <= 1'b1;
                        end else begin
                            overflow_handle <= 1'b0;
                        end
                
                    end else if (ip_b_cub_key_pressed != 2'b01) begin
                        prev_key_b <= 8'hFF;
                    end 
                    state <= 3'b000;

                end
    
                3'b100: begin // Compute
                    
                    op_b_cub_compute <= 1'b1;
                    
                    op_b_cub_a <= operand_reg_a[7:0];
                    op_b_cub_b <= operand_reg_b[7:0];
                    op_b_cub_inpoverflow <= overflow_handle;
                
                    state <= 3'b101; 

                end
                
                3'b101: begin // Clear
               
                    op_b_cub_compute <= 1'b0;
                    op_b_cub_opcode <= 4'hF;
                    op_b_cub_a <= 8'h00;
                    op_b_cub_b <= 8'h00;
                    op_b_cub_use_shifter <= 0;
                    op_b_cub_display_sel <= 1;
                    overflow_handle <= 1'b0;
                    
                    opc_load <= 0;
                    operand_reg_a <= 0;
                    operand_reg_b <= 0;
                    a_count <= 0;
                    b_count <= 0;
                    
                    state <= 3'b000;
                    
                end
                default: begin
                    state <= 3'b000;
                end
                
            endcase
            
            if (ip_b_cub_key_pressed != 2'b10) begin
                prev_key_opc <= 8'hFF;
            end
        end
    end
endmodule