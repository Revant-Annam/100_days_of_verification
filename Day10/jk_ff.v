module jk_ff(
        input [1:0] JK,
        input clk,
        input clr,
        output reg Q
        );
        always @(posedge clk) begin
        if(clr)
        Q<=0;
        else
        begin
        case(JK)
        2'b00: Q<=Q;
        2'b01: Q<=0;
        2'b10: Q<=1;
        2'b11: Q<=~Q;
        default: Q=0;
        endcase
        end
        end
endmodule
