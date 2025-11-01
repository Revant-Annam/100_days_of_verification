module LCA_design(
    input [7:0] A, input [7:0] B, input Cin, 
    output [7:0] Sum, output Cout);
    
    wire [7:0] P,G,C;
    
    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;
    
    assign C[1] = G[0] | C[0] & P[0];
    assign C[2] = G[1] | C[1] & P[1];
    assign C[3] = G[2] | C[2] & P[2];
    assign C[4] = G[3] | C[3] & P[3];
    assign C[5] = G[4] | C[4] & P[4];
    assign C[6] = G[5] | C[5] & P[5];
    assign C[7] = G[6] | C[6] & P[6];
    assign Cout = G[7] | C[7] & P[7];
    
    assign Sum = P ^ C;
endmodule
