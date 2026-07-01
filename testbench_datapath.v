`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 22:19:07
// Design Name: 
// Module Name: testbench_datapath
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


module testbench_datapath;

    reg clk = 1'b0;
    reg rst=1'b1;
    reg [23:0] inst;

    wire zero, carry, borrow, negative, overflow;

    // ---------------- DUT ----------------
    datapath uut(
        .clk(clk),
        .rst(rst),
        .inst(inst),

        .zero(zero),
        .carry(carry),
        .borrow(borrow),
        .negative(negative),
        .overflow(overflow)
    );

//---------------- CLOCK ----------------
    always #10 clk = ~clk;

//----------------ISA CODES---------------
function [23:0] R_TYPE;
    input [4:0] opcode,rd,rs;
    input [7:0] imm;
    begin
        R_TYPE = {opcode,rd,rs,1'b0,imm};
    end
endfunction

function [23:0] M_TYPE;
    input [4:0] opcode,rd;
    input [11:0] mem_addr;
    begin
        M_TYPE = {opcode,rd,mem_addr,2'b00};
    end
endfunction

//------------------------OP CODES---------------------
localparam ADD = 5'b00000;
localparam SUB = 5'b00001;
localparam AND = 5'b00010;
localparam OR = 5'b00011;
localparam XOR = 5'b00100;
localparam ADDI = 5'b00101;
localparam LOAD = 5'b00110;
localparam STORE = 5'b00111;
//------------------------TEST BEGINS------------------
initial begin
    inst = 0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    rst = 1'b0;
    $display("After reset: R1=%d R2=%d R3=%d", uut.RF.registers[1], uut.RF.registers[2],uut.RF.registers[3]);
    
    //==================TEST 1=============================================================
    //ADDI R1,10
    // R1 = R0 + 10 because R0 is connected to ground
    //=====================================================================================
    $display ("R1 = R0 + 10 , expected R1 = 10");
    $display ("initial -> R1 = %d , R0 = %d",uut.RF.registers[1],uut.RF.registers[0]);
    inst = R_TYPE(ADDI,5'd1,5'd0,8'd10);
    #1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $display ("final -> R1 = %d , R0 = %d",uut.RF.registers[1],uut.RF.registers[0]);
    
    //=================TEST 2==============================================================
    //ADDI R2,20
    //R2 = R0 + 20
    //=====================================================================================
    $display ("R2 = R0 + 20 , expected R2 = 20");
    $display ("initial -> R2 = %d , R0 = %d",uut.RF.registers[2],uut.RF.registers[0]);
    inst = R_TYPE(ADDI,5'd2,5'd0,8'd20);
    #1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $display ("final -> R2 = %d , R0 = %d",uut.RF.registers[2],uut.RF.registers[0]);
        
    //================TEST 3==============================================================
    // ADD R2,R1
    // R2 = R2 + R1
    //===================================================================
    $display ("R2 = R2 + R1 , expected R2 = 30");
    $display ("initial -> R2 = %d , R1 = %d",uut.RF.registers[2],uut.RF.registers[1]);
    inst = R_TYPE(ADD,5'd2,5'd1,8'd0);
    #1;
    @(posedge clk);
    @(posedge clk);
    $display ("final -> R2 = %d , R1 = %d",uut.RF.registers[2],uut.RF.registers[1]);

    //=================TEST 4===================================================
    //SUB R2,R1
    //R2 = R2 - R1
    //=========================================================================
    $display ("R2 = R2 - R1 ,expected R2 = 20");
    $display ("initial -> R2 = %d , R1 = %d",uut.RF.registers[2],uut.RF.registers[1]);
    inst = R_TYPE(SUB,5'd2,5'd1,8'd0);
    #1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $display("final -> R2 = %d , R1 = %d ",uut.RF.registers[2],uut.RF.registers[1]);
    
    //==================== TEST 5 ================================================
    //STORE R1 --> MEM[1000]
    //============================================================================
    $display (" R1 --> MEM[1000]");
    $display ("initial -> R1 = %d , MEM[1000] = %d ",uut.RF.registers[1],uut.MEMORY.memory[1000]);
    inst = M_TYPE(STORE,5'd1,12'd1000);
    #1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);

    $display ("final -> R1 = %d , MEM[1000] = %d ",uut.RF.registers[1],uut.MEMORY.memory[1000]);
    
    //========================TEST 6=============================================
    //LOAD MEM[1000] -> R3
    //==========================================================================
    $display ("MEM[1000] --> R3");
    $display ("initial -> R3 = %d , MEM[1000] = %d ",uut.RF.registers[3],uut.MEMORY.memory[1000]);
    inst = M_TYPE(LOAD,5'd3,12'd1000);
    #1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    
    $display ("final -> R3 = %d , MEM[1000] = %d ",uut.RF.registers[3],uut.MEMORY.memory[1000]);
    
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $finish;
end    

endmodule
