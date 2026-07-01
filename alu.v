`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2026 03:47:56
// Design Name: 
// Module Name: alu
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


module alu(input [7:0] a,
           input [7:0] b,
           input [3:0] op,
           
           output reg [7:0] result,
           
           output zero,
           output carry,
           output borrow,
           output negative,
           output overflow,
           
           output less,
           output equal,
           output greater 
    );
 
reg [8:0] temp;    
    
always @(*) begin
    temp = 9'b0;
    result = 8'b0;
    
    case(op)
        4'b0000 : begin                //ADD
            temp = a + b;
            result = temp[7:0];
            end    
            
        4'b0001 : begin               //SUBTRACT
            temp = a - b ;
            result = temp[7:0];
            end
                
        4'b0010 : result = a & b ;    //AND
        4'b0011 : result = a | b ;    //OR
        4'b0100 : result = a ^ b ;    //XOR
        4'b0101 : result = ~ a;       //NOT
        
        4'b0110 : result = a>>1 ;     //SHR (logical shift)
        4'b0111 : result = a<<1;      //SHL
        
        4'b1000 : result = a;         //PASS A
        4'b1001 : result = b;         //PASS B
        
        4'b1010 : result = $signed(a) >>> 1; //SAR (arithmetic shift)
        default: result = 8'b0;
        
    endcase
end

//flags
assign zero = (result == 8'b0);
assign negative = result[7];
assign carry = (op == 4'b0000)? temp[8]: 1'b0;
assign borrow = (op == 4'b0001)? (a<b) : 1'b0;

assign overflow = (op == 4'b0000) ? ((a[7] == b[7]) && (result[7] != a[7])) :
                  (op == 4'b0001) ? ((a[7] != b[7]) && (result[7] != a[7])) : 1'b0;

assign equal = (a==b);
assign less = ($signed(a) < $signed(b));
assign greater = ($signed(a) > $signed(b)); 
endmodule
