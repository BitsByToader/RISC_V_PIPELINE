`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 04:19:12 PM
// Design Name: 
// Module Name: alu_control
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


module alu_control(
    input [1:0] alu_op,
    input [6:0] funct7,
    input [2:0] funct3,
    
    output reg [3:0] alu_ctrl
);

    always @ ( alu_op or funct7 or funct3 ) begin
        casex({alu_op, funct7, funct3})  
            12'b00xxxxxxxxxx: alu_ctrl = 4'b0010; // ld,sd
            12'b100000000000: alu_ctrl = 4'b0010; // add
            12'b100100000000: alu_ctrl = 4'b0110; // sub
            12'b100000000111: alu_ctrl = 4'b0000; // and
            12'b100000000110: alu_ctrl = 4'b0001; // or
            12'b100000000100: alu_ctrl = 4'b0011; // xor 
            12'b1x000000x101: alu_ctrl = 4'b0101; // srl,srli
            12'b1x000000x001: alu_ctrl = 4'b0100; // sll,slli
            12'b1x010000x101: alu_ctrl = 4'b1001; // sra,srai
            12'b100000000011: alu_ctrl = 4'b0111; // sltu
            12'b100000000010: alu_ctrl = 4'b1000; // slt
            12'b11xxxxxxx000: alu_ctrl = 4'b0010; // addi
            12'b11xxxxxxx111: alu_ctrl = 4'b0000; // andi
            12'b11xxxxxxx110: alu_ctrl = 4'b0001; // ori
            12'b11xxxxxxx100: alu_ctrl = 4'b0011; // xori
            12'b11xxxxxxx011: alu_ctrl = 4'b0111; // sltiu
            12'b11xxxxxxx010: alu_ctrl = 4'b1000; // slti
            12'b01xxxxxxx00x: alu_ctrl = 4'b0110; // beq,bne
            12'b01xxxxxxx10x: alu_ctrl = 4'b1000; // blt,bge
            12'b01xxxxxxx11x: alu_ctrl = 4'b0111; // bltu,bgeu
        endcase
    end

endmodule
