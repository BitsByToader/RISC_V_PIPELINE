`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2023 09:50:05 AM
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
    input [4:0] rs1,                    //adresa registrului sursa 1 in etapa EX
    input [4:0] rs2,                    //adresa registrului sursa 2 in etapa EX
    input [4:0] ex_mem_rd,              //adresa registrului destinatie in etapa MEM
    input [4:0] mem_wb_rd,              //adresa registrului destinatie in etapa WB
    input ex_mem_regwrite,              //semnalul de control RegWrite in etapa MEM
    input mem_wb_regwrite,              //semnalul de control RegWrite in etapa WB
    output reg [1:0] forwardA,forwardB 
);

  always @(*) begin
    if ( ex_mem_regwrite && ( ex_mem_rd != 5'b0 ) && ( ex_mem_rd == rs1 ) )
        forwardA <= 2'b10; //EX hazard rs1
    else if ( mem_wb_regwrite && ( mem_wb_rd != 5'b0 ) && 
              !( ex_mem_regwrite && ( ex_mem_rd != 5'b0 ) && ( ex_mem_rd == rs1 ) ) && 
              ( mem_wb_rd == rs1 )
            )
      forwardA <= 2'b01; //MEM hazard rs1
    else
      forwardA <= 2'b00; //no hazard  
    
    if ( ex_mem_regwrite && ( ex_mem_rd != 5'b0 ) && ( ex_mem_rd == rs2 ) )
      forwardB <= 2'b10; //EX hazard rs2
    else if ( mem_wb_regwrite && ( mem_wb_rd != 5'b0 ) && 
              !( ex_mem_regwrite && ( ex_mem_rd != 5'b0 ) && ( ex_mem_rd == rs2 ) ) &&
              (mem_wb_rd == rs2)
            )
      forwardB <= 2'b01; //MEM hazard rs1
    else
      forwardB <= 2'b00; //no hazard
      
  end
endmodule
