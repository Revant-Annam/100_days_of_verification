`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 12:33:56 AM
// Design Name: 
// Module Name: FIFO_sync_tb
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


module FIFO_sync_tb();
    localparam DATA_WIDTH = 8;
    localparam DEPTH = 8;
    localparam ADDR_WIDTH = 3;

    reg [DATA_WIDTH-1:0] data_in;
    reg wr_en,rd_en, clk,rst;
    wire [DATA_WIDTH-1:0] d_out;
    wire full,empty;
    
    integer i;
    
    FIFO_sync #(DEPTH, DATA_WIDTH, ADDR_WIDTH) fifo_test(
        .data_in(data_in),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .clk(clk),
        .rst(rst),
        .d_out(d_out),
        .full(full),
        .empty(empty)
    );
     
    always #5 clk = ~clk;
    
    initial begin
        $monitor("Time=%t | rst=%b | wr=%b rd=%b full=%b empty=%b | data_in=%d | d_out=%d", 
                   $time, rst, wr_en, rd_en, full, empty, data_in, d_out);
        clk = 1;
        rst = 0; // Assert active-low reset
        wr_en=0;
        rd_en=0;
        data_in =0;
        
        @(negedge clk);
        rst = 1; // De-assert reset
        
        // --- Test 1: Fill the FIFO (will be "full" after 7 writes) ---
        $display("--- Filling FIFO ---");
        wr_en = 1;
        rd_en = 0;
        for(i=0; i<DEPTH; i=i+1) begin // Will only do 7 writes, then full=1
            data_in = i; 
            @(negedge clk);
        end
        
        // --- Test 2: Simultaneous Read/Write ---
        $display("--- Simultaneous R/W ---");
        wr_en = 1;
        rd_en = 1;
        for(i=0; i<DEPTH; i=i+1) begin
            data_in = i + 10; 
            @(negedge clk); 
        end
        
        // --- Test 3: Do Nothing ---
        $display("--- Idle ---");
        wr_en = 0;
        rd_en = 0;
        @(negedge clk);
        @(negedge clk);
        
        // --- Test 4: Drain the FIFO ---
        $display("--- Draining FIFO ---");
        wr_en = 0;
        rd_en = 1;
        for(i=0; i<DEPTH; i=i+1) begin // Will stop after 7 reads, then empty=1
            @(negedge clk);
        end
        
        // --- Test 5: Check Empty ---
        @(negedge clk);
        rd_en = 0;
        $display("--- Test Complete ---");
        $finish;
    end
endmodule
