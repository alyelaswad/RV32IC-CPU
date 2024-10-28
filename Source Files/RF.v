`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 03:07:57 PM
// Design Name: 
// Module Name: RF
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


module RF #(parameter N=32)(input [4:0] ReadReg1 , input [4:0] ReadReg2, input [4:0] WriteReg,input [N-1:0] WrData,input regWrite,clk,rst,
                            output  [N-1:0] ReadData1, output  [N-1:0] ReadData2);
reg [N-1:0] regfile [31:0];
assign ReadData1=regfile[ReadReg1];
assign ReadData2=regfile[ReadReg2];
integer i;
always @(posedge clk || rst) begin
if(regWrite && !rst && (WriteReg!=0)) begin
regfile[WriteReg]=WrData; end
if(rst) begin
for(i=0;i<32;i=i+1) begin
regfile[i]=0;
end
end
end
endmodule
