`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.06.2026 03:27:49
// Design Name: 
// Module Name: instruction_memory
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

//256 x 24 bit instruction memory , 768 byte memory (0.75 kB)
module instruction_memory(input [7:0] address,
                          output reg [23:0] instruction);
     reg [23:0] instr_mem [255:0];
     
     //Asynchornous read
     always @(*) begin
        instruction = instr_mem[address];
     end
                               
endmodule
