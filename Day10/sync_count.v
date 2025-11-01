module sync_count #(parameter N=4) (
        output [N-1:0] Q,
        input [1:0] JK, // Only used for Q[0]
        input clk,
        input clr
        );
        
        genvar i;
        jk_ff ff0(.JK(JK),.clk(clk),.clr(clr),.Q(Q[0])); // LSB toggles every clock
        jk_ff ff1(.JK({Q[0],Q[0]}),.clk(clk),.clr(clr),.Q(Q[1])); // Toggles if Q[0] is 1
        generate
        for(i=2;i<N;i=i+1)
        begin
        // Toggles only if all previous bits are 1
        jk_ff ff(.JK({&(Q[i-1:0]),&(Q[i-1:0])}),.clk(clk),.clr(clr),.Q(Q[i]));
        end
        endgenerate
endmodule
