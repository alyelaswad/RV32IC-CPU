`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Datapath.v
* Project: Single Cycle RISC-V Processor
* Author:
          Aly    alyelaswad@aucegypt.edu
          Ismail ismailsabry@aucegypt.edu
* Description: This module is the top level module of the processor. It instantiates all the other modules and connects them together. It also contains the control logic for the processor.
*  
**********************************************************************/


module Datapath(input clk, input rst, input [1:0] ledsel,input [3:0] ssdSel,input ssdClk,  output reg [15:0]leds, output reg [3:0]  Anode,output reg [6:0] ssd_out);
reg [13:0]ssd; // 14-bit register for the 7-segment display
wire outC; // The clock signal for the pushbuttons
wire outR; // The reset signal for the pushbuttons
wire clk_buttons; // The clock signal for the pushbuttons
wire [31:0] pcout; // The output of the program counter
reg [31:0] pcinp; // The input of the program counter
wire [31:0] ReadData1; // The output of the first register file read port
wire [31:0] ReadData2; // The output of the second register file read port
wire [31:0] WrData;    // The input of the register file write port
wire [31:0] pc4; // The program counter incremented by 4
wire [31:0] outputinst; // The output of the instruction memory
wire [1:0] ALUOp; // The ALU operation
wire Branch,MemRead,MemtoReg,MemWrite, ALUSrc, RegWrite; // The control signals
wire [31:0] immout; // The output of the immediate generator
wire [31:0] pcimm; // The immediate added to the program counter
reg ANDout; // The output of the AND gate
wire [31:0] ALUinp2; // The second input of the ALU
wire [3:0] ALUsel; // The ALU operation
wire [31:0] ALUout; // The output of the ALU
wire Z; // The zero flag
wire C; // The carry flag
wire N; // The negative flag
wire V; // The overflow flag
wire [31:0] data_out; // The output of the data memory
wire [15:0] signals; // The signals to be displayed on the LEDs
reg [3:0] LED_BCD;  // The BCD representation of the number to be displayed on the 7-segment display
reg [19:0] refresh_counter = 0; // 20-bit counter
wire [1:0] LED_activating_counter; // The 2-bit counter for the 7-segment display

//clockDivider #(500000)div2(ssdClk,1'd0, clk_buttons); // The clockdivider for the clock of the pushbuttons 
//pushButtonDetector clky (clk_buttons,rst, clk , outC); // The clk
//pushButtonDetector rsty(clk_buttons,0, rst, outR);  // The rst


always @(ssdClk|| rst) begin  
        if (rst) begin  
            pcinp <= 32'd0;  // Set pcinp to zero on reset
            end
            else
if(!(outputinst[6:0]==7'b1110011))
            pcinp <= (ANDout|| Jal) ? pcimm :(Jalr)? ALUout: pc4; // Example of how pcinp could be updated 
            
       
    end
Nbitreg #(32) nbitregya(ssdClk,1'b1,rst,pcinp,pcout); // The program counter register

InstMem instmemya(pcout[7:2],outputinst); // The instruction memory

assign pc4 = pcout+4; // The program counter incremented by 4


CU cuy(outputinst[6:2],Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp,Jal,Jalr,Lui,Auipc); // The control unit

RF #(32) rfya(outputinst[19:15],outputinst[24:20],outputinst[11:7],WrData,RegWrite,ssdClk,rst, ReadData1,ReadData2); // The register file


ImmGenen ig( immout,outputinst); // The immediate generator



assign pcimm = pcout + immout; // The immediate added to the program counter


assign ALUinp2 =(ALUSrc) ? immout : ReadData2; // The second input of the ALU


ALUCU ALUCUhaya(outputinst[14:12] ,outputinst[30], ALUOp,ALUsel); // The ALU control unit




NbitALU #(32) ALUhya(ReadData1, ALUinp2, ALUsel,ALUout,Z,N,V,C); // The ALU
always @(*)begin
if (Branch) begin
case (funct3)
3'b000: ANDout = Z; //beq
3'b001: ANDout = ~Z; // bne
3'b100: ANDout = ~((~C)+Z); //blt
3'b101: ANDout = (~C)+Z; // bge
3'b110: ANDout = ~C;          // bltu:
3'b111: ANDout = C;           // bgeu:
endcase
end
else 
ANDout=1'b0;
end

wire [2:0] funct3; // The funct3 field of the instruction
assign funct3=outputinst[14:12];
DataMem datamemaya(ssdClk,  MemRead, MemWrite, ALUout[7:2], ReadData2,  data_out,funct3,rst); // The data memory
wire [31:0] dOutaddresable;
assign dOutaddresable = 
    (outputinst[14:12] == 3'b000) ? {{24{data_out[7]}}, data_out[7:0]} :
    (outputinst[14:12] == 3'b001) ? {{16{data_out[15]}}, data_out[15:0]} :
    (outputinst[14:12] == 3'b010) ? data_out :
    (outputinst[14:12] == 3'b100) ? {24'd0, data_out[7:0]} :{16'd0, data_out[15:0]}; // The data memory output in the addressable format

assign WrData = (MemtoReg) ? dOutaddresable:(Jal||Jalr)? pc4:(Lui)? immout:(Auipc)? (pcout+immout): ALUout; // The input of the register file write port


assign signals={2'b00,ALUOp,ALUsel,Z,ANDout,Branch,MemRead,MemtoReg,MemWrite, ALUSrc, RegWrite}; // The signals to be displayed on the LEDs
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
