`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 02:02:03 PM
// Design Name: 
// Module Name: InstMem
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


module InstMem (input [5:0] addr, output [31:0] data_out);
reg [31:0] mem [0:63];
initial begin
mem[0]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0) 0
mem[1]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0) 4
mem[2]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0) 8
mem[3]=32'b00000000010100010000000010010011 ; //or x4, x1, x2 16 


end
assign data_out = mem[addr];


endmodule