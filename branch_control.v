`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2023 10:07:35 PM
// Design Name: 
// Module Name: branch_control
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


module branch_control(
    input alu_zero,
    input alu_out,
    input branches,
    input uncond_branch,
    input [2:0] funct3,
    
    output pc_src
);

wire beq, bne, blt, bge;

assign beq = alu_zero & (~funct3[2]) & (~funct3[1]) & (~funct3[0]);
assign bne = (~alu_zero) & (~funct3[2]) & (~funct3[1]) & funct3[0];
assign blt = alu_out & funct3[2] & (~funct3[0]);
assign bge = (~alu_out) & funct3[2] & funct3[0];

assign pc_src = branches & (beq|bne|blt|bge|uncond_branch); 

endmodule
