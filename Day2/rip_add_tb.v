module rip_add_tb;
    reg [3:0] A, B;
    reg Cin;
    wire Cout;
    wire [3:0] Sum;
    
    rip_add ripple_ex(.A(A), .B(B), .Cin(Cin), .Cout(Cout), .Sum(Sum));
    
    initial begin
        $monitor("A=%b B=%b Cin=%b | Sum=%b Cout=%b", A, B, Cin, Sum, Cout);
        //Basic stimuli
        A=4'b0000; B=4'b0000; Cin=0; #10;
        A=4'b0001; B=4'b0001; Cin=0; #10;
        A=4'b0011; B=4'b0001; Cin=0; #10;
        A=4'b0111; B=4'b0001; Cin=0; #10;
        A=4'b1000; B=4'b1000; Cin=0; #10;
        A=4'b1111; B=4'b0001; Cin=0; #10;
        A=4'b1111; B=4'b1111; Cin=0; #10;
        A=4'b1111; B=4'b1111; Cin=1; #10;

        $finish;
    end
endmodule
