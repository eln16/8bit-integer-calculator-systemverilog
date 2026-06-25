//##################################################################################################
/*
Project / Module    : ics
File name           : ics.sv
Version             : 1-0
Date created        : 14 APRIL 2025
Author              : Elveis Ng Kai Wei
Code type           : RTL Level (System Verilog)
Description         : Module definition of ICS, interacting all the block module
*/
//##################################################################################################

module ics (
    input               ip_sys_clk,
    input               ip_sys_reset,
    input [3:0]         ip_c_sync_nurow,
    input [3:0]         ip_c_sync_oprow,
    output logic [3:0]  op_c_hexc_nucol,
    output logic [3:0]  op_c_hexc_opcol,
    output logic [6:0]  op_c_iocb_seg,
    output logic [3:0]  op_c_iocb_sel);
    
    wire        is_negative;
    wire        use_shifter;
    wire        inpoverflow, aluoverflow;
    wire        compute;
    wire        display_sel;
    wire [1:0]  key_pressed;
    wire [2:0]  shift_amount;
    wire [3:0]  sync_nurow, sync_oprow;
    wire [3:0]  opcode;
    wire [7:0]  hex_num, hex_opc;
    wire [7:0]  operand_a, operand_b;
    wire [7:0]  alu_result; 
    wire [7:0]  shifted_data;


    syncb
    sync 
    (.ip_sys_clk(ip_sys_clk),
    .ip_sys_reset(ip_sys_reset),
    .ip_b_syncb_nurow(ip_c_sync_nurow),
    .ip_b_syncb_oprow(ip_c_sync_oprow),
    .op_b_syncb_nurow(sync_nurow),
    .op_b_syncb_oprow(sync_oprow));

    hexcb
    hexc
    (.ip_sys_clk(ip_sys_clk),
    .ip_sys_reset(ip_sys_reset),
    .ip_b_hexcb_nurow(sync_nurow),
    .ip_b_hexcb_oprow(sync_oprow),
    .op_b_hexcb_key_pressed(key_pressed),
    .op_b_hexcb_nucol(op_c_hexc_nucol),
    .op_b_hexcb_opcol(op_c_hexc_opcol),
    .op_b_hexcb_hex_num(hex_num),
    .op_b_hexcb_hex_opc(hex_opc));

    cub
    cu
    (.ip_sys_clk(ip_sys_clk),
    .ip_sys_reset(ip_sys_reset),
    .ip_b_cub_key_pressed(key_pressed),
    .ip_b_cub_hex_num(hex_num),
    .ip_b_cub_hex_opc(hex_opc),
    .op_b_cub_opcode(opcode),
    .op_b_cub_a(operand_a),
    .op_b_cub_b(operand_b),
    .op_b_cub_compute(compute),
    .op_b_cub_inpoverflow(inpoverflow),
    .op_b_cub_use_shifter(use_shifter),
    .op_b_cub_display_sel(display_sel));

    alub
    alu
    (.ip_sys_reset(ip_sys_reset),
    .ip_b_alub_compute(compute),
    .ip_b_alub_a(operand_a),
    .ip_b_alub_b(operand_b),
    .ip_b_alub_opcode(opcode),
    .op_b_alub_result(alu_result),
    .op_b_alub_neg(is_negative),
    .op_b_alub_aluoverflow(aluoverflow));

    bsb
    bs
    (.ip_sys_reset(ip_sys_reset),
    .ip_b_bsb_direction(opcode),
    .ip_b_bsb_data(operand_a),
    .ip_b_bsb_shift_amount(operand_b),
    .op_b_bsb_shifted_data(shifted_data));

    iocb
    ioc
    (.ip_sys_clk(ip_sys_clk),
    .ip_sys_reset(ip_sys_reset),
    .ip_b_iocb_neg(is_negative),
    .ip_b_iocb_compute(compute),
    .ip_b_iocb_inpoverflow(inpoverflow),
    .ip_b_iocb_aluoverflow(aluoverflow),
    .ip_b_iocb_display_sel(display_sel),
    .ip_b_iocb_use_shifter(use_shifter),
    .ip_b_iocb_a(operand_a),
    .ip_b_iocb_b(operand_b),
    .ip_b_iocb_result(alu_result),
    .ip_b_iocb_shifted_data(shifted_data),
    .op_b_iocb_seg(op_c_iocb_seg),
    .op_b_iocb_sel(op_c_iocb_sel));

endmodule