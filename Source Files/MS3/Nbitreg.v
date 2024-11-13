`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 03:13:19 PM
// Design Name: 
// Module Name: Nbitreg
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


module Nbitreg#(parameter n=8)(input clk, load, rst, input [n-1:0] D, output [n-1:0] Q);
wire [n-1:0] outMux;
genvar i;
generate 
for(i=0;i<n;i=i+1) begin 
//twoXonemux MUX_INST(.X(D[i]),.Y(Q[i]),.sel(load),.Z(outMux[i]));
assign outMux[i]=(load==0)?Q[i]:D[i];
DFlipFlop dff(.clk(clk),.rst(rst),.D(outMux[i]),.Q(Q[i]));
end
endgenerate
endmodule
