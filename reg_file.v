`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 02:27:25
// Design Name: 
// Module Name: reg_file
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


module reg_file #(parameter WIDTH = 8,
                  parameter DEPTH = 32,
                  parameter ADDR = 5
                )(
                  input clk,
                  input rst,
                  input [ADDR-1:0] raddr1,raddr2,  //READ PORTS
                  output [WIDTH-1:0] rdata1,rdata2,
                
                  input [ADDR-1:0] waddr,   //WRITE PORT
                  input [WIDTH-1:0] wdata,       
                  input we //WRITE ENABLE
    );
    
    reg [WIDTH-1:0] registers [DEPTH-1:0];// 32 registers wirh 8 bit each
    integer i;

    //SYNCHRONOUS WRITE
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i=0; i<DEPTH; i =i+1) begin
                registers[i] <= {WIDTH{1'b0}};
            end
        end
        else if (we==1 && waddr != 0) begin
            registers[waddr] <= wdata;
        end
    end
    
    //ASYNCHRONOUS READ
    
    assign rdata1 = (raddr1 == 0) ? {WIDTH{1'b0}}:
                    registers[raddr1];
    assign rdata2 = (raddr2 == 0)? {WIDTH{1'b0}}:
                    registers[raddr2];
endmodule
