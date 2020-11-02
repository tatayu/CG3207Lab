`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Shahzor Ahmad and Rajesh Panicker  
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: ARM
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: ARM Module
-- 
-- Dependencies: NIL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: The interface SHOULD NOT be modified. The implementation can be modified
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

//-- R15 is not stored
//-- Save waveform file and add it to the project
//-- Reset and launch simulation if you add interal signals to the waveform window

module ARM(
    input CLK,
    input RESET,
    //input Interrupt,  // for optional future use
    input [31:0] Instr,
    input [31:0] ReadData,
    output MemWrite,
    output [31:0] PC,
    output [31:0] ALUResult,
    output [31:0] WriteData
    );
    
    // RegFile signals
    //wire CLK ;
    wire WE3 ;
    wire WE5 ;
    wire [3:0] A1 ;
    wire [3:0] A2 ;
    wire [3:0] A3 ;
    wire [3:0] A4 ; //4th register for DPRSR or MULL
    wire [3:0] A5;
    wire [31:0] WD3 ;
    wire [31:0] WD4 ;
    wire [31:0] R15 ;
    wire [31:0] RD1 ;
    wire [31:0] RD2 ;
    wire [31:0] RD3 ; //value fromm the 4th register
    
    // Extend Module signals
    wire [1:0] ImmSrc ;
    wire [23:0] InstrImm ;
    wire [31:0] ExtImm ;
    
    // Decoder signals
    wire [3:0] Rd ;
    wire [1:0] Op ;
    wire [5:0] Funct ;
    //wire PCS ;
    //wire RegW ;
    //wire MemW ;
    wire MemtoReg ;
    wire ALUSrc ;
    //wire [1:0] ImmSrc ;
    wire [1:0] RegSrc ;
    //wire NoWrite ;
    //wire [1:0] ALUControl ;
    //wire [1:0] FlagW ;
    
    // CondLogic signals
    //wire CLK ;
    wire PCS ;
    wire RegW ;
    wire NoWrite ;
    wire MemW ;
    wire [1:0] FlagW ;
    wire [3:0] Cond ;
    //wire [3:0] ALUFlags,
    wire PCSrc ;
    wire RegWrite ; 
    //wire MemWrite
    wire Carry ;
       
    // Shifter signals // TODO: Will come back
    wire [1:0] Sh ;
    wire [4:0] Shamt5 ;
    wire [31:0] ShIn ;
    wire [31:0] ShOut ;
    wire ShCarry ;
    
    // ALU signals
    wire [31:0] Src_A ;
    wire [31:0] Src_B ;
    wire [1:0] ALUControl ;
    //wire [31:0] ALUResult ;
    wire [3:0] ALUFlags ;
    wire [1:0] MCycleFlags ;
    //wire [3:0] FinalFlags ;
    // ProgramCounter signals
    //wire CLK ;
    //wire RESET ;
    wire WE_PC ;    
    wire [31:0] PC_IN ; 
    //wire [31:0] PC ; 
    wire Swap;
    wire Cycle2;
    //wire SwapLDRDone; //1: when LDR of SWP is done ?Rn -> Rd?
        
    // Other internal signals here
    wire [31:0] PCPlus4 ;
    wire [31:0] PCPlus8 ;
    wire [31:0] Result ;
    
    //MUL and DIV signals
    wire Start ;
    wire [1:0] MCycleOp ;
    wire [31:0] Operand1;
    wire [31:0] Operand2;
    wire [31:0] Result1;
    wire [31:0] Result2;
    wire Busy;
    wire [3:0] MCond;
    wire [31:0] ALUMCMux;
    wire Done;
    
    //Pre/Post index signal
    wire StartProcessorStall;
    wire [1:0] CycleCounter; //counter for stall processor
    //wire DoneProcessorStall;
    wire ProcessorBusy;
    
    // datapath connections here
    //assign WE_PC = ~Busy; // Will need to control it for multi-cycle operations (Multiplication, Division) and/or Pipelining with hazard hardware.
    assign WE_PC = (Busy == 1'b1) ? 1'b0 : ((ProcessorBusy == 1'b1) ? 1'b0 : 1'b1);
    
    //MUL and DIV signals
    assign MCond = Instr[7:4];
    assign Operand1 = RD2;
    assign Operand2 = RD1;
    
    
    //Register File
    assign WE3 = RegWrite;
    assign A1 = (RegSrc[0] == 1) ? 4'b1111 : (Start == 1 ? Instr[11:8] : Instr[19:16]); //R15 or Rn or Rs for Div/Mul
    assign A2 = (Cycle2 == 1'b1) ? Instr[3:0] : ((RegSrc[1] == 1) ? Instr[15:12] : Instr[3:0]);
    assign A3 = (Start == 1) ? Instr[19:16] : Instr[15:12]; //RdHi for SMULL/UMULL[19:16] (write port)
    assign A4 = (Instr[27:26] == 2'b01) ? Instr[3:0] : Instr[11:8]; //register shifted register/register shifted immediate for MI(Rm)(read port)
    assign WE5 = (Start == 1 && (Instr[24:21] == 4'b0110 || Instr[24:21] == 4'b0100)) ? 1 : 0;
    assign A5 = Instr[15:12];
    assign WD3 = WE5 == 1 ? Result2 : Result; //RdLo
    assign WD4 = Result; //RdHi
    assign R15 = PCPlus8;
    assign WriteData = RD2;
      
    //Swap
    assign Swap = (Instr[27:20] == 8'b00010000 && Instr[7:4] == 4'b1001); //DP NON IMM 7:4 cannot be 1001   
    assign Cycle2 = (StartProcessorStall == 1 && CycleCounter == 2'b01);
    //Extend Module Signals
    assign InstrImm = (Swap == 1) ? 0 : Instr[23:0]; //Normal Instr or SWP
    
    //Decoder Signals
    assign Rd = (Cycle2 == 1'b1) ? Instr[19:16] : Instr[15:12];
    assign Op = Swap == 1'b1 ? 2'b01 : Instr[27:26]; //LDR/STR for SWP instr
    assign Funct = (Op == 2'b10) ? Instr[25:24] : ((Swap == 1'b1) ? ((Cycle2 == 1) ? 6'b011000 : 6'b011001) : Instr[25:20]); 
    
    //Conditional Logic Signals
    assign Cond = Instr[31:28];
    
    //ALU Signals
    assign Src_A = (Op == 2'b00) ? (Instr[24:21] == 4'b1101 ? 0 : (Instr[24:21] == 4'b1111 ? 0 : RD1)) : RD1;
    assign Src_B = (ALUSrc == 0) ? ShOut : ExtImm; //Shifter-operand
    
    //PC Signals
    assign PCPlus4 = PC + 4;
    assign PCPlus8 = PCPlus4 + 4;
    assign ALUMCMux = (Start == 1) ? Result1 : ALUResult;
    assign Result = (MemtoReg == 1) ? ReadData : ALUMCMux;
    assign PC_IN = (PCSrc == 1) ? Result : ( PCPlus4); 
    
    //Shifter Signals 
    assign Sh = (Op == 2'b01) ? Instr[6:5] : ((Instr[25] == 1) ? 2'b11 : Instr[6:5]);
    assign Shamt5 = (Op == 2'b01) ? Instr[11:7] : ((Instr[25] == 1) ? ({Instr[11:8], 1'b0}) : ((Instr[4] == 0) ? Instr[11:7] : RD3[4:0]));
    assign ShIn = (Op == 2'b01) ? (Instr[25] == 1 ? RD3 : ExtImm) : (Instr[25] == 1 ? ExtImm : RD2);
     
    // Instantiate RegFile
    RegFile RegFile1( 
                    CLK,
                    WE3,
                    WE5,
                    A1,
                    A2,
                    A3,
                    A4,
                    A5,
                    WD3,
                    WD4,
                    R15,
                    RD1,
                    RD2,
                    RD3   
                );
                
     // Instantiate Extend Module
    Extend Extend1(
                    ImmSrc,
                    InstrImm,
                    ExtImm
                );
                
    // Instantiate Decoder
    Decoder Decoder1(
                    Rd,
                    Op,
                    Funct,
                    MCond,
                    Swap,
                    PCS,
                    RegW,
                    MemW,
                    MemtoReg,
                    ALUSrc,
                    ImmSrc,
                    RegSrc,
                    NoWrite,
                    ALUControl,
                    FlagW,
                    Start,
                    MCycleOp,
                    StartProcessorStall
                );
                                
    // Instantiate CondLogic
    CondLogic CondLogic1(
                    CLK,
                    PCS,
                    RegW,
                    NoWrite,
                    MemW,
                    FlagW,
                    Cond,
                    ALUFlags,
                    MCycleFlags,
                    Done,
                    ShCarry,
                    Op,
                    Instr[20],
                    PCSrc,
                    RegWrite,
                    MemWrite,
                    Carry
                );
                
    // Instantiate Shifter        
    Shifter Shifter1(
                    Sh,
                    Shamt5,
                    ShIn,
                    ShOut,
                    ShCarry
                );
                
    // Instantiate ALU        
    ALU ALU1(
                    Src_A,
                    Src_B,
                    ALUControl,
                    Funct[4:1],
                    Op,
                    Carry,
                    ALUResult,
                    ALUFlags
                );                
    
    // Instantiate ProgramCounter    
    ProgramCounter ProgramCounter1(
                    CLK,
                    RESET,
                    WE_PC,    
                    PC_IN,
                    PC  
                );
                
    // Instantiate MCygle
    MCycle MCycle1(
                CLK,
                RESET,
                Start,
                MCycleOp,
                Operand1,
                Operand2,
                Result1,
                Result2,
                Busy,                
                MCycleFlags,
                Done
                );
                
    StallProcessor StallProcessor1(
                            CLK,
                            RESET,
                            StartProcessorStall,
                            CycleCounter,
                            //DoneProcessorStall
                            ProcessorBusy
                            );                             
endmodule








