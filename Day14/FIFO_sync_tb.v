// Code your testbench here
// or browse Examples
module synchronous_fifo_tb;

    // Parameters
    parameter DEPTH = 16;
    parameter DATA_WIDTH = 8;

    // Inputs
    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;

    // Outputs
    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // Instantiate the Unit Under Test (UUT)
    synchronous_fifo #(DEPTH, DATA_WIDTH) uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation: 10ns period (100MHz)
    always #5 clk = ~clk;

    // Task for FIFO Write (Push)
    task push(input [DATA_WIDTH-1:0] data);
        begin
            @(posedge clk);
            if (!full) begin
                wr_en = 1;
                data_in = data;
                $display("[TIME: %0t] PUSH: Data = %d", $time, data);
            end else begin
                $display("[TIME: %0t] PUSH FAILED: FIFO FULL", $time);
            end
            @(posedge clk);
            wr_en = 0;
        end
    endtask

    // Task for FIFO Read (Pop)
    task pop();
        begin
            @(posedge clk);
            if (!empty) begin
                rd_en = 1;
                #1; // Wait for data_out to update
                $display("[TIME: %0t] POP: Data = %d", $time, data_out);
            end else begin
                $display("[TIME: %0t] POP FAILED: FIFO EMPTY", $time);
            end
            @(posedge clk);
            rd_en = 0;
        end
    endtask

    // Main Test Sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Reset the system
        #20 rst_n = 1;
        $display("--- Reset Released ---");

        // 1. Write a few items
        push(8'd10);
        push(8'd20);
        push(8'd30);

        // 2. Read those items
        pop();
        pop();

        // 3. Fill the FIFO to test FULL flag
        $display("--- Filling FIFO ---");
        repeat (15) push($random % 100);
        
        // 4. Empty the FIFO to test EMPTY flag
        $display("--- Emptying FIFO ---");
        repeat (17) pop();

        #50;
        $display("--- Test Completed ---");
        $finish;
    end

endmodule
