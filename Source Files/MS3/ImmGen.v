`timescale 1ns / 1ps
/*******************************************************************
*
* Module: ImmGen.v
* Project: Single Cycle RISC-V Processor
* Author:
          Aly    alyelaswad@aucegypt.edu
          Ismail ismailsabry@aucegypt.edu
* Description: This module is the immediate generator of the processor. It generates the immediate value based on the instruction type.
                All the neccessary shifts have been done in this module. 
**********************************************************************/

module ImmGenen(output reg [31:0] gen_out, input [31:0] inst);
reg [11:0] imm;
reg [20:0] imm20;

always@(*)
begin
if(inst[6:0] == 7'b1101111) begin // JAL

//imm20={inst[31],inst[18:12],inst[19],inst[30:20],1'b0};
gen_out= { {12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 };
end 

else if(inst[6:0]==7'b0010111||inst[6:0]==7'b0110111) //U
begin
imm20=inst[31:12];
gen_out = imm20 << 12;

end

else if(inst[6:0] == 7'b1100011) //B
begin
imm={inst[31],inst[7],inst[30:25],inst[11:8]};
gen_out = {{19{imm[11]}},imm[11:0],1'b0};
end

else if(inst[6:0] == 7'b0100011) //S
begin
imm={inst[31:25],inst[11:7]};
gen_out = {{20{imm[11]}},imm[11:0]};
end
else if(inst[6:0] == 7'b0000011||inst[6:0] == 7'b1100111||inst[6:0] == 7'b0010011) begin//I {L,jalr,ri)
if(inst[14:12]==3'h5&&inst[30]==1'b1) begin
imm=inst[24:20];
gen_out={27'd0,imm};
end
else begin
imm = inst[31:20]; // Extract the immediate
gen_out = {{20{imm[11]}}, imm}; // Sign-extend the immediate
end
end
end

endmodule