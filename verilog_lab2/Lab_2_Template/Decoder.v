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
    //MI: Funct[0] = L-bit, [1] = L-bit, [2] = B-bit, [3] = U-bit, [4] = P-bit, [5] = I-bit
    output PCS,
    output RegW,
    output MemW,
    output MemtoReg,
    output ALUSrc,
    output [1:0] ImmSrc,
    output [1:0] RegSrc,
    output NoWrite,
    output reg [1:0] ALUControl,
    output reg [1:0] FlagW
    );
    
    wire ALUOp ;
    reg [9:0] controls ;
    //<extra signals, if any>
    
    assign RegW = (Op == 2'b00) || ((Op == 2'b01) && (Funct[0] == 1)); //All DP instructions and LDR
    
    assign PCS = ((Rd == 4'b1111) && RegW) || Op == 2'b10; //PC (R15) is written by an instruction or branch
    
    assign MemW = (Op == 2'b01) && (Funct[0] == 0); //Only for STR instruction
    
    assign MemtoReg = (Op == 2'b01) && (Funct[0] == 1); //Only for LDR intrctuion
    
    assign ALUSrc = ((Op == 2'b00) && (Funct[5] == 0)) ? 0 : 1; //Not for DP intruction with register Src2
    
    assign ImmSrc = Op; //Choose number of bits for immediate
    
    assign RegSrc = (Op == 2'b01) ? 2'b10 : (Op == 2'b10 ? 2'b01 : 2'b00);
    
    assign ALUOp = (Op == 2'b00) ? 1 : 0; //1 for DP, 0 for others
    
    assign NoWrite = (Op == 2'b00) && (Funct[4:1] == 4'b1010 || Funct[4:1] == 4'b1011) && (Funct[0] == 1); //for CMP
    
    always@(Rd, Op, Funct)//FlagW[1:0]
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
                    4'b0010: FlagW <= 2'b11; //SUB
                    4'b0000: FlagW <= 2'b10; //AND
                    4'b1100: FlagW <= 2'b10; //ORR
                    4'b1010: FlagW <= 2'b11; //CMP
                    4'b1011: FlagW <= 2'b11; //CMN
                endcase
            end
            else //S-bit = 0
            begin
               FlagW <= 2'b00;
            end
        end
    end
    
    always@(Rd, Op, Funct)//ALUControl[1:0]
    begin
        if(ALUOp == 0) //Other Instruction
        begin
            if(Op == 2'b01)//Memory Instruction
            begin
                case(Funct[3])
                    1'b1: ALUControl <= 2'b00; //ADD
                    1'b0: ALUControl <= 2'b01; //SUB
                endcase
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
                4'b0010: ALUControl <= 2'b01; //SUB
                4'b0000: ALUControl <= 2'b10; //AND
                4'b1100: ALUControl <= 2'b11; //ORR
                4'b1010: ALUControl <= 2'b01; //CMP
                4'b1011: ALUControl <= 2'b00; //CMN
            endcase
        end
    end
    
endmodule





