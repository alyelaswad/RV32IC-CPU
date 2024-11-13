`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 02:15:37 PM
// Design Name: 
// Module Name: Nbit2x1MUX
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


module Nbit2x1MUX #(parameter n=8)(input [n-1:0] x ,input [n-1:0] y,input sel,output [n-1:0] z);
genvar i;
generate
for(i =0; i<n; i=i+1) begin 
twoXonemux TWOMUX(x[i],y[i],sel,z[i]);
end
endgenerate
endmodule

