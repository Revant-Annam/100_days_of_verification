module seq_dec_1001_tb();

        reg X, clr, clk;
        wire out;
        
        seq_dec_1001_mealy sqdec1001(.out(out),.clr(clr),.clk(clk),.X(X));
        
        always begin 
            #5 clk = ~clk; // 10ns clock
        end
        
        initial begin 
            clr = 1;
            clk=0;
            #10 clr = 0;
            
            // Test sequence: 0-1-0-0-1 (Detect)
            #10 X = 0; // State=A
            #10 X = 1; // State=B
            #10 X = 0; // State=C
            #10 X = 0; // State=D
            #10 X = 1; // State=B, out=1
            
            // Test sequence: 0-0-1 (No Detect)
            #10 X = 0; // State=C
            #10 X = 0; // State=D
            #10 X = 1; // State=B, out=1
            
            // Test sequence: 1-0-0-1 (Detect)
            #10 X = 1; // State=B
            #10 X = 0; // State=C
            #10 X = 0; // State=D
            #10 X = 1; // State=B, out=1
            
            // Test sequence: 0-1-0-0-1 (Detect)
            #10 X = 0; // State=C
            #10 X = 1; // State=B
            #10 X = 0; // State=C
            #10 X = 0; // State=D
            #10 X = 1; // State=B, out=1
            
            $finish;
        end
      
    endmodule
