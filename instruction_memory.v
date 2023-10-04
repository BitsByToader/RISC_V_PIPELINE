`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2023 09:55:09 PM
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory (
    input [31:0] addr,
    output [31:0] dout
);

    reg [7:0] mem [0:256];

    assign dout = { mem[addr+3], mem[addr+2], mem[addr+1], mem[addr] };
    
    integer i;
    initial begin
        for ( i = 0; i < 256; i=i+1 ) begin
            mem[i] = 0;
        end
        
        $readmemh("code.mem", mem);
    end

endmodule
