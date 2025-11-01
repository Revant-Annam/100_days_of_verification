module ALU_tb;
    
    reg [3:0] A, B;
    wire [3:0] Y;
    reg [1:0] C;
    
    ALU_basic ALU (.A(A), .B(B), .C(C), .Y(Y));
    
    initial begin
        $monitor("For A=%b, B=%b, opcode=%b → Output=%b", A, B, C, Y);
        
        A = 4'b1010; B = 4'b0101;
        C = 2'b00; #10;   // ADD
        C = 2'b10; #10;   // AND
        C = 2'b01; #10;   // SUB
        C = 2'b11; #10;   // OR
        
        $finish;
    end
endmodule
