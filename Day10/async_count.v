`timescale 1ns / 1ps
module async_count #(parameter N=4)(
        output [N-1:0] Q,
        input clk,
        input clr,
        input [1:0] JK
        );
        genvar i;
        
        jk_ff dff0(.JK(JK),.clk(clk),.clr(clr),.Q(Q[0])); // LSB
        generate
        for(i=1;i<N;i=i+1)
        begin
        jk_ff dff1(.JK(JK),.clk(~Q[i-1]),.clr(clr),.Q(Q[i])); // Clock is from previous Q
        end
        endgenerate  
endmodule
