module seq_dec_1001_mealy(
        input X,
        input clr,
        output reg out,
        input clk
        );
        
        reg [1:0] state, nxt_state;
        
        localparam A=2'b00,B=2'b01,C=2'b10,D=2'b11;
        
        // State Register (Sequential)
        always @(posedge clk)
        begin
            if (clr)
                state <= A;
            else
                state <= nxt_state;
        end
        
        // Next State & Output Logic (Combinational)
        always @(*)
        begin
        out=0; // Default output is 0
        if(X) begin
            case (state)
                A: nxt_state = B;
                B: nxt_state = B;
                C: nxt_state = B;
                D: begin nxt_state = B; out = 1; end // Output 1 on D->B transition
                default: nxt_state = state;
            endcase
            end
        else begin
            case (state)
                A: nxt_state = A;
                B: nxt_state = C;
                C: nxt_state = D;
                D: nxt_state = A;
                default: nxt_state = state;
            endcase
            end
        end
endmodule
