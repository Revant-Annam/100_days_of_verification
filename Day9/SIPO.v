module SIPO(
        input clk,
        input D,
        input clr,
        output reg [3:0] Q
        );

        always @(posedge clk) begin 
        if(clr)
        Q <= 4'b0000;
        else begin
        Q <= {D,Q[3:1]}; // Concatenation: D becomes Q[3], Q[3] becomes Q[2], etc.
        end
        end
        
endmodule
