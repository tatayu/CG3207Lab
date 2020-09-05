
//----------------------------------------------------------------
// Instruction Memory
//----------------------------------------------------------------
initial begin
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
end

//----------------------------------------------------------------
// Data (Constant) Memory
//----------------------------------------------------------------
initial begin
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

