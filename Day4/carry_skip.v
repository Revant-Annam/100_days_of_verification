module carry_skip(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output Cout,
    output [31:0] Sum
    );
    wire [15:0] C;
    wire [31:0] P;
    
    assign P = A^B;
    
    ripple_carry_add RC0(.A(A[3:0]),.B(B[3:0]),.Cin(Cin),.Cout(C[0]),.Sum(Sum[3:0]));
    assign C[1] = &(P[3:0])?Cin:C[0];
    
    ripple_carry_add RC1(.A(A[7:4]),.B(B[7:4]),.Cin(C[1]),.Cout(C[2]),.Sum(Sum[7:4]));
    assign C[3] = &(P[7:4])?C[1]:C[2];
    
    ripple_carry_add RC2(.A(A[11:8]),.B(B[11:8]),.Cin(C[3]),.Cout(C[4]),.Sum(Sum[11:8]));
    assign C[5] = &(P[11:8])?C[3]:C[4];
    
    ripple_carry_add RC3(.A(A[15:12]),.B(B[15:12]),.Cin(C[5]),.Cout(C[6]),.Sum(Sum[15:12]));
    assign C[7] = &(P[15:12])?C[5]:C[6];
    
    ripple_carry_add RC4(.A(A[19:16]),.B(B[19:16]),.Cin(C[7]),.Cout(C[8]),.Sum(Sum[19:16]));
    assign C[9] = &(P[19:16])?C[7]:C[8];
    
    ripple_carry_add RC5(.A(A[23:20]),.B(B[23:20]),.Cin(C[9]),.Cout(C[10]),.Sum(Sum[23:20]));
    assign C[11] = &(P[23:20])?C[9]:C[10];
    
    ripple_carry_add RC6(.A(A[27:24]),.B(B[27:24]),.Cin(C[11]),.Cout(C[12]),.Sum(Sum[27:24]));
    assign C[13] = &(P[27:24])?C[11]:C[12];
    
    ripple_carry_add RC7(.A(A[31:28]),.B(B[31:28]),.Cin(C[13]),.Cout(C[14]),.Sum(Sum[31:28]));
    assign Cout = &(P[31:28])?C[13]:C[14];
    
endmodule
