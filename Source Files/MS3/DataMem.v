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


module Memory (input clk, input MemRead, input MemWrite, input [2:0] funct3,
input [13:0] addr, input [31:0] data_in, output reg [31:0] data_out);
reg [7:0] mem [0:4095];
reg [31:0] temp [0:31]; 


  initial begin
        $readmemh("C:/Users/IsmailSabry/Desktop/JALandfriends.hex", temp);
    end
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i+1)
            {mem[(i*4)+3], mem[(i*4)+2], mem[(i*4)+1], mem[i*4]} = temp[i];
    end
//{mem[3], mem[2], mem[1], mem[0]} = 32'b00000000010100000000001110010011;
//{mem[7], mem[6], mem[5], mem[4]} = 32'b00000000011100000000000100010011;
//{mem[11], mem[10], mem[9], mem[8]} = 32'b00000001000000000000001011100111;
//{mem[15], mem[14], mem[13], mem[12]} = 32'b00000000010100000000010100010011;
//{mem[19], mem[18], mem[17], mem[16]} = 32'b00000000000100000000010010010011;

////// lw x1, 0(x0) - 32'b000000000000_00000_010_00001_0000011
////{mem[3], mem[2], mem[1], mem[0]} = 32'b000000000000_00000_010_00001_0000011;

////// lw x2, 4(x0) - 32'b000000000100_00000_010_00010_0000011
////{mem[7], mem[6], mem[5], mem[4]} = 32'b000000000100_00000_010_00010_0000011;

////// lw x3, 8(x0) - 32'b000000001000_00000_010_00011_0000011
////{mem[11], mem[10], mem[9], mem[8]} = 32'b000000001000_00000_010_00011_0000011;


//////{mem[15], mem[14], mem[13], mem[12]} =32'b00000000000000000010000010110111;
////// or x4, x1, x2 - 32'b0000000_00010_00001_110_00100_0110011
////{mem[15], mem[14], mem[13], mem[12]} =32'b0000000_00010_00001_110_00100_0110011;

////// beq x4, x3, 4 - 32'b0_000000_00011_00100_000_0100_0_1100011
////{mem[19], mem[18], mem[17], mem[16]} = 32'b0_000000_00011_00100_000_0100_0_1100011;

////// add x3, x1, x2 - 32'b0000000_00010_00001_000_00011_0110011
////{mem[23], mem[22], mem[21], mem[20]} = 32'b0000000_00010_00001_000_00011_0110011;

////// add x5, x3, x2 - 32'b0000000_00010_00011_000_00101_0110011
////{mem[27], mem[26], mem[25], mem[24]} = 32'b0000000_00010_00011_000_00101_0110011;

////// sw x5, 12(x0) - 32'b0000000_00101_00000_010_01100_0100011
////{mem[31], mem[30], mem[29], mem[28]} = 32'b0000000_00101_00000_010_01100_0100011;

////// lw x6, 12(x0) - 32'b000000001100_00000_010_00110_0000011
////{mem[35], mem[34], mem[33], mem[32]} = 32'b000000001100_00000_010_00110_0000011;

////// and x7, x6, x1 - 32'b0000000_00001_00110_111_00111_0110011
////{mem[39], mem[38], mem[37], mem[36]} = 32'b0000000_00001_00110_111_00111_0110011;

////// sub x8, x1, x2 - 32'b0100000_00010_00001_000_01000_0110011
////{mem[43], mem[42], mem[41], mem[40]} = 32'b0100000_00010_00001_000_01000_0110011;

////// add x0, x1, x2 - 32'b0000000_00010_00001_000_00000_0110011
////{mem[47], mem[46], mem[45], mem[44]} = 32'b0000000_00010_00001_000_00000_0110011;

////// add x9, x0, x1 - 32'b0000000_00001_00000_000_01001_0110011
////{mem[51], mem[50], mem[49], mem[48]} = 32'b0000000_00001_00000_000_01001_0110011;



////    {mem[131], mem[130], mem[129], mem[128]}    = 32'd17;    // Address 0: 20 in hex (32-bit word)
////    {mem[135], mem[134], mem[133], mem[132]}    = 32'd9;    // Address 0: 20 in hex (32-bit word)
////    {mem[139], mem[138], mem[137], mem[136]}    = 32'd25;    // Address 0: 20 in hex (32-bit word)
//end
//initial begin

//    {mem[131], mem[130], mem[129], mem[128]}    = 32'd17;    // Address 0: 20 in hex (32-bit word)
//    {mem[135], mem[134], mem[133], mem[132]}    = 32'd9;    // Address 0: 20 in hex (32-bit word)
//    {mem[139], mem[138], mem[137], mem[136]}    = 32'd25;    // Address 0: 20 in hex (32-bit word)
//end
always @(posedge clk) begin
 if (MemWrite == 1'b1) begin
        case (funct3)
            3'b000: mem[addr[13:7]+128] = data_in[7:0]; // Store 8 bits
            3'b001: {mem[addr[13:7]+129], mem[addr[13:7]+128]} = data_in[15:0]; // Store 16 bits
            3'b010: {mem[addr[13:7]+131], mem[addr[13:7]+130], mem[addr[13:7]+129], mem[addr[13:7]+128]} = data_in; // Store 32 bits
            default: ; // No operation for other funct3 values
        endcase
    end
end

always @(*) begin
if(~clk) begin 
    if (MemRead) begin
        case (funct3)
            3'd0: data_out <= {{24{mem[addr[13:7]+128][7]}}, mem[addr[13:7]+128]}; // Sign-extend byte
            3'd1: data_out <= {{16{mem[addr[13:7]+1+128][7]}},mem[addr[13:7]+128+1], mem[addr[13:7]+128]}; 
            3'd2: data_out <= {mem[addr[13:7]+128+3],mem[addr[13:7]+128+2],mem[addr[13:7]+128+1], mem[addr[13:7]+128]};
            3'd4: data_out <= {24'd0, mem[addr[13:7]+128]}; 
            3'd5: data_out <= {16'd0, mem[addr[13:7]+1+128],mem[addr[13:7]+128]}; 
            default: data_out <=0;
        endcase
    end
end
else
data_out = {mem[addr[6:0]+3],mem[addr[6:0]+2],mem[addr[6:0]+1],mem[addr[6:0]]};
end
//assign data_out= (MemRead==1)? mem[addr]:data_out;
endmodule
