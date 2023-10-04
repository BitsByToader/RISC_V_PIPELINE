`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2023 02:14:36 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk,
    input reset
);

    wire if_pc_write;
    wire if_pc_src;
    wire if_id_pipe_write;
    wire pipeline_flush;
    wire [31:0] if_branch_addr;
    wire [31:0] id_pc_addr;
    wire [31:0] id_instr;

     instruction_fetch IF(
        clk,
        reset,
        pipeline_flush,
        if_pc_write,
        if_pc_src,
        if_branch_addr,
        if_id_pipe_write,
        id_pc_addr,
        id_instr
     );
     
     wire id_control_stall;
     
     wire [4:0] id_write_reg;
     wire [31:0] id_data_reg;
     wire id_reg_write_ctrl;
     wire [31:0] ex_pc_addr;
     wire [31:0] ex_rd1;
     wire [31:0] ex_rd2;
     wire [31:0] ex_imm_gen;
     wire [6:0] ex_funct7;
     wire [2:0] ex_funct3;
     
     wire [4:0] ex_write_reg, fu_rs1, fu_rs2;
     wire ex_mem_read_ctrl, ex_mem_write_ctrl, ex_mem_to_reg_ctrl, ex_reg_write_ctrl, ex_branch_ctrl, ex_alusrc_a_ctrl, ex_uncond_branch_ctrl, ex_addr_src_ctrl;
     wire [1:0] ex_aluop_ctrl, ex_alusrc_b_ctrl;
     
     instruction_decode ID(
        clk,
        reset,
        pipeline_flush,
        
        id_control_stall,
        
        id_pc_addr,
        id_instr,
 
        id_write_reg,
        id_data_reg,
        id_reg_write_ctrl,
       
        ex_pc_addr,
        ex_rd1,
        ex_rd2,
        ex_imm_gen,
        ex_funct7,
        ex_funct3,
        
        ex_write_reg,
        fu_rs1,
        fu_rs2,
        ex_mem_read_ctrl,
        ex_mem_write_ctrl,
        ex_mem_to_reg_ctrl,
        ex_reg_write_ctrl,
        ex_branch_ctrl,
        ex_uncond_branch_ctrl,
        ex_alusrc_a_ctrl,
        ex_alusrc_b_ctrl,
        ex_addr_src_ctrl,
        ex_aluop_ctrl       
     );
     
     wire [31:0] mem_alu_result;
     wire mem_alu_zero;
     wire [31:0] mem_rd2;
     wire [4:0] mem_write_reg;
     wire [2:0] mem_funct3;
     wire mem_mem_read_ctrl, mem_mem_write_ctrl, mem_mem_to_reg_ctrl, mem_reg_write_ctrl, mem_branch_ctrl, mem_uncond_branch_ctrl;
     
     wire [1:0] ex_forward_A, ex_forward_B;
     
     execution EX(
        clk,
        reset,
        pipeline_flush,

        ex_pc_addr,
        ex_rd1,
        ex_rd2,
        ex_imm_gen,
        ex_funct7,
        ex_funct3,
        ex_write_reg,
        
        ex_forward_A,
        ex_forward_B,
        mem_alu_result,
        id_data_reg,
       
        ex_mem_read_ctrl,
        ex_mem_write_ctrl,
        ex_mem_to_reg_ctrl,
        ex_reg_write_ctrl,
        ex_branch_ctrl,
        ex_uncond_branch_ctrl,
        ex_alusrc_a_ctrl,
        ex_alusrc_b_ctrl,
        ex_addr_src_ctrl,
        ex_aluop_ctrl,
       
        if_branch_addr,
        mem_alu_result,
        mem_alu_zero,
        mem_rd2,
        mem_write_reg,
        mem_funct3,
 
        mem_mem_read_ctrl,
        mem_mem_write_ctrl,
        mem_mem_to_reg_ctrl,
        mem_reg_write_ctrl,
        mem_branch_ctrl,
        mem_uncond_branch_ctrl
     );
     
     wire [31:0] wb_mem_data;
     wire [31:0] wb_alu_result;
     wire wb_mem_to_reg_ctrl;
     
     memory MEM(
        clk,
        reset,
   
        mem_funct3,
        mem_alu_result,
        mem_alu_zero,
        mem_rd2,
        mem_write_reg,
   
        mem_mem_read_ctrl,
        mem_mem_write_ctrl,
        mem_mem_to_reg_ctrl,
        mem_reg_write_ctrl,
        mem_branch_ctrl,
        mem_uncond_branch_ctrl,
   
        wb_mem_data,
        wb_alu_result,
        wb_mem_to_reg_ctrl,
        id_reg_write_ctrl,
        id_write_reg,
        
        if_pc_src
     );
     
     write_back WB(
        wb_mem_data,
        wb_alu_result,
        wb_mem_to_reg_ctrl,
    
        id_data_reg
     );
     
     forwarding_unit FU(
        fu_rs1,
        fu_rs2,
        mem_write_reg,
        id_write_reg,
        mem_reg_write_ctrl,
        id_reg_write_ctrl,
        ex_forward_A,
        ex_forward_B
     );
     
     hazard_detection_unit HDU(
        // Control hazard
        if_pc_src,
        pipeline_flush,
        
        // Data hazard
        ex_write_reg,
        id_instr[19:15],
        id_instr[24:20],
        ex_mem_read_ctrl,
        if_pc_write,
        if_id_pipe_write,
        id_control_stall
     );

endmodule