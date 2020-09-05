//////////////////////////////////////////////////////////////////////////////////
// This module is to generate an enable signal for different display frequency based on pushbuttons
// Fill in the blank to complete this module 
// (c) Gu Jing, ECE, NUS
//////////////////////////////////////////////////////////////////////////////////

module Clock_Enable(
	input clk,			// fundamental clock 100MHz
	input btnU,			// button BTNU for 4Hz speed
	input btnC,			// button BTNC for pause
	output reg enable);	// output signal used to enable the reading of next memory data

// define reg threshold to allow 4hz or 1hz frequency
reg enable_one_hz = 0;
reg enable_four_hz = 0;
// define reg counter to be able to count to certain threshold value
reg [26:0] counter_1 = 0;
reg [24:0] counter_2 = 0;
	
	
// complete this always block by determining the enable output by counter, threshold and buttons 
always @(posedge clk)
begin
	counter_1 <= counter_1 + 1;
	enable_one_hz <= counter_1 == 0 ? 1'b1 : 1'b0;
	
	counter_2 <= counter_2 + 1;
    enable_four_hz <= counter_2 == 0 ? 1'b1 : 1'b0;
end

always @(posedge clk)
begin
    if(btnU == 0 && btnC == 0) //default 1Hz
    begin
        enable <= enable_one_hz == 1 ? 1'b1 : 1'b0;
    end
     
    else if(btnU == 1 && btnC == 0) //4 Hz
    begin
        enable <= enable_four_hz == 1 ? 1'b1 : 1'b0;
    end    
    else if(btnC == 1) //pause
    begin
        enable <= 1'b0; //reading data disable
    end    
end
	
endmodule