`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 05:34:32 PM
// Design Name: 
// Module Name: write_back
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


module write_back(
    input [31:0] mem_data,
    input [31:0] alu_result,
    input mem_to_reg,
    
    output [31:0] write_back_out
);
    
    assign write_back_out = (mem_to_reg == 1'b1) ? mem_data : alu_result;

endmodule
