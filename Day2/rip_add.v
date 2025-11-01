module rip_add(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output Cout,
    output [3:0] Sum
);
    wire C1, C2, C3;
    //Module instantiation
    full_adder fa0(.A(A[0]), .B(B[0]), .Cin(Cin), .Cout(C1), .Sum(Sum[0]));
    full_adder fa1(.A(A[1]), .B(B[1]), .Cin(C1), .Cout(C2), .Sum(Sum[1]));
    full_adder fa2(.A(A[2]), .B(B[2]), .Cin(C2), .Cout(C3), .Sum(Sum[2]));
    full_adder fa3(.A(A[3]), .B(B[3]), .Cin(C3), .Cout(Cout), .Sum(Sum[3]));
endmodule
