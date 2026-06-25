//##################################################################################################
/*
Project / Module    : alub
File name           : alub.sv
Version             : 1.0
Date created        : 7 APRIL 2025
Author              : Ong Yee Hong
Code type           : RTL Level (System Verilog)
Description         : Arithmetic Logic Unit Block (ALUB) get input to perform arithmetic operation 
                      (+, -, *, /, etc)
*/
//##################################################################################################

module alub (
    input               ip_sys_reset,
    input               ip_b_alub_compute,
    input [7:0]         ip_b_alub_a, 
    input [7:0]         ip_b_alub_b,
    input [3:0]         ip_b_alub_opcode,
    output logic [7:0]  op_b_alub_result,
    output logic        op_b_alub_neg,
    output logic        op_b_alub_aluoverflow);
    
    logic [15:0]        mul_temp;

    always_comb begin
    
        if (ip_sys_reset) begin
        
            op_b_alub_aluoverflow = 1'b0;
            op_b_alub_result = 8'h00;
            op_b_alub_neg = 1'b0;
        
        end
        else begin
            
            if (ip_b_alub_compute) begin
                case (ip_b_alub_opcode)
                
                    4'h2: begin // Addition
                    
                        op_b_alub_result = ip_b_alub_a + ip_b_alub_b;                   
                        op_b_alub_aluoverflow = (ip_b_alub_a + ip_b_alub_b) < ip_b_alub_a;
                        op_b_alub_neg = 1'b0;
                      
                    end
                    
                    4'h3: begin // Subtraction
                    
                        op_b_alub_result = ip_b_alub_a - ip_b_alub_b;
                        
                        if (ip_b_alub_a < ip_b_alub_b) begin
                            op_b_alub_aluoverflow = 1'b0;
                            op_b_alub_neg = 1'b1;
                        end
                        else begin
                            op_b_alub_aluoverflow = 1'b0;
                            op_b_alub_neg = 1'b0;
                        end
                    
                    end
                    
                    4'h4: begin // Multiplication
                    
                        mul_temp = ip_b_alub_a * ip_b_alub_b;
                        op_b_alub_result = mul_temp[7:0];
                        
                        op_b_alub_aluoverflow = |mul_temp[15:8];
                        op_b_alub_neg = 1'b0;
                    
                    end
                    
                    4'h5: begin // Division
                    
                        if (ip_b_alub_b == 8'h00) begin
                            op_b_alub_aluoverflow = 1'b1;
                            op_b_alub_result = 8'h00;
                        end
                        else begin
                            op_b_alub_result = ip_b_alub_a / ip_b_alub_b;
                            op_b_alub_aluoverflow = 1'b0;
                        end
                    
                    end
                    
                    4'h6: begin // Bitwise AND
                    
                        op_b_alub_result = ip_b_alub_a & ip_b_alub_b;
                        op_b_alub_aluoverflow = 1'b0;
                        op_b_alub_neg = 1'b0;
                    
                    end
                    
                    4'h7: begin // Bitwise OR
                    
                        op_b_alub_result = ip_b_alub_a | ip_b_alub_b;
                        op_b_alub_aluoverflow = 1'b0;
                        op_b_alub_neg = 1'b0;
                    
                    end
                    
                    4'h8: begin // Bitwise XOR
                    
                        op_b_alub_result = ip_b_alub_a ^ ip_b_alub_b;
                        op_b_alub_aluoverflow = 1'b0;
                        op_b_alub_neg = 1'b0;
                    
                    end
                    
                    4'h9: begin // Bitwise NOT
                    
                        op_b_alub_result = ~ip_b_alub_b;
                        op_b_alub_aluoverflow = 1'b0;
                        op_b_alub_neg = 1'b0;
                    
                    end
                    
                    default: begin
                    
                        op_b_alub_aluoverflow = 1'b0;
                        op_b_alub_result = 8'h00;
                        op_b_alub_neg = 1'b0;
                    
                    end
                    
                endcase
            end
        end
    end
endmodule