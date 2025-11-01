module PISO_ff(
        input [3:0] D,
        input clk,
        input clr,
        input shift,
        output reg Q
        );
        reg [3:1] Q1;
        
        always @(posedge clk) begin 
        if(clr)
        Q <= 1'b0;
        else begin
        Q1[3] <= D[3];
        Q1[2] <= shift ? D[2] : Q1[3];
        Q1[1] <= shift ? D[1] : Q1[2];
        Q <= shift ? D[0] : Q1[1];
        end
        end

endmodule
