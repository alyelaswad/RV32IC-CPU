`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 04:08:48 PM
// Design Name: 
// Module Name: CU
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


module CU( input [4:0]inst, output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,output reg [1:0] ALUOp,output reg Jal,Jalr,Lui,Auipc);
always @(*) begin
case(inst) 
5'b01100: begin Branch=0; MemRead=0; MemtoReg=0; MemWrite=0; ALUSrc=0; RegWrite=1; ALUOp=2;Jal=0;Jalr=0;Lui=0;Auipc=0; end
5'b00000: begin Branch=0; MemRead=1; MemtoReg=1; MemWrite=0; ALUSrc=1; RegWrite=1; ALUOp=0;Jal=0;Jalr=0;Lui=0;Auipc=0; end
5'b01000: begin Branch=0; MemRead=0; MemtoReg=1'b0; MemWrite=1; ALUSrc=1; RegWrite=0; ALUOp=0;Jal=0;Jalr=0;Lui=0;Auipc=0; end
5'b11000: begin Branch=1; MemRead=0; MemtoReg=1'b0; MemWrite=0; ALUSrc=0; RegWrite=0; ALUOp=1;Jal=0;Jalr=0;Lui=0;Auipc=0; end
5'b00100: begin Branch=0; MemRead=0; MemtoReg=0; MemWrite=0; ALUSrc=1; RegWrite=1; ALUOp=3;Jal=0;Jalr=0;Lui=0;Auipc=0; end//i
5'b11011: begin Branch=0; MemRead=0; MemtoReg=1'b0; MemWrite=0; RegWrite=1;Jal=1;Jalr=0;Lui=0;Auipc=0; end // JAL
5'b11001: begin Branch=0; MemRead=0; MemtoReg=1'b0; MemWrite=0;  ALUOp=0; ALUSrc=1 ;RegWrite=1;Jal=0;Jalr=1;Lui=0;Auipc=0; end // JALR
5'b01101: begin Branch=0; MemRead=0; MemtoReg=1'b0; MemWrite=0;  RegWrite=1;Jal=0;Jalr=0;Lui=1;Auipc=0; end // LUI
5'b00101: begin Branch=0; MemRead=0; MemtoReg=1'b0; MemWrite=0;  RegWrite=1;Jal=0;Jalr=0;Lui=0;Auipc=1; end // AUIPC
5'b00011:begin Branch=0; MemRead=0; MemtoReg=0; MemWrite=0;  RegWrite=0;Jal=0;Jalr=0;Lui=0;Auipc=0;end
endcase
end
endmodule