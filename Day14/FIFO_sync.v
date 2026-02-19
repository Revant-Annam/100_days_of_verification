// Code your design here
module synchronous_fifo #(
    parameter DEPTH = 16,    // Number of slots in the FIFO
    parameter DATA_WIDTH = 8 // Number of bits per slot
)(
    input  wire                  clk,      // System Clock
    input  wire                  rst_n,    // Active-low Reset
    input  wire                  wr_en,    // Write Enable
    input  wire                  rd_en,    // Read Enable
    input  wire [DATA_WIDTH-1:0] data_in,  // Data to be written
    output reg  [DATA_WIDTH-1:0] data_out, // Data to be read
    output wire                  full,     // High if FIFO is full
    output wire                  empty     // High if FIFO is empty
);

    // Internal memory and pointers
    reg [DATA_WIDTH-1:0] fifo_ram [0:DEPTH-1];
    reg [$clog2(DEPTH)-1:0] w_ptr, r_ptr;
    reg [$clog2(DEPTH):0]   count; // Counter to track occupancy

    // Status Flags Logic
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    // Main FIFO Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_ptr    <= 0;
            r_ptr    <= 0;
            count    <= 0;
            data_out <= 0;
        end else begin
            // Write Operation: Only write if enabled and NOT full
            if (wr_en && !full) begin
                fifo_ram[w_ptr] <= data_in;
                w_ptr           <= w_ptr + 1;
                count           <= count + 1;
            end

            // Read Operation: Only read if enabled and NOT empty
            if (rd_en && !empty) begin
                data_out <= fifo_ram[r_ptr];
                r_ptr    <= r_ptr + 1;
                count    <= count - 1;
            end

            // Handle simultaneous Read and Write to keep count stable
            if (wr_en && !full && rd_en && !empty) begin
                count <= count; 
            end
        end
    end
endmodule
