`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2026 08:29:50 PM
// Design Name: 
// Module Name: synchronizer
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


module synchronizer #(parameter DEPTH = 16,    // Number of slots in the FIFO
    parameter DATA_WIDTH = 8 // Number of bits per slot
    )(
input wire clk,
input wire [$clog2(DEPTH):0] g_ptr,
input wire rst_n,
output reg [$clog2(DEPTH):0] g_ptr_sync
    );
    reg [$clog2(DEPTH):0] q1;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            q1 <= 0;
            g_ptr_sync <= 0;
        end
        else begin
            q1 <= g_ptr;
            g_ptr_sync <= q1;
        end
    end
endmodule
