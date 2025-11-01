`timescale 1ns / 1ps
    module traffic_control_tb;
        reg X, clr, clk;
        wire [1:0] high_out, count_out;
        
        traffic_control traf_cont(.highway_light(high_out), .clr(clr), .clk(clk), .X(X), .country_light(count_out));
        
        always begin 
            #5 clk = ~clk;
        end
        
        initial begin 
            clr = 1;
            clk=1;
            X=0;
            #10 clr = 0;
            
            #10 X = 0; // Stays HG
            #10 X = 0; // Stays HG
            #10 X = 0; // Stays HG
            #10 X = 1; // X=1 detected, state -> HOR on next clock
            #10 X = 1; // state = HOR, -> CG on next clock
            #10 X = 1; // state = CG, T_green=0. Stays CG
          *#10 X = 1; // state = CG, T_green=1. Stays CG*
            #10 X = 1; // state = CG, T_green=2. Timer expires. -> COR on next clock
            #10 X = 1; // state = COR, -> HG on next clock
            #10 X = 0; // state = HG, X=0. Stays HG
            #10 X = 0;
            #10 X = 0;
            #10 X = 0;
            
            $finish;
        end
    endmodule
