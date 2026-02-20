`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 05:53:57 PM
// Design Name: 
// Module Name: FIFO_async
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


module FIFO_async #(parameter DEPTH = 16,    // Number of slots in the FIFO
    parameter DATA_WIDTH = 8 // Number of bits per slot
    )

    (
    input  wire                  w_clk,      // Write Clock
    input  wire                  w_rst_n,    // Active-low write Reset
    input  wire                  r_clk,      // Read Clock
    input  wire                  r_rst_n,    // Active-low read Reset
    input  wire                  wr_en,    // Write Enable
    input  wire                  rd_en,    // Read Enable
    input  wire [DATA_WIDTH-1:0] data_in,  // Data to be written
    output reg  [DATA_WIDTH-1:0] data_out, // Data to be read
    output reg                  full,     // High if FIFO is full
    output reg                  empty     // High if FIFO is empty
    );
    
    reg [DATA_WIDTH-1:0] fifo_ram [0:DEPTH-1];
    reg [$clog2(DEPTH):0] w_bin_ptr, r_bin_ptr;
    
    wire [$clog2(DEPTH):0] g_wptr,g_rptr;
    wire [$clog2(DEPTH):0] g_wptr_sync,g_rptr_sync;
    
    write_pointer_handler write_handle(.b_wptr(w_bin_ptr),.g_wptr(g_wptr),.w_clk(w_clk),.w_en(wr_en),.w_rst_n(w_rst_n),.full(full));
    read_pointer_handler read_handle(.b_rptr(r_bin_ptr),.g_rptr(g_rptr),.r_clk(r_clk),.r_en(rd_en),.r_rst_n(r_rst_n),.empty(empty));
    
    synchronizer w_synchronizer(.clk(w_clk),.g_ptr(g_rptr),.rst_n(w_rst_n),.g_ptr_sync(g_rptr_sync));
    synchronizer r_synchronizer(.clk(r_clk),.g_ptr(g_wptr),.rst_n(r_rst_n),.g_ptr_sync(g_wptr_sync));
    
    // Main FIFO Logic
    always @(posedge w_clk) begin
            // Write Operation: Only write if enabled and NOT full
            if (wr_en && !full) begin
                fifo_ram[w_bin_ptr] <= data_in;
            end
    end
    
    always @(posedge r_clk) begin
            // Write Operation: Only write if enabled and NOT full
            if (rd_en && !empty) begin
                data_out   <= fifo_ram[r_bin_ptr];
            end
    end
endmodule
