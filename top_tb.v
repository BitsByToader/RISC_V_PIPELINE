`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2023 02:14:36 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb();

    reg clk, reset;
    
    top top(
        .clk(clk),
        .reset(reset)
    );
    
    initial begin
        clk = 0; reset = 1;
        #10 reset = 0;
        #300 $finish();
    end
    
    always #5 clk = ~clk;

endmodule
