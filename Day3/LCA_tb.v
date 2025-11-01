module LCA_tb();

    reg [7:0] A, B;
    reg Cin;
    wire Cout;
    wire [7:0] Sum;
    
    LCA_design LCA(.A(A), .B(B), .Cin(Cin), .Cout(Cout), .Sum(Sum));
    
    initial begin
        $monitor("For A=%b, B=%b, Cin=%b → Sum=%b, Cout=%b", A, B, Cin, Sum, Cout);
        
        A=8'b00000000; B=8'b00000011; Cin=0; #10;
        A=8'b00010001; B=8'b00010011; Cin=1; #10;
        A=8'b00110011; B=8'b00010011; Cin=0; #10;
        A=8'b01110011; B=8'b00010011; Cin=0; #10;
        A=8'b10000011; B=8'b10000011; Cin=1; #10;
        A=8'b11110011; B=8'b00010011; Cin=0; #10;
        A=8'b11110011; B=8'b11110011; Cin=0; #10;
        A=8'b11110011; B=8'b11110011; Cin=1; #10;
    end    
    
    initial begin
        #80;
        $finish;
    end
endmodule
