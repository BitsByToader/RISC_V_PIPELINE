`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2023 11:09:34 AM
// Design Name: 
// Module Name: hazard_detection_unit
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

module hazard_detection_unit(
    // For control hazars when branching
    input branches,
    output reg flush_if_id,
    
    // For data hazards when stalling is needed
    input [4:0] rd,         // destination reg in EX
    input [4:0] rs1,        // source reg in ID
    input [4:0] rs2,        // source reg in ID
    input mem_read,         // mem_read in EX
    output reg pc_write,    // controls write of pc
    output reg if_id_write, // controls writing of IF->ID pipeline reg
    output reg control_sel  // control unit selection
);
  
  always@(*) begin
    if ( branches ) begin // Control hazard ~~ branching
        pc_write <= 1'b1; // Still write to PC so we can effectively branch
        if_id_write <= 1'b1; // Stop writing to IF/ID pipe for the other signals to properly take effect
        control_sel <= 1'b1; // Zero-out the control signals
        flush_if_id <= 1'b1; // Flush the pipeline because we predicted wrong (we're always predicting a branch doesn't happen)
    end else begin // Data hazard ~~ stalling
        if( mem_read && ( (rd==rs1) || (rd==rs2) ) ) begin
            pc_write <= 1'b0; // Stop writing to PC during the stall to stop program execution
            if_id_write <= 1'b0; // Keep the pipe in place for the same reason as above
            control_sel <= 1'b1; // Zero-out the control signals
            flush_if_id <= 1'b0;
        end else begin // No hazard
            pc_write <= 1'b1;
            if_id_write <= 1'b1;
            control_sel <= 1'b0;
            flush_if_id <= 1'b0;
        end
    end
  end
          
endmodule

