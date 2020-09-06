`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.09.2020 10:45:27
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    reg clk = 0;
    reg sim_btnU = 0;
    reg sim_btnC = 0;
    wire [15:0] sim_led;
    
    Top top_sim(clk, sim_btnU, sim_btnC, sim_led);
    
    initial
    begin
        sim_btnU = 1'b0; sim_btnC = 1'b0; #23;
        sim_btnU = 1'b1; sim_btnC = 1'b0; #15;
        sim_btnU = 1'b1; sim_btnC = 1'b1; #20; 
        sim_btnU = 1'b1; sim_btnC = 1'b0; #13;   
        sim_btnU = 1'b0; sim_btnC = 1'b0; #15;
        sim_btnU = 1'b0; sim_btnC = 1'b1; #8;
        sim_btnU = 1'b0; sim_btnC = 1'b0;
    end
    
    always
    begin
    clk = ~clk; #1;
    end
endmodule
