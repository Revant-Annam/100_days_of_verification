module D_ff(
        output reg Q,
        input clk,
        input D
        );
        
        always @(posedge clk) begin
        Q <= D;
        end
endmodule
