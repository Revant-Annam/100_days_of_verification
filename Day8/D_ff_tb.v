`timescale 1ns / 1ps

module D_ff_tb();

        reg D,clk;
        wire Q;
        
        D_ff dff(.Q(Q),.D(D),.clk(clk));
        
        always begin
        #5 clk = ~clk;
        end
      
        initial begin
        $monitor("For the value of D = %b the value of Q will be %b",D,Q);
        clk = 0;
        D = 1;
        #20 D=0; 
        #30 D=1;
        #10 D=0;
        
        $finish;
        end
endmodule
