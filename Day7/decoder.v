module decoder(
    input [2:0] A,
    output [7:0] B
    );
    
    wire [2:0] nA;
    
    assign nA = ~A;
    
    assign B[0] = nA[2]&nA[1]&nA[0];
    assign B[1] = nA[2]&nA[1]&A[0];
    assign B[2] = nA[2]&A[1]&nA[0];
    assign B[3] = nA[2]&A[1]&A[0];
    assign B[4] = A[2]&nA[1]&nA[0];
    assign B[5] = A[2]&nA[1]&A[0];
    assign B[6] = A[2]&A[1]&nA[0];
    assign B[7] = A[2]&A[1]&A[0];
    
endmodule
