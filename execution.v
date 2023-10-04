`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 10:18:31 AM
// Design Name: 
// Module Name: execution
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


module execution(
    input clk,
    input reset,
    input flush_pipe,
    
    // From ID
    input [31:0] pc_addr,
    input [31:0] rd1,
    input [31:0] rd2_in,
    input [31:0] imm_gen,
    input [6:0] funct7,
    input [2:0] funct3,
    input [4:0] write_reg_in,
    
    // From Forwarding unit
    input [1:0] forwardA,
    input [1:0] forwardB,
    input [31:0] alu_data_mem,
    input [31:0] alu_data_wb,
    
    // From ID - Control Module
    input mem_read_ctrl_in,
    input mem_write_ctrl_in,
    input mem_to_reg_ctrl_in,
    input reg_write_ctrl_in,
    input branch_ctrl_in,
    input uncond_branch_ctrl_in,
    input alusrc_a_ctrl_in,
    input [1:0] alusrc_b_ctrl_in,
    input addr_src_ctrl_in,
    input [1:0] aluop_ctrl_in,
    
    // Pipeline registers: EX->MEM
    output reg [31:0] branch_addr,
    output reg [31:0] alu_result,
    output reg alu_zero,
    output reg [31:0] rd2_out,
    output reg [4:0] write_reg_out,
    output reg [2:0] funct3_out,
    
    // Passthrough Control Signals
    output reg mem_read_ctrl_out,
    output reg mem_write_ctrl_out,
    output reg mem_to_reg_ctrl_out,
    output reg reg_write_ctrl_out,
    output reg branch_ctrl_out,
    output reg uncond_branch_ctrl_out
);

    wire [3:0] alu_op;
    wire [31:0] alu_result_tmp;
    wire alu_zero_tmp;
    
    reg [31:0] aluA_tmp, aluB_tmp;
    
    // Branch Addr select MUX
    wire [31:0] branch_addr_tmp = imm_gen + ( (addr_src_ctrl_in == 1'b0) ? pc_addr : aluA_tmp );
    
    // ALU A source select mux
    wire [31:0] aluA = (alusrc_a_ctrl_in == 1'b0) ? aluA_tmp : pc_addr;
    
    // ALU B source select MUX
    reg [31:0] aluB;
    always @(alusrc_b_ctrl_in or imm_gen or aluB_tmp) begin
        case(alusrc_b_ctrl_in)
            2'b00: aluB <= aluB_tmp;
            2'b01: aluB <= imm_gen;
            2'b10: aluB <= 4;
        endcase
    end


    alu alu(
        aluA,
        aluB,
        alu_op,
        alu_result_tmp,
        alu_zero_tmp
    );
    
    alu_control alu_ctrl(
        .alu_op(aluop_ctrl_in),
        .funct7(funct7),
        .funct3(funct3),
        .alu_ctrl(alu_op)
    );
    
    // Forwarding muxes
    always @(forwardA or forwardB or rd1 or rd2_in or alu_data_wb or alu_data_mem) begin
        casex(forwardA)
            2'b00: aluA_tmp <= rd1;
            2'b01: aluA_tmp <= alu_data_wb;
            2'b10: aluA_tmp <= alu_data_mem;
            default: aluA_tmp <= 0;
        endcase
        
        casex(forwardB)
            2'b00: aluB_tmp <= rd2_in;
            2'b01: aluB_tmp <= alu_data_wb;
            2'b10: aluB_tmp <= alu_data_mem;
            default: aluB_tmp <= 0;
        endcase
    end
    
    // Pipeline Registers 
    always @(posedge clk) begin
        if ( reset || flush_pipe ) begin
            branch_addr <= 0;
            alu_result <= 0;
            alu_zero <= 0; 
            rd2_out <= 0;
            write_reg_out <= 0;
            funct3_out <= 0;
            mem_read_ctrl_out <= 0;
            mem_write_ctrl_out <= 0;
            mem_to_reg_ctrl_out <= 0;
            reg_write_ctrl_out <= 0;
            branch_ctrl_out <= 0;
            uncond_branch_ctrl_out <= 0;
        end else begin
            branch_addr <= branch_addr_tmp;
            alu_result <= alu_result_tmp;
            alu_zero <= alu_zero_tmp; 
            rd2_out <= aluB_tmp;
            write_reg_out <= write_reg_in;
            funct3_out <= funct3;
            mem_read_ctrl_out <= mem_read_ctrl_in;
            mem_write_ctrl_out <= mem_write_ctrl_in;
            mem_to_reg_ctrl_out <= mem_to_reg_ctrl_in;
            reg_write_ctrl_out <= reg_write_ctrl_in;
            branch_ctrl_out <= branch_ctrl_in;
            uncond_branch_ctrl_out <= uncond_branch_ctrl_in;
        end
    end

endmodule
