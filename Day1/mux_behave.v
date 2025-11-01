module mux_behave(out, i0, i1, i2, i3, s1, s0);
  output reg out;
  input i0, i1, i2, i3, s1, s0;
  
  always @(*)
    case ({s1, s0})
      2'b00: out = i0;
      2'b01: out = i1;
      2'b10: out = i2;
      2'b11: out = i3;
      default: out = 1'bx;
    endcase
endmodule
