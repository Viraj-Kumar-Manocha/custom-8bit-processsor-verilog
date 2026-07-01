`timescale 1ns / 1ps

module testbench_2;
    reg clk = 1'b0;
    reg rst = 1'b1;
    wire zero,carry,borrow,negative,overflow;
    wire [7:0] current_pc;
    
    top_module cpu(.clk(clk),.rst(rst),.zero(zero),.carry(carry),
                    .borrow(borrow),.negative(negative),.overflow(overflow),
                    .current_pc(current_pc));
    
    always #5 clk = ~clk;
    
    initial begin
        // Load program
        cpu.INSTR_MEM.instr_mem[0] = {5'b00101,5'b00001,5'b00000,1'b0,8'd5};    // ADDI R1, 5
        cpu.INSTR_MEM.instr_mem[1] = {5'b00101,5'd2,5'b00000,1'b0,8'd5};         // ADDI R2, 5
        cpu.INSTR_MEM.instr_mem[2] = {5'b01000,5'd2,5'd1,1'b0,8'd2};             // BEQ R2, R1, +2
        cpu.INSTR_MEM.instr_mem[3] = {5'b00101,5'd3,5'b00000,1'b0,8'd1};         // ADDI R3, 1 (SKIP)
        cpu.INSTR_MEM.instr_mem[4] = {5'b00101,5'd3,5'b00000,1'b0,8'd9};         // ADDI R3, 9
        
        $display("Starting simulation...");
        
        #20;
        rst=1'b0;
        
        $display("\n=== INSTRUCTION TRACE ===");
        // Print first 15 cycles of execution
        repeat(15) begin
            @(posedge clk);
            $display("[Cycle] PC=%d | Instr=%b | opcode=%b | is_branch=%b | R1=%d | R2=%d | R3=%d",
                     current_pc,
                     cpu.INSTR_MEM.instruction,
                     cpu.INSTR_MEM.instruction[23:19],
                     cpu.DEC.is_branch,
                     cpu.RF.registers[1],
                     cpu.RF.registers[2],
                     cpu.RF.registers[3]);
        end
        
        $display("\n=== FINAL RESULT ===");
        $display("R1=%d, R2=%d, R3=%d, PC=%d (expected: R1=5, R2=5, R3=9)",
                 cpu.RF.registers[1], cpu.RF.registers[2], cpu.RF.registers[3], current_pc);
        
        if (cpu.RF.registers[3] == 9)
            $display("✓ TEST PASSED");
        else
            $display("✗ TEST FAILED - BEQ branch not working");
        
        $finish;
    end
              
endmodule
