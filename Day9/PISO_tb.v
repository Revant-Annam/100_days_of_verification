module PISO_tb();
        reg [3:0] D;
        reg clk, clr, shift;
        wire Q;
        
        PISO_ff piso(.D(D),.clk(clk),.clr(clr),.shift(shift),.Q(Q));
    
        always begin 
        #5 clk = ~clk;
        end
        
        initial begin
        clk=1;
        clr = 1;
        shift = 1;
        #10 clr = 0;
        D = 4'b0101; // Load 0101
        #10 shift = 0; // Switch to Shift mode
        #40; // Shift for 4 cycles
        
        #10 D=4'b1010;
        #10 shift = 1; // Load 1010
        #10 shift = 0; // Switch to Shift mode
        #40;
        $finish;
        end
endmodule
