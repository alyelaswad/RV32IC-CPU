`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2024 03:01:13 PM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
 input [4:0] ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, MEM_WB_rd, input EX_MEM_CTRL_regwrite, MEM_WB_CTRL_regwrite, output reg [1:0] Forward_SelA, Forward_SelB
);
always@(*)

begin
if ( (EX_MEM_CTRL_regwrite == 1'b1) && (EX_MEM_rd != 0) && ( EX_MEM_rd == ID_EX_rs1) )
Forward_SelA = 2'b10;
else
Forward_SelA = 2'b00;

if ( (EX_MEM_CTRL_regwrite==1'b1) &&( EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2) )
Forward_SelB = 2'b10;
else
Forward_SelB = 2'b00;

end
endmodule
