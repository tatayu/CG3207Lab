`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.09.2020 10:21:12
// Design Name: 
// Module Name: test
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


module test(

    );
    reg clk = 0;
    reg btnU = 0;
    reg btnC = 0;
    wire [15:0] led;
    
    Top top_sim(clk, btnU, btnC, led);
    
    initial
    begin
    btnU = 1'b0; btnC = 1'b0; #23;
    
    btnU = 1'b1; btnC = 1'b0; #15;
    
    btnU = 1'b1; btnC = 1'b1; #20;
    
    btnU = 1'b1; btnC = 1'b0; #13;
    
    btnU = 1'b0; btnC = 1'b0; #15;
    
    btnU = 1'b0; btnC = 1'b1; #8;
    
    btnU = 1'b0; btnC = 1'b0;
    end
    
    always
    begin
        clk = ~clk; #1;
    end
endmodule
