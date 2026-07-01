`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.06.2026 21:08:06
// Design Name: 
// Module Name: testbench_fibonacci
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


module testbench_fibonacci;
reg clk = 1'b0;
reg rst = 1'b1;
wire zero,carry,borrow,overflow,negative;
wire [7:0] current_pc;
top_module cpu_fib(.clk(clk),.rst(rst),.zero(zero),.carry(carry),.borrow(borrow),
                   .overflow(overflow),.negative(negative),.current_pc(current_pc));
 
 always #5 clk = ~clk;
 
 function [23:0] ADDI(input [4:0] rd,input [4:0] rs, input [7:0] imm8);
    ADDI = {5'b00101,rd,rs,1'd0,imm8};
 endfunction
 
 function [23:0] ADD(input [4:0] rd,input [4:0] rs);                  
    ADD = {5'b00000,rd,rs,9'd0};
 endfunction
 
 function [23:0] MOVE(input [4:0] rd, input [4:0] rs);
    MOVE = {5'b01010,rd,rs,9'd0};
 endfunction
 
 initial begin
    //=================INSTRUCTION LOAD==================
        cpu_fib.INSTR_MEM.instr_mem[0] = ADDI(5'd1,5'd0,8'd1);
        cpu_fib.INSTR_MEM.instr_mem[1] = ADDI(5'd2,5'd0,8'd1);
        cpu_fib.INSTR_MEM.instr_mem[2] = MOVE(5'd3,5'd2);
        cpu_fib.INSTR_MEM.instr_mem[3] = ADD(5'd3,5'd1);
        cpu_fib.INSTR_MEM.instr_mem[4] = MOVE(5'd4,5'd3);
        cpu_fib.INSTR_MEM.instr_mem[5] = ADD(5'd4,5'd2);
        cpu_fib.INSTR_MEM.instr_mem[6] = MOVE(5'd5,5'd4);
        cpu_fib.INSTR_MEM.instr_mem[7] = ADD(5'd5,5'd3);
        cpu_fib.INSTR_MEM.instr_mem[8] = MOVE(5'd6,5'd5);
        cpu_fib.INSTR_MEM.instr_mem[9] = ADD(5'd6,5'd4);
        cpu_fib.INSTR_MEM.instr_mem[10] = MOVE(5'd7,5'd6);
        cpu_fib.INSTR_MEM.instr_mem[11] = ADD(5'd7,5'd5);
        cpu_fib.INSTR_MEM.instr_mem[12] = MOVE(5'd8,5'd7);
        cpu_fib.INSTR_MEM.instr_mem[13] = ADD(5'd8,5'd6);
        cpu_fib.INSTR_MEM.instr_mem[14] = MOVE(5'd9,5'd8);
        cpu_fib.INSTR_MEM.instr_mem[15] = ADD(5'd9,5'd7);
        cpu_fib.INSTR_MEM.instr_mem[16] = MOVE(5'd10,5'd9);
        cpu_fib.INSTR_MEM.instr_mem[17] = ADD(5'd10,5'd8);
        cpu_fib.INSTR_MEM.instr_mem[18] = MOVE(5'd11,5'd10);
        cpu_fib.INSTR_MEM.instr_mem[19] = ADD(5'd11,5'd9);
        cpu_fib.INSTR_MEM.instr_mem[20] = MOVE(5'd12,5'd11);
        cpu_fib.INSTR_MEM.instr_mem[21] = ADD(5'd12,5'd10);
        cpu_fib.INSTR_MEM.instr_mem[22] = MOVE(5'd13,5'd12);
        cpu_fib.INSTR_MEM.instr_mem[23] = ADD(5'd13,5'd11);
 
          
//====================================================================================
    $display ("STARTING SIMULATION......");
    #20;
    rst = 1'b0;
    $display ("\n===============INSTRUCTION TRACE===============");
    
    repeat (25) begin
        @(posedge clk)
            $display("[Cycle] PC =%d | R1=%d | R2=%d | R3=%d | R4=%d | R5=%d | R6=%d | R7=%d | R8=%d | R9=%d | R10=%d | R11=%d | R12=%d | R13=%d ",
                       current_pc,
                       cpu_fib.RF.registers[1],cpu_fib.RF.registers[2],cpu_fib.RF.registers[3],cpu_fib.RF.registers[4],cpu_fib.RF.registers[5],cpu_fib.RF.registers[6],
                       cpu_fib.RF.registers[7],cpu_fib.RF.registers[8],cpu_fib.RF.registers[9],cpu_fib.RF.registers[10],cpu_fib.RF.registers[11],cpu_fib.RF.registers[12],
                       cpu_fib.RF.registers[13]);
    end
    
       $display ("\n============== TEST COMPLETE =============");
      
       if (cpu_fib.RF.registers[13] == 8'd233 )
            $display ("TEST PASSED ✓");
       else
            $display ("TEST FAILED ✗");
    
    $finish;
end                 
endmodule
