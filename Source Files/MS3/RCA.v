`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 02:13:05 PM
// Design Name: 
// Module Name: RCA
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


module RCA #(parameter N=32)( input [N-1:0] A,  [N-1:0] B, output [N:0] sum);
wire [N-1:0]cin;
fulladder f1(.A(A[0]),.B(B[0]),.cin(1'b0),.sum(sum[0]),.cout(cin[0]));
genvar i;
generate 
for(i=1;i<N;i=i+1)begin
fulladder FA(.A(A[i]),.B(B[i]),.cin(cin[i-1]),.sum(sum[i]),.cout(cin[i]));
end
endgenerate
assign sum[N]=cin[N-1];

endmodule

