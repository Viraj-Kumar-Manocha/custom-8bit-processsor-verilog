`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 02:42:09
// Design Name: 
// Module Name: testbench_reg_file
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


module testbench_reg_file;
    parameter WIDTH = 8;
    parameter DEPTH = 32;
    parameter ADDR = 5;
    
    reg clk = 1'b0;
    reg rst,we;
    reg [ADDR-1:0] raddr1,raddr2,waddr;
    reg [WIDTH-1:0] wdata;
    wire [WIDTH-1:0] rdata1,rdata2;
    
    reg_file #(WIDTH,DEPTH,ADDR) uut(.clk(clk),.rst(rst),.we(we),
                                     .raddr1(raddr1),.raddr2(raddr2),
                                     .waddr(waddr),.wdata(wdata),
                                     .rdata1(rdata1),.rdata2(rdata2));
    
    //clk 
    always #5 clk = ~clk;
    
    initial begin
        $display("=============STARTING REG FILE TEST=============");
        rst = 1'b1;we=1'b0;
        raddr1 = 0; raddr2 = 0; waddr = 0; wdata = 0; 
        
        #10; rst = 1'b0;
        
        //test 1: write and read
        we = 1'b1; waddr = 5'd5; wdata = 8'hAA;
        #10;
        we = 1'b0; raddr1 = 5'd5;
        #10;
        $display("Read R5 = %h (EXPECTED = AA)",rdata1);
        
        we = 1'b1; waddr = 5'd8; wdata = 8'hC3;
        #10;
        we = 1'b0; raddr2 = 5'd8;
        #10;
        $display("Read R8 = %h (EXPECTED = C3)",rdata2);
        
        //test 2: R0 should stay zero
        we = 1'b1; waddr = 0; wdata = 8'h12;
        #10;
        we = 1'b0; raddr1 = 0;
        #10;
        $display ("Read R0 = %h (EXPECTED = 00)",rdata1);
        #10;
        
        //test 3 : forwarding
        we = 1'b1; waddr = 5'd5; wdata = 8'hAB;
        raddr1 = 5'd5;
        #10;
        $display ("Read R5 = %h (EXPECTED = AB)",rdata1);
        #10;
        
        //test 4 : dual reading
        we = 1'b1; waddr = 5'd16; wdata = 8'hA1;
        #10;
        waddr = 5'd28; wdata = 8'hFF;
        #10;
        we = 1'b0;raddr1=5'd16;raddr2=5'd28;
        #10;
        $display("R16 = %h , R28 = %h (EXPECTED A1 and FF)",rdata1,rdata2);
        #10;
        $display ("============TEST COMPLETE============");
        $finish;
    end 
endmodule
