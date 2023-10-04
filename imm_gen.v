`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2023 10:16:35 PM
// Design Name: 
// Module Name: register_file
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

module imm_gen(
    input [31:0] instr,
    output reg [31:0] imm
);

    always@(instr) begin
        casex({instr[14:12],instr[6:0]})
            10'bxxx0000011: imm <= {{20{instr[31]}},instr[31:20]}; // load instructions
            10'b0000010011: imm <= {{20{instr[31]}},instr[31:20]}; // addi
            10'b1110010011: imm <= {{20{instr[31]}},instr[31:20]}; // andi
            10'b1100010011: imm <= {{20{instr[31]}},instr[31:20]}; // ori
            10'b1000010011: imm <= {{20{instr[31]}},instr[31:20]}; // xori
            10'b0100010011: imm <= {{20{instr[31]}},instr[31:20]}; // slti
            10'b0110010011: imm <= {{20{instr[31]}},instr[31:20]}; // sltiu
            10'b1010010011: imm <= {27'b0,instr[24:20]}; // srli,srai
            10'b0010010011: imm <= {27'b0,instr[24:20]}; // slli
            10'bxxx0100011: imm <= {{20{instr[31]}},instr[31:25],instr[11:7]}; // store instructions
            10'bxxx1100011: imm <= {{20{instr[31]}},instr[7],instr[30:25],instr[11:8], 1'b0}; // beq,bne,blt,bge,bltu,bgeu
            10'b0001100111: imm <= {{20{instr[31]}},instr[31:20]}; // jalr
            10'bxxx1101111: imm <= {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21],1'h0}; // jal
            default: imm <= 32'b0;
        endcase
    end

endmodule 