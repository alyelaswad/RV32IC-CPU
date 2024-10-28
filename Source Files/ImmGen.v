`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2024 03:21:23 PM
// Design Name: 
// Module Name: ImmGen
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


module ImmGenen(output reg [31:0] gen_out, input [31:0] inst);
reg [11:0] imm;
reg [20:0] imm20;

always@(*)
begin
if(inst[6:0] == 7'b1101111) begin

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
imm = inst[31:20]; // Extract the immediate
gen_out = {{20{imm[11]}}, imm}; // Sign-extend the immediate
end
end

endmodule
