module ALU_basic(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Y,
    input [1:0] C
    );
    
    always @(*) begin
        case(C)
            2'b00: Y = A + B;
            2'b01: Y = A - B;
            2'b10: Y = A & B;
            2'b11: Y = A | B;
        endcase 
    end
endmodule
