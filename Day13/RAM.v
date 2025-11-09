`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2025 08:35:33 PM
// Design Name: 
// Module Name: RAM
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


module RAM #(parameter N=4, K=4)(
    input [K-1:0] addr,
    input [N-1:0] data_in,
    input cas_b,
    input ras_b,
    input enable,
    input clk,
    input read,
    output reg [N-1:0] data_out 
    );
    
    reg [K-1:0] row_reg,col_reg;
    reg [N-1:0] ram [(1<<K)-1:0][(1<<K)-1:0];
    
    always @(posedge clk) begin
    if (~ras_b) begin
        row_reg <= addr;
    end
    
    if (~cas_b) begin
        col_reg <= addr;
        
        
        if (read)
            data_out <= ram[row_reg][addr];
        else
            ram[row_reg][addr] <= data_in;
    end
end
       
 endmodule
