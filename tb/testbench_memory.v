`timescale 1ns / 1ps

module testbench_memory;
reg clk = 1'b0;
reg [11:0] address;
reg mem_read,mem_write;
reg [7:0] write_data;
wire [7:0] read_data;

data_memory_4kB uut(.clk(clk),.address(address),.mem_read(mem_read),.mem_write(mem_write),
                    .write_data(write_data),.read_data(read_data));

always #5 clk = ~clk;

initial begin
    $display ("================MEMORY TEST BEGIN===========");
    mem_read = 0; mem_write = 1;
    address = 12'd5; write_data = 8'hAA;
    #10;
    mem_read=1; mem_write = 0;
    #10;
    $display("Read data : %h (expected:aa)",read_data);
    #10;
    mem_read=0; mem_write =1;
    write_data = 8'h55; address = 12'd10;
    #10;
    mem_read = 1; mem_write = 0;
    #10;
    $display("Read data: %h (expected:55)",read_data);
    #10;
    $display("==========TEST END=========");
    $finish;
end
endmodule
