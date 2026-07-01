`timescale 1ns / 1ps

module datapath(input clk,
                input rst,
                input [23:0] inst,
                
                output zero,
                output carry,
                output borrow,
                output negative,
                output overflow);

wire [4:0] rs,rd;
wire [7:0] imm8;
wire [3:0] alu_op;
wire reg_we,mem_read,mem_write,alu_src,mem_to_reg,is_mem_inst;
wire [11:0] mem_addr;

wire [7:0] rs_data,rd_data;
wire [7:0] write_back_data;
wire [7:0] alu_source_1,alu_source_2;

//================================DECODER=======================================
    decoder DEC(.inst(inst),.rs(rs),.rd(rd),
                .imm8(imm8),.alu_op(alu_op),
                .reg_we(reg_we),.mem_read(mem_read),
                .mem_write(mem_write),.alu_src(alu_src),
                .mem_to_reg(mem_to_reg),.is_mem_inst(is_mem_inst),
                .mem_addr(mem_addr));

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
            .less(),.equal(),.greater());
 
 //=============================== MEMORY ========================================
    wire [7:0] mem_read_data;
    data_memory_4kB MEMORY(.clk(clk),.rst(rst),
                           .mem_read(mem_read),.mem_write(mem_write),
                           .address(mem_addr),
                           .write_data(rd_data),.read_data(mem_read_data));
                           
 //==============================WRITE BACK======================================
    assign write_back_data = (mem_to_reg) ? mem_read_data : result ;                    
endmodule
