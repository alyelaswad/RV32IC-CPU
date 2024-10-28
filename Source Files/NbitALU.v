`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 02:09:09 PM
// Design Name: 
// Module Name: NbitALU
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

module NbitALU #(parameter N=32)(input [N-1:0] A, input [N-1:0] B, input [3:0] sel, output reg [N-1:0]  Out, 
                                   output zf,output sf,output vf,output C);
reg [N-1:0] RcaB;
wire[31:0] RCAout;
wire [N-1:0] add, sub, op_b;
wire cfa, cfs;
assign op_b = (~B);
assign zf = (Out == 0);
assign sf = Out[31];
assign vf = (A[31] ^ (op_b[31]) ^ Out[31] ^ C);
    

always @(*) begin
case(sel)
`ALU_ADD: RcaB = B; 
`ALU_SUB: RcaB= (~B+1);
endcase
end
RCA RCAahy (A,RcaB,{C,RCAout});
always @(*) begin
case(sel)
`ALU_ADD:  Out =RCAout;
`ALU_SUB:  Out =RCAout;
`ALU_AND:  Out = A & B;
`ALU_OR:  Out = A | B;
`ALU_SRL:  Out= A >> B;
`ALU_XOR: Out=A^B; 
`ALU_SRA:Out = $signed(A) >>> B;

`ALU_SLL: Out = A << B;              // SLL operation (logical shift left)
`ALU_SLT: Out = ($signed(A) < $signed(B)) ? 1 : 0; // Signed comparison
`ALU_SLTU: Out = (A < B) ? 1 : 0; // Unsigned comparison
endcase
end


endmodule
