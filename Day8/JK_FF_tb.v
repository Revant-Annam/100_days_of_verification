module JK_FF_tb();

        reg [1:0] JK;
        reg clk;
        wire Q;
        
        JK_FF jkff(.Q(Q),.JK(JK),.clk(clk));
        
        always begin
        #5 clk = ~clk;
        end
        
        initial begin
        
        $monitor("For the value of J and k = %b the value of Q will be %b",JK,Q);
        clk = 1;
        JK = 2'b10;
        #10 JK=2'b11; 
        #10 JK=2'b10;
        #10 JK=2'b01;
        #10 JK=2'b00;
        
        #10; $finish;

        end 
endmodule
