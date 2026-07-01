`timescale 1ns / 1ps

module program_counter(input clk,
                       input rst,
                       input [7:0] pc_next,   //for jumps/branches 
                       input pc_write,        //enables pc write
                       input is_branch,       //flag for branch instruction
                       input branch_type,
                       input branch_condition,
                       
                       output reg [7:0] pc,       //current pc value
                       output wire [7:0] pc_plus_1);   //PC +1 
    
    assign pc_plus_1 = pc + 1;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 8'b0;
        end
        else if (pc_write) begin
            if(is_branch) begin
                if(branch_type) begin  //JUMP
                    pc <= pc + $signed(pc_next);
                end
                else if(branch_condition) begin
                        pc <= pc + $signed(pc_next);          //BRANCH
                    end
                    else begin
                        pc <= pc_plus_1;
                    end
            end
                else begin
                    pc <= pc_plus_1;   //Sequential
                end
        end
    end
                                      
endmodule
