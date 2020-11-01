`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Shahzor Ahmad and Rajesh Panicker  
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: Decoder
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: Decoder Module
-- 
-- Dependencies: NIL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v)	acknowledge that the program was written based on the microarchitecture described in the book Digital Design and Computer Architecture, ARM Edition by Harris and Harris;
--		(vi) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vii) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------
*/

module Decoder(
    input [3:0] Rd,
    input [1:0] Op,
    input [5:0] Funct,
    //DP: Funct[0] = S-bit, Funct[4:1] = cmd, Funct[5] = I-bit
    //MI: Funct[0] = L-bit, [1] = W-bit, [2] = B-bit, [3] = U-bit, [4] = P-bit, [5] = I-bit
    input [3:0] MCond,
    input Swap,
    output PCS,
    output RegW, 
    output MemW,
    output MemtoReg,
    output ALUSrc,
    output [1:0] ImmSrc,
    output [1:0] RegSrc,
    output NoWrite,
    output reg [1:0] ALUControl,
    output reg [1:0] FlagW,
    output Start,
    output [1:0] MCycleOp,
    output StartProcessorStall
    );
    
    wire ALUOp ;
    reg [9:0] controls ;
    //<extra signals, if any>
    
    assign RegW = (Op == 2'b00) || ((Op == 2'b01) && (Funct[0] == 1)); //All DP instructions and LDR ******
    //assign RegW = (Op == 2'b00) || ((Op == 2'b01) && (Funct[0] == 1))|| (CycleCounter == 2'b01) ; //All DP instructions and LDR ******
    
    assign PCS = ((Rd == 4'b1111) && RegW) || Op == 2'b10; //PC (R15) is written by an instruction or branch
    
    assign MemW = (Op == 2'b01) && (Funct[0] == 0); //Only for STR instruction ******
    
    assign MemtoReg = (Op == 2'b01) && (Funct[0] == 1); //Only for LDR intrctuion ******
    
    //assign ALUSrc = (Op == 2'b00) ? 0 : 1; //Not for DP intruction with register Src2
    assign ALUSrc = (Op == 2'b00) ? 0 : ((Op == 2'b01) ? (Funct[5] == 1 ? 0 : 1) : 1);
    //assign ALUSrc = ((Op == 2'b00) || (CycleCounter == 2'b01)) ? 0 : ((Op == 2'b01) ? (Funct[5] == 1 ? 0 : 1) : 1);
    
    assign ImmSrc = Op; //Choose number of bits for immediate
    //assign ImmSrc = (CycleCounter == 2'b01) ? 2'b00 : Op;
    
    assign RegSrc = (Op == 2'b01) ? 2'b10 : (Op == 2'b10 ? 2'b01 : 2'b00);
    
    assign ALUOp = (Op == 2'b00) ? 1 : 0; //1 for DP, 0 for others
    
    assign NoWrite = (Op == 2'b00) && (Funct[4:1] == 4'b1010 || Funct[4:1] == 4'b1011 || Funct[4:1] == 4'b1000 || Funct[4:1] == 4'b1001) && (Funct[0] == 1); //for CMP/CMN/TST/TEQ 
    
    assign Start = (Op == 2'b00 && MCond == 4'b1001 && Funct[5] == 1'b0) ? 1'b1 : 1'b0;
    
    assign MCycleOp = (Funct[4:1] == 4'b0000 || Funct[4:1] == 4'b0100) ? 2'b01 : ((Funct[4:1] == 4'b0110) ? 2'b00 : 2'b11) ;
    
    //assign StartProcessorStall = (Op == 2'b01) & (({Funct[4], Funct[1]} == 2'b00) || ({Funct[4], Funct[1]} == 2'b11));
    assign StartProcessorStall = Swap; //SWP
    
    always@(*)//FlagW[1:0]
    begin
        if(ALUOp == 0)
        begin
            FlagW <= 2'b00;
        end
        else
        begin
            if(Funct[0] == 1) //S-bit = 1
            begin
                case(Funct[4:1]) //cmd
                    4'b0100: FlagW <= 2'b11; //ADD
                    4'b0101: FlagW <= 2'b11; //ADC
                    4'b0010: FlagW <= 2'b11; //SUB
                    4'b0110: FlagW <= 2'b11; //SBC
                    4'b0011: FlagW <= 2'b11; //RSB
                    4'b0111: FlagW <= 2'b11; //RSC
                    4'b0000: FlagW <= 2'b10; //AND//MUL
                    4'b1110: FlagW <= 2'b10; //BIC
                    4'b1000: FlagW <= 2'b10; //TST
                    4'b1100: FlagW <= 2'b10; //ORR
                    4'b0001: FlagW <= 2'b10; //EOR
                    4'b1001: FlagW <= 2'b10; //TEQ
                    4'b1010: FlagW <= 2'b11; //CMP
                    4'b1011: FlagW <= 2'b11; //CMN
                    4'b1101: FlagW <= 2'b10; //MOV
                    4'b1111: FlagW <= 2'b10; //MVN
                    default: FlagW <= 2'b00; //unpredictable
                endcase
            end
            else //S-bit = 0
            begin
               FlagW <= 2'b00;
            end
        end
    end
    
    always@(*)//ALUControl[1:0]
    begin
        if(ALUOp == 0) //Other Instruction
        begin
            if(Op == 2'b01)//Memory Instruction
            begin
                if(Funct[3] == 1'b1)
                begin
                    ALUControl <= 2'b00; //ADD
                end
                else
                begin
                    ALUControl <= 2'b01; //SUB
                end
            end
            else
            begin
                ALUControl <= 2'b00;
            end
        end
        else //ALUOp == 1 DP Instruction
        begin
            case(Funct[4:1]) //cmd
                4'b0100: ALUControl <= 2'b00; //ADD
                4'b0101: ALUControl <= 2'b00; //ADC
                4'b0010: ALUControl <= 2'b01; //SUB
                4'b0110: ALUControl <= 2'b01; //SBC
                4'b0011: ALUControl <= 2'b01; //RSB
                4'b0111: ALUControl <= 2'b01; //RSC
                4'b0000: ALUControl <= 2'b10; //AND
                4'b1110: ALUControl <= 2'b10; //BIC
                4'b1000: ALUControl <= 2'b10; //TST
                4'b1100: ALUControl <= 2'b11; //ORR
                4'b0001: ALUControl <= 2'b11; //EOR
                4'b1001: ALUControl <= 2'b11; //TEQ
                4'b1010: ALUControl <= 2'b01; //CMP
                4'b1011: ALUControl <= 2'b00; //CMN
                4'b1101: ALUControl <= 2'b00; //MOV
                4'b1111: ALUControl <= 2'b00; //MVN
                default: ALUControl <= 2'b00; //unpredictable
            endcase
        end
    end
    
endmodule





