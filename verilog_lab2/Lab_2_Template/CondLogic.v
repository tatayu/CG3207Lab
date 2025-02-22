`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Shahzor Ahmad and Rajesh Panicker  
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: CondLogic
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: CondLogic Module
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

module CondLogic(
    input CLK,
    input PCS,
    input RegW,
    input NoWrite,
    input MemW,
    input [1:0] FlagW,
    input [3:0] Cond,
    input [3:0] ALUFlags,
    input [1:0] MCycleFlags,
    input MCycleDone,
    input ShCarry,
    input [1:0] Op,
    input S_bit,
    output PCSrc,
    output RegWrite,
    output MemWrite,
    output reg Carry
    );
    
    reg CondEx ;
    reg N = 0, Z = 0, C = 0, V = 0 ;
    wire [1:0] FlagWrite;
    //<extra signals, if any>
    
    always@(Cond, N, Z, C, V)
    begin
        case(Cond)
            4'b0000: CondEx <= Z ;                  // EQ  
            4'b0001: CondEx <= ~Z ;                 // NE 
            4'b0010: CondEx <= C ;                  // CS / HS 
            4'b0011: CondEx <= ~C ;                 // CC / LO  
            
            4'b0100: CondEx <= N ;                  // MI  
            4'b0101: CondEx <= ~N ;                 // PL  
            4'b0110: CondEx <= V ;                  // VS  
            4'b0111: CondEx <= ~V ;                 // VC  
            
            4'b1000: CondEx <= (~Z) & C ;           // HI  
            4'b1001: CondEx <= Z | (~C) ;           // LS  
            4'b1010: CondEx <= N ~^ V ;             // GE  
            4'b1011: CondEx <= N ^ V ;              // LT  
            
            4'b1100: CondEx <= (~Z) & (N ~^ V) ;    // GT  
            4'b1101: CondEx <= Z | (N ^ V) ;        // LE  
            4'b1110: CondEx <= 1'b1  ;              // AL 
            4'b1111: CondEx <= 1'bx ;               // unpredictable   
        endcase   
    end
    
    assign PCSrc = PCS & CondEx;
    assign RegWrite = RegW & CondEx & ~NoWrite;
    assign MemWrite = MemW & CondEx;
    assign FlagWrite[0] = CondEx & FlagW[0];
    assign FlagWrite[1] = CondEx & FlagW[1];
    
    
    always@(posedge CLK)
    begin
        if(FlagWrite[1] == 1'b1) 
        begin
            if(MCycleDone == 1'b1)
            begin
                N <= MCycleFlags[1];
                Z <= MCycleFlags[0];
            end
            else
            begin 
                N <= ALUFlags[3];
                Z <= ALUFlags[2];
            end
        end
        else
        begin
            N <= N;
            Z <= Z;
        end    
    end
        
    always@(posedge CLK)
    begin
        if(FlagWrite[0] == 1'b1) 
        begin
            C <= ALUFlags[1];
            V <= ALUFlags[0];
        end
        else if(Op == 2'b00 && S_bit == 1)
        begin
            C <= ShCarry;
            V <= V;
        end
        else
        begin
            C <= C;
            V <= V;
        end
        Carry <= C;
    end

endmodule













