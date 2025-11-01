module async_tb;

        reg clk,clr;
        reg [1:0] JK;
        wire [4:0] Q;
        
        async_count #(5) asc (.clk(clk),.clr(clr),.Q(Q),.JK(JK)); // Overrides N=4 to N=5
        
        initial begin
            clk = 0;
            forever #5 clk = ~clk; // 10ns period clock
        end
        
        initial begin
        clr = 1;
        JK = 2'b11; // Set to toggle mode
        #30;
        clr =0;
        $monitor("For time = %t the value of Q is = %b",$time,Q);
        #400 $finish;
        end
endmodule
