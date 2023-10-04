`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 04:42:55 PM
// Design Name: 
// Module Name: memory
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


module memory(
    input clk,
    input reset,
    
    // From EX
    input [2:0] funct3,
    input [31:0] alu_result_in,
    input alu_zero,
    input [31:0] rd2,
    input [4:0] write_reg_in,
    
    // Control Signals
    input mem_read_ctrl_in,
    input mem_write_ctrl_in,
    input mem_to_reg_ctrl_in,
    input reg_write_ctrl_in,
    input branch_ctrl_in,
    input uncond_branch_ctrl_in,
    
    // Outputs for next pipeline stage --> Write Back
    output reg [31:0] mem_data,
    output reg [31:0] alu_result_out,
    output reg mem_to_reg_ctrl_out,
    output reg reg_write_ctrl_out,
    output reg [4:0] write_reg_out,
    
    // Output for PC control
    output pc_src
);
    wire [31:0] mem_data_out_tmp; 
    
    data_memory datamem(
        clk,
        reset,
        alu_result_in,
        rd2,
        mem_write_ctrl_in,
        mem_read_ctrl_in,
        mem_data_out_tmp
    );
    
    branch_control branch_control(
        alu_zero,
        alu_result_in[0],
        branch_ctrl_in,
        uncond_branch_ctrl_in,
        funct3,
        pc_src
    );
    
    // Pipeline Registers
    always @(posedge clk) begin
        if ( reset ) begin
            mem_data <= 0;
            alu_result_out <= 0;
            mem_to_reg_ctrl_out <= 0;
            reg_write_ctrl_out <= 0;
            write_reg_out <= 0;
        end else begin
            mem_data <= mem_data_out_tmp;
            alu_result_out <= alu_result_in;
            mem_to_reg_ctrl_out <= mem_to_reg_ctrl_in;
            reg_write_ctrl_out <= reg_write_ctrl_in;
            write_reg_out <= write_reg_in;
        end
    end

endmodule
