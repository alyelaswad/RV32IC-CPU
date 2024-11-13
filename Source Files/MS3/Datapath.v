`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 03:15:21 PM
// Design Name: 
// Module Name: Datapath
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


module Datapath(input clk, input rst, input [1:0] ledsel,input [3:0] ssdSel,input ssdClk,  output reg [15:0]leds, output reg [3:0]  Anode,output reg [6:0] ssd_out);
reg [13:0]ssd;
wire outC;
wire outR;
wire clk_buttons;
wire [31:0] pcout;
reg [31:0] pcinp;
wire [31:0] ReadData1;
wire [31:0] ReadData2;
wire [31:0] WrData;
wire [31:0] pc4;
wire [31:0] outputinst;
wire [1:0] ALUOp;
wire Branch,MemRead,MemtoReg,MemWrite, ALUSrc, RegWrite;
wire [31:0] immout;
wire [31:0] pcimm;
reg ANDout;
wire [31:0] ALUinp2;
wire [3:0] ALUsel;
wire [31:0] ALUout;
wire Z;
wire V;
wire N;
wire [31:0] data_out;
wire [15:0] signals;
reg [3:0] LED_BCD;
reg [19:0] refresh_counter = 0; // 20-bit counter
wire [1:0] LED_activating_counter;
wire [31:0] IF_ID_PC;
wire [31:0] IF_ID_Inst;
wire [31:0] ID_EX_PC;
wire [31:0] ID_EX_RegR1;
wire [31:0] ID_EX_RegR2;
wire [31:0] ID_EX_Imm;
wire [11:0] ID_EX_Ctrl;
wire [3:0] ID_EX_Func;
wire [4:0] ID_EX_Rs1;
wire [4:0]  ID_EX_Rs2;
wire [4:0]  ID_EX_Rd;
wire [31:0] EX_MEM_BranchAddOut;
wire [31:0] EX_MEM_PC;
wire [31:0] EX_MEM_IMM;
wire [31:0] EX_MEM_ALU_out;
wire[31:0] EX_MEM_RegR2;
wire [8:0] EX_MEM_Ctrl;
wire [4:0] EX_MEM_Rd;
wire [2:0] EX_MEM_Func;
wire EX_MEM_Zero;
wire [31:0] MEM_WB_Mem_out;
wire [31:0] MEM_WB_PCimm;
wire [31:0] MEM_WB_PC;
wire [31:0] MEM_WB_IMM;
wire [31:0] MEM_WB_ALU_out;
wire [5:0] MEM_WB_Ctrl;
wire [4:0] MEM_WB_Rd;
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [31:0] ALUinputA;
wire [31:0] ALUinp2MUX;
wire [11:0] MUXCu;
wire [31:0] ID_EX_INST;
wire [31:0] EX_MEM_INST;
wire Jalr;
wire Jal;
wire Auipc;
wire Lui;
wire pcSrc;
wire[31:0] MuxedInst;
wire [8:0] MuxedCuSecondstage;
wire EX_MEM_Carry;
wire EX_MEM_V;
wire EX_MEM_N;


assign MuxedInst = (pcSrc) ? 32'd0 : data_out;
Nbitreg #(64) nbitregyaIF_ID(~ssdClk,1'b1,rst,{pcout,MuxedInst},{IF_ID_PC,IF_ID_Inst});
assign MUXCu =  (pcSrc)?12'd0 : {Jal,Jalr,Lui,Auipc,Branch, MemRead, MemtoReg,MemWrite, ALUSrc, RegWrite,ALUOp};
Nbitreg #(191) nbitregyaID_EX(ssdClk,1'b1,rst,{MUXCu,
                                            IF_ID_Inst,
                                            IF_ID_PC,
                                            ReadData1,
                                            ReadData2,
                                            immout,
                                            {IF_ID_Inst[30],IF_ID_Inst[14:12]},
                                            IF_ID_Inst[19:15],
                                            IF_ID_Inst[24:20],
                                            IF_ID_Inst[11:7]},
                                             {ID_EX_Ctrl,ID_EX_INST,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,
                                            ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd});
                                            
assign MuxedCuSecondstage = (pcSrc)? 9'd0 : {ID_EX_Ctrl[11:4],ID_EX_Ctrl[2]};
Nbitreg #(213) nbitregyaEX_MEM (~ssdClk,1'b1,rst,{V,N,ID_EX_INST,ID_EX_Imm,ID_EX_PC,C,ID_EX_Func[2:0],MuxedCuSecondstage,
pcimm,Z,ALUout,ALUinp2MUX,ID_EX_Rd},
{EX_MEM_V,EX_MEM_N,EX_MEM_INST,EX_MEM_IMM,EX_MEM_PC,EX_MEM_Carry,EX_MEM_Func,EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Zero,EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd} );
Nbitreg #(172) nbitregyaMEM_WB(ssdClk,1'b1,rst,
{EX_MEM_BranchAddOut,EX_MEM_IMM,EX_MEM_PC,{EX_MEM_Ctrl[8:5],EX_MEM_Ctrl[2],EX_MEM_Ctrl[0]},data_out,EX_MEM_ALU_out,EX_MEM_Rd},
{MEM_WB_PCimm,MEM_WB_IMM,MEM_WB_PC,MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,MEM_WB_Rd});


clockDivider #(500000)div2(ssdClk,1'd0, clk_buttons); // The clockdivider for the clock of the pushbuttons 
pushButtonDetector clky (clk_buttons,rst, clk , outC); // The clk
pushButtonDetector rsty(clk_buttons,0, rst, outR);  // The rst


always @(ssdClk|| rst) begin
        if (rst) begin  
            pcinp <= 32'd0;  // Set pcinp to zero on reset
            end
            else
//            pcinp <= (ANDout|| Jal) ? pcimm :(Jalr)? ALUout: pc4; 
//            pcinp <= (ANDout|| MEM_WB_Ctrl[5]) ? MEM_WB_PCimm :(MEM_WB_Ctrl[4])? MEM_WB_ALU_out: pc4; // Example of how pcinp could be updated 
//             pcinp <= (ANDout) ? EX_MEM_BranchAddOut : pc4; 
             if(!((EX_MEM_INST[6:0]==7'b1110011)&&(EX_MEM_INST[20]==1'b1)))
             pcinp <= (ANDout|| EX_MEM_Ctrl[8]) ? EX_MEM_BranchAddOut :( EX_MEM_Ctrl[7])? EX_MEM_ALU_out: pc4; 
       
    end
Nbitreg #(32) nbitregya(ssdClk,1'b1,rst,pcinp,pcout);

//InstMem instmemya(pcout[7:2],outputinst);

//assign pc4 = MEM_WB_PC+4;
assign pc4 = pcout+4;


CU cuy(IF_ID_Inst[6:2],Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp,Jal,Jalr,Lui,Auipc); // The control unit




RF #(32) rfya(IF_ID_Inst[19:15],IF_ID_Inst[24:20],MEM_WB_Rd,WrData,MEM_WB_Ctrl[0],ssdClk,rst, ReadData1,ReadData2);


ImmGenen ig( immout,IF_ID_Inst);



assign pcimm = ID_EX_PC + ID_EX_Imm;


assign ALUinp2MUX =(ForwardB==2'b00) ? ID_EX_RegR2 : (ForwardB==2'b01) ? WrData : EX_MEM_ALU_out;


assign ALUinp2 =(ID_EX_Ctrl[3]) ? ID_EX_Imm : ALUinp2MUX;

ALUCU ALUCUhaya(ID_EX_Func[2:0] ,ID_EX_Func[3], ID_EX_Ctrl[1:0],ALUsel);


assign ALUinputA =(ForwardA==2'b00)? ID_EX_RegR1: (ForwardA==2'b01)? WrData : EX_MEM_ALU_out;

NbitALU #(32) ALUhya(ALUinputA, ALUinp2, ALUsel,ALUout,Z,N,V,C); 



always @(*)begin
if (EX_MEM_Ctrl[4]) begin
case (EX_MEM_Func)
3'b000: ANDout = EX_MEM_Zero; //beq
3'b001: ANDout = ~EX_MEM_Zero; // bne
//3'b100: ANDout = ~((~EX_MEM_Carry)+EX_MEM_Zero); //blt
3'b100: ANDout = EX_MEM_N^EX_MEM_V; //blt
//3'b101: ANDout = (~EX_MEM_Carry)+EX_MEM_Zero; // bge
3'b101: ANDout = ~(EX_MEM_N^EX_MEM_V); // bge
3'b110: ANDout = ~(~EX_MEM_Carry| EX_MEM_Zero);          // bltu:
3'b111: ANDout = (~EX_MEM_Carry | EX_MEM_Zero);           // bgeu:
endcase
end
else 
ANDout=1'b0;
end
assign pcSrc = ANDout|| EX_MEM_Ctrl[8]||EX_MEM_Ctrl[7];


ForwardingUnit ForwardingUnithaya(ID_EX_Rs1,ID_EX_Rs2,EX_MEM_Rd,MEM_WB_Rd,EX_MEM_Ctrl[0],MEM_WB_Ctrl[0],ForwardA,ForwardB);


Memory memaya(ssdClk,  EX_MEM_Ctrl[3], EX_MEM_Ctrl[1],EX_MEM_Func, {EX_MEM_ALU_out[6:0],pcout[6:0]}, EX_MEM_RegR2,  data_out);

//assign WrData = (MEM_WB_Ctrl[1]) ? MEM_WB_Mem_out: MEM_WB_ALU_out;
//assign WrData = (MemtoReg) ? dOutaddresable:(Jal||Jalr)? pc4:(Lui)? immout:(Auipc)? (pcout+immout): ALUout; // The input of the register file write port

assign WrData = (MEM_WB_Ctrl[1]) ? MEM_WB_Mem_out:(MEM_WB_Ctrl[5]||MEM_WB_Ctrl[4])? (MEM_WB_PC+4):(MEM_WB_Ctrl[3])? MEM_WB_IMM:(MEM_WB_Ctrl[2])? (MEM_WB_PC+MEM_WB_IMM): MEM_WB_ALU_out; // The input of the register file write port


assign signals={2'b00,ALUOp,ALUsel,Z,ANDout,Branch,MemRead,MemtoReg,MemWrite, ALUSrc, RegWrite};
always @(*) begin
case(ledsel)
2'b00: leds=outputinst[15:0];
2'b01: leds=outputinst[31:16];
2'b10: leds=signals;
endcase
end

    always @(posedge ssdClk) begin
        refresh_counter <= refresh_counter + 1;
    end

    assign LED_activating_counter = refresh_counter[19:18];

    always @(*) begin
        case(LED_activating_counter)
            2'b00: begin
                Anode = 4'b0111;
                LED_BCD = ssd / 1000;
            end
            2'b01: begin
                Anode = 4'b1011;
                LED_BCD = (ssd % 1000) / 100;
            end
            2'b10: begin
               Anode = 4'b1101;
                LED_BCD = ((ssd % 1000) % 100) / 10;
            end
            2'b11: begin
                Anode = 4'b1110;
                LED_BCD = ((ssd % 1000) % 100) % 10;
            end
        endcase
    end
always @(*) begin
case(ssdSel)
4'b0000:ssd <=pcout;
4'b0001:ssd <=pc4;
4'b0010:ssd <=pcimm;
4'b0011:ssd <=pcinp;
4'b0100:ssd <=ReadData1;
4'b0101:ssd <=ReadData2;
4'b0110:ssd <=WrData;
4'b0111:ssd <=immout;
4'b1000:ssd <={immout[30:0],1'b0};
4'b1001:ssd <=ALUinp2;
4'b1010:ssd <=ALUout;
4'b1011:ssd <=data_out;
endcase
end
    always @(*) begin
        case(LED_BCD)
            4'b0000: ssd_out = 7'b0000001; // "0"
            4'b0001: ssd_out = 7'b1001111; // "1"
            4'b0010: ssd_out = 7'b0010010; // "2"
            4'b0011: ssd_out = 7'b0000110; // "3"
            4'b0100: ssd_out = 7'b1001100; // "4"
            4'b0101: ssd_out = 7'b0100100; // "5"
            4'b0110: ssd_out = 7'b0100000; // "6"
            4'b0111: ssd_out = 7'b0001111; // "7"
            4'b1000: ssd_out = 7'b0000000; // "8"
            4'b1001: ssd_out = 7'b0000100; // "9"
            default: ssd_out = 7'b0000001; // Default to "0"
        endcase
    end
endmodule