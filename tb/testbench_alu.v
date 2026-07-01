`timescale 1ns / 1ps

module testbench_alu;
reg [7:0] a,b;
reg [3:0] op;

wire [7:0] result;
wire zero,carry,negative,borrow,overflow;
wire greater,equal,less;

alu uut(.a(a),.b(b),.op(op),.result(result),
        .zero(zero),.carry(carry),.borrow(borrow),.overflow(overflow),.negative(negative),
        .greater(greater),.less(less),.equal(equal));

task test;
input [7:0]ta,tb;
input [3:0]top;
    begin
        a = ta;
        b = tb;
        op = top;
        #10;
    $display("A=%d B=%d OP=%d | RES=%d | Z=%b C=%b N=%b B=%b OV=%b | G=%b E=%b L=%b",a,b,op,
          result,zero,carry,negative,borrow,overflow,greater,equal,less);
    end
endtask

initial begin
$display ("==========ALU TEST START===========");

//ADD
test(8'd10,8'd5,4'b0000);
test(8'd200,8'd100,4'b0000); //overflow case

//SUBTRACT
test(8'd10,8'd5,4'b0001);
test(8'd5,8'd10,4'b0001); //borrow case

//LOGIC
test(8'b10101010,8'b11001100,4'b0010); //AND
test(8'b10101010,8'b11001100,4'b0011); //OR
test(8'b10101010,8'b11001100,4'b0100); //XOR
test(8'b10101010,8'b00000000,4'b0101); //NOT
       
//SHIFT
test(8'd8,0,4'b0110); //SHR (divide by 2)
test(8'd8,0,4'b0111); //SHL (multiply by 2)

//PASS
test(8'd55,8'd99,4'b1000); //PASS A
test(8'd55,8'd99,4'b1001); //PASS B      

//SAR
test(8'b10000000,0,4'b1010); //NEGATIVE SHIFT

//COMPARISON
test(8'd10,8'd10,4'b0000); //EQUAL
test(8'd10,8'd5,4'b0000);  //GREATER
test(8'd10,8'd15,4'b0000); //LESS

//EDGE CASES
test(8'd0,8'd0,4'b0000); //ZERO
test(8'd255,8'd1,4'b0000);
test(8'd127,8'd1,4'b0000); //OVERFLOW CASE
test(8'd128,8'd255,4'b0001); //NEGATIVE OVERFLOW CASE

$display("==============TEST COMPLETE=============");
$finish;
end
endmodule


