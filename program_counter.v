`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2023 09:00:51 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input clk,
    input reset,
    
    input wen,
    input branches,
    input [31:0] addr_in,
    
    output reg [31:0] pc
);
    
    always @(posedge clk) begin
        if ( reset ) begin
            pc <= 0;
        end else if ( !reset && wen ) begin
            if ( !branches ) begin
                pc <= pc + 4;
            end else begin
                pc <= addr_in;
            end
        end
    end

endmodule
