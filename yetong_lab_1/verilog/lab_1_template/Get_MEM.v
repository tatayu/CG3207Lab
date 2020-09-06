`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This module should contain the corresponding Memory data generated from Hex2ROM
// and choose the memory data to be displayed based on enable signal  
// Fill in the blank to complete this module 
// (c) Gu Jing, ECE, NUS
//////////////////////////////////////////////////////////////////////////////////


module Get_MEM(
    input clk,					// fundamental clock 100MHz
	input enable,				// enable signal to read the next content
	output reg [31:0] data,			// 32 bits memory contents for 7-segments display
    output reg upper_lower);      	// 1-bit signal rerequied for LEDs, indicating which half of the Memory data is displaying on LEDs
								// upper_lower = 0 to display upper half of the Memory data on LEDs
    
// declare INSTR_MEM and DATA_CONST_MEM
reg [31:0] INSTR_MEM [0:127];
reg [31:0] DATA_CONST_MEM [0:127];

// declare indics of INSTR_MEM and DATA_CONST_MEM
reg [8:0] addr = 9'b000000000;
reg [8:0] i, j;

initial begin
//----------------------------------------------------------------
// Instruction Memory
//----------------------------------------------------------------
    INSTR_MEM[0] = 32'hE59F11F8; 
    INSTR_MEM[1] = 32'hE59F21F8; 
    INSTR_MEM[2] = 32'hE59F3200; 
    INSTR_MEM[3] = 32'hE5924000; 
    INSTR_MEM[4] = 32'hE5814000; 
    INSTR_MEM[5] = 32'hE2533001; 
    INSTR_MEM[6] = 32'h1AFFFFFD; 
    INSTR_MEM[7] = 32'hE3530000; 
    INSTR_MEM[8] = 32'h0AFFFFF8; 
    INSTR_MEM[9] = 32'hEAFFFFFE; 
    for(i = 10; i < 128; i = i+1) begin 
        INSTR_MEM[i] = 32'h0; 
    end
//----------------------------------------------------------------
// Data (Constant) Memory
//----------------------------------------------------------------
    DATA_CONST_MEM[0] = 32'h00000C00; 
    DATA_CONST_MEM[1] = 32'h00000C04; 
    DATA_CONST_MEM[2] = 32'h00000C08; 
    DATA_CONST_MEM[3] = 32'h00000C0C; 
    DATA_CONST_MEM[4] = 32'h00000004; 
    DATA_CONST_MEM[5] = 32'h00000800; 
    DATA_CONST_MEM[6] = 32'hABCD1234; 
    DATA_CONST_MEM[7] = 32'h6C6C6548; 
    DATA_CONST_MEM[8] = 32'h6F57206F; 
    DATA_CONST_MEM[9] = 32'h21646C72; 
    DATA_CONST_MEM[10] = 32'h00212121; 
    for(i = 11; i < 128; i = i+1) begin 
        DATA_CONST_MEM[i] = 32'h0; 
    end
end

// determine upper_lower by corresponding input

// determine corresponding memory data that should be displayed on 7-segments

// determine memory index "addr" accordingly
always @(posedge clk)
begin
    if(enable == 1)
    begin
        if(addr[8] == 1'b0) //get instruction memory
        begin
            data <= INSTR_MEM[addr[7:1]];
        end
        else //get data constant memory
        begin
            data <= DATA_CONST_MEM[addr[7:1]];
        end
        upper_lower <= addr[0];
        addr <= addr + 1'b1;
    end
end
	
endmodule
