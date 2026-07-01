`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 01:16:57
// Design Name: 
// Module Name: decoder
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

//24 bit ISA -> 5 bit op code + 5 bit reg 1 + 5 bit reg 2 or 8 bit immediate or 12 bit mem_addr dependening upon op code
module decoder(input [23:0] inst,
               
               output reg [4:0] rs,
               output reg [4:0] rd,
               
               output reg [7:0] imm8,
               output reg [3:0] alu_op,
               
               output reg reg_we,
               output reg mem_read,
               output reg mem_write,
               
               output reg alu_src,         //0->reg, 1-> immediate
               output reg mem_to_reg,     //1 mem->reg
               
               output reg [11:0] mem_addr,
               
               output reg is_mem_inst,
               output reg is_branch,       //branch or jump
               output reg branch_type      //0-> BEQ , 1 -> JMP
               );
    wire [4:0] opcode;
    assign opcode = inst [23:19];
    
    always @(*) begin
        rd = inst[18:14];   //destination register
        rs = inst[13:9];   //source register
        
        imm8 = inst[7:0];  //immediate
        mem_addr = 12'b0;
        
        alu_op = 4'b0000;
        
        reg_we = 0;
        mem_read = 0;
        mem_write = 0;
        alu_src = 0;
        mem_to_reg = 0;
        is_mem_inst = 0;
        is_branch = 0;
        branch_type = 0;
        
        case(opcode)
            5'b00000: begin   //ADD
                alu_op = 4'b0000;
                reg_we = 1;
                alu_src = 0;
            end               
            
            5'b00001: begin   //SUB
                alu_op = 4'b0001;
                reg_we = 1;
                alu_src = 0;
            end
            
            5'b00010: begin   //AND
                alu_op = 4'b0010;
                reg_we = 1;
                alu_src = 0;
            end
            
            5'b00011: begin   //OR
                alu_op = 4'b0011;
                reg_we = 1;
                alu_src = 0;
            end
            
            5'b00100: begin   //XOR
                alu_op = 4'b0100;
                reg_we = 1;
                alu_src = 0;
            end
            
            5'b01010: begin      //MOVE
                alu_op = 4'b1001;
                reg_we = 1;
                alu_src = 0;
            end
            
            //======IMMEDIATE=======
            5'b00101: begin  //ADDI
                alu_op = 4'b0000;
                reg_we = 1;
                alu_src = 1;
            end
            
            //==============MEMORY LOAD=========
            5'b00110: begin  //LOAD
                mem_read = 1;
                reg_we = 1;
                mem_to_reg = 1;
                
                mem_addr = inst [13:2];
                is_mem_inst = 1;
            end
            
            5'b00111: begin //STORE
                mem_write = 1;
                
                mem_addr = inst[13:2];
                is_mem_inst = 1;
            end
            
            //=================BRANCH/JUMP==================
            5'b01000: begin //BEQ , rd-rs , if zero flag branch
            alu_op = 4'b0001;
            alu_src = 0;
            is_branch = 1;
            branch_type = 0;
            end
            
            5'b01001: begin     //UNCONDITIONAL JUMP
            is_branch = 1;
            branch_type = 1;
            end
            
            default : begin
                //safe case
            end
       endcase 
   end             

endmodule

