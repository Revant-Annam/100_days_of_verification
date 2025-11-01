module priority_encode_tb();

    reg [3:0] I;
    wire [1:0] Y;
    
    priority_encode pr_en(.I(I),.Y(Y));
    
    initial begin
    $monitor("For the data value %b the encoded output is %b",I,Y);
    
    I = 4'b0001;#10;
    I = 4'b0101;#10;
    I = 4'b1001;#10;
    I = 4'b1101;#10;
    I = 4'b0011;#10;
    I = 4'b0111;#10;
    I = 4'b1011;#10;
    I = 4'b0010;#10;
    
    end
endmodule
