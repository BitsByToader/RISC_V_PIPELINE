`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 04:05:49 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] opA,
    input [31:0] opB,
    input [3:0] op,
    
    output reg [31:0] result,
    output zero
);

    always @ ( opA or opB or op ) begin
        case (op)
            4'b0000: result <= opA & opB; //and
            4'b0001: result <= opA | opB; //or
            4'b0010: result <= opA + opB; //add
            4'b0011: result <= opA ^ opB; //xor
            4'b0100: result <= opA << opB[4:0]; //sll
            4'b0101: result <= opA >> opB[4:0]; //srl
            4'b0110: result <= opA - opB; //sub
            4'b0111: result <= (opA < opB) ? 32'b1 : 32'b0; //sltu
            4'b1000: result <= ($signed(opA) < $signed(opB)) ? 32'b1 : 32'b0; //slt
            4'b1001: result <= opA >>> opB[4:0]; //sra
        endcase  
   end
   
   assign zero = (result == 32'b0) ? 1'b1 : 1'b0; 

endmodule
