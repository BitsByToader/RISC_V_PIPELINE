`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2023 08:58:41 PM
// Design Name: 
// Module Name: instruction_fetch
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


module instruction_fetch(
    input clk,
    input reset,
    input flush_pipe,
    
    input pc_write,
    input pc_src,
    input [31:0] branch_addr,
    input pipeline_reg_write,
    
    output reg [31:0] pc_addr,
    output reg [31:0] instr
);

    wire [31:0] pc_addr_tmp;
    wire [31:0] instr_tmp;

    program_counter pc(
        .clk(clk),
        .reset(reset),
        .wen(pc_write),
        .branches(pc_src),
        .addr_in(branch_addr),
        .pc(pc_addr_tmp)
    );
    
    instruction_memory imem(
        .addr(pc_addr_tmp),
        .dout(instr_tmp)
    );
    
    // Pipeline Registers
    always @(posedge clk) begin
        if ( reset || flush_pipe ) begin
            pc_addr <=0;
            instr <= 0;
        end else if ( !reset && pipeline_reg_write )begin
            pc_addr <= pc_addr_tmp;
            instr <= instr_tmp;
        end
    end

endmodule
