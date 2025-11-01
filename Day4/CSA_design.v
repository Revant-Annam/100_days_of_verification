//RCA design is the same as before
module CSA_design(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output Cout,
    output [15:0] Sum
    );
    
    wire [3:0] Sum0, Sum1, Sum2, Sum3, Sum4, Sum5;
    wire C1,C2,C3,C4,C5,C6,C7,C8,C9;
    
    RCA_design RC0(.A(A[3:0]),.Sum(Sum[3:0]),.B(B[3:0]),.Cin(Cin),.Cout(C1));
    
    RCA_design RC1(.A(A[7:4]),.Sum(Sum0),.B(B[7:4]),.Cin(0),.Cout(C2));
    RCA_design RC2(.A(A[7:4]),.Sum(Sum1),.B(B[7:4]),.Cin(1),.Cout(C3));
    
    assign Sum[7:4] = (C1==0)?Sum0:Sum1;
    assign C4 = (C1==0)?C2:C3;
    
    RCA_design RC3(.A(A[11:8]),.Sum(Sum2),.B(B[11:8]),.Cin(0),.Cout(C5));
    RCA_design RC4(.A(A[11:8]),.Sum(Sum3),.B(B[11:8]),.Cin(1),.Cout(C6));
    
    assign Sum[11:8] = (C4==0)?Sum2:Sum3;
    assign C7 = (C4==0)?C5:C6;
    
    RCA_design RC5(.A(A[15:12]),.Sum(Sum4),.B(B[15:12]),.Cin(0),.Cout(C8));
    RCA_design RC6(.A(A[15:12]),.Sum(Sum5),.B(B[15:12]),.Cin(1),.Cout(C9));
    
    assign Sum[15:12] = (C7==0)?Sum4:Sum5;
    assign Cout = (C7==0)?C8:C9;
endmodule

