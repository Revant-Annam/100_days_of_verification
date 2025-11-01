// Testbench for carry skip adder
module tb_carry_skip_adder_32bit;
    reg [31:0] A, B;
    reg Cin;
    wire [31:0] Sum;
    wire Cout;

    carry_skip_adder_32bit CSkA (.A(A), .B(B), .Cin(Cin), .Sum(Sum), .Cout(Cout));

    initial begin
        $monitor("Time=%0t | A=%h B=%h Cin=%b => Sum=%h Cout=%b", 
                  $time, A, B, Cin, Sum, Cout);

        A = 32'h00000000; B = 32'h00000000; Cin = 0; #10;
        A = 32'h00000001; B = 32'h00000001; Cin = 0; #10;
        A = 32'h0F0F0F0F; B = 32'h0F0F0F0F; Cin = 0; #10;
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; Cin = 0; #10;
        A = 32'hFFFFFFFF; B = 32'h00000001; Cin = 0; #10;
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; Cin = 0; #10;
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; Cin = 1; #10;

        $finish;
    end
endmodule
