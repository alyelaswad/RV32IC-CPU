`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2024 03:10:54 PM
// Design Name: 
// Module Name: nBitshleft
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


module nBitshleft #(parameter n=8)(input [n-1:0] x, output [n-1:0] z);
assign z={x[n-2:0],1'b0};
endmodule
