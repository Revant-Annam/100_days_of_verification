`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 12:27:02 AM
// Design Name: 
// Module Name: FIFO_sync
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


module FIFO_sync #(
    parameter DEPTH      = 8,
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3  // 2^ADDR_WIDTH must == DEPTH
) (
    input [DATA_WIDTH-1:0] data_in,
    input wr_en,
    input rd_en,
    input clk,
    input rst, 
    output reg [DATA_WIDTH-1:0] d_out,
    output full,
    output empty
);

    reg [DATA_WIDTH-1:0] buffer [DEPTH-1:0];
    reg [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;

    // Logic to calculate the next pointer values
    wire [ADDR_WIDTH-1:0] wptr_next = (wr_ptr == DEPTH - 1) ? 0 : wr_ptr + 1;
    wire [ADDR_WIDTH-1:0] rptr_next = (rd_ptr == DEPTH - 1) ? 0 : rd_ptr + 1;

    // Pointer-based full/empty logic
    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wptr_next == rd_ptr); 

    // Pointers and Data-Out Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            d_out  <= 0;
        end else begin
            // Write Logic: update buffer and pointer
            if (wr_en && !full) begin
                buffer[wr_ptr] <= data_in;
                wr_ptr <= wptr_next;
            end

            // Read Logic: update data output and pointer
            if (rd_en && !empty) begin
                d_out <= buffer[rd_ptr];
                rd_ptr <= rptr_next;
            end
        end
    end
endmodule
