module sipo_tb_reg();
        reg clk,D,clr;
        wire [3:0] Q;
        
        SIPO sipo_reg(.clk(clk),.clr(clr),.D(D),.Q(Q));
        
        always begin
        #5 clk=~clk;
        end
        
        initial begin
        clr = 1;
        clk = 1;
        #5 clr = 0;
        D = 1;
        #10 D=0;
        #10 D=0;
        #10 D=1; // Data "1001" is shifted in
        
        #10 $finish;
        end
endmodule
