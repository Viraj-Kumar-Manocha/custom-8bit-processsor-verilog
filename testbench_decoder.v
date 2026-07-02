`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: testbench_decoder
// Description: Verifies correct control signal generation for every
//              instruction type supported by the decoder module.
//////////////////////////////////////////////////////////////////////////////////

module testbench_decoder;

    reg  [23:0] inst;

    wire [4:0]  rs;
    wire [4:0]  rd;
    wire [7:0]  imm8;
    wire [3:0]  alu_op;

    wire        reg_we;
    wire        mem_read;
    wire        mem_write;

    wire        alu_src;
    wire        mem_to_reg;

    wire [11:0] mem_addr;

    wire        is_mem_inst;
    wire        is_branch;
    wire        branch_type;

    integer errors = 0;

    // DUT instantiation
    decoder dut (
        .inst(inst),
        .rs(rs),
        .rd(rd),
        .imm8(imm8),
        .alu_op(alu_op),
        .reg_we(reg_we),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .mem_addr(mem_addr),
        .is_mem_inst(is_mem_inst),
        .is_branch(is_branch),
        .branch_type(branch_type)
    );

    // Task to check a control signal and log a mismatch
    task check(input [127:0] name, input expected, input actual);
        begin
            if (expected !== actual) begin
                $display("  MISMATCH: %s -> expected=%b actual=%b", name, expected, actual);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $display("=== Decoder Testbench Start ===");

        // ---------------- ADD: opcode 00000, rd=5, rs=3 ----------------
        inst = {5'b00000, 5'd5, 5'd3, 1'b0, 8'd0};
        #10;
        $display("[ADD] rd=%d rs=%d alu_op=%b", rd, rs, alu_op);
        check("ADD.rd",       5'd5,  rd);
        check("ADD.rs",       5'd3,  rs);
        check("ADD.alu_op",   4'b0000, alu_op);
        check("ADD.reg_we",   1'b1,  reg_we);
        check("ADD.alu_src",  1'b0,  alu_src);

        // ---------------- SUB: opcode 00001 ----------------
        inst = {5'b00001, 5'd7, 5'd2, 1'b0, 8'd0};
        #10;
        $display("[SUB] rd=%d rs=%d alu_op=%b", rd, rs, alu_op);
        check("SUB.alu_op",   4'b0001, alu_op);
        check("SUB.reg_we",   1'b1,  reg_we);

        // ---------------- AND: opcode 00010 ----------------
        inst = {5'b00010, 5'd1, 5'd2, 1'b0, 8'd0};
        #10;
        check("AND.alu_op",   4'b0010, alu_op);
        check("AND.reg_we",   1'b1,  reg_we);

        // ---------------- OR: opcode 00011 ----------------
        inst = {5'b00011, 5'd1, 5'd2, 1'b0, 8'd0};
        #10;
        check("OR.alu_op",    4'b0011, alu_op);
        check("OR.reg_we",    1'b1,  reg_we);

        // ---------------- XOR: opcode 00100 ----------------
        inst = {5'b00100, 5'd1, 5'd2, 1'b0, 8'd0};
        #10;
        check("XOR.alu_op",   4'b0100, alu_op);
        check("XOR.reg_we",   1'b1,  reg_we);

        // ---------------- MOVE: opcode 01010 ----------------
        inst = {5'b01010, 5'd9, 5'd4, 1'b0, 8'd0};
        #10;
        check("MOVE.alu_op",  4'b1001, alu_op);
        check("MOVE.reg_we",  1'b1,  reg_we);
        check("MOVE.alu_src", 1'b0,  alu_src);

        // ---------------- ADDI: opcode 00101, imm8=8'd42 ----------------
        inst = {5'b00101, 5'd6, 5'd0, 1'b0, 8'd42};
        #10;
        $display("[ADDI] rd=%d imm8=%d alu_src=%b", rd, imm8, alu_src);
        check("ADDI.rd",      5'd6,  rd);
        check("ADDI.imm8",    8'd42, imm8);
        check("ADDI.alu_op",  4'b0000, alu_op);
        check("ADDI.reg_we",  1'b1,  reg_we);
        check("ADDI.alu_src", 1'b1,  alu_src);

        // ---------------- LOAD: opcode 00110, rd=10, mem_addr=12'd100 ----------------
        inst = {5'b00110, 5'd10, 12'd100, 2'b00};
        #10;
        $display("[LOAD] rd=%d mem_addr=%d", rd, mem_addr);
        check("LOAD.rd",         5'd10,  rd);
        check("LOAD.mem_addr",   12'd100, mem_addr);
        check("LOAD.mem_read",   1'b1,  mem_read);
        check("LOAD.reg_we",     1'b1,  reg_we);
        check("LOAD.mem_to_reg", 1'b1,  mem_to_reg);
        check("LOAD.is_mem_inst",1'b1,  is_mem_inst);

        // ---------------- STORE: opcode 00111, rd=11, mem_addr=12'd200 ----------------
        inst = {5'b00111, 5'd11, 12'd200, 2'b00};
        #10;
        $display("[STORE] rd=%d mem_addr=%d", rd, mem_addr);
        check("STORE.mem_addr",    12'd200, mem_addr);
        check("STORE.mem_write",   1'b1,  mem_write);
        check("STORE.reg_we",      1'b0,  reg_we);
        check("STORE.is_mem_inst", 1'b1,  is_mem_inst);

        // ---------------- BEQ: opcode 01000, rd=3, rs=3 (equal), imm8 offset=5 ----------------
        inst = {5'b01000, 5'd3, 5'd3, 1'b0, 8'd5};
        #10;
        $display("[BEQ] rd=%d rs=%d imm8(offset)=%d is_branch=%b branch_type=%b",
                   rd, rs, imm8, is_branch, branch_type);
        check("BEQ.alu_op",      4'b0001, alu_op);
        check("BEQ.is_branch",   1'b1,  is_branch);
        check("BEQ.branch_type", 1'b0,  branch_type);
        check("BEQ.reg_we",      1'b0,  reg_we);

        // ---------------- JMP: opcode 01001, imm8 offset=10 ----------------
        inst = {5'b01001, 5'd0, 5'd0, 1'b0, 8'd10};
        #10;
        $display("[JMP] imm8(offset)=%d is_branch=%b branch_type=%b", imm8, is_branch, branch_type);
        check("JMP.is_branch",   1'b1,  is_branch);
        check("JMP.branch_type", 1'b1,  branch_type);
        check("JMP.reg_we",      1'b0,  reg_we);

        // ---------------- Default/undefined opcode: should produce safe no-op ----------------
        inst = {5'b11111, 5'd0, 5'd0, 1'b0, 8'd0};
        #10;
        $display("[DEFAULT] all control signals should be de-asserted");
        check("DEFAULT.reg_we",     1'b0, reg_we);
        check("DEFAULT.mem_read",   1'b0, mem_read);
        check("DEFAULT.mem_write",  1'b0, mem_write);
        check("DEFAULT.is_branch",  1'b0, is_branch);
        check("DEFAULT.is_mem_inst",1'b0, is_mem_inst);

        // ---------------- Summary ----------------
        if (errors == 0)
            $display("=== ALL TESTS PASSED ===");
        else
            $display("=== %d TEST(S) FAILED ===", errors);

        $finish;
    end

endmodule