
//----------------------------------------------------------------
// Instruction Memory
//----------------------------------------------------------------
initial begin
			INSTR_MEM[0] = 32'hE59F11FC; 
			INSTR_MEM[1] = 32'hE59F21F4; 
			INSTR_MEM[2] = 32'hE59F3200; 
			INSTR_MEM[3] = 32'hE5914000; 
			INSTR_MEM[4] = 32'hE5014004; 
			INSTR_MEM[5] = 32'hE5814014; 
			INSTR_MEM[6] = 32'hE59F51F4; 
			INSTR_MEM[7] = 32'hE5825000; 
			INSTR_MEM[8] = 32'hE5835000; 
			INSTR_MEM[9] = 32'hE0844005; 
			INSTR_MEM[10] = 32'hE5824000; 
			INSTR_MEM[11] = 32'hE5834000; 
			INSTR_MEM[12] = 32'hE1844005; 
			INSTR_MEM[13] = 32'hE5824000; 
			INSTR_MEM[14] = 32'hE5834000; 
			INSTR_MEM[15] = 32'hE0856124; 
			INSTR_MEM[16] = 32'hE5826000; 
			INSTR_MEM[17] = 32'hE5836000; 
			INSTR_MEM[18] = 32'hE2555001; 
			INSTR_MEM[19] = 32'hE5825000; 
			INSTR_MEM[20] = 32'hE5835000; 
			INSTR_MEM[21] = 32'h1AFFFFFB; 
			INSTR_MEM[22] = 32'hE59F51B4; 
			INSTR_MEM[23] = 32'hE5825000; 
			INSTR_MEM[24] = 32'hE5835000; 
			INSTR_MEM[25] = 32'hE3550002; 
			INSTR_MEM[26] = 32'hE5825000; 
			INSTR_MEM[27] = 32'hE5835000; 
			INSTR_MEM[28] = 32'h02555002; 
			INSTR_MEM[29] = 32'hE5825000; 
			INSTR_MEM[30] = 32'hE5835000; 
			INSTR_MEM[31] = 32'h03855002; 
			INSTR_MEM[32] = 32'hE5825000; 
			INSTR_MEM[33] = 32'hE5835000; 
			INSTR_MEM[34] = 32'hE3550002; 
			INSTR_MEM[35] = 32'h02155000; 
			INSTR_MEM[36] = 32'hE5825000; 
			INSTR_MEM[37] = 32'hE5835000; 
			INSTR_MEM[38] = 32'h0AFFFFDB; 
			INSTR_MEM[39] = 32'hEAFFFFFE; 
			for(i = 40; i < 128; i = i+1) begin 
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
			DATA_CONST_MEM[4] = 32'h00000C18; 
			DATA_CONST_MEM[5] = 32'h00000002; 
			DATA_CONST_MEM[6] = 32'h00000800; 
			DATA_CONST_MEM[7] = 32'h00000804; 
			DATA_CONST_MEM[8] = 32'hABCD1234; 
			DATA_CONST_MEM[9] = 32'h6C6C6548; 
			DATA_CONST_MEM[10] = 32'h6F57206F; 
			DATA_CONST_MEM[11] = 32'h21646C72; 
			DATA_CONST_MEM[12] = 32'h00212121; 
			DATA_CONST_MEM[13] = 32'h00000800; 
			DATA_CONST_MEM[14] = 32'h00000804; 
			for(i = 15; i < 128; i = i+1) begin 
				DATA_CONST_MEM[i] = 32'h0; 
			end
end

