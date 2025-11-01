module JK_FF(
        input [1:0] JK,
        input clk,
        output reg Q
        );
        
        always @(posedge clk) begin
        case(JK)
        2'b00: Q <= Q;
        2'b01: Q <= 0;
        2'b10: Q <= 1;
        2'b11: Q <= ~Q;
        default: Q <= 0;
        endcase
        end
endmodule
