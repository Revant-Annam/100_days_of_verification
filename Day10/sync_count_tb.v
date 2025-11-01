module sync_count_tb;
        wire [3:0] Q;
        reg [1:0] JK;
        reg clk, clr;
        
        sync_count #(4) sc (.clk(clk),.clr(clr),.Q(Q),.JK(JK)); // Uses default N=4
        
        initial begin
            clk = 0;
            forever #5 clk = ~clk; // 10ns period clock
        end
        
        initial begin
        clr = 1;
        JK = 2'b11; // Set to toggle mode
        #20;
        clr =0;
        $monitor("For time = %t the value of Q is = %b",$time,Q);
        #200 $finish;
        end
endmodule
