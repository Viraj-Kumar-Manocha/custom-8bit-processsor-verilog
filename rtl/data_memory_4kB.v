`timescale 1ns / 1ps

module data_memory_4kB(input clk,
                       input rst,
                       input mem_read,
                       input mem_write,
                       input [11:0]address,   //12 bit adress for 4096 byte locations
                       input [7:0] write_data,  //8 bit data to write
                       output reg [7:0] read_data);
    
    reg [7:0] memory[4095:0]; //4096 unita of 8 bit each
                              //4kB memory
    integer i;
    always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i=0;i<4096;i=i+1) begin
            memory[i] <= 0;
        end
    end
    else if (mem_write) begin
            memory[address] <= write_data;
        end
    end
    
    always @(*) begin
        if (mem_read) begin
            read_data = memory[address];
        end
        else begin
            read_data = 8'b0;
        end
    end
endmodule
