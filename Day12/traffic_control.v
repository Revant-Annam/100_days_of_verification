`timescale 1ns / 1ps
    module traffic_control(
        input X,
        input clk,
        input clr,
        output reg [1:0] highway_light,
        output reg [1:0] country_light
        );
        reg [1:0] state, nxt_state;
        
        localparam HG=2'b00, HOR=2'b01, CG=2'b10, COR=2'b11;
        parameter G2R = 4'd2; // Timer limit (3 clock cycles)
        reg [3:0] T_green;

        // State Register
        always @(posedge clk)
        begin
            if (clr)
                state <= HG;
            else begin
                state <= nxt_state;
            end
        end
        
        // Timer Logic
        always @(posedge clk or posedge clr) begin
            if (clr)
                T_green <= 0;
            else if (state == CG) begin
                if (X && (T_green < G2R))
                    T_green <= T_green + 1;
                else
                    T_green <= 0; // Reset timer when condition fails or delay is met
            end else begin
                T_green <= 0; // Ensure timer is 0 in other states
            end
        end
        
        // Next State Logic (Combinational)
        always @(*) begin
            case (state)
            HG: if(X) nxt_state = HOR; else nxt_state = HG;
            HOR: nxt_state = CG;
            CG: if(X==1 && T_green<G2R) nxt_state = CG; 
             	      else nxt_state = COR;
            COR: nxt_state = HG;
            default: nxt_state = HG;
            endcase
        end
        
        // Output Logic (Combinational - Moore Style)
        // Red = 00
        // Orange = 01
        // Green = 10
        always @(*) begin
        highway_light = 2'b00;
        country_light = 2'b00;
            case (state)
                HG: begin highway_light = 2'b10; country_light = 2'b00; end // Highway Green, Farm Red
                HOR: begin highway_light = 2'b01; country_light = 2'b00; end // Highway Yellow, Farm Red
                CG: begin highway_light = 2'b00; country_light = 2'b10; end // Highway Red, Farm Green
                COR: begin highway_light = 2'b00; country_light = 2'b01; end // Highway Red, Farm Yellow
                default: begin highway_light = 2'b00; country_light = 2'b00; end
            endcase
        end
    endmodule
