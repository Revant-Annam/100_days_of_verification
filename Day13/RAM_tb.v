`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2025 09:36:24 PM
// Design Name: 
// Module Name: RAM_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module RAM_tb #(parameter N=8, K=8)();
    
    reg [K-1:0] addr;
    reg [N-1:0] data_in;
    reg cas_b, ras_b, enable, clk, read;
    wire [N-1:0] data_out;

    RAM ram(
        .addr(addr), .data_in(data_in), .cas_b(cas_b), .ras_b(ras_b), 
        .enable(enable), .clk(clk), .read(read), .data_out(data_out)
    );
    
    // Clock generator
    always #5 clk = ~clk;
    
initial begin
    $monitor("Time=%t | en=%b ras=%b cas=%b read=%b | addr=%h | data_in=%h | data_out=%h",
              $time, enable, ras_b, cas_b, read, addr, data_in, data_out);
    
    //Initialize 
    clk = 0;
    enable  = 0;
    data_in = 0;
    read = 0;
    cas_b = 1;
    ras_b = 1;
    
    @(negedge clk);
    enable = 1;
    
    // Write 8'hAA to (Row=8'hA4, Col=8'h73)
    @(negedge clk);
    read = 0;                 
    data_in = 8'hAA;
    addr = 8'hA4;             
    ras_b = 0;                
    
    @(negedge clk);
    ras_b = 1;                
    
    @(negedge clk);
    addr = 8'h73;             
    cas_b = 0;                
    
    @(negedge clk);
    cas_b = 1; 
                   
     // Reading data from (Row=8'hA4, Col=8'h73)
    @(negedge clk);
    read = 1;                 
    addr = 8'hA4;             
    ras_b = 0;               
    
    @(negedge clk);
    ras_b = 1;               
    
    @(negedge clk);
    addr = 8'h73;            
    cas_b = 0;               
    
    @(negedge clk);
    cas_b = 1;                
    
    #100; 
    $finish;
end
endmodule