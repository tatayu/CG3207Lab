`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2020 10:50:00
// Design Name: 
// Module Name: StallProcessor
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


module StallProcessor(
        input CLK,
        input RESET,
        input Start,
        output reg [1:0] CycleCounter,
        output ProcessorBusy
    ); 
    assign ProcessorBusy = Start & ~CycleCounter;
    
    always@(posedge CLK) begin       
        // reset
        if(~RESET) begin
            if(Start && CycleCounter == 2'b00) begin
                CycleCounter <= CycleCounter + 1'b1;
            end
            else begin
                CycleCounter <= 1'b0;
            end
        end
    end      

    
    
endmodule
