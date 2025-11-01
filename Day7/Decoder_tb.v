module Decoder_tb();

        reg [2:0] A;
        wire [7:0] B;
        
        decoder dc(.A(A),.B(B));
        
        initial 
        begin 
        $monitor("For the encoded value %b the decoded output will be %b",A,B);
        A = 3'b100;#10;
        A = 3'b101;#10;
        A = 3'b111;#10;
        A = 3'b001;#10;
        A = 3'b011;#10;
        A = 3'b010;#10;
        A = 3'b000;#10;
       access; A = 3'b110;#10;
        $finish;
        end
        
    endmodule
