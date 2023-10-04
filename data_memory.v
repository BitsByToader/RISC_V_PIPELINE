`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 04:52:56 PM
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input clk,
    input reset,

    input [31:0] address,
    input [31:0] write_data,
    input wen,
    input ren,
    output reg [31:0] read_data
);

    reg [31:0] data [0:1023];
    
    integer i;
    always @(posedge clk) begin
        if ( reset ) begin
            for (i = 0; i < 1024; i = i + 1) begin
                data[i] <= 32'b0;
            end
            
            data[0] <= 70;
            data[1] <= 71;
            data[2] <= 72;
            data[3] <= 73;
            data[4] <= 74;
            data[5] <= 75;
        end else begin
            if ( wen )
                data[address] <= write_data;
        end
    end
    
    always @(ren or address) begin
        if ( ren )
            read_data <= data[address];
    end

endmodule
