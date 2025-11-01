//Dataflow modelling
module full_adder(
    input A,
    input B,
    input Cin,
    output Cout,
    output Sum
);
  //Single bit
  assign Sum  = A ^ B ^ Cin; // Equation of sum
  assign Cout = (A & B) | (Cin & (A ^ B)); //Equation of Carry
endmodule
