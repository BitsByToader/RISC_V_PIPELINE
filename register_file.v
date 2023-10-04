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


module register_file(
    input clk,
    input reset,
    
    input wen,
    
    input [4:0] ra,
    input [4:0] rb,
    input [4:0] rc,
    
    output [31:0] da,
    output [31:0] db,
    input [31:0] dc
);

    reg [31:0] regs [0:31];

    // read
    assign da = (ra != 5'b0) ?
               (((wen == 1'b1)&&(ra == rc)) ? // bypass for when reading and writing in the same cycle
                      dc : regs[ra]) : 32'b0;
                      
  assign db = (rb != 5'b0) ?
                      (((wen == 1'b1)&&(rb == rc)) ? 
                      dc: regs[rb]) : 32'b0;
    
    // write
    always @(posedge clk) begin
        if ( reset ) begin
            regs[0] <= 0; regs[1] <= 0; regs[2] <= 0; regs[3] <= 0; regs[4] <= 0; regs[5] <= 0; regs[6] <= 0; regs[7] <= 0; 
            regs[8] <= 0; regs[9] <= 0; regs[10] <= 0; regs[11] <= 0; regs[12] <= 0; regs[13] <= 0; regs[14] <= 0; regs[15] <= 0;
            regs[16] <= 0; regs[17] <= 0; regs[18] <= 0; regs[19] <= 0; regs[20] <= 0; regs[21] <= 0; regs[22] <= 0; regs[23] <= 0;
            regs[24] <= 0; regs[25] <= 0; regs[26] <= 0; regs[27] <= 0; regs[28] <= 0; regs[29] <= 0; regs[30] <= 0; regs[31] <= 0;
        end else begin 
            if ( wen ) begin
                regs[rc] <= dc;
            end
        end
    end

endmodule
