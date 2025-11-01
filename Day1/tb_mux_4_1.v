module tb_mux_4_1;
  reg I0, I1, I2, I3, S0, S1;
  wire OUT;

  mux_behave mux_ex(.out(OUT), .i0(I0), .i1(I1), .i2(I2), .i3(I3), .s1(S1), .s0(S0));

  initial begin
    I0 = 1; I1 = 0; I2 = 1; I3 = 1;
    $monitor("S1=%b, S0=%b → OUT=%b", S1, S0, OUT);
    #100 S1=0; S0=0;
    #100 S1=0; S0=1;
    #100 S1=1; S0=0;
    #100 S1=1; S0=1;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
