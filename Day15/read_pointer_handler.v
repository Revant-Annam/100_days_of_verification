`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2026 07:12:06 PM
// Design Name: 
// Module Name: read_pointer_handler
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


module read_pointer_handler #(parameter DEPTH = 16,    // Number of slots in the FIFO
    parameter DATA_WIDTH = 8 // Number of bits per slot
    )
( input wire r_clk,
  input wire r_rst_n,
  input wire r_en,
  input wire [$clog2(DEPTH):0] g_wptr_sync,
  output reg empty,
  output reg [$clog2(DEPTH):0] b_rptr,
  output wire [$clog2(DEPTH):0] g_rptr
    );
    assign b_rptr_next = r_en & !empty ? b_rptr +1 : b_rptr;
    assign g_rptr = (b_rptr_next>>1)^b_rptr_next;
    
    always @(posedge r_clk or negedge r_rst_n) begin
        if(!r_rst_n) begin
            b_rptr <= 0;
            empty <= 0;
        end
        else begin
            if(r_en & !empty) begin
                b_rptr <= b_rptr_next;
                empty <= g_rptr == g_wptr_sync;
            end
        end
    end
endmodule

