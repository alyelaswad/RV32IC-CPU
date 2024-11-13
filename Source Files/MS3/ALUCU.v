`timescale 1ns / 1ps

/*******************************************************************
*
* Module: ALUCU.v
* Project: Single Cycle RISC-V Processor
* Author:
          Aly    alyelaswad@aucegypt.edu
          Ismail ismailsabry@aucegypt.edu
* Description: This module is the ALU of the processor. It performs the arithmetic and logical operations on the inputs A and B according to the control signals.
**********************************************************************/
`define     ALU_ADD         4'b0010 
`define     ALU_SUB         4'b0110 
`define     ALU_PASS        4'b00_11 
`define     ALU_OR          4'b0001
`define     ALU_AND         4'b0000 
`define     ALU_XOR         4'b0011
`define     ALU_SRL         4'b0100 
`define     ALU_SRA         4'b0111 
`define     ALU_SLL         4'b1000
`define     ALU_SLT         4'b11_01
`define     ALU_SLTU        4'b11_11

module ALUCU( input [2:0]inst14,input inst30, input[1:0] ALUop, output reg [3:0] ALUsel);
always @(*) begin
if(ALUop==2'b00) ALUsel = `ALU_ADD;
if(ALUop==2'b01) ALUsel = `ALU_SUB ;
if(ALUop==2'b10) //r
begin
case({inst14,inst30})
        4'b0000: ALUsel = `ALU_ADD; // Example: ADD (specific case)
        4'b0001: ALUsel = `ALU_SUB ; // Example: SUB (specific case)
        4'b1110: ALUsel = `ALU_AND; // Example: AND
        4'b1100: ALUsel = `ALU_OR ; // Example: OR
        4'b1000: ALUsel = `ALU_XOR; //xor
        4'b1010: ALUsel = `ALU_SRL; //srl 
        4'b1011: ALUsel=  `ALU_SRA ; //sra 
        4'b0010: ALUsel=  `ALU_SLL; //sll 
        4'b0100: ALUsel=  `ALU_SLT; //slt
        4'b0110: ALUsel= `ALU_SLTU; //sltu
endcase 
end
if(ALUop==2'b11) //I
begin
case({inst14})
        3'b000: ALUsel = `ALU_ADD; // Example: ADD (specific case)
        3'b111: ALUsel = `ALU_AND; // Example: AND
        3'b110: ALUsel = `ALU_OR ; // Example: OR
        3'b100: ALUsel = `ALU_XOR; //xor
        3'b101: ALUsel = (inst30==1'b0)?`ALU_SRL:`ALU_SRA;
        3'b001: ALUsel=  `ALU_SLL; //sll 
        3'b010: ALUsel=  `ALU_SLT; //slt
        3'b011: ALUsel= `ALU_SLTU; //sltu
endcase 
end
end

endmodule