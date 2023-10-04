`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 09:42:42 AM
// Design Name: 
// Module Name: control_module
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


module control_module(
    input [6:0] opcode,
    input stall,
    
    output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
    output reg RegWrite,
    output reg Branch,
    output reg UnconditionalBranch,
    output reg ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg AddrSrc,
    output reg [1:0] ALUop
);

    always@(stall or opcode) begin
        casex({stall, opcode})
            8'b1_XXXXXXX: {UnconditionalBranch, AddrSrc, ALUSrcA, ALUSrcB,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 12'b000000000000; // STALL!
            8'b0_0000000: {UnconditionalBranch, AddrSrc, ALUSrcA, ALUSrcB,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 12'b000000000000; // nop
            8'b0_0000011: {UnconditionalBranch, AddrSrc, ALUSrcA, ALUSrcB,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 12'b000011110000; // lw
            8'b0_0100011: {UnconditionalBranch, AddrSrc, ALUSrcA, ALUSrcB,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 12'b000010001000; // sw
            8'b0_0110011: {UnconditionalBranch, AddrSrc, ALUSrcA, ALUSrcB,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 12'b000000100010; // r
            8'b0_0010011: {UnconditionalBranch, AddrSrc, ALUSrcA, ALUSrcB,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 12'b000010100011; // i
            8'b0_1100011: {UnconditionalBranch, AddrSrc, ALUSrcA, ALUSrcB,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 12'b000000000101; // branch
            8'b0_1100111: {UnconditionalBranch, AddrSrc, ALUSrcA, ALUSrcB,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 12'b111100100100; // jalr
            8'b0_1101111: {UnconditionalBranch, AddrSrc, ALUSrcA, ALUSrcB,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 12'b101100100100; // jal
        endcase
    end

endmodule
