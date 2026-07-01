`timescale 1ns / 1ps

module top_module( input clk,
                   input rst,
               
                   output zero,
                   output carry,
                   output borrow,
                   output negative,
                   output overflow,
                   output [7:0] current_pc);

wire [4:0] rs,rd;
wire [7:0] imm8;
wire [3:0] alu_op;
wire reg_we,mem_read,mem_write,alu_src,mem_to_reg,is_mem_inst;
wire [11:0] mem_addr;
wire is_branch;
wire branch_type;
wire branch_equal_condition;

wire [7:0] rs_data,rd_data;
wire [7:0] write_back_data;
wire [7:0] alu_source_1,alu_source_2;
wire [23:0] inst;
wire [7:0] pc;

//=========================================PROGRAM COUNTER===============================
    program_counter PC(.clk(clk),.rst(rst),.pc_next(imm8),.pc_write(1'b1),
                       .branch_type(branch_type),.branch_condition(branch_equal_condition),
                       .is_branch(is_branch),.pc(pc),.pc_plus_1());
                       
//========================================INSTRUCTION MEMORY=============================                       
    instruction_memory INSTR_MEM(.address(pc),.instruction(inst));
    
//================================DECODER=======================================
    decoder DEC(.inst(inst),.rs(rs),.rd(rd),
                .imm8(imm8),.alu_op(alu_op),
                .reg_we(reg_we),.mem_read(mem_read),
                .mem_write(mem_write),.alu_src(alu_src),
                .mem_to_reg(mem_to_reg),.is_mem_inst(is_mem_inst),
                .mem_addr(mem_addr),
                .is_branch(is_branch),.branch_type(branch_type));

//================================REGISTER FILE==================================
    reg_file RF(.clk(clk),.rst(rst),.raddr1(rd),.raddr2(rs),
                .rdata1(rd_data),.rdata2(rs_data),.we(reg_we),
                .waddr(rd),.wdata(write_back_data));

//================================ALU SELECTION MUX==============================
    assign alu_source_1 = (alu_src) ? rs_data : rd_data;  
    assign alu_source_2 = (alu_src) ? imm8 : rs_data;

//================================   ALU  =======================================
    wire [7:0] result;
    alu ALU(.a(alu_source_1),.b(alu_source_2),
            .op(alu_op),.result(result),
            .zero(zero),.carry(carry),
            .negative(negative),.overflow(overflow),
            .borrow(borrow),
            .less(),.equal(branch_equal_condition),.greater());
 
 //=============================== MEMORY ========================================
    wire [7:0] mem_read_data;
    data_memory_4kB MEMORY(.clk(clk),.rst(rst),
                           .mem_read(mem_read),.mem_write(mem_write),
                           .address(mem_addr),
                           .write_data(rd_data),.read_data(mem_read_data));
                           
 //==============================WRITE BACK======================================
    assign write_back_data = (mem_to_reg) ? mem_read_data : result ;                    

//===================================OUTPUT======================================
    assign current_pc = pc;
   
endmodule
