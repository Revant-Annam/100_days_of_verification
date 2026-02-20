`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2026 04:07:57 PM
// Design Name: 
// Module Name: write_pointer_handler
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


module write_pointer_handler #(parameter DEPTH = 16,    // Number of slots in the FIFO
    parameter DATA_WIDTH = 8 // Number of bits per slot
    )
( input wire w_clk,
  input wire w_rst_n,
  input wire w_en,
  input wire [$clog2(DEPTH):0] g_rptr_sync,
  output reg full,
  output reg [$clog2(DEPTH):0] b_wptr,
  output wire [$clog2(DEPTH):0] g_wptr
    );
    assign b_wptr_next = w_en & !full ? b_wptr +1 : b_wptr;
    assign g_wptr = (b_wptr_next>>1)^b_wptr_next;
    
    always @(posedge w_clk or negedge w_rst_n) begin
        if(!w_rst_n) begin
            b_wptr <= 0;
            full <= 0;
        end
        else begin
            if(w_en & !full) begin
                b_wptr <= b_wptr_next;
                full <= g_wptr == {~g_rptr_sync[$clog2(DEPTH):$clog2(DEPTH)-1],g_rptr_sync[$clog2(DEPTH)-2:0]};
            end
        end
    end
endmodule
