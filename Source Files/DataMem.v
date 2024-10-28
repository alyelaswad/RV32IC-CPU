`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 02:20:38 PM
// Design Name: 
// Module Name: DataMem
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

module DataMem (input clk, input MemRead, input MemWrite,
input [5:0] addr, input [31:0] data_in, output [31:0] data_out, input [2:0] funct3,input rst);
reg [31:0] mem [0:63];
//reg [7:0] mem [0:255];
initial begin
//mem[0]=32'd17;
////mem[1]=8'd0;
////mem[2]=8'd0;
////mem[3]=8'd0;

//mem[1]=32'd9;
//mem[2]=32'd25;
end
integer i;
always @(posedge clk) begin
if(rst) begin
for(i=0;i<63;i=i+1) begin
mem[i]=0;
end
end
else if(MemWrite==1'b1)begin
if(funct3==3'b010)
mem[addr]=data_in;
else if (funct3==3'b001)
mem[addr]={mem[addr][31:16],data_in[15:0]};
else if (funct3==3'b000)
mem[addr]={mem[addr][31:8],data_in[7:0]};

end
end
assign data_out= (MemRead==1)? mem[addr]:data_out;
endmodule
