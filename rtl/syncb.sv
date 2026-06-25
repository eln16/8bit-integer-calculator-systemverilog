//##################################################################################################
/*
Project / Module    : syncb
File name           : syncb.sv
Version             : 1-0
Date created        : 7 APRIL 2025
Author              : Liew Jia Xin
Code type           : RTL Level (System Verilog)
Description         : Double-flip-flop synchronizer for 4-bit input signals
*/ 
//##################################################################################################

module syncb(
    input ip_sys_clk,
    input ip_sys_reset,
    input [3:0] ip_b_syncb_nurow,
    input [3:0] ip_b_syncb_oprow,
    output logic [3:0] op_b_syncb_nurow,
    output logic [3:0] op_b_syncb_oprow);
    
    logic [3:0] sync_num_ff;
    logic [3:0] sync_opc_ff;
    
    always_ff @(posedge ip_sys_clk, posedge ip_sys_reset) begin 
        
        if (ip_sys_reset) begin
            sync_num_ff <= 4'b1111;
            sync_opc_ff <= 4'b1111;
            op_b_syncb_nurow <= 4'b1111;
            op_b_syncb_oprow <= 4'b1111;

        end
        
        else begin 
            sync_num_ff <= ip_b_syncb_nurow;
            op_b_syncb_nurow <= sync_num_ff;
            
            sync_opc_ff <= ip_b_syncb_oprow;
            op_b_syncb_oprow <= sync_opc_ff;

        end

    end 
endmodule
